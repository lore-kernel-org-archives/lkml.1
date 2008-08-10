Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbYHJVRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbYHJVRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 17:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYHJVRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 17:17:11 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54524 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbYHJVRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 17:17:11 -0400
Date: Mon, 11 Aug 2008 00:15:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make cgroup_is_removed() static
Message-ID: <20080810211530.GB5480@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_is_removed() can now become static.

Additionally, make it no longer "inline" but let gcc decide whether or 
not to inline it.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
8e37a5ecc6f51b3904d5be693c16324bad6923c5 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c98dd7c..f5df0ae 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -295,8 +295,6 @@ int cgroup_add_files(struct cgroup *cgrp,
 			const struct cftype cft[],
 			int count);
 
-int cgroup_is_removed(const struct cgroup *cgrp);
-
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
 
 int cgroup_task_count(const struct cgroup *cgrp);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 13932ab..e6d6d40 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -119,7 +119,7 @@ static int need_forkexit_callback __read_mostly;
 static int need_mm_owner_callback __read_mostly;
 
 /* convenient tests for these bits */
-inline int cgroup_is_removed(const struct cgroup *cgrp)
+static int cgroup_is_removed(const struct cgroup *cgrp)
 {
 	return test_bit(CGRP_REMOVED, &cgrp->flags);
 }

