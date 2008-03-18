Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbYCRBMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbYCRBMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 21:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757383AbYCRBMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 21:12:06 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:49675 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808AbYCRBME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 21:12:04 -0400
Message-ID: <47DF167D.9040405@linux.vnet.ibm.com>
Date: Tue, 18 Mar 2008 06:40:21 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
CC: linux-mm@kvack.org, hugh@veritas.com, skumar@linux.vnet.ibm.com,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, rientjes@google.com, xemul@openvz.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [RFC][2/3] Account and control virtual address space allocations
References: <20080316173005.8812.88290.sendpatchset@localhost.localdomain> <20080317233552.4A7E21E7CE6@siro.lan>
In-Reply-To: <20080317233552.4A7E21E7CE6@siro.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YAMAMOTO Takashi wrote:
>> diff -puN mm/swapfile.c~memory-controller-virtual-address-space-accounting-and-control mm/swapfile.c
>> diff -puN mm/memory.c~memory-controller-virtual-address-space-accounting-and-control mm/memory.c
>> --- linux-2.6.25-rc5/mm/memory.c~memory-controller-virtual-address-space-accounting-and-control	2008-03-16 22:57:40.000000000 +0530
>> +++ linux-2.6.25-rc5-balbir/mm/memory.c	2008-03-16 22:57:40.000000000 +0530
>> @@ -838,6 +838,11 @@ unsigned long unmap_vmas(struct mmu_gath
>>  
>>  		if (vma->vm_flags & VM_ACCOUNT)
>>  			*nr_accounted += (end - start) >> PAGE_SHIFT;
>> +		/*
>> +		 * Unaccount used virtual memory for cgroups
>> +		 */
>> +		mem_cgroup_update_as(vma->vm_mm,
>> +					((long)(start - end)) >> PAGE_SHIFT);
>>  
>>  		while (start != end) {
>>  			if (!tlb_start_valid) {
> 
> i think you can sum and uncharge it with a single call.
> 

Like nr_accounted? I'll have to duplicate nr_accounted since that depends
conditionally on VM_ACCOUNT.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
