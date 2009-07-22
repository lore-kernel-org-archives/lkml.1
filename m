Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbZGVCba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbZGVCba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 22:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZGVCba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 22:31:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59956 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbZGVCb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 22:31:29 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: akpm@linux-foundation.org
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] cgroup: make unlock sequence in cgroup_get_sb consistent
Date: Wed, 22 Jul 2009 10:31:22 +0800
Message-Id: <1248229882-21508-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the last unlock sequence consistent with previous unlock sequeue.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3737a68..11ef162 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1140,8 +1140,8 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 		BUG_ON(root->number_of_cgroups != 1);
 
 		cgroup_populate_dir(root_cgrp);
-		mutex_unlock(&inode->i_mutex);
 		mutex_unlock(&cgroup_mutex);
+		mutex_unlock(&inode->i_mutex);
 	}
 
 	simple_set_mnt(mnt, sb);
-- 
1.6.2.5

