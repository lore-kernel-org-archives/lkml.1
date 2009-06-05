Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZFEV4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZFEV4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbZFEV4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:56:03 -0400
Received: from mx28.mail.ru ([94.100.176.42]:12361 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbZFEV4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:56:01 -0400
From: Sergei Trofimovich <slyfox@inbox.ru>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: Sergei Trofimovich <slyfox@inbox.ru>
Subject: [PATCH] cleanup: shmem_file_setup: 'char *' -> 'const char *' for name argument
Date: Sat,  6 Jun 2009 00:48:49 +0300
Message-Id: <1244238529-31976-1-git-send-email-slyfox@inbox.ru>
X-Mailer: git-send-email 1.6.0.6
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As function shmem_file_setup does not modify/allocate/free/pass
given filename - mark it as const.

Signed-off-by: Sergei Trofimovich <slyfox@inbox.ru>
---
 include/linux/mm.h |    2 +-
 mm/shmem.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bff1f0d..e2d8d63 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -726,7 +726,7 @@ static inline int shmem_lock(struct file *file, int lock,
 	return 0;
 }
 #endif
-struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags);
+struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags);
 
 int shmem_zero_setup(struct vm_area_struct *);
 
diff --git a/mm/shmem.c b/mm/shmem.c
index b25f95c..a21d60a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2612,7 +2612,7 @@ int shmem_unuse(swp_entry_t entry, struct page *page)
  * @size: size to be set for the file
  * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
  */
-struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
+struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags)
 {
 	int error;
 	struct file *file;
-- 
1.6.0.6

