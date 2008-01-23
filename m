Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbYAWSW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbYAWSW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbYAWSWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:22:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4467 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753529AbYAWSWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:22:33 -0500
Date: Wed, 23 Jan 2008 13:31:49 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, Kirill Korotaev <dev@sw.ru>
Subject: Re: [PATCH] printk deadlocks if called with runqueue lock held
Message-ID: <20080123133149.GA4059@ucw.cz>
References: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801172000430.32679@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I thought that one could place a printk anywhere without worrying.
> But it seems that it is not wise to place a printk where the runqueue
> lock is held.
> 
> I just spent two hours debugging why some of my code was locking up,
> to find that the lockup was caused by some debugging printk's that
> I had in the scheduler.  The printk's were only in rare paths so
> they shouldn't be too much of a problem, but after I hit the printk
> the system locked up.
> 
> Thinking that it was locking up on my code I went looking down the
> wrong path. I finally found (after examining an NMI dump) that
> the lockup happened because printk was trying to wakeup the klogd
> daemon, which caused a deadlock when the try_to_wakeup code tries
> to grab the runqueue lock.

Could try_to_wakeup use trylock, and only avoid wakeup if lock is
already held?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
