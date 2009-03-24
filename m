Return-Path: <linux-kernel-owner+w=401wt.eu-S1761758AbZCXOU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761758AbZCXOU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760825AbZCXOLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:11:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37597 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760846AbZCXOLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:11:46 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] dlm: ignore cancel on granted lock
Date: Tue, 24 Mar 2009 09:07:51 -0500
Message-Id: <1237903672-18913-7-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return immediately from dlm_unlock(CANCEL) if the lock is
granted and not being converted; there's nothing to cancel.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 8cb9204..205ec95 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2186,6 +2186,13 @@ static int validate_unlock_args(struct dlm_lkb *lkb, struct dlm_args *args)
 			goto out;
 		}
 
+		/* there's nothing to cancel */
+		if (lkb->lkb_status == DLM_LKSTS_GRANTED &&
+		    !lkb->lkb_wait_type) {
+			rv = -EBUSY;
+			goto out;
+		}
+
 		switch (lkb->lkb_wait_type) {
 		case DLM_MSG_LOOKUP:
 		case DLM_MSG_REQUEST:
-- 
1.5.5.6

