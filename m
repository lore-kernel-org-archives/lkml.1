Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYHMBYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYHMBYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYHMBYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:24:15 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:58947 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbYHMBYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:24:15 -0400
Message-ID: <48A237B8.6060004@linux.vnet.ibm.com>
Date: Wed, 13 Aug 2008 06:54:08 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       nishimura@mxp.nes.nec.co.jp, xemul@openvz.org, hugh@veritas.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 0/2] Memory rlimit fix crash on fork
References: <20080811100719.26336.98302.sendpatchset@balbir-laptop> <20080812171407.2f468729.akpm@linux-foundation.org>
In-Reply-To: <20080812171407.2f468729.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 11 Aug 2008 15:37:19 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> --- linux-2.6.27-rc1/mm/memory.c~memrlimit-fix-crash-on-fork	2008-08-11 14:57:48.000000000 +0530
>> +++ linux-2.6.27-rc1-balbir/mm/memory.c	2008-08-11 14:58:33.000000000 +0530
>> @@ -901,8 +901,12 @@ unsigned long unmap_vmas(struct mmu_gath
> 
> ^^ returns a long.
> 
>>  	unsigned long start = start_addr;
>>  	spinlock_t *i_mmap_lock = details? details->i_mmap_lock: NULL;
>>  	int fullmm = (*tlbp)->fullmm;
>> -	struct mm_struct *mm = vma->vm_mm;
>> +	struct mm_struct *mm;
>> +
>> +	if (!vma)
>> +		return;
> 
> ^^ mm/memory.c:907: warning: 'return' with no value, in function returning non-void
> 
> How does this happen?
> 
> I'll drop the patch.  The above mystery change needs a comment, IMO.

Oops.. I'll send the updated version. I'll comment it as well.

-- 
	Balbir
