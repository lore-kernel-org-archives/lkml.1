Return-Path: <linux-kernel-owner+w=401wt.eu-S1751546AbYL0GuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbYL0GuO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 01:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYL0Gtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 01:49:43 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:36034 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbYL0Gtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 01:49:41 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] linux/elf.h: remove kernel prototypes for userspace
Date: Sat, 27 Dec 2008 01:49:40 -0500
Message-Id: <1230360580-6631-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The internal elf notes funcs do are for the kernel-only, so hide them
behind __KERNEL__.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/elf.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/elf.h b/include/linux/elf.h
index 0b61ca4..1b6e350 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -395,6 +395,7 @@ extern Elf64_Dyn _DYNAMIC [];
 
 #endif
 
+#ifdef __KERNEL__
 /* Optional callbacks to write extra ELF notes. */
 #ifndef ARCH_HAVE_EXTRA_ELF_NOTES
 static inline int elf_coredump_extra_notes_size(void) { return 0; }
@@ -404,5 +405,6 @@ static inline int elf_coredump_extra_notes_write(struct file *file,
 extern int elf_coredump_extra_notes_size(void);
 extern int elf_coredump_extra_notes_write(struct file *file, loff_t *foffset);
 #endif
+#endif
 
 #endif /* _LINUX_ELF_H */
-- 
1.6.0.6

