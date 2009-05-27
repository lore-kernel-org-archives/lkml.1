Return-Path: <linux-kernel-owner+w=401wt.eu-S1762992AbZE0Hbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762992AbZE0Hbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762333AbZE0H0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:26:45 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:46925 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762291AbZE0H0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:26:44 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       michal.simek@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 27/29] microblaze_mmu_v2: stat.h MMU update
Date: Wed, 27 May 2009 08:47:52 +0200
Message-Id: <1243406874-3917-28-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1243406874-3917-27-git-send-email-monstr@monstr.eu>
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu>
 <1243406874-3917-2-git-send-email-monstr@monstr.eu>
 <1243406874-3917-3-git-send-email-monstr@monstr.eu>
 <1243406874-3917-4-git-send-email-monstr@monstr.eu>
 <1243406874-3917-5-git-send-email-monstr@monstr.eu>
 <1243406874-3917-6-git-send-email-monstr@monstr.eu>
 <1243406874-3917-7-git-send-email-monstr@monstr.eu>
 <1243406874-3917-8-git-send-email-monstr@monstr.eu>
 <1243406874-3917-9-git-send-email-monstr@monstr.eu>
 <1243406874-3917-10-git-send-email-monstr@monstr.eu>
 <1243406874-3917-11-git-send-email-monstr@monstr.eu>
 <1243406874-3917-12-git-send-email-monstr@monstr.eu>
 <1243406874-3917-13-git-send-email-monstr@monstr.eu>
 <1243406874-3917-14-git-send-email-monstr@monstr.eu>
 <1243406874-3917-15-git-send-email-monstr@monstr.eu>
 <1243406874-3917-16-git-send-email-monstr@monstr.eu>
 <1243406874-3917-17-git-send-email-monstr@monstr.eu>
 <1243406874-3917-18-git-send-email-monstr@monstr.eu>
 <1243406874-3917-19-git-send-email-monstr@monstr.eu>
 <1243406874-3917-20-git-send-email-monstr@monstr.eu>
 <1243406874-3917-21-git-send-email-monstr@monstr.eu>
 <1243406874-3917-22-git-send-email-monstr@monstr.eu>
 <1243406874-3917-23-git-send-email-monstr@monstr.eu>
 <1243406874-3917-24-git-send-email-monstr@monstr.eu>
 <1243406874-3917-25-git-send-email-monstr@monstr.eu>
 <1243406874-3917-26-git-send-email-monstr@monstr.eu>
 <1243406874-3917-27-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/stat.h |   77 +++++++++++++++++-------------------
 1 files changed, 36 insertions(+), 41 deletions(-)

diff --git a/arch/microblaze/include/asm/stat.h b/arch/microblaze/include/asm/stat.h
index 5f18b8a..a15f775 100644
--- a/arch/microblaze/include/asm/stat.h
+++ b/arch/microblaze/include/asm/stat.h
@@ -16,58 +16,53 @@
 
 #include <linux/posix_types.h>
 
+#define STAT_HAVE_NSEC 1
+
 struct stat {
-	unsigned int	st_dev;
+	unsigned long	st_dev;
 	unsigned long	st_ino;
 	unsigned int	st_mode;
 	unsigned int	st_nlink;
 	unsigned int	st_uid;
 	unsigned int	st_gid;
-	unsigned int	st_rdev;
-	unsigned long	st_size;
-	unsigned long	st_blksize;
-	unsigned long	st_blocks;
-	unsigned long	st_atime;
-	unsigned long	__unused1; /* unsigned long  st_atime_nsec */
-	unsigned long	st_mtime;
-	unsigned long	__unused2; /* unsigned long  st_mtime_nsec */
-	unsigned long	st_ctime;
-	unsigned long	__unused3; /* unsigned long  st_ctime_nsec */
+	unsigned long	st_rdev;
+	unsigned long	__pad1;
+	long		st_size;
+	int		st_blksize;
+	int		__pad2;
+	long		st_blocks;
+	int		st_atime;
+	unsigned int	st_atime_nsec;
+	int		st_mtime;
+	unsigned int	st_mtime_nsec;
+	int		st_ctime;
+	unsigned int	st_ctime_nsec;
 	unsigned long	__unused4;
 	unsigned long	__unused5;
 };
 
 struct stat64 {
-	unsigned long long	st_dev;
-	unsigned long	__unused1;
-
-	unsigned long long	st_ino;
-
-	unsigned int	st_mode;
-	unsigned int	st_nlink;
-
-	unsigned int	st_uid;
-	unsigned int	st_gid;
-
-	unsigned long long	st_rdev;
-	unsigned long	__unused3;
-
-	long long	st_size;
-	unsigned long	st_blksize;
-
-	unsigned long	st_blocks; /* No. of 512-byte blocks allocated */
-	unsigned long	__unused4; /* future possible st_blocks high bits */
-
-	unsigned long	st_atime;
-	unsigned long	st_atime_nsec;
-
-	unsigned long	st_mtime;
-	unsigned long	st_mtime_nsec;
-
-	unsigned long	st_ctime;
-	unsigned long	st_ctime_nsec;
-
-	unsigned long	__unused8;
+	unsigned long long	st_dev;		/* Device.  */
+	unsigned long long	st_ino;		/* File serial number.  */
+	unsigned int		st_mode;	/* File mode.  */
+	unsigned int		st_nlink;	/* Link count.  */
+	unsigned int		st_uid;		/* User ID of the file's owner.  */
+	unsigned int		st_gid;		/* Group ID of the file's group. */
+	unsigned long long	st_rdev;	/* Device number, if device.  */
+	unsigned long long	__pad1;
+	long long		st_size;	/* Size of file, in bytes.  */
+	int			st_blksize;	/* Optimal block size for I/O.  */
+	int			__pad2;
+	long long		st_blocks;	/* Number 512-byte blocks allocated. */
+	int			st_atime;	/* Time of last access.  */
+	unsigned int		st_atime_nsec;
+	int			st_mtime;	/* Time of last modification.  */
+	unsigned int		st_mtime_nsec;
+	int			st_ctime;	/* Time of last status change.  */
+	unsigned int		st_ctime_nsec;
+	unsigned int		__unused4;
+	unsigned int		__unused5;
 };
 
 #endif /* _ASM_MICROBLAZE_STAT_H */
+
-- 
1.5.5.1

