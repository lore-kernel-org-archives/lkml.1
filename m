Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYK3KyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYK3KyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 05:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYK3KyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 05:54:12 -0500
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:57067 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYK3KyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 05:54:11 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH 00/09] memcg: split-lru feature for memcg
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sun, 30 Nov 2008 19:54:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, SplitLRU patch series dramatically improvement VM reclaim
logic.

it have following improvement.
 (1) splite lru per page type
 (2) introduce inactive/active anon balancing logic
 (3) introduce anon/file balancing logic

Unfortunately, the improvement of memcgroup reclaim is incomplete.
Currently, it only has (1), but doesn't have (2) and (3).


This patch introduce (2) and (3) improvements to memcgroup.
this implementation is straightforward porting from global reclaim.

Therefere
  - code is simple.
  - memcg reclaim become efficiency as global reclaim.
  - the logic is the same as global lru.
    then, memcg reclaim debugging become easily.


this patch series has three part

[part 1: inactive-anon vs active-anon balancing improvement]
  [01/09] inactive_anon_is_low() move to vmscan.c
  [02/09] memcg: make inactive_anon_is_low()

[part 2: anon vs file balancing improvement]
  [03/09] introduce zone_reclaim struct
  [04/09] memcg: make zone_reclaim_stat
  [05/09] make zone_nr_pages() helper function
  [06/09] make get_scan_ratio() to memcg awareness
  [07/09] memcg: remove mem_cgroup_calc_reclaim()

[part 3: add split-lru related statics field to /cgroup/memory.stat]
  [08/09] memcg: show inactive_ratio
  [09/09] memcg: show reclaim stat

patch against: mmotm 29 Nov 2008


Thanks!



