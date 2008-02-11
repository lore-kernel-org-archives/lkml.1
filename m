Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbYBKJjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbYBKJjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYBKJjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:39:35 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:48468 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYBKJjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:39:33 -0500
Message-ID: <47B01741.2060006@linux.vnet.ibm.com>
Date: Mon, 11 Feb 2008 15:07:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       Robert Reif <reif@earthlink.net>
Subject: Re: [patch] sparc: fix build
References: <20080207231230.GE7198@cs181133002.pp.htv.fi> <alpine.DEB.1.00.0802071538440.15050@chino.kir.corp.google.com> <20080210153355.GA6737@palantir8> <alpine.DEB.1.00.0802101117510.5043@chino.kir.corp.google.com> <47AF7048.3060200@earthlink.net> <alpine.DEB.1.00.0802101529310.17892@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.0802101529310.17892@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> Fix build failures on sparc:
> 
> 	In file included from include/linux/mm.h:39,
> 	                from include/linux/memcontrol.h:24,
> 	                from include/linux/swap.h:8,
> 	                from include/linux/suspend.h:7,
> 	                from init/do_mounts.c:6:
> 	include/asm/pgtable.h:344: warning: parameter names (without
> 		types) in function declaration
> 	include/asm/pgtable.h:345: warning: parameter names (without
> 		types) in function declaration
> 	include/asm/pgtable.h:346: error: expected '=', ',', ';', 'asm' or
> 		'__attribute__' before '___f___swp_entry'
> 
> and
> 
> 	arch/sparc/kernel/led.c: In function 'led_blink':
> 	arch/sparc/kernel/led.c:35: error: invalid use of undefined type
> 		'struct timer_list'
> 	arch/sparc/kernel/led.c:35: error: 'jiffies' undeclared (first use
> 		in this function)
> 	arch/sparc/kernel/led.c:35: error: (Each undeclared identifier is
> 		reported only once
> 	arch/sparc/kernel/led.c:35: error: for each function it appears
> 		in.)
> 	arch/sparc/kernel/led.c:36: error: 'avenrun' undeclared (first use
> 		in this function)
> 	arch/sparc/kernel/led.c:36: error: 'FSHIFT' undeclared (first use
> 		in this function)
> 	arch/sparc/kernel/led.c:36: error: 'HZ' undeclared (first use in
> 		this function)
> 	arch/sparc/kernel/led.c:37: error: invalid use of undefined type
> 		'struct timer_list'
> 	arch/sparc/kernel/led.c:39: error: invalid use of undefined type
> 		'struct timer_list'
> 	arch/sparc/kernel/led.c:40: error: invalid use of undefined type
> 		'struct timer_list'
> 	arch/sparc/kernel/led.c:42: error: implicit declaration of
> 		function 'add_timer'
> 	arch/sparc/kernel/led.c: In function 'led_write_proc':
> 	arch/sparc/kernel/led.c:70: error: implicit declaration of
> 		function 'copy_from_user'
> 	arch/sparc/kernel/led.c:84: error: implicit declaration of
> 		function 'del_timer_sync'
> 	arch/sparc/kernel/led.c: In function 'led_init':
> 	arch/sparc/kernel/led.c:109: error: implicit declaration of
> 		function 'init_timer'
> 	arch/sparc/kernel/led.c:110: error: invalid use of undefined type
> 		'struct timer_list'
> 
> Cc: Adrian Bunk <bunk@kernel.org>
> Cc: Robert Reif <reif@earthlink.net>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  arch/sparc/kernel/led.c    |    3 ++-
>  include/linux/memcontrol.h |    3 ---
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/sparc/kernel/led.c b/arch/sparc/kernel/led.c
> --- a/arch/sparc/kernel/led.c
> +++ b/arch/sparc/kernel/led.c
> @@ -1,8 +1,9 @@
> -#include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/proc_fs.h>
>  #include <linux/string.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> 
>  #include <asm/auxio.h>
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -20,9 +20,6 @@
>  #ifndef _LINUX_MEMCONTROL_H
>  #define _LINUX_MEMCONTROL_H
> 
> -#include <linux/rcupdate.h>
> -#include <linux/mm.h>
> -
>  struct mem_cgroup;
>  struct page_cgroup;
>  struct page;

This patch allowed my sparc cross compiler to build beyond mm/memcontrol.o, but
I faced a build issue at

drivers/net/e1000e/netdev.c: In function 'e1000e_update_stats':
drivers/net/e1000e/netdev.c:2583: error: unable to find a register to spill in
class 'FP_REGS'
drivers/net/e1000e/netdev.c:2583: error: this is the insn:
(insn 66 2379 2236 2 drivers/net/e1000e/netdev.c:2459 (set (reg:DI 487 [ D.34076 ])
        (mem/s/j:DI (plus:SI (reg/v/f:SI 11 %o3 [orig:492 adapter ] [492])
                (reg:SI 7 %g7 [514])) [0 <variable>.stats.gprc+0 S8 A128])) 45
{*movdi_insn_sp32} (insn_list:REG_DEP_TRUE 65 (insn_list:REG_DEP_ANTI 32 (nil)))
    (expr_list:REG_EQUIV (mem/s/j:DI (plus:SI (reg/v/f:SI 11 %o3 [orig:492
adapter ] [492])
                (reg:SI 7 %g7 [514])) [0 <variable>.stats.gprc+0 S8 A128])
        (nil)))
drivers/net/e1000e/netdev.c:2583: confused by earlier errors, bailing out
make[3]: *** [drivers/net/e1000e/netdev.o] Error 1
make[2]: *** [drivers/net/e1000e] Error 2
make[1]: *** [drivers/net] Error 2

So for the problem reported

Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
