Return-Path: <linux-kernel-owner+w=401wt.eu-S934617AbZJNPqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934617AbZJNPqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934601AbZJNPqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:46:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:33934 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934567AbZJNPqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:46:30 -0400
Date: Wed, 14 Oct 2009 15:45:18 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jang@linux.vnet.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jang@linux.vnet.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <20091010153349.601625576@linutronix.de>
References: <20091010153349.601625576@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/arch] s390: Remove BKL from prng
Message-ID: <tip-ca1b82ba0888e742a7efdb89ed8e2aab453e091f@git.kernel.org>
Git-Commit-ID: ca1b82ba0888e742a7efdb89ed8e2aab453e091f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:45:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca1b82ba0888e742a7efdb89ed8e2aab453e091f
Gitweb:     http://git.kernel.org/tip/ca1b82ba0888e742a7efdb89ed8e2aab453e091f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 10:21:03 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 15:35:50 +0200

s390: Remove BKL from prng

cycle_kernel_lock() was added during the big BKL pushdown. It should
ensure the serializiation against driver init code. In this case there
is nothing to serialize. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
LKML-Reference: <20091010153349.601625576@linutronix.de>
Acked-by: Jan Glauber <jang@linux.vnet.ibm.com>

---
 arch/s390/crypto/prng.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/s390/crypto/prng.c b/arch/s390/crypto/prng.c
index b49c00c..a320990 100644
--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -6,7 +6,6 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -49,7 +48,6 @@ static unsigned char parm_block[32] = {
 
 static int prng_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
 	return nonseekable_open(inode, file);
 }
 
