Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbYERT2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbYERT2W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbYERT2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 15:28:10 -0400
Received: from www.tglx.de ([62.245.132.106]:38072 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbYERT2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 15:28:09 -0400
Date: Sun, 18 May 2008 21:27:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Vegard Nossum <vegard.nossum@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #10710] [BISECTED] Lots of "rescheduling IPIs" in
 powertop
In-Reply-To: <48306E8D.5050109@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0805182017070.18798@apollo.tec.linutronix.de>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>  <7wuznNhcUqC.A.xiH.EsBMIB@albercik> <19f34abd0805180523o12732812k87b8ddd832843af4@mail.gmail.com> <48306E8D.5050109@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008, Andi Kleen wrote:
> > Ingo Molnar provided the patch that solved the problem (the referenced
> > link) but he wanted to wait for Andreas Herrmann to provide an
> > additional patch that would solve some implication on AMD CPUs. So
> > this is in theory fixed, but the fix has not yet been applied anywhere
> > as far as I know.
> 
> There's a CPUID way to distingush the cases I found out now (with help
> from Venki, thanks) so it would be possible to solve it properly, but
> once even a bad Ingo patch is in it's nearly impossible to replace it
> with something better so I bail out at this point.

Andi,

stop these pointless ad hominem attacks!

When a better solution is available then it _is_ applied regardless of
the persons involved.

Right now we had the choice to wait until the CPUID solution becomes
eventually correct or just revert to the state which was working
before. There was no sign of a solution so I went back to the old
known to work state which excludes AMD family 0x10/11 from mwait.

Where is the problem ?

> [In case someone is interested it's CPUID 5 ECX bit 0 which enumerates
> if the MWAIT enumeration is there. So the correct mwait_usable() that
> would have avoided your problem would be something like (untested):
> 
> return c->cpuid_level >= 5 &&
>            ((cpuid_ecx(5) & 1) == 0 || (cpuid_edx(5) >> 4) & 0xf) > 0);
> ]

I'm interested, but I'd be even more interested in some useful pointer
to the magic bitnumbers in that check, but don't exert yourself in
providing the information, I'm going to figure it out myself.

Thanks,

	tglx
