Return-Path: <linux-kernel-owner+w=401wt.eu-S2993122AbXDYXNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993122AbXDYXNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXDYXNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:13:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51460 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754509AbXDYXNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:13:30 -0400
Date: Thu, 26 Apr 2007 01:13:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425231319.GK17387@elf.ucw.cz>
References: <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain> <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org> <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org> <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org> <1177540027.5025.87.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > And name *one* thing that have in common.
> > 
> > Set/reset the scsi transaction id thingy? Hibernation didn't work with
> > SCSI for a long time precisely because that support was missing.
> 
> And by "hibernation", you mean what? You mean "snapshot + shutdown", 
> right?
> 
> Think about it for five seconds, and then ask yourself: at which point in 
> the "snapshot + shutdown" sequence would you actually tell a disk to shut 
> down?

Current design is:

Twice. Once during snapshot (then we spin it up when the snapshot is
done), and once during shutdown.

Yep, we optimize away spindown, because it takes too long, so SCSI
disks are actually very bad example.

> If you said "snapshot", then you'd be *wrong*. 
> 
> That's my _point_. The snapshot() function should not (and MUST NOT) tell 
> disks to shut down, because unlike suspend(), we're still going to _use_ 
> those disks afterwards (why? To write out the snapshot image!).

No, I'd like you to understand that we actually CAN tell the disks to
spin down, because we'll call resume and spin them back again before
writing the image. We used to do it. We still can do it, but it is
slow.

Yes, it is quite confusing.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
