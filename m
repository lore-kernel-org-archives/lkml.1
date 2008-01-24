Return-Path: <linux-kernel-owner+w=401wt.eu-S1759928AbYAXREh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbYAXREh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758358AbYAXQ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758286AbYAXQ6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:40 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 17/19] dlm: change error message to debug
Date: Thu, 24 Jan 2008 10:50:40 -0600
Message-Id: <1201193442-8260-18-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The invalid lockspace messages are normal and can appear relatively
often.  They should be suppressed without debugging enabled.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index bc2e4ba..7ee7c7c 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3857,8 +3857,9 @@ void dlm_receive_buffer(struct dlm_header *hd, int nodeid)
 
 	ls = dlm_find_lockspace_global(hd->h_lockspace);
 	if (!ls) {
-		log_print("invalid h_lockspace %x from %d cmd %d type %d",
-			  hd->h_lockspace, nodeid, hd->h_cmd, type);
+		if (dlm_config.ci_log_debug)
+			log_print("invalid lockspace %x from %d cmd %d type %d",
+				  hd->h_lockspace, nodeid, hd->h_cmd, type);
 
 		if (hd->h_cmd == DLM_RCOM && type == DLM_RCOM_STATUS)
 			dlm_send_ls_not_ready(nodeid, rc);
-- 
1.5.3.3

