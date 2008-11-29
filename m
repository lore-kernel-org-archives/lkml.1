Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYK2Q0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYK2Q0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 11:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYK2Q0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 11:26:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:22835 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYK2Q0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 11:26:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=wLo6FFl8FAg6dA+2COenLaOOAAQ5kYBS+58js+W79OSkKqH8zTriMd/NpIw+CyvZ8/
         ieLpVvsKyFx01BT8jxhuVCxdvgJvtniFYf59xqudSbuFGDUvVr/40zBgZvCPvHc+y687
         ouVDTSnIGZ+q4bhMzQfwni+u/iHHOk0MgRy7c=
Message-ID: <49316D15.4070703@gmail.com>
Date: Sat, 29 Nov 2008 11:25:57 -0500
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ROMFS: romfs_iget() - unsigned ino >= 0 is always true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

romfs_strnlen() returns int
unsigned X >= 0 is always true

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
for romfs_strnlen(), see
vi fs/romfs/inode.c +200

diff --git a/fs/romfs/inode.c b/fs/romfs/inode.c
index 60d2f82..28b180b 100644
--- a/fs/romfs/inode.c
+++ b/fs/romfs/inode.c
@@ -490,7 +490,7 @@ static mode_t romfs_modemap[] =
 static struct inode *
 romfs_iget(struct super_block *sb, unsigned long ino)
 {
-	int nextfh;
+	int nextfh, ret;
 	struct romfs_inode ri;
 	struct inode *i;
 
@@ -527,9 +527,9 @@ romfs_iget(struct super_block *sb, unsigned long ino)
 	i->i_uid = i->i_gid = 0;
 
         /* Precalculate the data offset */
-        ino = romfs_strnlen(i, ino+ROMFH_SIZE, ROMFS_MAXFN);
-        if (ino >= 0)
-                ino = ((ROMFH_SIZE+ino+1+ROMFH_PAD)&ROMFH_MASK);
+        ret = romfs_strnlen(i, ino+ROMFH_SIZE, ROMFS_MAXFN);
+        if (ret >= 0)
+                ino = ((ROMFH_SIZE+ret+1+ROMFH_PAD)&ROMFH_MASK);
         else
                 ino = 0;
 

