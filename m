Return-Path: <linux-kernel-owner+w=401wt.eu-S933404AbXCUEMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbXCUEMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 00:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933571AbXCUEMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 00:12:15 -0400
Received: from [212.12.190.150] ([212.12.190.150]:33312 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933404AbXCUEMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 00:12:14 -0400
From: Al Boldi <a1426z@gawab.com>
To: Artur Skawina <art_k@o2.pl>
Subject: Re: RSDL v0.31
Date: Wed, 21 Mar 2007 07:15:35 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703192353.19673.a1426z@gawab.com> <46003B1B.9070601@o2.pl>
In-Reply-To: <46003B1B.9070601@o2.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703210715.35898.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Artur Skawina wrote:
> Al Boldi wrote:
> > --- sched.bak.c	2007-03-16 23:07:23.000000000 +0300
> > +++ sched.c	2007-03-19 23:49:40.000000000 +0300
> > @@ -938,7 +938,11 @@ static void activate_task(struct task_st
> >  				     (now - p->timestamp) >> 20);
> >  	}
> >
> > -	p->quota = rr_quota(p);
> > +	/*
> > +	 * boost factor hardcoded to 5; adjust to your liking
> > +	 * higher means more likely to DoS
> > +	 */
> > +	p->quota = rr_quota(p) + (((now - p->timestamp) >> 20) * 5);
> >  	p->prio = effective_prio(p);
> >  	p->timestamp = now;
> >  	__activate_task(p, rq);
>
> i've tried this and it lasted only a few minutes -- i was seeing
> mouse cursor stalls lasting almost 1s. i/o bound tasks starving X?
> After reverting the patch everything is smooth again.

This patch wasn't really meant for production, as any sleeping background 
proc turned cpu-hog may DoS the system.

If you like to play with this, then you probably want to at least reset the 
quota in its expiration.


Thanks!

--
Al

