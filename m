Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbYGKLFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbYGKLFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756185AbYGKLBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:01:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927AbYGKLBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:01:46 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/18] [GFS2] Fix module building
Date: Fri, 11 Jul 2008 11:11:13 +0100
Message-Id: <12157711073280-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1215771106247-git-send-email-swhiteho@redhat.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
 <12157710872782-git-send-email-swhiteho@redhat.com>
 <1215771089769-git-send-email-swhiteho@redhat.com>
 <1215771091790-git-send-email-swhiteho@redhat.com>
 <12157710931623-git-send-email-swhiteho@redhat.com>
 <12157710954145-git-send-email-swhiteho@redhat.com>
 <12157710973601-git-send-email-swhiteho@redhat.com>
 <12157710983282-git-send-email-swhiteho@redhat.com>
 <12157711013356-git-send-email-swhiteho@redhat.com>
 <12157711023743-git-send-email-swhiteho@redhat.com>
 <12157711041157-git-send-email-swhiteho@redhat.com>
 <1215771106247-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Two lines missed from the previous patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/lock_dlm.h b/fs/gfs2/locking/dlm/lock_dlm.h
index 21cf466..3c98e7c 100644
--- a/fs/gfs2/locking/dlm/lock_dlm.h
+++ b/fs/gfs2/locking/dlm/lock_dlm.h
@@ -148,7 +148,6 @@ void gdlm_release_threads(struct gdlm_ls *);
 /* lock.c */
 
 void gdlm_submit_delayed(struct gdlm_ls *);
-int gdlm_release_all_locks(struct gdlm_ls *);
 unsigned int gdlm_do_lock(struct gdlm_lock *);
 
 int gdlm_get_lock(void *, struct lm_lockname *, void **);
diff --git a/fs/gfs2/locking/dlm/mount.c b/fs/gfs2/locking/dlm/mount.c
index 947e706..09d78c2 100644
--- a/fs/gfs2/locking/dlm/mount.c
+++ b/fs/gfs2/locking/dlm/mount.c
@@ -221,7 +221,6 @@ static void gdlm_withdraw(void *lockspace)
 
 	dlm_release_lockspace(ls->dlm_lockspace, 2);
 	gdlm_release_threads(ls);
-	gdlm_release_all_locks(ls);
 	gdlm_kobject_release(ls);
 }
 
-- 
1.5.1.2

