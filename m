Return-Path: <linux-kernel-owner+w=401wt.eu-S1751526AbZFEEEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbZFEEEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbZFEED6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:03:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42277 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbZFEED5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:03:57 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Subject: [PATCH] shm: fix unused warnings on nommu
Date: Fri,  5 Jun 2009 00:03:52 -0400
Message-Id: <1244174632-19361-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The massive nommu update (8feae131) resulted in these warnings:
ipc/shm.c: In function ‘sys_shmdt’:
ipc/shm.c:974: warning: unused variable ‘size’
ipc/shm.c:972: warning: unused variable ‘next’

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 ipc/shm.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index faa46da..4259716 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -969,10 +969,13 @@ SYSCALL_DEFINE3(shmat, int, shmid, char __user *, shmaddr, int, shmflg)
 SYSCALL_DEFINE1(shmdt, char __user *, shmaddr)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma, *next;
+	struct vm_area_struct *vma;
 	unsigned long addr = (unsigned long)shmaddr;
-	loff_t size = 0;
 	int retval = -EINVAL;
+#ifdef CONFIG_MMU
+	loff_t size = 0;
+	struct vm_area_struct *next;
+#endif
 
 	if (addr & ~PAGE_MASK)
 		return retval;
-- 
1.6.3.1

