Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYKGTme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYKGTme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYKGTmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:42:25 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:14967 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYKGTmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:42:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RyDfuZybUcG1gDQFQX4XgbkwWhriaU+FMnLdNFFqEK3xwnNvA9u25SS75yMlQDusjZ
         2O26ikliYKprLrzrJZg8VpNmvxHUX3yxaFPWhPOZ3TNow0J6SOCrqOIyVqMIJZmVQfOO
         2FWm5SWFrBffhXQymQgvUiandLDZbxu9AOOnU=
Subject: [PATCH] dlm: trivial annotation of be16 value
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Teigland <teigland@redhat.com>,
       Patrick Caulfield <pcaulfie@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 11:41:38 -0800
Message-Id: <1226086898.11596.49.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/dlm/dir.c:419:14: warning: incorrect type in assignment (different base types)
fs/dlm/dir.c:419:14:    expected unsigned short [unsigned] [addressable] [assigned] [usertype] be_namelen
fs/dlm/dir.c:419:14:    got restricted __be16 [usertype] <noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
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
1.6.0.3.756.gb776d



