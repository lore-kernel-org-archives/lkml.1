Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbXGFN4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbXGFN4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 09:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbXGFN4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 09:56:03 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:59476 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbXGFN4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 09:56:00 -0400
Message-ID: <468E49DE.1000100@s5r6.in-berlin.de>
Date: Fri, 06 Jul 2007 15:55:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] I386: Deactivate the test for the dead CONFIG_BALANCED_IRQ_DEBUG
 variable.
References: <Pine.LNX.4.64.0707060844280.23613@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0707060844280.23613@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> --- a/arch/i386/kernel/io_apic.c
> +++ b/arch/i386/kernel/io_apic.c
> @@ -353,7 +353,7 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t cpumask)
>  # include <linux/slab.h>		/* kmalloc() */
>  # include <linux/timer.h>	/* time_after() */
> 
> -#ifdef CONFIG_BALANCED_IRQ_DEBUG
> +#if 0 /* debug IRQ balancing */
>  #  define TDprintk(x...) do { printk("<%ld:%s:%d>: ", jiffies, __FILE__, __LINE__); printk(x); } while (0)
>  #  define Dprintk(x...) do { TDprintk(x); } while (0)
>  # else

Regarding the Subject:  Perhaps it's not of type "dead (K)config
variable"in the strict sense but rather of the type "local macro whose
name was unbefittingly taken from CONFIG_ namespace".

BTW, when I suggested the "#if 0" to you, I forgot that some developers
might be interested in compiling their kernel with
-DCONFIG_BALANCED_IRQ_DEBUG injected via the commandline. But we'll hear
from them if that's the case.

On the other hand, these debug macros seem to be very old.  I'll have a
closer look with qgit/git-blame later today.  Maybe it's time to remove
them now.
-- 
Stefan Richter
-=====-=-=== -=== --==-
http://arcgraph.de/sr/
