Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbXD0FHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbXD0FHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbXD0FHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:07:22 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41148 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbXD0FHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:07:20 -0400
Date: Fri, 27 Apr 2007 10:40:57 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] include/linux/kprobes.h: always offer show_registers() prototype
Message-ID: <20070427051056.GB9787@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070426234749.GJ3468@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426234749.GJ3468@stusta.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 01:47:49AM +0200, Adrian Bunk wrote:
> Allow gcc to perform show_registers() type checking also with 
> CONFIG_KPROBES=n.

Is kprobes.h the correct place to allow for this change? Perhaps, with
Christoph's patch http://marc.info/?l=linux-kernel&m=117432009501114&w=2
consolidating the die_notifier code, this could be moved to
include/linux/kdebug.h instead?

Ananth

> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
> This patch has been sent on:
> - 27 Mar 2007
> 
>  include/linux/kprobes.h |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.21-rc4-mm1/include/linux/kprobes.h.old	2007-03-26 15:28:27.000000000 +0200
> +++ linux-2.6.21-rc4-mm1/include/linux/kprobes.h	2007-03-26 15:32:23.000000000 +0200
> @@ -163,7 +163,6 @@
>  extern void arch_arm_kprobe(struct kprobe *p);
>  extern void arch_disarm_kprobe(struct kprobe *p);
>  extern int arch_init_kprobes(void);
> -extern void show_registers(struct pt_regs *regs);
>  extern kprobe_opcode_t *get_insn_slot(void);
>  extern void free_insn_slot(kprobe_opcode_t *slot, int dirty);
>  extern void kprobes_inc_nmissed_count(struct kprobe *p);
> @@ -241,4 +240,7 @@
>  {
>  }
>  #endif				/* CONFIG_KPROBES */
> +
> +void show_registers(struct pt_regs *regs);
> +
>  #endif				/* _LINUX_KPROBES_H */
