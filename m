Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbYLACBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbYLACBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 21:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYLACAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 21:00:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49090 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbYLACAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 21:00:52 -0500
Date: Mon, 1 Dec 2008 11:00:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 00/09] memcg: split-lru feature for memcg
Message-Id: <20081201110000.bcdfccff.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2008 19:54:08 +0900 (JST)
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
> this patch series has three part
> 
> [part 1: inactive-anon vs active-anon balancing improvement]
>   [01/09] inactive_anon_is_low() move to vmscan.c
>   [02/09] memcg: make inactive_anon_is_low()
> 
> [part 2: anon vs file balancing improvement]
>   [03/09] introduce zone_reclaim struct
>   [04/09] memcg: make zone_reclaim_stat
>   [05/09] make zone_nr_pages() helper function
>   [06/09] make get_scan_ratio() to memcg awareness
>   [07/09] memcg: remove mem_cgroup_calc_reclaim()
> 
> [part 3: add split-lru related statics field to /cgroup/memory.stat]
>   [08/09] memcg: show inactive_ratio
>   [09/09] memcg: show reclaim stat
> 
> patch against: mmotm 29 Nov 2008
> 

Hi, kosaki. thank you for your work.

My request is
 . split global-lru part and memcg part explicitly.
 
There are Nishimura's patch and my patch under development.
I may have to prepare weekly-update queue again.

Thanks,
-Kame

