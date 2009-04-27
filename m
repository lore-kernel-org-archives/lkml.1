Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbZD0JwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbZD0JwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZD0Jsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:33 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754124AbZD0Jsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:32 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
Date: Mon, 27 Apr 2009 10:32:18 +0200
Message-Id: <1240821139-7247-30-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1240821139-7247-29-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
 <1240821139-7247-2-git-send-email-monstr@monstr.eu>
 <1240821139-7247-3-git-send-email-monstr@monstr.eu>
 <1240821139-7247-4-git-send-email-monstr@monstr.eu>
 <1240821139-7247-5-git-send-email-monstr@monstr.eu>
 <1240821139-7247-6-git-send-email-monstr@monstr.eu>
 <1240821139-7247-7-git-send-email-monstr@monstr.eu>
 <1240821139-7247-8-git-send-email-monstr@monstr.eu>
 <1240821139-7247-9-git-send-email-monstr@monstr.eu>
 <1240821139-7247-10-git-send-email-monstr@monstr.eu>
 <1240821139-7247-11-git-send-email-monstr@monstr.eu>
 <1240821139-7247-12-git-send-email-monstr@monstr.eu>
 <1240821139-7247-13-git-send-email-monstr@monstr.eu>
 <1240821139-7247-14-git-send-email-monstr@monstr.eu>
 <1240821139-7247-15-git-send-email-monstr@monstr.eu>
 <1240821139-7247-16-git-send-email-monstr@monstr.eu>
 <1240821139-7247-17-git-send-email-monstr@monstr.eu>
 <1240821139-7247-18-git-send-email-monstr@monstr.eu>
 <1240821139-7247-19-git-send-email-monstr@monstr.eu>
 <1240821139-7247-20-git-send-email-monstr@monstr.eu>
 <1240821139-7247-21-git-send-email-monstr@monstr.eu>
 <1240821139-7247-22-git-send-email-monstr@monstr.eu>
 <1240821139-7247-23-git-send-email-monstr@monstr.eu>
 <1240821139-7247-24-git-send-email-monstr@monstr.eu>
 <1240821139-7247-25-git-send-email-monstr@monstr.eu>
 <1240821139-7247-26-git-send-email-monstr@monstr.eu>
 <1240821139-7247-27-git-send-email-monstr@monstr.eu>
 <1240821139-7247-28-git-send-email-monstr@monstr.eu>
 <1240821139-7247-29-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/stat.h |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/include/asm/stat.h b/arch/microblaze/include/asm/stat.h
index 5f18b8a..5a33b17 100644
--- a/arch/microblaze/include/asm/stat.h
+++ b/arch/microblaze/include/asm/stat.h
@@ -36,7 +36,7 @@ struct stat {
 	unsigned long	__unused4;
 	unsigned long	__unused5;
 };
-
+# ifdef __uClinux__
 struct stat64 {
 	unsigned long long	st_dev;
 	unsigned long	__unused1;
@@ -69,5 +69,29 @@ struct stat64 {
 
 	unsigned long	__unused8;
 };
+# else /* __uClinux__ */
+/* FIXME */
+struct stat64 {
+	unsigned long long	st_dev; /* Device.*/
+	unsigned long long	st_ino; /* File serial number.*/
+	unsigned int		st_mode; /* File mode.*/
+	unsigned int		st_nlink; /* Link count. */
+	unsigned int		st_uid; /* User ID of the file's owner. */
+	unsigned int		st_gid; /* Group ID of the file's group. */
+	unsigned long long	st_rdev; /* Device number, if device. */
+	unsigned short		__pad2;
+	long long		st_size; /* Size of file, in bytes. */
+	int			st_blksize; /* Optimal block size for I/O. */
+	long long		st_blocks; /* No. 512-byte blocks allocated */
+	int			st_atime; /* Time of last access.  */
+	unsigned int		st_atime_nsec;
+	int			st_mtime; /* Time of last modification. */
+	unsigned int		st_mtime_nsec;
+	int			st_ctime; /* Time of last status change. */
+	unsigned int		st_ctime_nsec;
+	unsigned int		__unused4;
+	unsigned int		__unused5;
+};
+# endif /* __uClinux__ */
 
 #endif /* _ASM_MICROBLAZE_STAT_H */
-- 
1.5.5.1

