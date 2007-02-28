Return-Path: <linux-kernel-owner+w=401wt.eu-S932402AbXB1TdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbXB1TdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932418AbXB1TdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:33:11 -0500
Received: from mail.screens.ru ([213.234.233.54]:52026 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402AbXB1TdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:33:10 -0500
Date: Wed, 28 Feb 2007 22:32:34 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: vatsa@in.ibm.com, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228193234.GA86@tv-sign.ru>
References: <200702272251.28844.rjw@sisk.pl> <200702281211.04515.rjw@sisk.pl> <20070228131721.GD15509@in.ibm.com> <200702282017.39752.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702282017.39752.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Rafael J. Wysocki wrote:
>
> > --- workqueue.c.org	2007-02-28 18:32:48.000000000 +0530
> > +++ workqueue.c	2007-02-28 18:44:23.000000000 +0530
> > @@ -718,6 +718,8 @@ static void cleanup_workqueue_thread(str
> >  		insert_wq_barrier(cwq, &barr, 1);
> >  		cwq->should_stop = 1;
> >  		alive = 1;
> > +		if (frozen(cwq->thread))
> > +			thaw(cwq->thread);
> >  	}
> >  	spin_unlock_irq(&cwq->lock);
>
> Unfortunately, the above code is mm-only.  Is the analogous fix for 2.6.21-rc2
> viable?

I am sorry, I lost track of this problem. As for 2.6.21, create_freezeable_workqueue
doesn't work and conflict with suspend. Why can't we remove it from XFS as you
suggested before?

Iirc,
	On 02/28, Nigel Cunningham wrote:
	>
	> On Wed, 2007-02-28 at 01:08 +0100, Rafael J. Wysocki wrote:
	> > On Wednesday, 28 February 2007 01:01, Johannes Berg wrote:
	> > > On Wed, 2007-02-28 at 00:57 +0100, Rafael J. Wysocki wrote:
	> > >
	> > > > Okay, in that case I'd suggest removing create_freezeable_workqueue() and
	> > > > make all workqueues nonfreezable once again for 2.6.21 (as far as I know, only
	> > > > the two XFS workqueues are affected).
	> > >
	> > > I think Nigel might object but I forgot what specific trouble XFS was
	> > > causing him.
	> >
	> > We suspected that the XFS' worker threads might commit I/O after
	> > freeze_processes() has returned, but that hasn't been supported by evidence,
	> > as far as I can recall.
	> >
	> > Also, making them freezable was controversial ...
	>
	> Controversy is no reason to give in! Nevertheless, I think you're right
	> - I believe the XFS guys said they fixed the issue that had caused I/O
	> to be submitted post-freeze. Well, we'll see if it appears again, won't
	> we?

Oleg.

