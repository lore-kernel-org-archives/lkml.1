Return-Path: <linux-kernel-owner+w=401wt.eu-S1763024AbYENNLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763024AbYENNLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762714AbYENNKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:10:19 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58471 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762711AbYENNKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:10:17 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 14 May 2008 18:39:39 +0530
Message-Id: <20080514130939.24440.73960.sendpatchset@localhost.localdomain>
In-Reply-To: <20080514130904.24440.23486.sendpatchset@localhost.localdomain>
References: <20080514130904.24440.23486.sendpatchset@localhost.localdomain>
Subject: [-mm][PATCH 3/4] cgroup mm owner callback changes to add task info (v4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds an additional field to the mm_owner callbacks. This field
is required to get to the mm that changed.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/cgroup.h |    3 ++-
 kernel/cgroup.c        |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/cgroup.h~cgroup-add-task-to-mm-owner-callbacks include/linux/cgroup.h
--- linux-2.6.26-rc2/include/linux/cgroup.h~cgroup-add-task-to-mm-owner-callbacks	2008-05-14 18:36:59.000000000 +0530
+++ linux-2.6.26-rc2-balbir/include/linux/cgroup.h	2008-05-14 18:36:59.000000000 +0530
@@ -310,7 +310,8 @@ struct cgroup_subsys {
 	 */
 	void (*mm_owner_changed)(struct cgroup_subsys *ss,
 					struct cgroup *old,
-					struct cgroup *new);
+					struct cgroup *new,
+					struct task_struct *p);
 	int subsys_id;
 	int active;
 	int disabled;
diff -puN kernel/cgroup.c~cgroup-add-task-to-mm-owner-callbacks kernel/cgroup.c
--- linux-2.6.26-rc2/kernel/cgroup.c~cgroup-add-task-to-mm-owner-callbacks	2008-05-14 18:36:59.000000000 +0530
+++ linux-2.6.26-rc2-balbir/kernel/cgroup.c	2008-05-14 18:36:59.000000000 +0530
@@ -2772,7 +2772,7 @@ void cgroup_mm_owner_callbacks(struct ta
 			if (oldcgrp == newcgrp)
 				continue;
 			if (ss->mm_owner_changed)
-				ss->mm_owner_changed(ss, oldcgrp, newcgrp);
+				ss->mm_owner_changed(ss, oldcgrp, newcgrp, new);
 		}
 	}
 }
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
