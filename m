Return-Path: <linux-kernel-owner+w=401wt.eu-S940849AbXGaFPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940849AbXGaFPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 01:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757597AbXGaFPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 01:15:03 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:33268 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751209AbXGaFPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 01:15:01 -0400
To: balbir@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com, xemul@openvz.org
Subject: Re: [-mm PATCH 6/9] Memory controller add per container LRU and
 reclaim
	(v4)
In-Reply-To: Your message of "Sat, 28 Jul 2007 01:40:41 +0530"
	<20070727201041.31565.14803.sendpatchset@balbir-laptop>
References: <20070727201041.31565.14803.sendpatchset@balbir-laptop>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20070731051459.E827E1BF77B@siro.lan>
Date: Tue, 31 Jul 2007 14:14:59 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +unsigned long mem_container_isolate_pages(unsigned long nr_to_scan,
> +					struct list_head *dst,
> +					unsigned long *scanned, int order,
> +					int mode, struct zone *z,
> +					struct mem_container *mem_cont,
> +					int active)
> +{
> +	unsigned long nr_taken = 0;
> +	struct page *page;
> +	unsigned long scan;
> +	LIST_HEAD(mp_list);
> +	struct list_head *src;
> +	struct meta_page *mp;
> +
> +	if (active)
> +		src = &mem_cont->active_list;
> +	else
> +		src = &mem_cont->inactive_list;
> +
> +	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
> +		mp = list_entry(src->prev, struct meta_page, lru);

what prevents another thread from freeing mp here?

> +		spin_lock(&mem_cont->lru_lock);
> +		if (mp)
> +			page = mp->page;
> +		spin_unlock(&mem_cont->lru_lock);
> +		if (!mp)
> +			continue;

YAMAMOTO Takashi
