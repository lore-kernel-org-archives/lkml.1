Return-Path: <linux-kernel-owner+w=401wt.eu-S1761899AbYG3Mzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761899AbYG3Mzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbYG3Mza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:55:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbYG3Mz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:55:29 -0400
Date: Wed, 30 Jul 2008 08:55:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Simon Horman <horms@verge.net.au>
Cc: kexec@lists.infradead.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] kdump: use is_kdump_kernel() in sba_init()
Message-ID: <20080730125522.GA16373@redhat.com>
References: <20080729081235.293361145@vergenet.net> <20080729081629.356523305@vergenet.net> <20080729231507.GF6370@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729231507.GF6370@verge.net.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 09:15:10AM +1000, Simon Horman wrote:
> After recent patches* is_kdump_kernel() should return 1 in the
> case where code is executing in a crashkernel and 0 otherwise.
> It is safe to use outside of CONFIG_CRASH_DUMP.
> 
> * http://lkml.org/lkml/2008/7/28/445
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> 
> Index: linux-2.6/arch/ia64/hp/common/sba_iommu.c
> ===================================================================
> --- linux-2.6.orig/arch/ia64/hp/common/sba_iommu.c	2008-07-29 10:57:17.000000000 +1000
> +++ linux-2.6/arch/ia64/hp/common/sba_iommu.c	2008-07-29 10:57:51.000000000 +1000
> @@ -2070,14 +2070,13 @@ sba_init(void)
>  	if (!ia64_platform_is("hpzx1") && !ia64_platform_is("hpzx1_swiotlb"))
>  		return 0;
>  
> -#if defined(CONFIG_IA64_GENERIC) && defined(CONFIG_CRASH_DUMP) && \
> -        defined(CONFIG_PROC_FS)
> +#if defined(CONFIG_IA64_GENERIC)
>  	/* If we are booting a kdump kernel, the sba_iommu will
>  	 * cause devices that were not shutdown properly to MCA
>  	 * as soon as they are turned back on.  Our only option for
>  	 * a successful kdump kernel boot is to use the swiotlb.
>  	 */
> -	if (elfcorehdr_addr < ELFCORE_ADDR_MAX) {
> +	if (is_kdump_kernel()) {
>  		if (swiotlb_late_init_with_default_size(64 * (1<<20)) != 0)
>  			panic("Unable to initialize software I/O TLB:"
>  				  " Try machvec=dig boot option");

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

