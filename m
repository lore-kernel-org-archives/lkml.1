Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbXGHMXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbXGHMXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 08:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXGHMXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 08:23:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3498 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751667AbXGHMXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 08:23:13 -0400
Date: Sun, 8 Jul 2007 12:09:33 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oliver Neukum <oliver@neukum.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
Message-ID: <20070708120933.GA3866@ucw.cz>
References: <Pine.LNX.4.44L0.0707061039380.3737-100000@iolanthe.rowland.org> <200707080108.17371.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707080108.17371.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > And then you will face the problem of a user task doing I/O during 
> > hibernate after the atomic snapshot has been made.
> 
> I don't think that this is possible in normal conditions.  It would be possible
> if, for example, the task were waiting for an unavailable resource and that
> resource became available after the hibernation image had been created.
> In that case, however, to do any damage, the task would have to cause some
> filesystem-related data to be flushed in the same syscall (ie. before returning
> to user space).

I agree that it is relatively unlikely to trigger (if you avoid
freezing the tasks that were uninterruptible for long), but it will
trigger in error cases etc.

> Such situations may be prevented by a mechanizm detecting if any uniterruptible
> and freezing task has been woken up after creating the image and aborting the
> hibernation in that cases.  For this purpose, we only need to add an
> appropriate condition to try_to_wake_up() and make it start to trigger after,
> for example, enabling the nonboot CPUs.

I don't know how to do that mechanism... but if we knew where to trap
filesystem writes, we could simply freeze at that point, and at that
point only, no?
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
