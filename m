Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbZCQAfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbZCQAfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZCQAe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:34:58 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56732 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZCQAe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:34:57 -0400
Date: Mon, 16 Mar 2009 20:34:26 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       ltt-dev@lists.casi.polymtl.ca, danymadden@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/irq/handle.c fix kstat_irqs_cpu and irq_to_desc
	symbols v2
Message-ID: <20090317003426.GC3873@zod.rchland.ibm.com>
References: <20090316182227.GA2444@yoda.jdub.homelinux.org> <20090316194459.GD11878@Krystal> <20090316200115.GA22538@yoda.jdub.homelinux.org> <20090316202500.GA13872@Krystal> <20090316205829.GB22538@yoda.jdub.homelinux.org> <20090316215337.GB15119@Krystal> <20090316220518.GD22538@yoda.jdub.homelinux.org> <20090316231122.GA18113@Krystal> <alpine.LFD.2.00.0903170048120.29264@localhost.localdomain> <20090317000859.GB19848@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317000859.GB19848@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 08:08:59PM -0400, Mathieu Desnoyers wrote:
>* Thomas Gleixner (tglx@linutronix.de) wrote:
>> Is this a contribution to the "most useless patch of the week"
>> contest ?
>> 
>> You have my vote.
>> 
>
>Count mine too ! :) Actually, this was not what it should look like.
>Here is my version. I am not totally convinced that the struct irq_desc
>is absolutely required, but in some include orders, it might matter.
>However, the #endif around the EXPORT_SYMBOL is definitely needed.
>
>Best regards,
>
>Mathieu
>
>kernel/irq/handle.c fix kstat_irqs_cpu and irq_to_desc symbols v2
>
>On Mon, Mar 16, 2009 at 05:53:37PM -0400, Mathieu Desnoyers wrote:
>>* Josh Boyer (jwboyer@linux.vnet.ibm.com) wrote:
>>> On Mon, Mar 16, 2009 at 04:25:00PM -0400, Mathieu Desnoyers wrote:
>>> >* Josh Boyer (jwboyer@linux.vnet.ibm.com) wrote:
>>> >> On Mon, Mar 16, 2009 at 03:44:59PM -0400, Mathieu Desnoyers wrote:
>>> >> >* Josh Boyer (jwboyer@linux.vnet.ibm.com) wrote:
>>> >> >> Hi All,
>>> >> >> 
>>> >> >> I was attempting to build a simple ppc64_defconfig using
>>> >> >> the latest LTTng tag from git.  When doing a:
>>> >> >> 
>>> >> >> 	make ppc64_defconfig
>>> >> >> 	make
>>> >> >> 
>>> >> >> I get the error below.
>>> >> >> 
>>> >> >
>>> >> >Hi Josh,
>>> >> >
>>> >> >Yes, LTTng has been tested with slub, but not for the powerpc64
>>> >> >cross-build. Thanks for the report, this is actually a header circular
>>> >> >dependency I caused. It should be fixed in LTTng 0.111.
>>> >> 
>>> >> Bah. Yes, I should have clarified on ppc/ppc64.  Sorry for the confusion
>>> >> there.
>>> >> 
>>> >> >I'll have to update my powerpc64 cross compiler to test it, because I am
>>> >> >stucked with a broken gcc 4.1. Please tell me if 0.111 fixes the problem
>>> >> >for you or if you encounter other problems.
>>> >> 
>>> >> Yep, the extern on tb_ticks_per_sec is what I had come up with locally.
>>> >> It should work fine, and does indeed get past the error I was seeing.  The
>>> >> build now dies with:
>>> >> 
>>> >> kernel/irq/handle.c:259: error: __ksymtab_irq_to_desc causes a section type conflict
>>> >> kernel/irq/handle.c:259: error: __ksymtab_irq_to_desc causes a section type conflict
>>> >> make[2]: *** [kernel/irq/handle.o] Error 1
>>> >> make[1]: *** [kernel/irq] Error 2
>>> >> make: *** [kernel] Error 2
>>> >> make: *** Waiting for unfinished jobs....
>>> >> 
>>> >
>>> >Can I get your full .config ?
>>> 
>>> Sure, attached.  Note, this is just:
>>> 
>>> make ppc64_defconfig
>>> make vmlinux
>>> 
>>> josh
>>
>>Can you try moving this code around ?
>
>Yep, allows vmlinux and modules to build just fine.  Here's a patch for you ;)
>
>Based on a patch from Josh Boyer <jwboyer@linux.vnet.ibm.com>, updated by
>Mathieu Desnoyers.

You don't need to credit me here.  All I did was take your "Can you try moving
this code around" sequence and actually turn it into patch format.

I do agree the #endif move is needed in the builds I was trying though.

josh

>Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>---
> include/linux/irqnr.h |    1 +
> kernel/irq/handle.c   |    2 +-
> 2 files changed, 2 insertions(+), 1 deletion(-)
>
>Index: linux-2.6-lttng/include/linux/irqnr.h
>===================================================================
>--- linux-2.6-lttng.orig/include/linux/irqnr.h	2009-03-16 18:45:40.000000000 -0400
>+++ linux-2.6-lttng/include/linux/irqnr.h	2009-03-16 19:45:26.000000000 -0400
>@@ -23,6 +23,7 @@
> #else /* CONFIG_GENERIC_HARDIRQS */
>
> extern int nr_irqs;
>+struct irq_desc;
> extern struct irq_desc *irq_to_desc(unsigned int irq);
>
> # define for_each_irq_desc(irq, desc)					\
>Index: linux-2.6-lttng/kernel/irq/handle.c
>===================================================================
>--- linux-2.6-lttng.orig/kernel/irq/handle.c	2009-03-16 18:45:40.000000000 -0400
>+++ linux-2.6-lttng/kernel/irq/handle.c	2009-03-16 19:44:05.000000000 -0400
>@@ -473,6 +473,6 @@ unsigned int kstat_irqs_cpu(unsigned int
> 	struct irq_desc *desc = irq_to_desc(irq);
> 	return desc ? desc->kstat_irqs[cpu] : 0;
> }
>-#endif
> EXPORT_SYMBOL(kstat_irqs_cpu);
>+#endif
>
>
>-- 
>Mathieu Desnoyers
>OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
