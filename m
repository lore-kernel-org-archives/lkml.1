Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbYDWGTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbYDWGTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 02:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbYDWGTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 02:19:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55750 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbYDWGTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 02:19:39 -0400
Message-ID: <480ED4D8.5070607@cn.fujitsu.com>
Date: Wed, 23 Apr 2008 14:19:04 +0800
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: akpm@linux-foundation.org, Hugh Dickins <hugh@veritas.com>,
       Mel Gorman <mel@csn.ul.ie>, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [BUGFIX][PATCH] Fix usemap initialization v3
References: <20080418161522.GB9147@csn.ul.ie>	<48080706.50305@cn.fujitsu.com>	<48080930.5090905@cn.fujitsu.com>	<48080B86.7040200@cn.fujitsu.com>	<20080418211214.299f91cd.kamezawa.hiroyu@jp.fujitsu.com>	<21878461.1208539556838.kamezawa.hiroyu@jp.fujitsu.com>	<20080421112048.78f0ec76.kamezawa.hiroyu@jp.fujitsu.com>	<Pine.LNX.4.64.0804211250000.16476@blonde.site>	<20080422104043.215c7dc4.kamezawa.hiroyu@jp.fujitsu.com> <20080423134621.6020dd83.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080423134621.6020dd83.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote::
> fixed typos.
> ==
> usemap must be initialized only when pfn is within zone.
> If not, it corrupts memory.
> 
> And this patch also reduces the number of calls to set_pageblock_migratetype()
> from
> 	(pfn & (pageblock_nr_pages -1)
> to
> 	!(pfn & (pageblock_nr_pages-1)
> it should be called once per pageblock.
> 
> Changelog.
> v2->v3
>  - Fixed typos.
> v1->v2
>  - Fixed boundary check.
>  - Move calculation of pointer for zone struct to out of loop.

I noticed v3 takes "zone" instead of "zid" in the code line 
"z = &NODE_DATA(nid)->node_zones[zone];".
I tested v3, it works well now.

Thanks,
-Shi

