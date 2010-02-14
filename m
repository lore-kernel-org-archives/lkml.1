Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0BNGNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 01:13:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:39486 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab0BNGNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 01:13:31 -0500
Subject: Re: [PATCH 8/9] of/sparc: Remove sparc-local declaration of
 allnodes and devtree_lock
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: monstr@monstr.eu, sfr@canb.auug.org.au, jeremy.kerr@canonical.com,
       davem@davemloft.net, microblaze-uclinux@itee.uq.edu.au,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100213160309.4767.94443.stgit@angua>
References: <20100213154838.4767.83881.stgit@angua>
	 <20100213160309.4767.94443.stgit@angua>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 17:13:09 +1100
Message-ID: <1266127989.16346.65.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-13 at 09:03 -0700, Grant Likely wrote:
> Both allnodes and devtree_lock are defined in common code.  The
> extern declaration should be in the common header too so that the
> compiler can type check.  allnodes is already in of.h, but
> devtree_lock should be declared there too.
> 
> This patch removes the SPARC declarations and uses decls in of.h instead.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
> 
>  arch/sparc/kernel/prom.h |    3 ---
>  include/linux/of.h       |    2 ++
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/sparc/kernel/prom.h b/arch/sparc/kernel/prom.h
> index 453397f..a8591ef 100644
> --- a/arch/sparc/kernel/prom.h
> +++ b/arch/sparc/kernel/prom.h
> @@ -4,9 +4,6 @@
>  #include <linux/spinlock.h>
>  #include <asm/prom.h>
>  
> -extern struct device_node *allnodes;	/* temporary while merging */
> -extern rwlock_t devtree_lock;	/* temporary while merging */
> -
>  extern void * prom_early_alloc(unsigned long size);
>  extern void irq_trans_init(struct device_node *dp);
>  
> diff --git a/include/linux/of.h b/include/linux/of.h
> index d34cc5d..f6d9cbc 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -19,6 +19,7 @@
>  #include <linux/bitops.h>
>  #include <linux/kref.h>
>  #include <linux/mod_devicetable.h>
> +#include <linux/spinlock.h>
>  
>  #include <asm/byteorder.h>
>  
> @@ -67,6 +68,7 @@ struct device_node {
>  /* Pointer for first entry in chain of all nodes. */
>  extern struct device_node *allnodes;
>  extern struct device_node *of_chosen;
> +extern rwlock_t devtree_lock;
>  
>  static inline int of_node_check_flag(struct device_node *n, unsigned long flag)
>  {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


