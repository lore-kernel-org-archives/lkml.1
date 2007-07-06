Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbXGFWtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbXGFWtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 18:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbXGFWtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 18:49:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60229 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbXGFWtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 18:49:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
Date: Sat, 7 Jul 2007 00:56:21 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Nigel Cunningham <nigel@nigel.suspend2.net>
References: <20070706202629.GA158@tv-sign.ru>
In-Reply-To: <20070706202629.GA158@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707070056.22560.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 6 July 2007 22:26, Oleg Nesterov wrote:
> Rafael J. Wysocki wrote:
> >
> > This patch makes the freezer skip uninterruptible user space tasks (ie. such
> > that have an mm of their own) when counting the tasks to be frozen.  As a
> > result, these tasks have the TIF_FREEZE and TIF_SIGPENDING flags set, but the
> > freezer doesn't wait for them to enter the refrigerator.  Nevertheless, they
> > will enter the refrigerator as soon as they change their state.
> 
> A small correction: they will enter the refrigerator on return to user-space.

Yes, I should have written that explicitly.

> Actually, TASK_INTERRUPTIBLE doesn't mean the task actually sleeps. It could
> be running or preempted... I am a bit worried :)

Fortunately, similar approach has been tested quite extensively by suspend2,
IIRC. :-)
 
> > +static int freezer_should_skip(struct task_struct *p)
> > +{
> > +       return (has_mm(p) && (p->state | TASK_UNINTERRUPTIBLE));
>                                         ^^^
> I guess you meant "&", not "|".

Yes, I've already spotted that, but thanks anyway.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
