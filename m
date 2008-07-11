Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbYGKLCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbYGKLCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYGKLBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755141AbYGKLBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:34 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/18] [GFS2] Fix ordering of args for list_add
Date: Fri, 11 Jul 2008 11:11:06 +0100
Message-Id: <12157710954145-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12157710931623-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
 <1215771091790-git-send-email-swhiteho@redhat.com>
 <12157710931623-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The patch to remove lock_nolock managed to get the arguments
of this list_add backwards. This fixes it.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking.c b/fs/gfs2/locking.c
index a4a367a..523243a 100644
--- a/fs/gfs2/locking.c
+++ b/fs/gfs2/locking.c
@@ -163,7 +163,7 @@ retry:
 	mutex_lock(&lmh_lock);
 
 	if (list_empty(&nolock_proto.lw_list))
-		list_add(&lmh_list, &nolock_proto.lw_list);
+		list_add(&nolock_proto.lw_list, &lmh_list);
 
 	found = 0;
 	list_for_each_entry(lw, &lmh_list, lw_list) {
-- 
1.5.1.2

