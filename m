Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab0COFUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 01:20:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59566 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932503Ab0COFUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 01:20:06 -0400
Message-ID: <4B9DC38C.30506@cn.fujitsu.com>
Date: Mon, 15 Mar 2010 13:20:12 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Paul Menage <menage@google.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 2/2] cpuset: alloc nodemask_t at heap not stack - fix
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V1 to V2:
- remove unnecessary checking.

fix memory leak

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Against the following patch in mmotm-2010-03-11-13-13:
cpuset-alloc-nodemask_t-at-heap-not-stack.patch
---
 kernel/cpuset.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f36e577..02b4545 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1401,7 +1401,7 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
 
 	if (from == NULL || to == NULL)
-		return;
+		goto alloc_fail;
 
 	if (cs == &top_cpuset) {
 		cpumask_copy(cpus_attach, cpu_possible_mask);
@@ -1432,6 +1432,7 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 		mmput(mm);
 	}
 
+alloc_fail:
 	NODEMASK_FREE(from);
 	NODEMASK_FREE(to);
 }
-- 
1.6.5.2


