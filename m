Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZIOOi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZIOOi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbZIOOiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:38:21 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46850 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbZIOOiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:38:21 -0400
Message-ID: <4AAFA6D0.9060604@linux.vnet.ibm.com>
Date: Tue, 15 Sep 2009 09:38:08 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Nathan Fontenot <nfont@austin.ibm.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] move of_drconf_cell definition to prom.h
References: <4AAABC55.4070207@austin.ibm.com> <4AAABD37.2050205@austin.ibm.com>
In-Reply-To: <4AAABD37.2050205@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Fontenot wrote:
> Move the definition of the of_drconf_cell struct from numa.c to prom.h. 
> This
> is needed so that we can parse the ibm,dynamic-memory device-tree property
> when DLPAR adding and removing memory.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> ---
> 
> Index: powerpc/arch/powerpc/include/asm/prom.h
> ===================================================================
> --- powerpc.orig/arch/powerpc/include/asm/prom.h    2009-09-11
> 12:43:39.000000000 -0500
> +++ powerpc/arch/powerpc/include/asm/prom.h    2009-09-11
> 12:52:11.000000000 -0500
> @@ -349,6 +349,18 @@
>  */
> extern void __iomem *of_iomap(struct device_node *device, int index);
> 
> +struct of_drconf_cell {
> +    u64    base_addr;
> +    u32    drc_index;
> +    u32    reserved;
> +    u32    aa_index;
> +    u32    flags;
> +};

Might as well fix this up to use a tab instead of spaces for the indentation
if you are moving it.

> +
> +#define DRCONF_MEM_ASSIGNED    0x00000008
> +#define DRCONF_MEM_AI_INVALID    0x00000040
> +#define DRCONF_MEM_RESERVED    0x00000080
> +
> /*
>  * NB:  This is here while we transition from using asm/prom.h
>  * to linux/of.h
> Index: powerpc/arch/powerpc/mm/numa.c
> ===================================================================
> --- powerpc.orig/arch/powerpc/mm/numa.c    2009-09-11 12:43:39.000000000
> -0500
> +++ powerpc/arch/powerpc/mm/numa.c    2009-09-11 12:52:11.000000000 -0500
> @@ -296,18 +296,6 @@
>     return result;
> }
> 
> -struct of_drconf_cell {
> -    u64    base_addr;
> -    u32    drc_index;
> -    u32    reserved;
> -    u32    aa_index;
> -    u32    flags;
> -};
> -
> -#define DRCONF_MEM_ASSIGNED    0x00000008
> -#define DRCONF_MEM_AI_INVALID    0x00000040
> -#define DRCONF_MEM_RESERVED    0x00000080
> -
> /*
>  * Read the next lmb list entry from the ibm,dynamic-memory property
>  * and return the information in the provided of_drconf_cell structure.
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


