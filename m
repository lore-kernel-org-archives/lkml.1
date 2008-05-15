Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbYEOBWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbYEOBWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYEOBWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:22:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:54743 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYEOBWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Gj8pkxkqUduyb8nTTP13PzE8YsSxJYOl3IUpGJfMXja9AHHMXzAsC+8QJs7lvMtb0AC/6o4tcfaS3EQeFOENc3QygCc5Xb+s60BdmF2Mc/NTYTYEO3ev4t6FhOZTlA1wOwexKqqjKRrlfQ3tDT1UemfAsJL0hhRFvo7HHSlz5WU=
Subject: [PATCH 2/2] mtd: mtdchar.c remove shadowed variable warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 14 May 2008 18:22:11 -0700
Message-Id: <1210814531.6191.54.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use einfo, oinfo for the inner erase_info and otp_info structs
used in individual case statements.

drivers/mtd/mtdchar.c:582:26: warning: symbol 'info' shadows an earlier one
drivers/mtd/mtdchar.c:380:23: originally declared here
drivers/mtd/mtdchar.c:596:26: warning: symbol 'info' shadows an earlier one
drivers/mtd/mtdchar.c:380:23: originally declared here
drivers/mtd/mtdchar.c:704:19: warning: symbol 'info' shadows an earlier one
drivers/mtd/mtdchar.c:380:23: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/mtd/mtdchar.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 3522d4a..87845b5 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -579,29 +579,29 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
 
 	case MEMLOCK:
 	{
-		struct erase_info_user info;
+		struct erase_info_user einfo;
 
-		if (copy_from_user(&info, argp, sizeof(info)))
+		if (copy_from_user(&einfo, argp, sizeof(einfo)))
 			return -EFAULT;
 
 		if (!mtd->lock)
 			ret = -EOPNOTSUPP;
 		else
-			ret = mtd->lock(mtd, info.start, info.length);
+			ret = mtd->lock(mtd, einfo.start, einfo.length);
 		break;
 	}
 
 	case MEMUNLOCK:
 	{
-		struct erase_info_user info;
+		struct erase_info_user einfo;
 
-		if (copy_from_user(&info, argp, sizeof(info)))
+		if (copy_from_user(&einfo, argp, sizeof(einfo)))
 			return -EFAULT;
 
 		if (!mtd->unlock)
 			ret = -EOPNOTSUPP;
 		else
-			ret = mtd->unlock(mtd, info.start, info.length);
+			ret = mtd->unlock(mtd, einfo.start, einfo.length);
 		break;
 	}
 
@@ -701,15 +701,15 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
 
 	case OTPLOCK:
 	{
-		struct otp_info info;
+		struct otp_info oinfo;
 
 		if (mfi->mode != MTD_MODE_OTP_USER)
 			return -EINVAL;
-		if (copy_from_user(&info, argp, sizeof(info)))
+		if (copy_from_user(&oinfo, argp, sizeof(oinfo)))
 			return -EFAULT;
 		if (!mtd->lock_user_prot_reg)
 			return -EOPNOTSUPP;
-		ret = mtd->lock_user_prot_reg(mtd, info.start, info.length);
+		ret = mtd->lock_user_prot_reg(mtd, oinfo.start, oinfo.length);
 		break;
 	}
 #endif
-- 
1.5.5.1.482.g0f174

