Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab0BNGKM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 01:10:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:51607 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab0BNGKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 01:10:08 -0500
Subject: Re: [PATCH 1/9] of: Remove old and misplaced function declarations
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: monstr@monstr.eu, sfr@canb.auug.org.au, jeremy.kerr@canonical.com,
       davem@davemloft.net, microblaze-uclinux@itee.uq.edu.au,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100213160231.4767.23831.stgit@angua>
References: <20100213154838.4767.83881.stgit@angua>
	 <20100213160231.4767.23831.stgit@angua>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 17:09:36 +1100
Message-ID: <1266127776.16346.58.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-13 at 09:02 -0700, Grant Likely wrote:
> The following functions don't exist:
>   finish_device_tree()
>   print_properties()
>   prom_n_intr_cells()
>   prom_get_irq_senses()
> 
> The following functions are in drivers/of/base.c, so the declaration
> belongs in of.h instead of of_fdt.h
>   of_machine_is_compatible()
>   prom_add_property()
>   prom_remove_property()
>   prom_update_property()
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
> 
>  include/linux/of.h     |    8 ++++++++
>  include/linux/of_fdt.h |   10 ----------
>  2 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index fa5571b..5c7b6a6 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -180,6 +180,14 @@ extern int of_parse_phandles_with_args(struct device_node *np,
>  	const char *list_name, const char *cells_name, int index,
>  	struct device_node **out_node, const void **out_args);
>  
> +extern int of_machine_is_compatible(const char *compat);
> +
> +extern int prom_add_property(struct device_node* np, struct property* prop);
> +extern int prom_remove_property(struct device_node *np, struct property *prop);
> +extern int prom_update_property(struct device_node *np,
> +				struct property *newprop,
> +				struct property *oldprop);
> +
>  #if defined(CONFIG_OF_DYNAMIC)
>  /* For updating the device tree at runtime */
>  extern void of_attach_node(struct device_node *);
> diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
> index 0007187..c9cb8a7 100644
> --- a/include/linux/of_fdt.h
> +++ b/include/linux/of_fdt.h
> @@ -95,18 +95,8 @@ extern int early_init_dt_scan_root(unsigned long node, const char *uname,
>  				   int depth, void *data);
>  
>  /* Other Prototypes */
> -extern void finish_device_tree(void);
>  extern void unflatten_device_tree(void);
>  extern void early_init_devtree(void *);
> -extern int of_machine_is_compatible(const char *compat);
> -extern void print_properties(struct device_node *node);
> -extern int prom_n_intr_cells(struct device_node* np);
> -extern void prom_get_irq_senses(unsigned char *senses, int off, int max);
> -extern int prom_add_property(struct device_node* np, struct property* prop);
> -extern int prom_remove_property(struct device_node *np, struct property *prop);
> -extern int prom_update_property(struct device_node *np,
> -				struct property *newprop,
> -				struct property *oldprop);
>  
>  #endif /* __ASSEMBLY__ */
>  #endif /* _LINUX_OF_FDT_H */


