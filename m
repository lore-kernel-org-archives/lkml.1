Return-Path: <linux-kernel-owner+w=401wt.eu-S1762575AbYENNJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762575AbYENNJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762439AbYENNJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:09:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48734 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762430AbYENNJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:09:38 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 14 May 2008 18:39:15 +0530
Message-Id: <20080514130915.24440.56106.sendpatchset@localhost.localdomain>
In-Reply-To: <20080514130904.24440.23486.sendpatchset@localhost.localdomain>
References: <20080514130904.24440.23486.sendpatchset@localhost.localdomain>
Subject: [-mm][PATCH 1/4] Add memrlimit controller documentation (v4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Documentation patch - describes the goals and usage of the memrlimit
controller.


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 Documentation/controllers/memrlimit.txt |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff -puN /dev/null Documentation/controllers/memrlimit.txt
--- /dev/null	2008-05-14 04:27:30.032276540 +0530
+++ linux-2.6.26-rc2-balbir/Documentation/controllers/memrlimit.txt	2008-05-14 18:35:55.000000000 +0530
@@ -0,0 +1,29 @@
+This controller is enabled by the CONFIG_CGROUP_MEMRLIMIT_CTLR option. Prior
+to reading this documentation please read Documentation/cgroups.txt and
+Documentation/controllers/memory.txt. Several of the principles of this
+controller are similar to the memory resource controller.
+
+This controller framework is designed to be extensible to control any
+memory resource limit with little effort.
+
+This new controller, controls the address space expansion of the tasks
+belonging to a cgroup. Address space control is provided along the same lines as
+RLIMIT_AS control, which is available via getrlimit(2)/setrlimit(2).
+The interface for controlling address space is provided through
+"rlimit.limit_in_bytes". The file is similar to "limit_in_bytes" w.r.t. the user
+interface. Please see section 3 of the memory resource controller documentation
+for more details on how to use the user interface to get and set values.
+
+The "memrlimit.usage_in_bytes" file provides information about the total address
+space usage of the tasks in the cgroup, in bytes.
+
+Advantages of providing this feature
+
+1. Control over virtual address space allows for a cgroup to fail gracefully
+   i.e., via a malloc or mmap failure as compared to OOM kill when no
+   pages can be reclaimed.
+2. It provides better control over how many pages can be swapped out when
+   the cgroup goes over its limit. A badly setup cgroup can cause excessive
+   swapping. Providing control over the address space allocations ensures
+   that the system administrator has control over the total swapping that
+   can take place.
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
