Return-Path: <linux-kernel-owner+w=401wt.eu-S1761210AbYFIXlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210AbYFIXlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 19:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbYFIXlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 19:41:35 -0400
Received: from [78.13.68.104] ([78.13.68.104]:38402 "EHLO linux.localdomain"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758526AbYFIXle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 19:41:34 -0400
From: Andrea Righi <righi.andrea@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: menage@google.com, kamezawa.hiroyu@jp.fujitsu.com,
       kosaki.motohiro@jp.fujitsu.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       Andrea Righi <righi.andrea@gmail.com>
Subject: [RFC PATCH 1/5] memcg VM overcommit documentation
Date: Tue, 10 Jun 2008 01:32:59 +0200
Message-Id: <1213054383-18137-2-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation of the VM overcommit memory controller included in the generic
memory controller documentation: basic description and usage.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 Documentation/controllers/memory.txt |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/Documentation/controllers/memory.txt b/Documentation/controllers/memory.txt
index 866b9cd..e984bfb 100644
--- a/Documentation/controllers/memory.txt
+++ b/Documentation/controllers/memory.txt
@@ -12,6 +12,7 @@ c. Provides *zero overhead* for non memory controller users
 d. Provides a double LRU: global memory pressure causes reclaim from the
    global LRU; a cgroup on hitting a limit, reclaims from the per
    cgroup LRU
+e. Provide distinct cgroup VM overcommit accounting and handling
 
 NOTE: Swap Cache (unmapped) is not accounted now.
 
@@ -142,6 +143,31 @@ The reclaim algorithm has not been modified for cgroups, except that
 pages that are selected for reclaiming come from the per cgroup LRU
 list.
 
+2.5 VM overcommit accounting and handling
+
+The concept of committed VM is replicated within each cgroup as well as global
+committed memory concept. Each cgroup can set its own overcommit policy using
+the files:
+
+memory.overcommit_memory
+memory.overcommit_ratio
+
+These settings override the system sysctl settings (`vm.overcommit_memory` and
+`vm.overcommit_ratio`) and they apply locally to the cgroup they refer.
+
+Global sysctl settings are initially used by the root level cgroups. Child
+cgroups initially inherit the parent's settings. Each cgroup can change its own
+overcommit parameters at any time simply modifying the files
+`memory.overcommit_memory` and/or `memory.overcommit_ratio`.
+
+Statistics about the current committed space and limit are reported in
+`memory.overcommit_as` for each cgroup.
+
+Per-cgroup overcommit limit depends of the local cgroup overcommit settings and
+memory limit (RSS + cache) imposed by the memory controller.
+
+See "Documentation/vm/overcommit-accounting" for additional details.
+
 2. Locking
 
 The memory controller uses the following hierarchy
@@ -230,6 +256,9 @@ carried forward. The pages allocated from the original cgroup still
 remain charged to it, the charge is dropped when the page is freed or
 reclaimed.
 
+The amount of the task's committed VM, instead, is uncharged from the old
+cgroup and accounted to the newer.
+
 4.3 Removing a cgroup
 
 A cgroup can be removed by rmdir, but as discussed in sections 4.1 and 4.2, a
-- 
1.5.4.3

