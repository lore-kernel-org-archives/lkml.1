Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZCPXxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZCPXxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 19:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbZCPXxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 19:53:03 -0400
Received: from www.tglx.de ([62.245.132.106]:42221 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbZCPXxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 19:53:01 -0400
Date: Tue, 17 Mar 2009 00:52:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Ingo Molnar <mingo@elte.hu>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       ltt-dev@lists.casi.polymtl.ca, danymadden@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/irq/handle.c fix kstat_irqs_cpu and irq_to_desc
 symbols
In-Reply-To: <20090316231122.GA18113@Krystal>
Message-ID: <alpine.LFD.2.00.0903170048120.29264@localhost.localdomain>
References: <20090316182227.GA2444@yoda.jdub.homelinux.org> <20090316194459.GD11878@Krystal> <20090316200115.GA22538@yoda.jdub.homelinux.org> <20090316202500.GA13872@Krystal> <20090316205829.GB22538@yoda.jdub.homelinux.org> <20090316215337.GB15119@Krystal>
 <20090316220518.GD22538@yoda.jdub.homelinux.org> <20090316231122.GA18113@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, Mathieu Desnoyers wrote:
> Mathieu :
> 
> This build problem was exhibited because of the added
> EXPORT_SYMBOL(irq_to_desc) in the LTTng tree, but only on powerpc.
> 
> Applies on 2.6.29-rc8.

Applies, but that does not make it a useful patch per se.

2.6.29-rc8/include/linux/irqnr.h has (condensed excerpt):

#ifndef CONFIG_GENERIC_HARDIRQS
#define nr_irqs                 NR_IRQS
#define irq_to_desc(irq)        (&irq_desc[irq])
#else
extern int nr_irqs;
extern struct irq_desc *irq_to_desc(unsigned int irq);
#endif  /* CONFIG_GENERIC_HARDIRQS */

And this adds right below of the #endif:
 
> +++ linux-2.6-lttng/include/linux/irqnr.h	2009-03-16 18:40:01.000000000 -0400
> @@ -38,6 +38,10 @@ extern struct irq_desc *irq_to_desc(unsi
>  
>  #endif /* CONFIG_GENERIC_HARDIRQS */
>  
> +extern int nr_irqs;
> +struct irq_desc;
> +extern struct irq_desc *irq_to_desc(unsigned int irq);
> +

Is this a contribution to the "most useless patch of the week"
contest ?

You have my vote.

    tglx


