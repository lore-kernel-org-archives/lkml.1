Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbXD0Mu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbXD0Mu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbXD0Mu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:50:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37775 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755770AbXD0MuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:50:03 -0400
Date: Fri, 27 Apr 2007 14:49:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070427124932.GA23513@elf.ucw.cz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> <1177573348.5025.224.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > * Doing things in the right order? (Prepare the image, then do the
> > atomic copy, then save).
> 
> I'd actually like to discuss this a bit..
> 
> I'm obviously not a huge fan of the whole user/kernel level split and 
> interfaces, but I actually do think that there is *one* split that makes 
> sense:
> 
>  - generate the (whole) snapshot image entirely inside the kernel
> 
>  - do nothing else (ie no IO at all), and just export it as a single image 
>    to user space (literally just mapping the pages into user space). 
>    *one* interface. None of the "pretty UI update" crap. Just a single 
>    system call:
> 
> 	void *snapshot_system(u32 *size);
> 
>    which will map in the snapshot, return the mapped address and the size 
>    (and if you want to support snapshots > 4GB, be my guest, but I suspect 
>    you're actually *better* off just admitting that if you cannot shrink 
>    the snapshot to less than 32 bits, it's not worth doing)

I think this is very similar to current uswsusp design; except that we
are using read on /dev/snapshot to read the snapshot (not memory
mapping) and that we freeze the system (because I do not think killall
_SIGSTOP is enough).

Can you confirm that it is indeed similar design, or tell me why I'm
wrong? You had some pretty strong words for uswsusp before, so I'd
like to understand your position here. ("Ouch, I do not know, I am out
of time" is still better reply than silence.)
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
