Return-Path: <linux-kernel-owner+w=401wt.eu-S2993270AbXECPae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993270AbXECPae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993267AbXECPae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:30:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4844 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1162128AbXECP37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:29:59 -0400
Date: Thu, 3 May 2007 15:25:08 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070503152507.GE3866@ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280004.47683.rjw@sisk.pl> <alpine.LFD.0.98.0704271506080.9964@woody.linux-foundation.org> <200704280041.17617.rjw@sisk.pl> <alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704271612380.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > 1) if the kernel threads are frozen, we know that they don't hold any locks
> > that could interfere with the freezing of device drivers,
> > 2) if they are frozen, we know, for example, that they won't call user mode
> > helpers or do similar things,
> > 3) if they are frozen, we know that they won't submit I/O to disks and
> > potentially damage filesystems (suspend2 has much more problems with that
> > than swsusp, but still.  And yes, there have been bug reports related to it,
> > so it's not just my fantasy).
> 
> NONE of these are valid explanations at all. You're listing totally 
> theoretical problems, and ignoring all the _real_ problems that trying to 
> freeze kernel threads has _caused_.

xfs problem was real. And I do not see that many problems caused by
freezing kernel threads:  at least you get deadlocks, not silent fs
corruption.

> And no, kernel threads do not submit IO to disks on their own. You just 
> made that up. Yes, they can be involved in that whole disk submission 
> thing, but in a good way - they can be required in order to make disk 
> writing work!

Yep, so we have md doing io while we are doing atomic copy. That
probably means it will continue when atomic copy is done... getting
image out of sync with disk.

(Plus we used to have bdflush, doing periodic writes to disk).

> The problem that suspend has had is that it's done everything totally the 
> wrong way around. Do kernel threads do disk IO? Sure, if asked to do so. 
> For example, kernel threads can be involved in md etc, but that's a *good* 
> thing. The way to shut them up is not to freeze the threads, but to freeze 
> the *disk*.

Well, if freezing the disk was available, I'd gladly do it. Is there
easy way to implement that?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
