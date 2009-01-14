Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbZANHFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbZANHFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbZANHFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:05:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61918 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755335AbZANHFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:05:19 -0500
Message-ID: <496D8E80.8070401@cn.fujitsu.com>
Date: Wed, 14 Jan 2009 15:04:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rakib Mullick <rakib.mullick@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] memcg: fix section mismatch
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At system boot when creating the top cgroup, mem_cgroup_create() calls
enable_swap_cgroup() which is marked as __init, so mark mem_cgroup_create()
as __ref to avoid false section mismatch warning.

Reported-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

use __ref instead of __init_refok

---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2996b8..e57afca 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2181,7 +2181,7 @@ static void __init enable_swap_cgroup(void)
 }
 #endif
 
-static struct cgroup_subsys_state *
+static struct cgroup_subsys_state * __ref
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	struct mem_cgroup *mem, *parent;
-- 
1.5.4.rc3
