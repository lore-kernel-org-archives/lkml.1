Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbZGJNAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbZGJNAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 09:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZGJNAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 09:00:05 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:56430 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbZGJNAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 09:00:03 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 10 Jul 2009 18:29:57 +0530
Message-Id: <20090710125957.5610.56168.sendpatchset@balbir-laptop>
In-Reply-To: <20090710125950.5610.99139.sendpatchset@balbir-laptop>
References: <20090710125950.5610.99139.sendpatchset@balbir-laptop>
Subject: [RFC][PATCH 1/5] Memory controller soft limit documentation (v9)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feature: Add documentation for soft limits

From: Balbir Singh <balbir@linux.vnet.ibm.com>

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 Documentation/cgroups/memory.txt |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)


diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index ab0a021..b871f25 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -379,7 +379,42 @@ cgroups created below it.
 
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
+When the system detects memory contention or low memory control groups
+are pushed back to their soft limits. If the soft limit of each control
+group is very high, they are pushed back as much as possible to make
+sure that one control group does not starve the others of memory.
+
+Please note that soft limits is a best effort feature, it comes with
+no guarantees, but it does its best to make sure that when memory is
+heavily contended for, memory is allocated based on the soft limit
+hints/setup. Currently soft limit based reclaim is setup such that
+it gets invoked from balance_pgdat (kswapd).
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
+NOTE1: Soft limits take effect over a long period of time, since they involve
+       reclaiming memory for balancing between memory cgroups
+NOTE2: It is recommended to set the soft limit always below the hard limit,
+       otherwise the hard limit will take precedence.
+
+8. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first

-- 
	Balbir
