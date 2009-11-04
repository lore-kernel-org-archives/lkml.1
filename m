Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbZKDGqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbZKDGqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbZKDGp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:45:59 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:44502 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZKDGp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:45:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=AgJTcHnX79vfN+HcCA0bVeD67Y5RGNq+z3OQDlO+xowM0slPRGCVjKtAHizsw/kGU9
         UqyfdOkv3aTr28l/5EWdmNPOwUPfcHRCWH3biX9QPwFBsW++vq+uSfjSwf7P8THmRMrV
         5MYwepb+7er4HUKMzHsOrMYlV6AJkY4GasGDg=
Subject: [PATCH] fs/ocfs2/stack_user.c - Fixing Compiler warning (PS ignore
 my formatting in previous email)
From: askb <askb23@gmail.com>
To: mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Nov 2009 12:14:17 +0530
Message-Id: <1257317057.14838.57.camel@linux-k65f.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found the following compile warning on linux-next:

fs/ocfs2/stack_user.c: In function ‘user_cluster_connect’:
fs/ocfs2/stack_user.c:817: warning: ‘control’ may be used uninitialized
in this function

fix for the above warning:

Signed-off-by: Anil SB <askb23@gmail.com>

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index ff4c798..858ef6f 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -814,7 +814,7 @@ static int fs_protocol_compare(struct ocfs2_protocol_version *existing,
 static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_lockspace_t *fsdlm;
-	struct ocfs2_live_connection *control;
+	struct ocfs2_live_connection *control = NULL;
 	int rc = 0;
 
 	BUG_ON(conn == NULL);




