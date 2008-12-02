Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYLBE03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYLBE03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 23:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYLBE0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 23:26:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37723 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYLBE0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 23:26:19 -0500
Date: Tue, 2 Dec 2008 13:25:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 00/11] memcg: split-lru feature for memcg take2
Message-Id: <20081202132526.b588a1f8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Dec 2008 21:10:59 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Recently, SplitLRU patch series dramatically improvement VM reclaim
> logic.
> 
> it have following improvement.
>  (1) splite lru per page type
>  (2) introduce inactive/active anon balancing logic
>  (3) introduce anon/file balancing logic
> 
> Unfortunately, the improvement of memcgroup reclaim is incomplete.
> Currently, it only has (1), but doesn't have (2) and (3).
> 
> 
> This patch introduce (2) and (3) improvements to memcgroup.
> this implementation is straightforward porting from global reclaim.
> 
> Therefere
>   - code is simple.
>   - memcg reclaim become efficiency as global reclaim.
>   - the logic is the same as global lru.
>     then, memcg reclaim debugging become easily.
> 
> 
> this patch series has five part.
> 
> [part 1: global lru clean up]
>   [PATCH 01/11] inactive_anon_is_low() move to vmscan.c
>   [PATCH 02/11] introduce zone_reclaim struct
>   [PATCH 03/11] make zone_nr_pages() helper function
>   [PATCH 04/11] make get_scan_ratio() to memcg safe
> 
> [part 2: memcg: trivial fix]
>   [PATCH 05/11] memcg: add null check to page_cgroup_zoneinfo()
> 
> [part 3: memcg: inactive-anon vs active-anon balancing improvement]
>   [PATCH 06/11] memcg: make inactive_anon_is_low()
> 
> [part 4: anon vs file balancing improvement]
>   [PATCH 07/11] memcg: make mem_cgroup_zone_nr_pages()
>   [PATCH 08/11] memcg: make zone_reclaim_stat
>   [PATCH 09/11] memcg: remove mem_cgroup_calc_reclaim()
> 
> [part 5: add split-lru related statics field to /cgroup/memory.stat]
>   [PATCH 10/11] memcg: show inactive_ratio
>   [PATCH 11/11] memcg: show reclaim_stat
> 
> 
> patch against: mmotm 29 Nov 2008
> 
> Andrew, could you please pick 01-04 up to -mm?
> 01-04 don't have any behavior change.
> kamezawwa-san queue 05-11 to his memcg queueue awhile.
> 

Thanks, I'll try weekly update queue for memcg. 
(includes 01-04 if necessary)

-Kame



