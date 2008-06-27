Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbYF0PSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbYF0PSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760044AbYF0PSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:18:31 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39824 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759815AbYF0PS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:18:29 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 27 Jun 2008 20:48:18 +0530
Message-Id: <20080627151818.31664.69486.sendpatchset@balbir-laptop>
In-Reply-To: <20080627151808.31664.36047.sendpatchset@balbir-laptop>
References: <20080627151808.31664.36047.sendpatchset@balbir-laptop>
Subject: [RFC 1/5] Memory controller soft limit documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Add documentation for the soft limit feature.

Changelog v2 (Thanks to the review by Randy Dunlap)
1. Change several misuses of it's to its
2. Fix spelling errors and punctuation

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 Documentation/controllers/memory.txt |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN Documentation/controllers/memory.txt~memory-controller-soft-limit-add-documentation Documentation/controllers/memory.txt
--- linux-2.6.26-rc5/Documentation/controllers/memory.txt~memory-controller-soft-limit-add-documentation	2008-06-27 20:43:04.000000000 +0530
+++ linux-2.6.26-rc5-balbir/Documentation/controllers/memory.txt	2008-06-27 20:43:04.000000000 +0530
@@ -205,6 +205,22 @@ The memory.force_empty gives an interfac
 
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
+# echo 100M > memory.soft_limit_in_bytes
+
 4. Testing
 
 Balbir posted lmbench, AIM9, LTP and vmmstress results [10] and [11].
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
