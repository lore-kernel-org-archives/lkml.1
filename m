Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZBPLJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZBPLJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 06:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbZBPLJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 06:09:04 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:57893 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920AbZBPLJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 06:09:01 -0500
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
Date: Mon, 16 Feb 2009 16:38:49 +0530
Message-Id: <20090216110849.29795.65329.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216110844.29795.17804.sendpatchset@localhost.localdomain>
References: <20090216110844.29795.17804.sendpatchset@localhost.localdomain>
Subject: [RFC][PATCH 1/4] Memory controller soft limit documentation (v2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for soft limit feature support.

From: Balbir Singh <balbir@linux.vnet.ibm.com>

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 Documentation/cgroups/memory.txt |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)


diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index a98a7fe..6e6ef41 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -360,7 +360,33 @@ cgroups created below it.
 
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
+When the system detects memory contention (through do_try_to_free_pages(),
+while allocating), control groups are pushed back to their soft limits if
+possible. If the soft limit of each control group is very high, they are
+pushed back as much as possible to make sure that one control group does not
+starve the others.
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
