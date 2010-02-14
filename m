Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab0BNGcz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 01:32:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:54075 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab0BNGcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 01:32:53 -0500
Subject: Re: [PATCH 7/9] of: move definition of of_chosen into common code.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: monstr@monstr.eu, sfr@canb.auug.org.au, jeremy.kerr@canonical.com,
       davem@davemloft.net, microblaze-uclinux@itee.uq.edu.au,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100213160303.4767.36411.stgit@angua>
References: <20100213154838.4767.83881.stgit@angua>
	 <20100213160303.4767.36411.stgit@angua>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 17:12:40 +1100
Message-ID: <1266127960.16346.64.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-13 at 09:03 -0700, Grant Likely wrote:
> Rather than defining of_chosen in each arch, it can be defined for all
> in driver/of/base.c
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
> 
>  arch/microblaze/include/asm/prom.h |    2 --
>  arch/microblaze/kernel/prom.c      |    3 ---
>  arch/powerpc/include/asm/prom.h    |    2 --
>  arch/powerpc/kernel/prom.c         |    3 ---
>  drivers/of/base.c                  |    1 +
>  include/linux/of.h                 |    1 +
>  6 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
> index 8b1ebd3..aa1a437 100644
> --- a/arch/microblaze/include/asm/prom.h
> +++ b/arch/microblaze/include/asm/prom.h
> @@ -26,8 +26,6 @@
>  #include <asm/irq.h>
>  #include <asm/atomic.h>
>  
> -extern struct device_node *of_chosen;
> -
>  #define HAVE_ARCH_DEVTREE_FIXUPS
>  
>  /* Other Prototypes */
> diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
> index a7dcaf0..a15ef6d 100644
> --- a/arch/microblaze/kernel/prom.c
> +++ b/arch/microblaze/kernel/prom.c
> @@ -42,9 +42,6 @@
>  #include <asm/sections.h>
>  #include <asm/pci-bridge.h>
>  
> -/* export that to outside world */
> -struct device_node *of_chosen;
> -
>  void __init early_init_dt_scan_chosen_arch(unsigned long node)
>  {
>  	/* No Microblaze specific code here */
> diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
> index 4a5070e..7f9a50a 100644
> --- a/arch/powerpc/include/asm/prom.h
> +++ b/arch/powerpc/include/asm/prom.h
> @@ -23,8 +23,6 @@
>  #include <asm/irq.h>
>  #include <asm/atomic.h>
>  
> -extern struct device_node *of_chosen;
> -
>  #define HAVE_ARCH_DEVTREE_FIXUPS
>  
>  #ifdef CONFIG_PPC32
> diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
> index 4869c93..43238b2 100644
> --- a/arch/powerpc/kernel/prom.c
> +++ b/arch/powerpc/kernel/prom.c
> @@ -67,9 +67,6 @@ int __initdata iommu_force_on;
>  unsigned long tce_alloc_start, tce_alloc_end;
>  #endif
>  
> -/* export that to outside world */
> -struct device_node *of_chosen;
> -
>  static int __init early_parse_mem(char *p)
>  {
>  	if (!p)
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 873479a..cb96888 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -23,6 +23,7 @@
>  #include <linux/proc_fs.h>
>  
>  struct device_node *allnodes;
> +struct device_node *of_chosen;
>  
>  /* use when traversing tree through the allnext, child, sibling,
>   * or parent members of struct device_node.
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 5cd2840..d34cc5d 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -66,6 +66,7 @@ struct device_node {
>  
>  /* Pointer for first entry in chain of all nodes. */
>  extern struct device_node *allnodes;
> +extern struct device_node *of_chosen;
>  
>  static inline int of_node_check_flag(struct device_node *n, unsigned long flag)
>  {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


