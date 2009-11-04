Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbZKDCoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbZKDCoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbZKDCoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:44:37 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:43727 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbZKDCog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:44:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=GFyUYvTYxKzPt6hCrWZWHUXTTkma0jloyyqCN2vHDbs2KY3nDclPxacbfbUQC9lpau
         65Y9ubLbg7YvcmmaToBtYK+9F9emBVf8XQ9gukxAJGPVZ8C45+Bkn+Nm+gCnxzpcTxb8
         fI2hNwinAuyivmV0T+C24hriWTv0RPaDxtZGs=
Subject: [PATCH] fs/ocfs2/stack_user.c - Fixing Compiler warning.
From: askb <askb23@gmail.com>
To: mfasheh@suse.com, joel.becker@oracle.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Nov 2009 08:12:54 +0530
Message-Id: <1257302574.14838.22.camel@linux-k65f.site>
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
@@ -814,7 +814,7 @@ static int fs_protocol_compare(struct
ocfs2_protocol_version *existing,
static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
{
dlm_lockspace_t *fsdlm;
- struct ocfs2_live_connection *control;
+ struct ocfs2_live_connection *control = NULL;
int rc = 0;

BUG_ON(conn == NULL);

Thanks

