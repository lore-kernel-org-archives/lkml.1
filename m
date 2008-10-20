Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYJTXcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYJTXcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYJTXcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:32:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097AbYJTXcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:32:35 -0400
Date: Mon, 20 Oct 2008 16:32:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: mitake@clustcom.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081020163228.d401e16f.akpm@linux-foundation.org>
In-Reply-To: <48f90621.hByuTnD4aM0CRbL+%dougthompson@xmission.com>
References: <48f90621.hByuTnD4aM0CRbL+%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 15:39:45 -0600
dougthompson@xmission.com wrote:

> From: Hitoshi Mitake <mitake@clustcom.com>
> 
> I wrote a new module for Intel X38 chipset.
> This chipset is very similar to Intel 3200 chipset,
> but there are some different points,
> so I copyed i3200_edac.c and modified.
> 
> This is a Intel's web page describing this chipset.
> http://www.intel.com/Products/Desktop/Chipsets/X38/X38-overview.htm
> 
> I've tested this new module with broken memory,
> and it seems working well.
> 
> This is a patch, please use.
> Hitoshi
> 
> Signed-off-by: Hitoshi Mitake <mitake@clustcom.com>
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> ---
> 
> Index: linux-2.6.27/drivers/edac/Kconfig
> ===================================================================
> --- linux-2.6.27.orig/drivers/edac/Kconfig
> +++ linux-2.6.27/drivers/edac/Kconfig
> @@ -102,6 +102,13 @@ config EDAC_I3000
>  	  Support for error detection and correction on the Intel
>  	  3000 and 3010 server chipsets.
>  
> +config EDAC_X38
> +	tristate "Intel X38"
> +	depends on EDAC_MM_EDAC && PCI && X86
> +	help
> +	  Support for error detection and correction on the Intel
> +	  X38 server chipsets.

Is this truly X86, or will this driver only ever be used on x86_64 kernels?

>
> ...
>
> +static u64 x38_readq(const void __iomem *addr)
> +{
> +	return readl(addr) | (((u64)readl(addr + 4)) << 32);
> +}

Because the x86_64 architecture already implements readq(), and it
would be nice to avoid creating a private version.


