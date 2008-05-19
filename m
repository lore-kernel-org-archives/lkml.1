Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbYESA5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbYESA5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 20:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYESA5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 20:57:38 -0400
Received: from www.tglx.de ([62.245.132.106]:41093 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYESA5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 20:57:37 -0400
Date: Mon, 19 May 2008 02:57:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Vegard Nossum <vegard.nossum@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #10710] [BISECTED] Lots of "rescheduling IPIs" in
 powertop
In-Reply-To: <483091E6.9080703@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0805182243210.18798@apollo.tec.linutronix.de>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>  <7wuznNhcUqC.A.xiH.EsBMIB@albercik> <19f34abd0805180523o12732812k87b8ddd832843af4@mail.gmail.com> <48306E8D.5050109@firstfloor.org> <alpine.LFD.1.10.0805182017070.18798@apollo.tec.linutronix.de>
 <483091E6.9080703@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008, Andi Kleen wrote:
> Thomas Gleixner wrote:
> 
> > stop these pointless ad hominem attacks!
> 
> Just my experience from past incidents sorry. I'm sure it never happened
> to you.

Stop this encrypted FUD campain. If you have something to complain
about then please speak up in clear text. Your insinuations are just
annoying.

> >> [In case someone is interested it's CPUID 5 ECX bit 0 which enumerates
> >> if the MWAIT enumeration is there. So the correct mwait_usable() that
> >> would have avoided your problem would be something like (untested):
> >>
> >> return c->cpuid_level >= 5 &&
> >>            ((cpuid_ecx(5) & 1) == 0 || (cpuid_edx(5) >> 4) & 0xf) > 0);
> >> ]
> > 
> > I'm interested, but I'd be even more interested in some useful pointer
> > to the magic bitnumbers in that check, but don't exert yourself in
> > providing the information,
> 
> It's documented in the IA32 SDM vol2 as part of the CPUID description.
> It's a reasonable expection that everyone hacking on cpuid code has that
> at hand.

I have one at hand and I'm able to read and _understand_ it, but it's
an even more resonable expectation that:

1) someone who submits a CPUID related patch in the first place
   actually understands what he is doing.

2) someone who proposes a "proper" solution provides at least some
   useful pointer to documentation including page number or a useful
   comment to the change. Forcing the maintainers to dig out the docs
   and research the same topic again is just an impolite annoyance.

3) the submitter considers whether suitable descriptive macros or
   inlines can be introduced to make the code more readable to
   non-CPUID-hackers.

4) maintainers who trust a submitter are not exposed to nasty attacks
   by the person they trusted when an identified problematic patch
   gets reverted to the previous working state.

I'm really starting to get grumpy about your hostile and attacking
behaviour.

It was _your_ patch which caused the regression and it is a reasonable
decision of a maintainer to revert it to the previous known to work
status quo.

Also I'm impressed by your self-righteous attitude of alleging that
I'm incompetent and you need to teach me what is the reasonable
documentation. I know for sure that I'm far from perfect and I really
appreciate your experience with the x86 architecture, but please do
not try to take me for a fool.

You screwed it up in the first place and you needed the help of others
to decode the documentation, which is not that hard to get straight
(and I did _not_ talk to Venki, I did not even try to talk to him):

ECX Bits 00: Enumeration of Monitor-Mwait extensions (beyond EAX and
             EBX registers) supported

If the bit is set then the EDX values need to be evaluated. On the P4
the bit is 0 and therefor EDX must be ignored. On the AMD family 0x10
box the bit is 1 and the EDX bits are 0, which indicates that MWAIT is
not supported in any of the sub C-states. Newer Intels have the bit
set and indicate the mwait support in EDX.

So after Venki explained the meaning of ECX[bit 0] to you, you come
back and make a huge stink about the decision of the maintainers to
revert your patch which caused a regression in the first place and
just dump a cryptic solution along with nasty and insulting comments.

Do you really expect that this is an acceptable form of cooperation ?

The last time you tried to do that was your "bug fixing" IST security
hole patch and you did not have the spark of decency to come back and
admit your mistake let alone to take back your subtle allegations that
I'm not able to understand the IST mechanism and your superiour patch.

Thanks^WNoThanks^W<Plonk><

	tglx
