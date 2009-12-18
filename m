Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbZLRBH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbZLRBH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 20:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZLRBHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 20:07:54 -0500
Received: from claw.goop.org ([74.207.240.146]:52596 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbZLRBHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 20:07:52 -0500
Message-ID: <4B2AD5E7.4030000@goop.org>
Date: Thu, 17 Dec 2009 17:07:51 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, npiggin@suse.de, akpm@osdl.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       kurt.hackel@oracle.com, Russell <rusty@rustcorp.com.au>,
       Rik van Riel <riel@redhat.com>, dave.mccracken@oracle.com,
       linux-mm@kvack.org, Rusty@rcsinet15.oracle.com,
       sunil.mushran@oracle.com, Avi Kivity <avi@redhat.com>,
       Schwidefsky <schwidefsky@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, alan@lxorguk.ukuu.org.uk,
       chris.mason@oracle.com, Pavel Machek <pavel@ucw.cz>
Subject: Re: Tmem [PATCH 4/5] (Take 3): Add mm buildfiles
References: <6160c200-144c-4cc0-b095-6fe27e9ee3a1@default>
In-Reply-To: <6160c200-144c-4cc0-b095-6fe27e9ee3a1@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 04:38 PM, Dan Magenheimer wrote:
> Tmem [PATCH 4/5] (Take 3): Add mm buildfiles
>
> Add necessary Kconfig and Makefile changes to mm directory
>    

These should be part of their respective tmem-core/frontswap/cleancache 
patches.

     J

> Signed-off-by: Dan Magenheimer<dan.magenheimer@oracle.com>
>
>   Kconfig                                  |   26 +++++++++++++++++++++
>   Makefile                                 |    3 ++
>   2 files changed, 29 insertions(+)
>
> --- linux-2.6.32/mm/Kconfig	2009-12-02 20:51:21.000000000 -0700
> +++ linux-2.6.32-tmem/mm/Kconfig	2009-12-17 13:56:46.000000000 -0700
> @@ -287,3 +287,29 @@ config NOMMU_INITIAL_TRIM_EXCESS
>   	  of 1 says that all excess pages should be trimmed.
>
>   	  See Documentation/nommu-mmap.txt for more information.
> +
> +#
> +# support for transcendent memory
> +#
> +config TMEM
> +	bool "Transcendent memory support"
> +	help
> +	  In a virtualized environment, allows unused and underutilized
> +	  system physical memory to be made accessible through a narrow
> +	  well-defined page-copy-based API.
> +
> +config CLEANCACHE
> +	bool "Cache clean pages in transcendent memory"
> +	depends on TMEM
> +	help
> +	  Allows the transcendent memory pool to be used to store clean
> +	  page-cache pages which, under some circumstances, will greatly
> +	  reduce paging and thus improve performance.
> +
> +config FRONTSWAP
> +	bool "Swap pages to transcendent memory"
> +	depends on TMEM
> +	help
> +	  Allows the transcendent memory pool to be used as a pseudo-swap
> +	  device which, under some circumstances, will greatly reduce
> +	  swapping and thus improve performance.
> --- linux-2.6.32/mm/Makefile	2009-12-02 20:51:21.000000000 -0700
> +++ linux-2.6.32-tmem/mm/Makefile	2009-12-17 14:23:40.000000000 -0700
> @@ -17,6 +17,9 @@ obj-y += init-mm.o
>
>   obj-$(CONFIG_BOUNCE)	+= bounce.o
>   obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
> +obj-$(CONFIG_TMEM)	+= tmem.o
> +obj-$(CONFIG_FRONTSWAP)	+= frontswap.o
> +obj-$(CONFIG_CLEANCACHE) += cleancache.o
>   obj-$(CONFIG_HAS_DMA)	+= dmapool.o
>   obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
>   obj-$(CONFIG_NUMA) 	+= mempolicy.o
>
>    

