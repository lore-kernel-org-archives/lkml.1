Return-Path: <linux-kernel-owner+w=401wt.eu-S1751300AbZGTPVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbZGTPVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbZGTPVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:21:09 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34221 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbZGTPVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:21:08 -0400
Date: Tue, 21 Jul 2009 00:20:38 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 5/5] Memory controller soft limit reclaim on contention (v9)
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090710130021.5610.74850.sendpatchset@balbir-laptop>
References: <20090710125950.5610.99139.sendpatchset@balbir-laptop> <20090710130021.5610.74850.sendpatchset@balbir-laptop>
Message-Id: <20090721001923.AF72.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


very sorry for the delaying.


> @@ -1918,6 +1951,7 @@ loop_again:
>  		for (i = 0; i <= end_zone; i++) {
>  			struct zone *zone = pgdat->node_zones + i;
>  			int nr_slab;
> +			int nid, zid;
>  
>  			if (!populated_zone(zone))
>  				continue;
> @@ -1932,6 +1966,15 @@ loop_again:
>  			temp_priority[i] = priority;
>  			sc.nr_scanned = 0;
>  			note_zone_scanning_priority(zone, priority);
> +
> +			nid = pgdat->node_id;
> +			zid = zone_idx(zone);
> +			/*
> +			 * Call soft limit reclaim before calling shrink_zone.
> +			 * For now we ignore the return value
> +			 */
> +			mem_cgroup_soft_limit_reclaim(zone, order, sc.gfp_mask,
> +							nid, zid);
>  			/*
>  			 * We put equal pressure on every zone, unless one
>  			 * zone has way too many pages free already.


In this part:
	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



