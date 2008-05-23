Return-Path: <linux-kernel-owner+w=401wt.eu-S1760029AbYEWHjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029AbYEWHjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 03:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYEWHjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 03:39:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52140 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbYEWHjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 03:39:43 -0400
Message-ID: <483674AA.4090504@cn.fujitsu.com>
Date: Fri, 23 May 2008 15:39:22 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>
Subject: [PATCH] cpusets: fix and update Documentation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the doc consistent with current cpusets implementation.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

---
 Documentation/cpusets.txt |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/cpusets.txt b/Documentation/cpusets.txt
index fb7b361..d803c5c 100644
--- a/Documentation/cpusets.txt
+++ b/Documentation/cpusets.txt
@@ -199,7 +199,7 @@ using the sched_setaffinity, mbind and set_mempolicy system calls.
 The following rules apply to each cpuset:
 
  - Its CPUs and Memory Nodes must be a subset of its parents.
- - It can only be marked exclusive if its parent is.
+ - It can't be marked exclusive unless its parent is.
  - If its cpu or memory is exclusive, they may not overlap any sibling.
 
 These rules, and the natural hierarchy of cpusets, enable efficient
@@ -345,7 +345,7 @@ is modified to perform an inline check for this PF_SPREAD_PAGE task
 flag, and if set, a call to a new routine cpuset_mem_spread_node()
 returns the node to prefer for the allocation.
 
-Similarly, setting 'memory_spread_cache' turns on the flag
+Similarly, setting 'memory_spread_slab' turns on the flag
 PF_SPREAD_SLAB, and appropriately marked slab caches will allocate
 pages from the node returned by cpuset_mem_spread_node().
 
@@ -709,7 +709,10 @@ Now you want to do something with this cpuset.
 
 In this directory you can find several files:
 # ls
-cpus  cpu_exclusive  mems  mem_exclusive mem_hardwall  tasks
+cpu_exclusive  memory_migrate      mems                      tasks
+cpus           memory_pressure     notify_on_release
+mem_exclusive  memory_spread_page  sched_load_balance
+mem_hardwall   memory_spread_slab  sched_relax_domain_level
 
 Reading them will give you information about the state of this cpuset:
 the CPUs and Memory Nodes it can use, the processes that are using
-- 
1.5.4.rc3



