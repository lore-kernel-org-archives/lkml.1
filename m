Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbZKPA1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbZKPA1s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 19:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZKPA1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 19:27:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56050 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbZKPA1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 19:27:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 12/12] compat_ioctl: remove unused handlers
Date: Mon, 16 Nov 2009 00:27:07 +0000
Message-Id: <1258331227-1694-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258331227-1694-1-git-send-email-arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+MqLuk+WXc2tqxj1CqavGGRNDhHod9fpQTr3J
 nawti39aqwcEzaURB5lPQ1TNpIM/JRMMna9R9xjbJgSytQNQaN
 8kFxfjE/K124zCi5tSOJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These handlers were moved into the respective drivers and can
now be deleted from common code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c |   26 --------------------------
 1 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 1fef181..5ae4fde 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -735,21 +735,6 @@ COMPATIBLE_IOCTL(FIGETBSZ)
 /* 'X' - originally XFS but some now in the VFS */
 COMPATIBLE_IOCTL(FIFREEZE)
 COMPATIBLE_IOCTL(FITHAW)
-COMPATIBLE_IOCTL(KDGETKEYCODE)
-COMPATIBLE_IOCTL(KDSETKEYCODE)
-COMPATIBLE_IOCTL(KDGKBTYPE)
-COMPATIBLE_IOCTL(KDGETMODE)
-COMPATIBLE_IOCTL(KDGKBMODE)
-COMPATIBLE_IOCTL(KDGKBMETA)
-COMPATIBLE_IOCTL(KDGKBENT)
-COMPATIBLE_IOCTL(KDSKBENT)
-COMPATIBLE_IOCTL(KDGKBSENT)
-COMPATIBLE_IOCTL(KDSKBSENT)
-COMPATIBLE_IOCTL(KDGKBDIACR)
-COMPATIBLE_IOCTL(KDSKBDIACR)
-COMPATIBLE_IOCTL(KDKBDREP)
-COMPATIBLE_IOCTL(KDGKBLED)
-COMPATIBLE_IOCTL(KDGETLED)
 #ifdef CONFIG_BLOCK
 /* Big S */
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_IDLUN)
@@ -1277,26 +1262,15 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 		return do_video_stillpicture(fd, cmd, argp);
 	case VIDEO_SET_SPU_PALETTE:
 		return do_video_set_spu_palette(fd, cmd, argp);
-	}
 
 	/*
 	 * These take an integer instead of a pointer as 'arg',
 	 * so we must not do a compat_ptr() translation.
 	 */
-	switch (cmd) {
 	/* Big T */
 	case TCSBRKP:
 	case TIOCMIWAIT:
 	case TIOCSCTTY:
-	/* Big K */
-	case KDSIGACCEPT:
-	case KIOCSOUND:
-	case KDMKTONE:
-	case KDSETMODE:
-	case KDSKBMODE:
-	case KDSKBMETA:
-	case KDSKBLED:
-	case KDSETLED:
 		return do_vfs_ioctl(file, fd, cmd, arg);
 	}
 
-- 
1.6.3.3

