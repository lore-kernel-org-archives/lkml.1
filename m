Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbXDYX2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbXDYX2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbXDYX2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:28:42 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34732 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754586AbXDYX2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:28:39 -0400
Date: Thu, 26 Apr 2007 01:28:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425232806.GL17387@elf.ucw.cz>
References: <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain> <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org> <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org> <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org> <20070425224928.GJ17387@elf.ucw.cz> <alpine.LFD.0.98.0704251601020.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704251601020.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I don't understand how you can even *claim* something like that.
> > 
> > BTW most problems are in thaw/resume functions.
> 
> And do you realize that the thaw/resume functions are totally different 
> too?
> 
> Or rather, they *would* be, if you allowed them to.
> 
> For example, for "snapshot + thaw", the _sane_ thing is to actually make 
> the snapshot just throw away all the DMA tables etc, and let the thawing 
> just do a full initialization (as it did on boot). It basically needs to 
> do that anyway, and it simplifies the whole thing (ie you don't even 
> *want* to save things like the DMA command queues etc - the ones that will 
> quite often be stepped on by the final "write snapshot to disk" stuff 
> anyway).

I'd prefer thaw to be similar to module insert, yes.

> For suspend to ram, in contrast, since you *know* that nobody will be 
> touching the hardware, and since the timings are very different anyway 
> (you'd hope that you can resume in a second or two), you'd generally want 
> to keep the DMA engine tables right where they are, and just literally 
> suspend the PCI chip itself.

I'd actually prefer resume to be similar to module insert, too... Do
you think that resume is _that_ time critical?

> You think they have things in common just because your whole (incorrect) 
> mindset has _forced_ them to have things in common, becasue your setup 
> stupidly thinks that "resume" is the same as "thaw", the same way you 
> think "freeze" is the same as "suspend".
> 
> NEITHER is true. You've _made_ them true in your mind, but there's 
> absolutely zero reason that they *should* be true.

[I'd like you to drop me a line saying you understand current design
and that it works -- even if it is very inelegant]

Now, we can separate suspend/freeze and resume/thaw (with some common
helpers). It will speed the code up by avoiding unneccessary
operations. It also needs attetion from driver writers (ouch).

Do we want to do that?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
