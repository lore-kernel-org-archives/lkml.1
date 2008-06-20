Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbYFTPCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbYFTPCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758622AbYFTPCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:02:14 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49911 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758615AbYFTPCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:02:12 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 20 Jun 2008 20:31:52 +0530
Message-Id: <20080620150152.16094.76790.sendpatchset@localhost.localdomain>
In-Reply-To: <20080620150132.16094.29151.sendpatchset@localhost.localdomain>
References: <20080620150132.16094.29151.sendpatchset@localhost.localdomain>
Subject: [2/2] memrlimit fix usage of tmp as a parameter name
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Fix the variable tmp being used in write_strategy. This patch replaces tmp
with val, the fact that it is an output parameter can be interpreted from
the pass by reference.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/memrlimitcgroup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memrlimitcgroup.c~memrlimit-cgroup-simple-cleanup mm/memrlimitcgroup.c
--- linux-2.6.26-rc5/mm/memrlimitcgroup.c~memrlimit-cgroup-simple-cleanup	2008-06-20 20:14:00.000000000 +0530
+++ linux-2.6.26-rc5-balbir/mm/memrlimitcgroup.c	2008-06-20 20:22:08.000000000 +0530
@@ -118,13 +118,13 @@ static u64 memrlimit_cgroup_read(struct 
 					cft->private);
 }
 
-static int memrlimit_cgroup_write_strategy(char *buf, unsigned long long *tmp)
+static int memrlimit_cgroup_write_strategy(char *buf, unsigned long long *val)
 {
-	*tmp = memparse(buf, &buf);
+	*val = memparse(buf, &buf);
 	if (*buf != '\0')
 		return -EINVAL;
 
-	*tmp = PAGE_ALIGN(*tmp);
+	*val = PAGE_ALIGN(*val);
 	return 0;
 }
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
