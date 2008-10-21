Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbYJUGSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbYJUGSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 02:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYJUGSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 02:18:13 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:37511 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbYJUGSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 02:18:11 -0400
Message-ID: <48FD73CE.6070004@linux.vnet.ibm.com>
Date: Tue, 21 Oct 2008 11:46:46 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nishimura@mxp.nes.nec.co.jp
Subject: Re: memcg: Fix init/Kconfig documentation
References: <20081021055118.GA11429@balbir.in.ibm.com> <20081021151105.f13ec6d2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081021151105.f13ec6d2.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 21 Oct 2008 11:21:18 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> From: Balbir Singh <balbir@linux.vnet.ibm.com>
>> Date: Tue, 21 Oct 2008 11:12:45 +0530
>> Subject: [PATCH] memcg: Update Kconfig to remove the struct page overhead statement.
>>
>> The memory resource controller no longer has a struct page overhead
>> associated with it. The init/Kconfig help has been replaced with
>> something more suitable based on the current implementation.
>>
> Oh, this is my version..could you merge if this includes something good ?
> 
> ==
> Fixes menu help text for memcg-allocate-page-cgroup-at-boot.patch.
> 
> 
> Signed-off-by: KAMEZAWA hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
>  init/Kconfig |   16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> Index: mmotm-2.6.27+/init/Kconfig
> ===================================================================
> --- mmotm-2.6.27+.orig/init/Kconfig
> +++ mmotm-2.6.27+/init/Kconfig
> @@ -401,16 +401,20 @@ config CGROUP_MEM_RES_CTLR
>  	depends on CGROUPS && RESOURCE_COUNTERS
>  	select MM_OWNER
>  	help
> -	  Provides a memory resource controller that manages both page cache and
> -	  RSS memory.
> +	  Provides a memory resource controller that manages both anonymous
> +	  memory and page cache. (See Documentation/controllers/memory.txt)
> 
>  	  Note that setting this option increases fixed memory overhead
> -	  associated with each page of memory in the system by 4/8 bytes
> -	  and also increases cache misses because struct page on many 64bit
> -	  systems will not fit into a single cache line anymore.
> +	  associated with each page of memory in the system. By this,
> +	  20(40)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
> +	  usage tracking struct at boot. Total amount of this is printed out
> +	  at boot.
> 
>  	  Only enable when you're ok with these trade offs and really
> -	  sure you need the memory resource controller.
> +	  sure you need the memory resource controller. Even when you enable
> +	  this, you can set "cgroup_disable=memory" at your boot option to
> +	  disable memory resource controller and you can avoid almost all bads.
							       ^^^^ (replace)
							       the overhead

> +	  (and lost benefits of memory resource contoller)
               ^^^^
		lose

> 
>  	  This config option also selects MM_OWNER config option, which
>  	  could in turn add some fork/exit overhead.
> 

Looks good otherwise.

-- 
	Balbir
