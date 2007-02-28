Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbXB1Iyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbXB1Iyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 03:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXB1Iyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 03:54:36 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33480 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752072AbXB1Iyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 03:54:35 -0500
Date: Wed, 28 Feb 2007 09:54:24 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228085424.GA8442@elf.ucw.cz>
References: <200702272251.28844.rjw@sisk.pl> <20070227232855.GA457@tv-sign.ru> <200702280057.36198.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702280057.36198.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I'm afraid this is racy. We can't touch *cwq, it may be freed. Suppose
> > that another thread does destroy_workqueue(), and we thaw that thread
> > before cwq->thread.
> 
> Okay, in that case I'd suggest removing create_freezeable_workqueue() and
> make all workqueues nonfreezable once again for 2.6.21 (as far as I know, only
> the two XFS workqueues are affected).
> 
> Pavel, would that be acceptable?

Not sure... I really dislike XFS running while we are doing
swsusp. I'd like to move in direction of freezeable workqueues in the
future.

Anyway, if it gets us out of current trouble... yes I guess we can do
it.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
