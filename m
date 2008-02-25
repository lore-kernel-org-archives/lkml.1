Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbYBYSeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbYBYSeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:34:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbYBYSdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:33:17 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58625 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758501AbYBYSdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:33:16 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 25 Feb 2008 23:57:46 +0530
Message-Id: <20080225182746.9512.21582.sendpatchset@localhost.localdomain>
Subject: [PATCH] Memory Resource Controller use strstrip while parsing arguments
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The memory controller has a requirement that while writing values, we need
to use echo -n. This patch fixes the problem and makes the UI more consistent.


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 Documentation/controllers/memory.txt |    6 +++---
 kernel/res_counter.c                 |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/controllers/memory.txt~memory-controller-fix-crlf-echo-issue Documentation/controllers/memory.txt
--- linux-2.6.25-rc3/Documentation/controllers/memory.txt~memory-controller-fix-crlf-echo-issue	2008-02-25 23:47:45.000000000 +0530
+++ linux-2.6.25-rc3-balbir/Documentation/controllers/memory.txt	2008-02-25 23:47:45.000000000 +0530
@@ -168,7 +168,7 @@ c. Enable CONFIG_CGROUP_MEM_RES_CTLR
 
 Since now we're in the 0 cgroup,
 We can alter the memory limit:
-# echo -n 4M > /cgroups/0/memory.limit_in_bytes
+# echo 4M > /cgroups/0/memory.limit_in_bytes
 
 NOTE: We can use a suffix (k, K, m, M, g or G) to indicate values in kilo,
 mega or gigabytes.
@@ -189,7 +189,7 @@ number of factors, such as rounding up t
 availability of memory on the system.  The user is required to re-read
 this file after a write to guarantee the value committed by the kernel.
 
-# echo -n 1 > memory.limit_in_bytes
+# echo 1 > memory.limit_in_bytes
 # cat memory.limit_in_bytes
 4096
 
@@ -201,7 +201,7 @@ caches, RSS and Active pages/Inactive pa
 
 The memory.force_empty gives an interface to drop *all* charges by force.
 
-# echo -n 1 > memory.force_empty
+# echo 1 > memory.force_empty
 
 will drop all charges in cgroup. Currently, this is maintained for test.
 
diff -puN kernel/res_counter.c~memory-controller-fix-crlf-echo-issue kernel/res_counter.c
--- linux-2.6.25-rc3/kernel/res_counter.c~memory-controller-fix-crlf-echo-issue	2008-02-25 23:47:45.000000000 +0530
+++ linux-2.6.25-rc3-balbir/kernel/res_counter.c	2008-02-25 23:47:45.000000000 +0530
@@ -113,6 +113,7 @@ ssize_t res_counter_write(struct res_cou
 
 	ret = -EINVAL;
 
+	strstrip(buf);
 	if (write_strategy) {
 		if (write_strategy(buf, &tmp)) {
 			goto out_free;
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
