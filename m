Return-Path: <linux-kernel-owner+w=401wt.eu-S1752336AbXB1RjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbXB1RjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbXB1RjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:39:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43573 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbXB1RjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:39:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: vatsa@in.ibm.com
Subject: Re: Problem with freezable workqueues
Date: Wed, 28 Feb 2007 18:41:57 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
References: <200702272251.28844.rjw@sisk.pl> <20070228131721.GD15509@in.ibm.com> <20070228132734.GA17050@in.ibm.com>
In-Reply-To: <20070228132734.GA17050@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702281841.58217.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 February 2007 14:27, Srivatsa Vaddagiri wrote:
> On Wed, Feb 28, 2007 at 06:47:21PM +0530, Srivatsa Vaddagiri wrote:
> > --- workqueue.c.org	2007-02-28 18:32:48.000000000 +0530
> > +++ workqueue.c	2007-02-28 18:44:23.000000000 +0530
> > @@ -718,6 +718,8 @@ static void cleanup_workqueue_thread(str
> >  		insert_wq_barrier(cwq, &barr, 1);
> >  		cwq->should_stop = 1;
> >  		alive = 1;
> > +		if (frozen(cwq->thread))
> > +			thaw(cwq->thread);
> 
> I meant thaw_process(cwq->thread) 

I thought so, but thanks anyway. ;-)

> 
> >  	}
> >  	spin_unlock_irq(&cwq->lock);
> 
