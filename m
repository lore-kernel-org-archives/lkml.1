Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYLaMHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYLaMHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 07:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbYLaMH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 07:07:29 -0500
Received: from smtp-out-41.synserver.de ([217.119.50.41]:1044 "HELO
	smtp-out-41.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755908AbYLaMH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 07:07:27 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Dec 2008 07:07:27 EST
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 23572
Date: Wed, 31 Dec 2008 13:00:43 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, yinghai@kernel.org
Subject: Re: [sparseirq] remove debug printks (io_apic.c)
Message-ID: <20081231120043.GA2419@gentoox2.trippelsdorf.de>
References: <20081225160741.GA14486@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225160741.GA14486@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 05:07:41PM +0100, Ingo Molnar wrote:
> 
> Please pull the latest irq-core-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-core-for-linus
> 
> Most of the changes here are related to enable and implement sparseirq 
> support on x86.

> Yinghai Lu (10):
>       sparse irq_desc[] array: core kernel and x86 changes
>       x86: use NR_IRQS_LEGACY
>       x86: MSI start irq numbering from nr_irqs_gsi
>       x86, MSI: pass irq_cfg and irq_desc
>       sparseirq: fix Alpha build failure
>       sparseirq: fix !SMP && !PCI_MSI && !HT_IRQ build
>       x86, sparseirq: move irq_desc according to smp_affinity, v7
>       sparseirq: fix !SMP building, #2
>       sparseirq: add kernel-doc notation for new member in irq_desc, -v2
>       sparseirq: fix numa_migrate_irq_desc dependency and comments

The message "alloc irq_2_pin on cpu 0 node 0" is printed way too often.

% dmesg|grep irq_2_pin|wc -l
20

Get rid of the debug printks.

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
---
 arch/x86/kernel/io_apic.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index f6ea94b..66f97b2 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -129,7 +129,6 @@ static struct irq_pin_list *get_one_free_irq_2_pin(int cpu)
 	node = cpu_to_node(cpu);
 
 	pin = kzalloc_node(sizeof(*pin), GFP_ATOMIC, node);
-	printk(KERN_DEBUG "  alloc irq_2_pin on cpu %d node %d\n", cpu, node);
 
 	return pin;
 }
@@ -207,7 +206,6 @@ static struct irq_cfg *get_one_free_irq_cfg(int cpu)
 	node = cpu_to_node(cpu);
 
 	cfg = kzalloc_node(sizeof(*cfg), GFP_ATOMIC, node);
-	printk(KERN_DEBUG "  alloc irq_cfg on cpu %d node %d\n", cpu, node);
 
 	return cfg;
 }
-- 
Markus
