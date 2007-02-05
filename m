Return-Path: <linux-kernel-owner+w=401wt.eu-S932749AbXBEOOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbXBEOOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932772AbXBEOOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:14:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711AbXBEOOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:14:41 -0500
Subject: [DLM] change some log_error to log_debug [17/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:22:40 +0000
Message-Id: <1170685360.11001.304.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From a9ade49e7bbf836feb4512c2f282faf51c486d78 Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Tue, 9 Jan 2007 09:38:39 -0600
Subject: [PATCH] [DLM] change some log_error to log_debug

Some common, non-error messages should use log_debug instead of log_error
so they can be turned off.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/rcom.c b/fs/dlm/rcom.c
index 54fba9b..2e246af 100644
--- a/fs/dlm/rcom.c
+++ b/fs/dlm/rcom.c
@@ -435,7 +435,7 @@ static int is_old_reply(struct dlm_ls *ls, struct dlm_rcom *rc)
 		seq = ls->ls_recover_seq;
 		spin_unlock(&ls->ls_recover_lock);
 		if (rc->rc_seq_reply != seq) {
-			log_error(ls, "ignoring old reply %x from %d "
+			log_debug(ls, "ignoring old reply %x from %d "
 				      "seq_reply %llx expect %llx",
 				      rc->rc_type, rc->rc_header.h_nodeid,
 				      (unsigned long long)rc->rc_seq_reply,
@@ -469,7 +469,7 @@ void dlm_receive_rcom(struct dlm_header *hd, int nodeid)
 	}
 
 	if (dlm_recovery_stopped(ls) && (rc->rc_type != DLM_RCOM_STATUS)) {
-		log_error(ls, "ignoring recovery message %x from %d",
+		log_debug(ls, "ignoring recovery message %x from %d",
 			  rc->rc_type, nodeid);
 		goto out;
 	}
diff --git a/fs/dlm/recoverd.c b/fs/dlm/recoverd.c
index 650536a..3cb636d 100644
--- a/fs/dlm/recoverd.c
+++ b/fs/dlm/recoverd.c
@@ -77,7 +77,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 	error = dlm_recover_members(ls, rv, &neg);
 	if (error) {
-		log_error(ls, "recover_members failed %d", error);
+		log_debug(ls, "recover_members failed %d", error);
 		goto fail;
 	}
 	start = jiffies;
@@ -89,7 +89,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 	error = dlm_recover_directory(ls);
 	if (error) {
-		log_error(ls, "recover_directory failed %d", error);
+		log_debug(ls, "recover_directory failed %d", error);
 		goto fail;
 	}
 
@@ -99,7 +99,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 	error = dlm_recover_directory_wait(ls);
 	if (error) {
-		log_error(ls, "recover_directory_wait failed %d", error);
+		log_debug(ls, "recover_directory_wait failed %d", error);
 		goto fail;
 	}
 
@@ -129,7 +129,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 		error = dlm_recover_masters(ls);
 		if (error) {
-			log_error(ls, "recover_masters failed %d", error);
+			log_debug(ls, "recover_masters failed %d", error);
 			goto fail;
 		}
 
@@ -139,13 +139,13 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 		error = dlm_recover_locks(ls);
 		if (error) {
-			log_error(ls, "recover_locks failed %d", error);
+			log_debug(ls, "recover_locks failed %d", error);
 			goto fail;
 		}
 
 		error = dlm_recover_locks_wait(ls);
 		if (error) {
-			log_error(ls, "recover_locks_wait failed %d", error);
+			log_debug(ls, "recover_locks_wait failed %d", error);
 			goto fail;
 		}
 
@@ -166,7 +166,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 		error = dlm_recover_locks_wait(ls);
 		if (error) {
-			log_error(ls, "recover_locks_wait failed %d", error);
+			log_debug(ls, "recover_locks_wait failed %d", error);
 			goto fail;
 		}
 	}
@@ -184,7 +184,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 	dlm_set_recover_status(ls, DLM_RS_DONE);
 	error = dlm_recover_done_wait(ls);
 	if (error) {
-		log_error(ls, "recover_done_wait failed %d", error);
+		log_debug(ls, "recover_done_wait failed %d", error);
 		goto fail;
 	}
 
@@ -192,19 +192,19 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 	error = enable_locking(ls, rv->seq);
 	if (error) {
-		log_error(ls, "enable_locking failed %d", error);
+		log_debug(ls, "enable_locking failed %d", error);
 		goto fail;
 	}
 
 	error = dlm_process_requestqueue(ls);
 	if (error) {
-		log_error(ls, "process_requestqueue failed %d", error);
+		log_debug(ls, "process_requestqueue failed %d", error);
 		goto fail;
 	}
 
 	error = dlm_recover_waiters_post(ls);
 	if (error) {
-		log_error(ls, "recover_waiters_post failed %d", error);
+		log_debug(ls, "recover_waiters_post failed %d", error);
 		goto fail;
 	}
 
-- 
1.4.4.2



