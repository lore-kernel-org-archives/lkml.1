Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbXLJFvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbXLJFvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 00:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbXLJFvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 00:51:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50799 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXLJFvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 00:51:11 -0500
Date: Mon, 10 Dec 2007 14:50:02 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: sparsemem: Make SPARSEMEM_VMEMMAP selectable
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <475B6D77.6070906@am.sony.com>
References: <47537F2E.2070204@am.sony.com> <475B6D77.6070906@am.sony.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071210144624.B6EA.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Thanks.

Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>


> 
> From: Geoff Levand <geoffrey.levand@am.sony.com>
> 
> SPARSEMEM_VMEMMAP needs to be a selectable config option to
> support building the kernel both with and without sparsemem
> vmemmap support.  This selection is desirable for platforms
> which could be configured one way for platform specific
> builds and the other for multi-platform builds.
> 
> Signed-off-by: Miguel Boton <mboton@gmail.com>
> Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
> ---
> 
> Andrew, 
> 
> Please consider for 2.6.24.
> 
> -Geoff
> 
> 
>  mm/Kconfig |   15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -112,18 +112,17 @@ config SPARSEMEM_EXTREME
>  	def_bool y
>  	depends on SPARSEMEM && !SPARSEMEM_STATIC
>  
> -#
> -# SPARSEMEM_VMEMMAP uses a virtually mapped mem_map to optimise pfn_to_page
> -# and page_to_pfn.  The most efficient option where kernel virtual space is
> -# not under pressure.
> -#
>  config SPARSEMEM_VMEMMAP_ENABLE
>  	def_bool n
>  
>  config SPARSEMEM_VMEMMAP
> -	bool
> -	depends on SPARSEMEM
> -	default y if (SPARSEMEM_VMEMMAP_ENABLE)
> +	bool "Sparse Memory virtual memmap"
> +	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
> +	default y
> +	help
> +	 SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
> +	 pfn_to_page and page_to_pfn operations.  This is the most
> +	 efficient option when sufficient kernel resources are available.
>  
>  # eventually, we can have this option just 'select SPARSEMEM'
>  config MEMORY_HOTPLUG
> 
> 

-- 
Yasunori Goto 


