Return-Path: <linux-kernel-owner+w=401wt.eu-S1762817AbYBPBtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762817AbYBPBtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 20:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYBPBtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 20:49:39 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:18860 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbYBPBti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 20:49:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tiWf/32ZXLcj6yeoMneQdJrv+/O/ZHy2paTm1v7OpxmybWsoxtTei6V00RonRGzoTeaPXXoEbKMrlX+guZlx25CKTwoMykuHIRJbUw0HOr/Dxl9+GRUINBHWOJFjsxHnuLtj7y+O2+nCatbuGZA/RljYvGvWJmtEJi2fO1eDI/o=
Subject: [PATCH] autofs4: fix sparse warning in root.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ian Kent <raven@themaw.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 17:49:32 -0800
Message-Id: <1203126572.7442.13.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/autofs4/root.c:536:23: warning: symbol 'ino' shadows an earlier one
fs/autofs4/root.c:510:22: originally declared here

There is no need to redeclare, we are at the end of the loop and in
the next iteration of the loop, ino will be reset.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/autofs4/root.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index a54a946..1b43456 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -533,8 +533,8 @@ static struct dentry *autofs4_lookup_unhashed(struct autofs_sb_info *sbi, struct
 			goto next;
 
 		if (d_unhashed(dentry)) {
-			struct autofs_info *ino = autofs4_dentry_ino(dentry);
 			struct inode *inode = dentry->d_inode;
+			ino = autofs4_dentry_ino(dentry);
 
 			list_del_init(&ino->rehash);
 			dget(dentry);
-- 
1.5.4.1.1278.gc75be



