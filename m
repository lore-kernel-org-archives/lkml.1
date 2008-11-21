Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYKUIwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYKUIwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYKUIwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:52:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54118 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbYKUIwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:52:34 -0500
Message-ID: <49267614.5000505@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 16:49:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH] devcgroup: use list_for_each_entry_rcu()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we should use list_for_each_entry_rcu in RCU read site.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 5ba7870..cd377b9 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -517,7 +517,7 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
 
 	dev_cgroup = task_devcgroup(current);
 
-	list_for_each_entry(wh, &dev_cgroup->whitelist, list) {
+	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
 		if (wh->type & DEV_ALL)
 			goto acc_check;
 		if ((wh->type & DEV_BLOCK) && !S_ISBLK(mode))

