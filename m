Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbZAGSlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbZAGSlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbZAGSlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:41:19 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:52757 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbZAGSlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:41:18 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 08 Jan 2009 00:11:16 +0530
Message-Id: <20090107184116.18062.8379.sendpatchset@localhost.localdomain>
In-Reply-To: <20090107184110.18062.41459.sendpatchset@localhost.localdomain>
References: <20090107184110.18062.41459.sendpatchset@localhost.localdomain>
Subject: [RFC][PATCH 1/4] Memory controller soft limit documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balbir Singh <balbir@linux.vnet.ibm.com>

Add documentation for soft limit feature support.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 Documentation/controllers/memory.txt |   28 ++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff -puN Documentation/controllers/memory.txt~memcg-soft-limit-documentation Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~memcg-soft-limit-documentation
+++ a/Documentation/controllers/memory.txt
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
_

-- 
	Balbir
