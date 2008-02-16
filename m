Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbYBPTi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbYBPTi3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 14:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYBPTiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 14:38:21 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:57238 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbYBPTiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 14:38:21 -0500
Message-ID: <47B73BA7.1000004@tiscali.nl>
Date: Sat, 16 Feb 2008 20:38:15 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Evgeniy Dushistov <dushistov@mail.ru>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/ufs/util.h 2nd parameter of fs32_to_cpu is not boolean
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from: fs/befs/endian.h +33
static inline u32
fs32_to_cpu(const struct super_block *sb, fs32 n)
{
        if (BEFS_SB(sb)->byte_order == BEFS_BYTESEX_LE)
                return le32_to_cpu((__force __le32)n);
        else
                return be32_to_cpu((__force __be32)n);
}

The 2nd parameter is not boolean
---
Test the return value, rather than passing a boolean

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/fs/ufs/util.h b/fs/ufs/util.h
index b26fc4d..23ceed8 100644
--- a/fs/ufs/util.h
+++ b/fs/ufs/util.h
@@ -58,7 +58,7 @@ ufs_set_fs_state(struct super_block *sb, struct ufs_super_block_first *usb1,
 {
 	switch (UFS_SB(sb)->s_flags & UFS_ST_MASK) {
 	case UFS_ST_SUNOS:
-		if (fs32_to_cpu(sb, usb3->fs_postblformat == UFS_42POSTBLFMT)) {
+		if (fs32_to_cpu(sb, usb3->fs_postblformat) == UFS_42POSTBLFMT) {
 			usb1->fs_u0.fs_sun.fs_state = cpu_to_fs32(sb, value);
 			break;
 		}
