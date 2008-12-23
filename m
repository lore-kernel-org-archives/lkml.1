Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbYLWQPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbYLWQPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYLWQNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:13:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48932 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbYLWQNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:13:04 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 02/10] dlm: trivial annotation of be16 value
Date: Tue, 23 Dec 2008 10:58:35 -0600
Message-Id: <1230051523-5478-3-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

fs/dlm/dir.c:419:14: warning: incorrect type in assignment (different base types)
fs/dlm/dir.c:419:14:    expected unsigned short [unsigned] [addressable] [assigned] [usertype] be_namelen
fs/dlm/dir.c:419:14:    got restricted __be16 [usertype] <noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dir.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/dlm/dir.c b/fs/dlm/dir.c
index 85defeb..92969f8 100644
--- a/fs/dlm/dir.c
+++ b/fs/dlm/dir.c
@@ -374,7 +374,7 @@ void dlm_copy_master_names(struct dlm_ls *ls, char *inbuf, int inlen,
 	struct list_head *list;
 	struct dlm_rsb *r;
 	int offset = 0, dir_nodeid;
-	uint16_t be_namelen;
+	__be16 be_namelen;
 
 	down_read(&ls->ls_root_sem);
 
@@ -410,15 +410,15 @@ void dlm_copy_master_names(struct dlm_ls *ls, char *inbuf, int inlen,
 
 		if (offset + sizeof(uint16_t)*2 + r->res_length > outlen) {
 			/* Write end-of-block record */
-			be_namelen = 0;
-			memcpy(outbuf + offset, &be_namelen, sizeof(uint16_t));
-			offset += sizeof(uint16_t);
+			be_namelen = cpu_to_be16(0);
+			memcpy(outbuf + offset, &be_namelen, sizeof(__be16));
+			offset += sizeof(__be16);
 			goto out;
 		}
 
 		be_namelen = cpu_to_be16(r->res_length);
-		memcpy(outbuf + offset, &be_namelen, sizeof(uint16_t));
-		offset += sizeof(uint16_t);
+		memcpy(outbuf + offset, &be_namelen, sizeof(__be16));
+		offset += sizeof(__be16);
 		memcpy(outbuf + offset, r->res_name, r->res_length);
 		offset += r->res_length;
 	}
@@ -430,9 +430,9 @@ void dlm_copy_master_names(struct dlm_ls *ls, char *inbuf, int inlen,
 
 	if ((list == &ls->ls_root_list) &&
 	    (offset + sizeof(uint16_t) <= outlen)) {
-		be_namelen = 0xFFFF;
-		memcpy(outbuf + offset, &be_namelen, sizeof(uint16_t));
-		offset += sizeof(uint16_t);
+		be_namelen = cpu_to_be16(0xFFFF);
+		memcpy(outbuf + offset, &be_namelen, sizeof(__be16));
+		offset += sizeof(__be16);
 	}
 
  out:
-- 
1.5.5.1

