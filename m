Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZE1Xwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZE1Xwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZE1Xwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:52:39 -0400
Received: from kroah.org ([198.145.64.141]:59041 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZE1Xwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:52:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/2] sysfs: file.c: use create_singlethread_workqueue()
Date: Thu, 28 May 2009 16:49:02 -0700
Message-Id: <1243554543-11117-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090528234155.GA10930@kroah.com>
References: <20090528234155.GA10930@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

We don't need a kernel thread per CPU for this application.

Acked-by: Alex Chiang <achiang@hp.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index b1606e0..561a9c0 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -723,7 +723,7 @@ int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
 	mutex_unlock(&sysfs_workq_mutex);
 
 	if (sysfs_workqueue == NULL) {
-		sysfs_workqueue = create_workqueue("sysfsd");
+		sysfs_workqueue = create_singlethread_workqueue("sysfsd");
 		if (sysfs_workqueue == NULL) {
 			module_put(owner);
 			return -ENOMEM;
-- 
1.6.3

