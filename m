Return-Path: <linux-kernel-owner+w=401wt.eu-S1762867AbYBSHIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762867AbYBSHIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 02:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762218AbYBSHHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 02:07:32 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38747 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762144AbYBSHH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 02:07:29 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Hugh Dickins <hugh@veritas.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Herbert Poetzl <herbert@13thfloor.at>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik Van Riel <riel@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 19 Feb 2008 12:33:25 +0530
Message-Id: <20080219070325.25349.13889.sendpatchset@localhost.localdomain>
In-Reply-To: <20080219070232.25349.21196.sendpatchset@localhost.localdomain>
References: <20080219070232.25349.21196.sendpatchset@localhost.localdomain>
Subject: [mm] [PATCH 4/4] Add soft limit documentation v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add documentation for the soft limit feature.

Changelog v2 (Thanks to the review by Randy Dunlap)
1. Change several misuses of it's to its
2. Fix spelling errors and punctuation

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 Documentation/controllers/memory.txt |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN Documentation/controllers/memory.txt~memory-controller-add-soft-limit-documentation Documentation/controllers/memory.txt
--- linux-2.6.25-rc2/Documentation/controllers/memory.txt~memory-controller-add-soft-limit-documentation	2008-02-19 12:31:53.000000000 +0530
+++ linux-2.6.25-rc2-balbir/Documentation/controllers/memory.txt	2008-02-19 12:31:53.000000000 +0530
@@ -201,6 +201,22 @@ The memory.force_empty gives an interfac
 
 will drop all charges in cgroup. Currently, this is maintained for test.
 
+The file memory.soft_limit_in_bytes allows users to set soft limits. A soft
+limit is set in a manner similar to limit. The limit feature described
+earlier is a hard limit. A group can never exceed its hard limit. A soft
+limit on the other hand can be exceeded. A group will be shrunk back
+to its soft limit, when there is memory pressure/contention.
+
+Ideally the soft limit should always be set to a value smaller than the
+hard limit. However, the code does not force the user to do so. The soft
+limit can be greater than the hard limit; then the soft limit has
+no meaning in that setup, since the group will always be restrained to its
+hard limit.
+
+Example setting of soft limit
+
+# echo -n 100M > memory.soft_limit_in_bytes
+
 4. Testing
 
 Balbir posted lmbench, AIM9, LTP and vmmstress results [10] and [11].
@@ -221,7 +237,7 @@ some of the pages cached in the cgroup (
 
 4.2 Task migration
 
-When a task migrates from one cgroup to another, it's charge is not
+When a task migrates from one cgroup to another, its charge is not
 carried forward. The pages allocated from the original cgroup still
 remain charged to it, the charge is dropped when the page is freed or
 reclaimed.
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
