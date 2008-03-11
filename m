Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbYCKLJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbYCKLJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 07:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYCKLJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 07:09:44 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:53972 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752372AbYCKLJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 07:09:43 -0400
Message-ID: <47D66865.1080508@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2008 16:39:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Move memory controller allocations to their own slabs
 (v2)
References: <20080311061836.6664.5072.sendpatchset@localhost.localdomain> <47D63E9D.70500@openvz.org> <47D63FB1.7040502@linux.vnet.ibm.com> <47D6443D.9000904@openvz.org>
In-Reply-To: <47D6443D.9000904@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> Balbir Singh wrote:
>> Pavel Emelyanov wrote:
>>> Balbir Singh wrote:
>>>> Move the memory controller data structure page_cgroup to its own slab cache.
>>>> It saves space on the system, allocations are not necessarily pushed to order
>>>> of 2 and should provide performance benefits. Users who disable the memory
>>>> controller can also double check that the memory controller is not allocating
>>>> page_cgroup's.
>>> Can you, please, check how many objects-per-page we have with and 
>>> without this patch for SLAB and SLUB?
>>>
>>> Thanks.
>> I can for objects-per-page with this patch for SLUB and SLAB. I am not sure
>> about what to check for without this patch. The machine is temporarily busy,
> 
> Well, the objects-per-page without the patch is objects-per-page for
> according kmalloc cache :)
> 

OK, so here is the data

On my 64 bit powerpc system (structure size could be different on other systems)

1. sizeof page_cgroup is 40 bytes
   which means kmalloc will allocate 64 bytes
2. With 4K pagesize SLAB with HWCACHE_ALIGN, 59 objects are packed per slab
3. With SLUB the value is 102 per slab



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
