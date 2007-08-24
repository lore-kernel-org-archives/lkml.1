Return-Path: <linux-kernel-owner+w=401wt.eu-S965006AbXHXAjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965006AbXHXAjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765515AbXHXAji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:39:38 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:26890 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765446AbXHXAjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=TLWA2mzPRke4YRuxHfg1yvevKDn1vWf9u6sEEa26uOivH0ccT8ZVrwjOH6hwRQ/P6I0aYjkSQt7igmP3JdQuCgyMb2kCtAMGroN0EKOEWvOPi8YfsUql7lDhO6/yPnVofbU+f6XibCNEb2L35GBOMCA89Y2lTmEx9uTAFKvBhsQ=
Message-Id: <18983edfb06c7b133f699e34194112ca6a53b14d.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:36:43 +0200
Subject: [PATCH 28/30] jfs: avoid pointless casts of kmalloc() return val
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
       jfs-discussion@lists.sourceforge.net,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to cast the, void *, return value of kmalloc() when
assigning to a pointer variable.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 fs/jfs/jfs_dtree.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index c14ba3c..3f15b36 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -592,9 +592,7 @@ int dtSearch(struct inode *ip, struct component_name * key, ino_t * data,
 	struct component_name ciKey;
 	struct super_block *sb = ip->i_sb;
 
-	ciKey.name =
-	    (wchar_t *) kmalloc((JFS_NAME_MAX + 1) * sizeof(wchar_t),
-				GFP_NOFS);
+	ciKey.name = kmalloc((JFS_NAME_MAX + 1) * sizeof(wchar_t), GFP_NOFS);
 	if (ciKey.name == 0) {
 		rc = -ENOMEM;
 		goto dtSearch_Exit2;
@@ -957,9 +955,7 @@ static int dtSplitUp(tid_t tid,
 	smp = split->mp;
 	sp = DT_PAGE(ip, smp);
 
-	key.name =
-	    (wchar_t *) kmalloc((JFS_NAME_MAX + 2) * sizeof(wchar_t),
-				GFP_NOFS);
+	key.name = kmalloc((JFS_NAME_MAX + 2) * sizeof(wchar_t), GFP_NOFS);
 	if (key.name == 0) {
 		DT_PUTPAGE(smp);
 		rc = -ENOMEM;
-- 
1.5.2.2

