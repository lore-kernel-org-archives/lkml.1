Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbZBIXEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbZBIXEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbZBIXDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:03:51 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:33334 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbZBIXDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:03:50 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] integrity: shmem zero fix
Date: Mon,  9 Feb 2009 18:02:28 -0500
Message-Id: <1234220548-4791-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on comments from Mike Frysinger and Randy Dunlap,
- moved ima.h include before CONFIG_SHMEM test
- added 'struct linux_binprm' in ima.h

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 6db30a3..7018ee8 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -12,6 +12,8 @@
 #ifndef _LINUX_IMA_H
 #define _LINUX_IMA_H
 
+struct linux_binprm;
+
 #ifdef CONFIG_IMA
 extern int ima_bprm_check(struct linux_binprm *bprm);
 extern int ima_inode_alloc(struct inode *inode);
diff --git a/mm/shmem.c b/mm/shmem.c
index 7519988..8135fac 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -28,6 +28,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/swap.h>
+#include <linux/ima.h>
 
 static struct vfsmount *shm_mnt;
 
@@ -59,7 +60,6 @@ static struct vfsmount *shm_mnt;
 #include <linux/highmem.h>
 #include <linux/seq_file.h>
 #include <linux/magic.h>
-#include <linux/ima.h>
 
 #include <asm/uaccess.h>
 #include <asm/div64.h>
-- 
1.5.6.6

