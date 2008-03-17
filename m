Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbYCQXgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbYCQXgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 19:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbYCQXfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 19:35:54 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:34030 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752652AbYCQXfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 19:35:53 -0400
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, hugh@veritas.com, skumar@linux.vnet.ibm.com,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, rientjes@google.com, xemul@openvz.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [RFC][2/3] Account and control virtual address space allocations
In-Reply-To: Your message of "Sun, 16 Mar 2008 23:00:05 +0530"
	<20080316173005.8812.88290.sendpatchset@localhost.localdomain>
References: <20080316173005.8812.88290.sendpatchset@localhost.localdomain>
X-Mailer: Cue version 0.8 (080303-0742/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080317233552.4A7E21E7CE6@siro.lan>
Date: Tue, 18 Mar 2008 08:35:52 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff -puN mm/swapfile.c~memory-controller-virtual-address-space-accounting-and-control mm/swapfile.c
> diff -puN mm/memory.c~memory-controller-virtual-address-space-accounting-and-control mm/memory.c
> --- linux-2.6.25-rc5/mm/memory.c~memory-controller-virtual-address-space-accounting-and-control	2008-03-16 22:57:40.000000000 +0530
> +++ linux-2.6.25-rc5-balbir/mm/memory.c	2008-03-16 22:57:40.000000000 +0530
> @@ -838,6 +838,11 @@ unsigned long unmap_vmas(struct mmu_gath
>  
>  		if (vma->vm_flags & VM_ACCOUNT)
>  			*nr_accounted += (end - start) >> PAGE_SHIFT;
> +		/*
> +		 * Unaccount used virtual memory for cgroups
> +		 */
> +		mem_cgroup_update_as(vma->vm_mm,
> +					((long)(start - end)) >> PAGE_SHIFT);
>  
>  		while (start != end) {
>  			if (!tlb_start_valid) {

i think you can sum and uncharge it with a single call.

YAMAMOTO Takashi
