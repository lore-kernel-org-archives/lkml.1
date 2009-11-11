Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbZKKIRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbZKKIRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757082AbZKKIRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:17:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38841 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077AbZKKIR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:17:29 -0500
Date: Wed, 11 Nov 2009 09:17:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Willy Tarreau <w@1wt.eu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091111081727.GA24849@elf.ucw.cz>
References: <20091110201602.GA26633@1wt.eu>
 <20091110205445.GB1407@ucw.cz>
 <20091110211259.GD26633@1wt.eu>
 <4AF9D8E2.7050205@zytor.com>
 <20091110220652.GE26633@1wt.eu>
 <4AF9E61B.5090407@zytor.com>
 <20091110222031.GA22911@elte.hu>
 <20091110224222.GA28648@1wt.eu>
 <4AF9ED78.3000106@zytor.com>
 <20091111055220.GA560@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111055220.GA560@1wt.eu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >>> *THIS* is the kind of complexity that makes me think that having a 
> > >>> single source for all interpretation done in the kernel is the 
> > >>> preferred option.
> > >>
> > >> Definitely agreed ... The NX code is quite a maze right now, so changes 
> > >> to it should come generously laced with cleanups.
> > > 
> > > BTW, I don't see why we should be impacted by NX. Trying to
> > > execute from an NX page would return a SEGV, not SIGILL, so
> > > we should not be bothered, am I wrong ?
> > 
> > Yes.  Consider a page-crossing instruction.
> 
> OK, but to be pragmatic, NX is there to prevent execution of
> instructions in the stack (or heap) during buffer overflows.
> If we only implement the few instructions lised in previous
> mail, there is very little benefit to check for NX :
> 
>   - those instructions cannot jump to other code, they just
>     change one register or memory location at most (or just nop)
> 
>   - once we return from the signal handler, if we have crossed
>     a NX page boundary, the program will segfault anyway, taking
>     with it the change we just completed.
> 
>   - last, the probability of having an NX page just after an
>     executable one seems too tight to me to even constitute
>     an attack vector ! BTW, I'm not even certain that all CPUs
>     correctly implement this check !

Yes, you can probably "get away" with it. But I would not want to
debug problems on systems with half-instruction-emulation. Please do
it right, or not at all.

> So in short, I think we could reasonably implement CMOV/NOPL
> with the instruction length control, with getuser for data
> accesses but without checking the code pages permissions if
> we know that the CPU could already fetch the beginning of
> the instruction correctly to cause an invalid opcode trap.
> 
> I'm not saying this is perfect, just that this is reasonable.

Reasonable hack to get distro booting yes. Reasonable for mainline?
No.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
