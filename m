Return-Path: <linux-kernel-owner+w=401wt.eu-S934696AbZJNPuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934696AbZJNPuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934678AbZJNPuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:50:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:34147 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736AbZJNPuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:50:06 -0400
Date: Wed, 14 Oct 2009 15:49:10 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <1255116426-7270-1-git-send-email-fweisbec@gmail.com>
References: <1255116426-7270-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] nvram: Drop the bkl from non-generic nvram_llseek()
Message-ID: <tip-9e8ab74ddaa591575f599248080a1f0d917a56ee@git.kernel.org>
Git-Commit-ID: 9e8ab74ddaa591575f599248080a1f0d917a56ee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:49:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e8ab74ddaa591575f599248080a1f0d917a56ee
Gitweb:     http://git.kernel.org/tip/9e8ab74ddaa591575f599248080a1f0d917a56ee
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 9 Oct 2009 21:27:06 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:50 +0200

nvram: Drop the bkl from non-generic nvram_llseek()

Drop the bkl from nvram_llseek() as it obviously protects nothing.
The file offset is safe in essence.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1255116426-7270-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/char/nvram.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 88cee40..2100a8f 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -38,7 +38,6 @@
 #define NVRAM_VERSION	"1.3"
 
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/nvram.h>
 
 #define PC		1
@@ -214,7 +213,6 @@ void nvram_set_checksum(void)
 
 static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 {
-	lock_kernel();
 	switch (origin) {
 	case 0:
 		/* nothing to do */
@@ -226,7 +224,7 @@ static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 		offset += NVRAM_BYTES;
 		break;
 	}
-	unlock_kernel();
+
 	return (offset >= 0) ? (file->f_pos = offset) : -EINVAL;
 }
 
