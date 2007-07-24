Return-Path: <linux-kernel-owner+w=401wt.eu-S935605AbXGXLvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935605AbXGXLvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 07:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbXGXLvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 07:51:04 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:43374 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752908AbXGXLvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 07:51:02 -0400
To: balbir@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       containers@lists.osdl.org, menage@google.com, haveblue@us.ibm.com,
       linux-mm@kvack.org, svaidy@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [RFC][-mm PATCH 6/8] Memory controller add per container LRU and
 reclaim (v3)
In-Reply-To: Your message of "Fri, 20 Jul 2007 13:55:04 +0530"
	<20070720082504.20752.62858.sendpatchset@balbir-laptop>
References: <20070720082504.20752.62858.sendpatchset@balbir-laptop>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20070724115100.B7A9B1BF959@siro.lan>
Date: Tue, 24 Jul 2007 20:51:00 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

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
> +		page = mp->page;
> +

- is it safe to pick the lists without mem_cont->lru_lock held?

- what prevents mem_container_uncharge from freeing this meta_page
 behind us?

YAMAMOTO Takashi
