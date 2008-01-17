Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbYAQSpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbYAQSpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYAQSoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:44:55 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:48940 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbYAQSoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:44:54 -0500
Date: Fri, 18 Jan 2008 00:14:06 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86 refuses to build [Re: 2.6.24-rc8-mm1]
Message-ID: <20080117184406.GA561@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <20080117172857.GA24121@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117172857.GA24121@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 10:58:57PM +0530, Dhaval Giani wrote:
> On Thu, Jan 17, 2008 at 02:35:14AM -0800, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
> > 
> 
> Hi Ingo, Thomas,
> 
> x86 fails to build with 
> 
> arch/x86/mm/discontig_32.c:39:23: bios_ebda.h:
> No such file or directory
> make[1]: *** [arch/x86/mm/discontig_32.o] Error 1
> make: *** [arch/x86/mm] Error 2
> 
> Applying a trivial fix like,
> 
> ---
>  arch/x86/mm/discontig_32.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.24-rc8/arch/x86/mm/discontig_32.c
> ===================================================================
> --- linux-2.6.24-rc8.orig/arch/x86/mm/discontig_32.c
> +++ linux-2.6.24-rc8/arch/x86/mm/discontig_32.c
> @@ -36,7 +36,7 @@
>  #include <asm/e820.h>
>  #include <asm/setup.h>
>  #include <asm/mmzone.h>
> -#include <bios_ebda.h>
> +#include <asm/bios_ebda.h>
>  
>  struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
>  EXPORT_SYMBOL(node_data);
> 
> 
> causes,
> 
> kernel/built-in.o(.text+0x5131): In function `move_task_off_dead_cpu':
> include/asm/topology.h:43: undefined reference to
> `x86_cpu_to_node_map_early_ptr'
> kernel/built-in.o(.text+0x5156):include/asm/topology.h:48: undefined
> reference to `per_cpu__x86_cpu_to_node_map'
> kernel/built-in.o(.text+0x5c0d): In function `cpu_to_allnodes_group':
> include/asm/topology.h:43: undefined reference to
> `x86_cpu_to_node_map_early_ptr'
> kernel/built-in.o(.text+0x5c2e):include/asm/topology.h:48: undefined
> reference to `per_cpu__x86_cpu_to_node_map'
> kernel/built-in.o(.text+0x5e84): In function `build_sched_domains':
> include/asm/topology.h:43: undefined reference to
> `x86_cpu_to_node_map_early_ptr'

<snip>

grepping around and looking through the code, I notice it is because
these variables just do not exist for 32 bit NUMA. I am not sure how to
go about it, and will just leave it to folks who know what they are
doing there :).

-- 
regards,
Dhaval
