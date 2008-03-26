Return-Path: <linux-kernel-owner+w=401wt.eu-S1762642AbYCZSyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762642AbYCZSyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762360AbYCZSxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:53:54 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50586 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762339AbYCZSxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:53:52 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>
Cc: Hugh Dickins <hugh@veritas.com>, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 27 Mar 2008 00:20:29 +0530
Message-Id: <20080326185029.9465.7378.sendpatchset@localhost.localdomain>
In-Reply-To: <20080326184954.9465.19379.sendpatchset@localhost.localdomain>
References: <20080326184954.9465.19379.sendpatchset@localhost.localdomain>
Subject: [RFC][3/3] Update documentation for virtual address space control (v2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Changelog v2
------------
Fix typos and implement review suggestions from Randy

This patch adds documentation for virtual address space control.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 Documentation/controllers/memory.txt |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff -puN Documentation/controllers/memory.txt~memory-controller-virtual-address-control-documentation Documentation/controllers/memory.txt
--- linux-2.6.25-rc5/Documentation/controllers/memory.txt~memory-controller-virtual-address-control-documentation	2008-03-27 00:18:19.000000000 +0530
+++ linux-2.6.25-rc5-balbir/Documentation/controllers/memory.txt	2008-03-27 00:18:19.000000000 +0530
@@ -237,7 +237,33 @@ cgroup might have some charge associated
 tasks have migrated away from it. Such charges are automatically dropped at
 rmdir() if there are no tasks.
 
-5. TODO
+5. Virtual address space accounting
+
+A new resource counter controls the address space expansion of the tasks in
+the cgroup. Address space control is provided along the same lines as
+RLIMIT_AS control, which is available via getrlimit(2)/setrlimit(2).
+The interface for controlling address space is provided through
+"as_limit_in_bytes". The file is similar to "limit_in_bytes" w.r.t. the user
+interface. Please see section 3 for more details on how to use the user
+interface to get and set values.
+
+The "as_usage_in_bytes" file provides information about the total address
+space usage of the cgroup in bytes.
+
+5.1 Advantages of providing this feature
+
+1. Control over virtual address space allows for a cgroup to fail gracefully
+   i.e., via a malloc or mmap failure as compared to OOM kill when no
+   pages can be reclaimed.
+2. It provides better control over how many pages can be swapped out when
+   the cgroup goes over its limit. A badly setup cgroup can cause excessive
+   swapping. Providing control over the address space allocations ensures
+   that the system administrator has control over the total swapping that
+   can take place.
+
+NOTE: This feature is controlled by the CONFIG_CGROUP_MEM_RES_CTLR_AS
+
+6. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
