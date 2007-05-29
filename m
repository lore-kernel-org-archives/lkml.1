Return-Path: <linux-kernel-owner+w=401wt.eu-S1763665AbXE2StU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763665AbXE2StU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbXE2StG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:49:06 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:56250 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbXE2StE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:49:04 -0400
Date: Tue, 29 May 2007 19:49:01 +0100 (IST)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Christoph Lameter <clameter@sgi.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 3/7] Allow CONFIG_MIGRATION to be set without CONFIG_NUMA
In-Reply-To: <Pine.LNX.4.64.0705291133380.24473@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0705291948100.5669@skynet.skynet.ie>
References: <20070529173609.1570.4686.sendpatchset@skynet.skynet.ie>
 <20070529173710.1570.91203.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0705291057170.24126@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705291910430.5669@skynet.skynet.ie>
 <Pine.LNX.4.64.0705291133380.24473@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Christoph Lameter wrote:

> On Tue, 29 May 2007, Mel Gorman wrote:
>
>>>> +config SYSCALL_MOVE_PAGES
>>>> +	def_bool y
>>>> +	depends on MIGRATION && NUMA
>>>> +
>>>
>>> Do we really need the CONFIG_SYSCALL_MOVE_PAGES? I think you will directly
>>> access the lower levels. So why have it? CONFIG_SYSCALL_MOVE_PAGES ==
>>> CONFIG_NUMA.
>>
>> Without SYSCALL_MOVE_PAGES, the check in migrate.h becomes
>>
>> #if defined(CONFIG_NUMA) && defined(CONFIG_MIGRATION)
>> /* Check if a vma is migratable */
>> static inline int vma_migratable(struct vm_area_struct *vma)
>> #endif
>
> Why do you need vma_migratable for the CONFIG_MIGRATION case? The use of
> vma_migratable in a !NUMA sitation would not be working right as far as I
> can tell.
>
> #ifdef CONFIG_NUMA
>
> is fine.
>

Makes sense.

>> That in itself is fine but in mm/migrate.c I didn't want to define
>> sys_move_pages() in the non-NUMA case. Whatever about the header file where
>> SYSCALL_MOVE_PAGES obscures understanding, I think it makes sense to have
>> SYSCALL_MOVE_PAGES for mm/migrate.c . What do you think?
>
> Why do you need sys_move_pages for the non-NUMA case?
>
> The low level function that I intended to be used by defrag is
> migrate_pages and that one is outside of #ifdef CONFIG_NUMA.
>

Also make sense. It'll be fixed up in the next verion minus the 
SYSCALL_MOVE_PAGES dirt. It'll even simplify the patch.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
