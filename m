Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZCAGao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZCAGao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 01:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZCAGaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 01:30:15 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:43878 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbZCAGaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 01:30:13 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Sun, 01 Mar 2009 12:00:05 +0530
Message-Id: <20090301063005.31557.1071.sendpatchset@localhost.localdomain>
In-Reply-To: <20090301062959.31557.31079.sendpatchset@localhost.localdomain>
References: <20090301062959.31557.31079.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/4] Memory controller soft limit documentation (v3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for soft limit feature support.

From: Balbir Singh <balbir@linux.vnet.ibm.com>

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 Documentation/cgroups/memory.txt |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)


diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index a98a7fe..812cb74 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -360,7 +360,32 @@ cgroups created below it.
 
 NOTE2: This feature can be enabled/disabled per subtree.
 
-7. TODO
+7. Soft limits
+
+Soft limits allow for greater sharing of memory. The idea behind soft limits
+is to allow control groups to use as much of the memory as needed, provided
+
+a. There is no memory contention
+b. They do not exceed their hard limit
+
+When the system detects memory contention or low memory (kswapd is woken up)
+control groups are pushed back to their soft limits. If the soft limit of each
+control group is very high, they are pushed back as much as possible to make
+sure that one control group does not starve the others of memory.
+
+7.1 Interface
+
+Soft limits can be setup by using the following commands (in this example we
+assume a soft limit of 256 megabytes)
+
+# echo 256M > memory.soft_limit_in_bytes
+
+If we want to change this to 1G, we can at any time use
+
+# echo 1G > memory.soft_limit_in_bytes
+
+
+8. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first

-- 
	Balbir
