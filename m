Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYCYR3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYCYR3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbYCYR3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:29:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbYCYR3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:29:32 -0400
Message-ID: <47E93655.10907@redhat.com>
Date: Tue, 25 Mar 2008 13:28:53 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] srat, x86_64: Add support for nodes spanning other nodes
References: <20080325171435.GA3313@linux-os.sc.intel.com>
In-Reply-To: <20080325171435.GA3313@linux-os.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> For example, If the physical address layout on a two node system with 8 GB
> memory is something like:
> node 0: 0-2GB, 4-6GB
> node 1: 2-4GB, 6-8GB
> 
> Current kernels fail to boot/detect this NUMA topology.
> 
> ACPI SRAT tables can expose such a topology which needs to be supported.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 227fdb0..99eb102 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -880,6 +880,15 @@ config X86_64_ACPI_NUMA
>  	help
>  	  Enable ACPI SRAT based node topology detection.
>  
> +# Some NUMA nodes have memory ranges that span
> +# other nodes.  Even though a pfn is valid and
> +# between a node's start and end pfns, it may not
> +# reside on that node.  See memmap_init_zone()
> +# for details.
> +config NODES_SPAN_OTHER_NODES
> +	def_bool y
> +	depends on X86_64_ACPI_NUMA
> +

Is this hunk a leftover from your testing?  You're not using the config option 
anywhere, and there isn't really anything in this patch that would justify 
making this a separate config option in mainline.

-- Chris
