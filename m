Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbYDDB5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbYDDB5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYDDB5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:57:39 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34942 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbYDDB5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:57:38 -0400
Date: Fri, 04 Apr 2008 10:56:28 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1 of 6] hotplug-memory: refactor online_pages to separate zone growth from page onlining
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <5a397e7f3c1aeb7648b9.1207267541@localhost>
References: <patchbomb.1207267540@localhost> <5a397e7f3c1aeb7648b9.1207267541@localhost>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080404104358.C7F5.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* Mark a set of pages as online */
> +unsigned long mark_pages_onlined(unsigned long pfn, unsigned long nr_pages)
> +{
> +	struct zone *zone = page_zone(pfn_to_page(pfn));
> +	unsigned long onlined_pages = 0;
> +	int need_zonelists_rebuild = 0;
>  
>  	/*
>  	 * If this zone is not populated, then it is not in zonelist.
> @@ -240,10 +246,38 @@
>  	vm_total_pages = nr_free_pagecache_pages();
>  	writeback_set_ratelimit();
>  
> -	if (onlined_pages)
> +	if (onlined_pages) {
> +		struct memory_notify arg;
> +
> +		arg.start_pfn = pfn;  /* ? */
> +		arg.nr_pages = onlined_pages;
> +		arg.status_change_nid = -1;  /* ? */

status_change_nid is to prepare data structures which are allocated on
each NUMA node.

When memory less node gets new memory, and it changes status
to normal memory, then status_change_nid must be set.

SLUB uses it now.

Thanks.

-- 
Yasunori Goto 


