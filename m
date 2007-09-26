Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbXIZIUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbXIZIUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 04:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbXIZIUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 04:20:08 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:45781 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbXIZIUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:20:06 -0400
Message-ID: <46FA1604.3040808@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2007 13:49:16 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Badari Pulavarty <pbadari@gmail.com>
Subject: Re: 2.6.23-rc8-mm1 - powerpc memory hotplug link failure
References: <20070925014625.3cd5f896.akpm@linux-foundation.org> <46F968C2.7080900@linux.vnet.ibm.com> <20070926103205.c72a8e8a.kamezawa.hiroyu@jp.fujitsu.com> <20070926104854.7cc09d13.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070926104854.7cc09d13.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 26 Sep 2007 10:32:05 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> Maybe my patch is the problem. could you give me your .config ?
>>
> Ah, memory hot remove is selectable even if the arch doesn't support it....sorry.
> 
> ok, this is fix.
> 
> Thanks,
> -Kame
> ==
> MEMORY_HOTREMOVE config option is selectable even it arch doesn't support it.
> This fix it.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> 
> Index: linux-2.6.23-rc8-mm1/arch/ia64/Kconfig
> ===================================================================
> --- linux-2.6.23-rc8-mm1.orig/arch/ia64/Kconfig
> +++ linux-2.6.23-rc8-mm1/arch/ia64/Kconfig
> @@ -305,6 +305,9 @@ config HOTPLUG_CPU
>  config ARCH_ENABLE_MEMORY_HOTPLUG
>  	def_bool y
> 
> +config ARCH_ENABLE_MEMORY_HOTREMOVE
> +	def_bool y
> +
>  config SCHED_SMT
>  	bool "SMT scheduler support"
>  	depends on SMP
> Index: linux-2.6.23-rc8-mm1/mm/Kconfig
> ===================================================================
> --- linux-2.6.23-rc8-mm1.orig/mm/Kconfig
> +++ linux-2.6.23-rc8-mm1/mm/Kconfig
> @@ -141,7 +141,7 @@ config MEMORY_HOTPLUG_SPARSE
> 
>  config MEMORY_HOTREMOVE
>  	bool "Allow for memory hot remove"
> -	depends on MEMORY_HOTPLUG
> +	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
>  	depends on MIGRATION
> 
>  # Heavily threaded applications may benefit from splitting the mm-wide
> 
> -
Hi Kame,

Thanks, your patch fixes the problem.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
