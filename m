Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499Ab0AZQt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab0AZQt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996Ab0AZQt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:49:57 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:18201 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab0AZQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:49:56 -0500
Date: Tue, 26 Jan 2010 08:48:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: adharmap@codeaurora.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
       dwalker@codeaurora.org, Arnd Bergmann <arnd@arndb.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joerg Roedel <joerg.roedel@amd.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Dan Williams <dan.j.williams@intel.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Yang Hongyang <yanghy@cn.fujitsu.com>, linux-arch@vger.kernel.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: Re: [RFC PATCH] dma: Add barrierless dma mapping/unmapping api
Message-Id: <20100126084859.d33904d3.randy.dunlap@oracle.com>
In-Reply-To: <1264473346-32721-1-git-send-email-adharmap@codeaurora.org>
References: <1264473346-32721-1-git-send-email-adharmap@codeaurora.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B5F1D0C.00EB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010 18:35:46 -0800 adharmap@codeaurora.org wrote:

> From: Abhijeet Dharmapurikar <adharmap@quicinc.com>
> 
> Tests have shown that there is a significant performance gain
> when a driver uses mapping/unmapping functions without a barrier
> multiple times and calls dsb() only after the last buffer. This
> api adds support for barrierless dma operations on ARMv6
> and ARMv7.
> 
> Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> ---
> 
> Please refer to the earlier post here http://lkml.org/lkml/2010/1/4/347. 
> These changes only are only for the arm v6 and v7
> architecture and introduce dma_map/unmap_single_nobarrier api.
> The idea is to extend the cpu_cache_fns.dma_.*_range functions to accept 
> a third boolean argument that tells it whether to execute the barrier or
> skip it. Note that this applies over Linux 2.6.33-rc5 and needs a few changes
> to apply on the linux-next tree.
> 
> 
>  arch/arm/include/asm/cacheflush.h  |   12 ++++----
>  arch/arm/include/asm/dma-mapping.h |   57 ++++++++++++++++++++++++++++++++++--
>  arch/arm/mm/cache-v6.S             |   15 ++++++----
>  arch/arm/mm/cache-v7.S             |   19 +++++++++++-
>  arch/arm/mm/dma-mapping.c          |   17 ++++++-----
>  drivers/staging/dream/pmem.c       |    4 +-
>  6 files changed, 97 insertions(+), 27 deletions(-)


Along with the other comments, the patch is also missing updates
to Documentation/DMA-API.txt ...


---
~Randy
