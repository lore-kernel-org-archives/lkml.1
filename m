Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbYBGGXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbYBGGXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbYBGGS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 11/16] dlm: fix overflows when copying from ->m_extra to lvb
Date: Thu,  7 Feb 2008 00:09:14 -0600
Message-Id: <1202364559-9201-12-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 6d98cf9..5b82187 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -1226,6 +1226,8 @@ static void set_lvb_lock_pc(struct dlm_rsb *r, struct dlm_lkb *lkb,
 	b = dlm_lvb_operations[lkb->lkb_grmode + 1][lkb->lkb_rqmode + 1];
 	if (b == 1) {
 		int len = receive_extralen(ms);
+		if (len > DLM_RESNAME_MAXLEN)
+			len = DLM_RESNAME_MAXLEN;
 		memcpy(lkb->lkb_lvbptr, ms->m_extra, len);
 		lkb->lkb_lvbseq = ms->m_lvbseq;
 	}
@@ -2993,6 +2995,8 @@ static int receive_lvb(struct dlm_ls *ls, struct dlm_lkb *lkb,
 		if (!lkb->lkb_lvbptr)
 			return -ENOMEM;
 		len = receive_extralen(ms);
+		if (len > DLM_RESNAME_MAXLEN)
+			len = DLM_RESNAME_MAXLEN;
 		memcpy(lkb->lkb_lvbptr, ms->m_extra, len);
 	}
 	return 0;
-- 
1.5.3.3

