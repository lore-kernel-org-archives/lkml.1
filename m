Return-Path: <linux-kernel-owner+w=401wt.eu-S1762150AbZDJQGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762150AbZDJQGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759355AbZDJQFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:05:53 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:60530 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756294AbZDJQFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:05:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AukFABsK30lMQW1W/2dsb2JhbACBUclygjyBPwY
Date: Fri, 10 Apr 2009 12:05:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, ananth@in.ibm.com, garyhade@us.ibm.com,
       akpm@linux-foundation.org, tglx@linutronix.de,
       systemtap@sources.redhat.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: fix set_fixmap to use phys_addr_t
Message-ID: <20090410160547.GA31132@Krystal>
References: <49DE3695.6040800@redhat.com> <tip-189cdc2b41fce3a780a6f3aa963cc4e8114aec6b@git.kernel.org> <49DF63C3.7000406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49DF63C3.7000406@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:02:32 up 41 days, 12:28,  2 users,  load average: 0.22, 0.30,
	0.22
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Masami Hiramatsu wrote:
> > Commit-ID:  189cdc2b41fce3a780a6f3aa963cc4e8114aec6b
> > Gitweb:     http://git.kernel.org/tip/189cdc2b41fce3a780a6f3aa963cc4e8114aec6b
> > Author:     Masami Hiramatsu <mhiramat@redhat.com>
> > AuthorDate: Thu, 9 Apr 2009 10:55:33 -0700
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Fri, 10 Apr 2009 15:52:59 +0200
> > 
> > x86: fix set_fixmap to use phys_addr_t
> > 
> > Impact: fix kprobes crash on 32-bit with RAM above 4G
> > 
> > Use phys_addr_t for receiving a physical address argument
> > instead of unsigned long. This allows fixmap to handle
> > pages higher than 4GB on x86-32.
> > 
> > Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> > Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> I thought I had to update ioremap.c too...
> Anyway, here is the ioremap.c update. If you think it is useful,
> please merge it.
> 
> Thank you,
> ----
> 
> x86: fix early_ioremap and early_set_fixmap to handle over 4G pages
> 
> From: Masami Hiramatsu <mhiramat@redhat.com>
> 
> Impact: Allow early_ioremap to handle over 4G pages
> 
> Use phys_addr_t and resource_size_t for receiving a physical
> address argument instead of unsigned long in early_set_fixmap
> and early_ioremap. This allows early_ioremap to handle
> pages higher than 4GB on x86-32 with PAE.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> 
>  arch/x86/include/asm/io.h |    6 ++++--
>  arch/x86/mm/ioremap.c     |   23 +++++++++++++----------
>  2 files changed, 17 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> index e5383e3..7373932 100644
> --- a/arch/x86/include/asm/io.h
> +++ b/arch/x86/include/asm/io.h
> @@ -193,8 +193,10 @@ extern void __iomem *ioremap_wc(resource_size_t offset, unsigned long size);
>   */
>  extern void early_ioremap_init(void);
>  extern void early_ioremap_reset(void);
> -extern void __iomem *early_ioremap(unsigned long offset, unsigned long size);
> -extern void __iomem *early_memremap(unsigned long offset, unsigned long size);
> +extern void __iomem *early_ioremap(resource_size_t phys_addr,
> +				   unsigned long size);
> +extern void __iomem *early_memremap(resource_size_t phys_addr,
> +				    unsigned long size);


Nitpick : those second lines are not aligned with each other. The rest
has my

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Thanks !

Mathieu

>  extern void early_iounmap(void __iomem *addr, unsigned long size);
> 
>  #define IO_SPACE_LIMIT 0xffff
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index 0dfa09d..09daebf 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -547,7 +547,7 @@ void __init early_ioremap_reset(void)
>  }
> 
>  static void __init __early_set_fixmap(enum fixed_addresses idx,
> -				   unsigned long phys, pgprot_t flags)
> +				      phys_addr_t phys, pgprot_t flags)
>  {
>  	unsigned long addr = __fix_to_virt(idx);
>  	pte_t *pte;
> @@ -566,7 +566,7 @@ static void __init __early_set_fixmap(enum fixed_addresses idx,
>  }
> 
>  static inline void __init early_set_fixmap(enum fixed_addresses idx,
> -					   unsigned long phys, pgprot_t prot)
> +					   phys_addr_t phys, pgprot_t prot)
>  {
>  	if (after_paging_init)
>  		__set_fixmap(idx, phys, prot);
> @@ -607,9 +607,10 @@ static int __init check_early_ioremap_leak(void)
>  late_initcall(check_early_ioremap_leak);
> 
>  static void __init __iomem *
> -__early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
> +__early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
>  {
> -	unsigned long offset, last_addr;
> +	unsigned long offset;
> +	resource_size_t last_addr;
>  	unsigned int nrpages;
>  	enum fixed_addresses idx0, idx;
>  	int i, slot;
> @@ -625,15 +626,15 @@ __early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
>  	}
> 
>  	if (slot < 0) {
> -		printk(KERN_INFO "early_iomap(%08lx, %08lx) not found slot\n",
> -			 phys_addr, size);
> +		printk(KERN_INFO "early_iomap(%08llx, %08lx) not found slot\n",
> +			 (u64)phys_addr, size);
>  		WARN_ON(1);
>  		return NULL;
>  	}
> 
>  	if (early_ioremap_debug) {
> -		printk(KERN_INFO "early_ioremap(%08lx, %08lx) [%d] => ",
> -		       phys_addr, size, slot);
> +		printk(KERN_INFO "early_ioremap(%08llx, %08lx) [%d] => ",
> +		       (u64)phys_addr, size, slot);
>  		dump_stack();
>  	}
> 
> @@ -680,13 +681,15 @@ __early_ioremap(unsigned long phys_addr, unsigned long size, pgprot_t prot)
>  }
> 
>  /* Remap an IO device */
> -void __init __iomem *early_ioremap(unsigned long phys_addr, unsigned long size)
> +void __init __iomem *
> +early_ioremap(resource_size_t phys_addr, unsigned long size)
>  {
>  	return __early_ioremap(phys_addr, size, PAGE_KERNEL_IO);
>  }
> 
>  /* Remap memory */
> -void __init __iomem *early_memremap(unsigned long phys_addr, unsigned long size)
> +void __init __iomem *
> +early_memremap(resource_size_t phys_addr, unsigned long size)
>  {
>  	return __early_ioremap(phys_addr, size, PAGE_KERNEL);
>  }
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
