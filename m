Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbZJRWr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbZJRWr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbZJRWr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:47:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430AbZJRWr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:47:57 -0400
Date: Mon, 19 Oct 2009 00:47:35 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Subject: [PATCH] crypto: s390: Remove BKL in zcrypt_open
Message-ID: <alpine.LFD.2.00.0910190046540.3405@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7673a4ec79b4b4edf3cead3ed88a93d6081c44f0 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Mon, 19 Oct 2009 00:44:03 +0200
Subject: [PATCH] crypto: s390: Remove BKL in zcrypt_open

Do we really need to look an atomic_inc? I don't think so.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/s390/crypto/zcrypt_api.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 65b6a96..e55e311 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -34,7 +34,6 @@
 #include <linux/fs.h>
 #include <linux/proc_fs.h>
 #include <linux/compat.h>
-#include <linux/smp_lock.h>
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 #include <linux/hw_random.h>
@@ -299,9 +298,7 @@ static ssize_t zcrypt_write(struct file *filp, const char __user *buf,
  */
 static int zcrypt_open(struct inode *inode, struct file *filp)
 {
-	lock_kernel();
 	atomic_inc(&zcrypt_open_count);
-	unlock_kernel();
 	return 0;
 }
 
-- 
1.6.0.6

