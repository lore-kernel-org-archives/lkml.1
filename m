Return-Path: <linux-kernel-owner+w=401wt.eu-S1759688AbYGPOXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688AbYGPOXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbYGPOWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:22:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42906 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757520AbYGPOWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:22:42 -0400
Date: Wed, 16 Jul 2008 16:22:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: more header fixes
Message-ID: <20080716142225.GA19054@elte.hu>
References: <20080618103006.GF15255@elte.hu> <19f34abd0806180919v5a8c21e7ua7e1f928d8a53ab4@mail.gmail.com> <20080626120202.GH29619@elte.hu> <19f34abd0806260953h504ff85dmf11a59171df3442b@mail.gmail.com> <20080701092820.GA31309@elte.hu> <20080716115137.GA8075@elte.hu> <19f34abd0807160550v68aacb58nbdd46b0fe74c4704@mail.gmail.com> <20080716130839.GA1296@elte.hu> <20080716131745.GA10266@elte.hu> <19f34abd0807160646t55aa7227t4ac53302345ee828@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807160646t55aa7227t4ac53302345ee828@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Wed, Jul 16, 2008 at 3:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> thanks. I've picked up these changes and rebased them to -git. (that
> >> way they can be maintained as a topic easier) The few files that were
> >> left out due to conflicts we can do later on. I pushed the result out
> >> into the tip/x86/header-guards topic branch - please double-check that
> >> i merged it right.
> >
> > hm, doesnt work with:
> >
> > http://redhat.com/~mingo/misc/config-Wed_Jul_16_15_13_24_CEST_2008.bad
> >
> > include/asm/mpspec.h:39: error: 'MAX_MP_BUSSES' undeclared here (not in
> > a function)
> > In file included from include/asm/smp.h:15,
> >                 from include/linux/smp.h:28,
> >                 from include/asm/desc.h:8,
> >                 from include/asm/elf.h:89,
> >                 from include/linux/elf.h:7,
> >                 from arch/x86/boot/compressed/misc.c:29:
> > include/asm/io_apic.h:149: error: 'MAX_IRQ_SOURCES' undeclared here (not
> > in a function)
> >
> > etc. Some of those header guards confused some other code i guess.
> 
> Yes, you are right. Check out this incredibly hideous hack of
> arch/x86/boot/compressed/misc.c:
> 
> /*
>  * we have to be careful, because no indirections are allowed here, and
>  * paravirt_ops is a kind of one. As it will only run in baremetal anyway,
>  * we just keep it from happening
>  */
> #undef CONFIG_PARAVIRT
> #ifdef CONFIG_X86_32
> #define _ASM_DESC_H_ 1
> #endif
> 
> #ifdef CONFIG_X86_64
> #define _LINUX_STRING_H_ 1
> #define __LINUX_BITMAP_H 1
> #endif
> 
> I'm not sure how we should proceed with this. On one hand, we could 
> just fix the issues as they come up and be done with it. On the other 
> hand, this was exactly the thing I wanted to avoid by automatic it. I 
> guess it can never be fully automated... The question is if there is 
> any danger of *silent* (read: runtime) breakage, which would be much 
> worse than compiler errors.

dont worry, lets fix the above hideous hack first, then i can merge the 
guards fixes ontop of that fix. That's why we do testing, to catch the 
cases where assumptions fail. Your script is just fine - it beats having 
to edit 280+ files by hand ...

	Ingo
