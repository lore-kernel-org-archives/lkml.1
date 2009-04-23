Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZDWGiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZDWGiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZDWGiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:38:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49928 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbZDWGiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:38:03 -0400
Date: Thu, 23 Apr 2009 08:36:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: fresh data was Re: [PATCH] X86-32: Let gcc decide whether to
	inline memcpy was Re: New x86 warning
Message-ID: <20090423063625.GB9833@elte.hu>
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu> <8763gxoz50.fsf_-_@basil.nowhere.org> <alpine.LFD.2.00.0904221354320.3101@localhost.localdomain> <20090422211501.GD13896@one.firstfloor.org> <alpine.LFD.2.00.0904221417110.3101@localhost.localdomain> <20090422220428.GE13896@one.firstfloor.org> <87skjzoqah.fsf_-_@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skjzoqah.fsf_-_@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Andi Kleen <andi@firstfloor.org> writes:
> 
> >> > Quick test here:
> >> 
> >> How about you just compile the kernel with gcc-3.2 and compare the number 
> >> of calls to memcpy before-and-after instead? That's the real test.
> >
> > I waited over 10 minutes for the full vmlinux objdumps to finish. sorry lost
> > patience. If someone has a fast disassembler we can try it. I'll leave
> > them running over night, maybe there are exact numbers tomorrow.
> >
> > But from a quick check (find -name '*.o' | xargs nm | grep memcpy) there are
> > very little files which call it with the patch, so there's some
> > evidence that there isn't a dramatic increase.
> 
> I let the objdumps finish over night. [...]

objdump -d never took me more than a minute - let alone a full 
night. You must be doing something really wrong there. Looking at 
objdump -d is an essential, unavoidable component of my workflow 
with x86 architecture patches, you need to find a way to do it 
efficiently if you want to send patches for this area of the kernel.

> [...] On my setup (defconfig + some additions) there are actually 
> less calls to out of line memcpy/__memcpy with the patch. I see 
> only one for my defconfig, while there are ~10 without the patch. 
> So it makes very little difference. The code size savings must 
> come from more efficient code generation for the inline case. I 
> haven't investigated that in detail though.
> 
> So the patch seems like a overall win.

It's a clear loss here with GCC 3.4, and it took me less than 5 
minutes to figure that out.

With what precise compiler version did you test (please paste the 
gcc -v output), and could you send me the precise .config you used, 
and describe the method you used to determine the number of 
out-of-line memcpy calls? I'd like to double-check your numbers.

	Ingo
