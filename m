Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbXELTRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbXELTRS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756395AbXELTRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:17:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36787 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754920AbXELTRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:17:11 -0400
Date: Sat, 12 May 2007 21:17:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] Freezing of kernel threads
Message-ID: <20070512191709.GA428@elf.ucw.cz>
References: <200705122017.32792.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705122017.32792.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Having considered the issue of freezing (or not freezing) kernel threads for a
> longer while I tend to agree with Linus that we shouldn't be freezing as many
> kernel threads as we currently freeze, but there's one thing that he doesn't
> seem to take into account.  Namely, there may be some kernel threads that
> actually *want* (or need) to be frozen. :-)
> 
> For the suspend they may be kernel threads that otherwise would need some
> special synchronization with some device drivers' .suspend() and .resume()
> callbacks or fs-related kernel threads.  For the CPU hotplug they might be
> kernel threads that otherwise would interfere with the removal or addition of
> CPUs.  Still, in each case there seems to be a limited group of kernel threads
> that may want to be frozen and the remaining kernel threads that shouldn't be
> involved in any freezer-related actions at all.  However, we currently require
> all kernel threads to take part in the freezing mechanism, which doesn't seem to
> be correct.

Well.. It is actually a feature.

These days, you have to either add PF_NOFREEZE explicitly (which
hopefully means you know what you are doing) or add try_to_freeze() at
specific place.

If you fail to do that, we'll see freezer failure, quickly, and catch
the simple bug.

I'm afraid that if we default to "do not freeze by default", someone
will just port zfs, will know nothing about suspend, and his 
"write management info somewhere periodically" thread will corrupt
people's disks.

OTOH... perhaps suspend/resume is common enough operation that people
_know_ they need to stop their writing? ...no, I do not think we are
there yet.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
