Return-Path: <linux-kernel-owner+w=401wt.eu-S1763196AbXGXMPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763196AbXGXMPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXGXMPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:15:04 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:61406 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbXGXMPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:15:01 -0400
Message-ID: <46A5ED11.4090905@linux.vnet.ibm.com>
Date: Tue, 24 Jul 2007 17:44:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
CC: akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       containers@lists.osdl.org, menage@google.com, haveblue@us.ibm.com,
       linux-mm@kvack.org, svaidy@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [RFC][-mm PATCH 6/8] Memory controller add per container LRU
 and reclaim (v3)
References: <20070720082504.20752.62858.sendpatchset@balbir-laptop> <20070724115100.B7A9B1BF959@siro.lan>
In-Reply-To: <20070724115100.B7A9B1BF959@siro.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

YAMAMOTO Takashi wrote:
> hi,
> 
>> +unsigned long mem_container_isolate_pages(unsigned long nr_to_scan,
>> +					struct list_head *dst,
>> +					unsigned long *scanned, int order,
>> +					int mode, struct zone *z,
>> +					struct mem_container *mem_cont,
>> +					int active)
>> +{
>> +	unsigned long nr_taken = 0;
>> +	struct page *page;
>> +	unsigned long scan;
>> +	LIST_HEAD(mp_list);
>> +	struct list_head *src;
>> +	struct meta_page *mp;
>> +
>> +	if (active)
>> +		src = &mem_cont->active_list;
>> +	else
>> +		src = &mem_cont->inactive_list;
>> +
>> +	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
>> +		mp = list_entry(src->prev, struct meta_page, lru);
>> +		page = mp->page;
>> +
> 
> - is it safe to pick the lists without mem_cont->lru_lock held?
> 
> - what prevents mem_container_uncharge from freeing this meta_page
>  behind us?
> 
> YAMAMOTO Takashi

Hi, YAMAMOTO,

We do take the lru_lock before deleting the page from the list
and in mem_container_move_lists(). But, I guess like you point
out page = mp->page might not be a safe operation. I'll fix
the problem in the next release.

Thanks for the review,
-- 
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
