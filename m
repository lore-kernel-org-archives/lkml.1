Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbYBOSq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbYBOSq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760242AbYBOSqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:46:09 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:59973 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760134AbYBOSqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:46:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U02dBLo/Z2lG6jnwOkOZxZpJhAYfT51Ctzb0J4AJrDSSF+7eFwsT3b0C0cbosNF9ujSn166Mg/ANQGkoMgGTbwt47vPTjC2LWRP9G/cSzCjnWCJsFpG8D4kHy8bp87Fcs3rHCRFo143wCb6Qai3FBUMhXCrklpdnTx1va/6OhyM=
Subject: [PATCH] befs: fix sparse warning in linuxvfs.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "Sergey S. Kostyliov" <rathamahata@php4.ru>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 10:46:04 -0800
Message-Id: <1203101164.15275.21.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use link as the variable name to avoid shadowing the arg.

fs/befs/linuxvfs.c:492:8: warning: symbol 'p' shadows an earlier one
fs/befs/linuxvfs.c:488:77: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
This should be checked in case there is a latent bug here.  Should it
be the arg *p getting freed, or the local var *p that was shadowing
it?

 fs/befs/linuxvfs.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 82123ff..e8717de 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -489,9 +489,9 @@ static void befs_put_link(struct dentry *dentry, struct nameidata *nd, void *p)
 {
 	befs_inode_info *befs_ino = BEFS_I(dentry->d_inode);
 	if (befs_ino->i_flags & BEFS_LONG_SYMLINK) {
-		char *p = nd_get_link(nd);
-		if (!IS_ERR(p))
-			kfree(p);
+		char *link = nd_get_link(nd);
+		if (!IS_ERR(link))
+			kfree(link);
 	}
 }
 
-- 
1.5.4.1.1278.gc75be



