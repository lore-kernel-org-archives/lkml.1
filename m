Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYIQSNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYIQSNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYIQSNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:13:16 -0400
Received: from gw.goop.org ([64.81.55.164]:37612 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbYIQSNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:13:15 -0400
Message-ID: <48D148BD.5020302@goop.org>
Date: Wed, 17 Sep 2008 11:13:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, tglx@tglx.de
Subject: Re: [PATCH] x86: print DMI information in the oops trace
References: <20080916112730.0b57689d@infradead.org>
In-Reply-To: <20080916112730.0b57689d@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] x86: print DMI information in the oops trace
>
> in order to diagnose hard system specific issues, it's useful to
> have the system name in the oops (as provided by DMI)
>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  arch/x86/kernel/process_32.c |   10 ++++++++--
>   

Not on 64-bit too?

    J

>  1 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> index 4eb2159..d9f34cf 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -37,6 +37,7 @@
>  #include <linux/tick.h>
>  #include <linux/percpu.h>
>  #include <linux/prctl.h>
> +#include <linux/dmi.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/pgtable.h>
> @@ -127,6 +128,7 @@ void __show_regs(struct pt_regs *regs, int all)
>  	unsigned long d0, d1, d2, d3, d6, d7;
>  	unsigned long sp;
>  	unsigned short ss, gs;
> +	const char *board;
>  
>  	if (user_mode_vm(regs)) {
>  		sp = regs->sp;
> @@ -139,11 +141,15 @@ void __show_regs(struct pt_regs *regs, int all)
>  	}
>  
>  	printk("\n");
> -	printk("Pid: %d, comm: %s %s (%s %.*s)\n",
> +
> +	board = dmi_get_system_info(DMI_PRODUCT_NAME);
> +	if (!board)
> +		board = "";
> +	printk("Pid: %d, comm: %s %s (%s %.*s) %s\n",
>  			task_pid_nr(current), current->comm,
>  			print_tainted(), init_utsname()->release,
>  			(int)strcspn(init_utsname()->version, " "),
> -			init_utsname()->version);
> +			init_utsname()->version, board);
>  
>  	printk("EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
>  			(u16)regs->cs, regs->ip, regs->flags,
>   

