Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbYLWQNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbYLWQNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYLWQNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:13:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48923 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYLWQNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:13:04 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] dlm: add time stamp of blocking callback
Date: Tue, 23 Dec 2008 10:58:41 -0600
Message-Id: <1230051523-5478-9-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record the time the latest blocking callback was queued for
a lock.  This will be used for debugging in combination with
lock queue timestamp changes in the previous patch.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dlm_internal.h |    1 +
 fs/dlm/lock.c         |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index e69135c..0c48829 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -245,6 +245,7 @@ struct dlm_lkb {
 	struct list_head	lkb_astqueue;	/* need ast to be sent */
 	struct list_head	lkb_ownqueue;	/* list of locks for a process */
 	struct list_head	lkb_time_list;
+	ktime_t			lkb_time_bast;	/* for debugging */
 	ktime_t			lkb_timestamp;
 	unsigned long		lkb_timeout_cs;
 
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index dfc57ae..6cfe65b 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -318,6 +318,8 @@ static inline void queue_cast_overlap(struct dlm_rsb *r, struct dlm_lkb *lkb)
 
 static void queue_bast(struct dlm_rsb *r, struct dlm_lkb *lkb, int rqmode)
 {
+	lkb->lkb_time_bast = ktime_get();
+
 	if (is_master_copy(lkb))
 		send_bast(r, lkb, rqmode);
 	else
-- 
1.5.5.1

