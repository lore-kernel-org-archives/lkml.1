Return-Path: <linux-kernel-owner+w=401wt.eu-S1423387AbXDYWmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423387AbXDYWmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423391AbXDYWmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:42:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45071 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423387AbXDYWme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:42:34 -0400
Date: Thu, 26 Apr 2007 00:42:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425224216.GI17387@elf.ucw.cz>
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain> <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org> <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org> <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Not the same... but they are still related. "freeze" (for atomic
> > snapshot) is actually subset of "suspend"... freeze needs DMAs off and
> > saved state, and you need DMAs off and saved state for "suspend".
> 
> THEY HAVE ABSOLUTELY NOTHING IN COMMON!
> 
> Nobody in their right mind thinks that "disable DMA" and "suspend" are 
> similar operations. 
> 
> > So it is actually correct to do "suspend" when you want "freeze"; it
> > is just slow. That's why they only differ in parameter these days.
> 
> It is *not* correct to "suspend" when you want "freeze".

Example?

> I don't understand how you can even *claim* something like that.
> 
> Here's a trivial example:
>  - SCSI disk
> 
> Tell me, what does "suspend" do, and what does "freeze" (snapshot) do?

Suspend syncs caches/spins down. Freeze does not do anything.

That's okay, I keep claiming "freeze" is subset of "suspend". Can you
name device where that is not true?

Remember we do

suspend(PMSG_FREEZE)
atomic snapshot
resume()
write snapshot.

So if we do spin the scsi disk down, nothing really bad happens, we'll
just spin it up. (So scsi disk is not example I want. Spining down
scsi disk on freeze is slow and stupid, but it is not incorrect).

Yes, If I'd knew what I know now, drivers would have
suspend/freeze/thaw/resume methods. We probably still can do that
change. Unfortunately, it needs driver authors to understand 4 hooks
(not 2) and do the right thing.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
