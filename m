Return-Path: <linux-kernel-owner+w=401wt.eu-S934629AbZJNPqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934629AbZJNPqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934619AbZJNPqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:46:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:33955 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934593AbZJNPql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:46:41 -0400
Date: Wed, 14 Oct 2009 15:45:34 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jdike@addtoit.com, tglx@linutronix.de
In-Reply-To: <20091010153349.641118498@linutronix.de>
References: <20091010153349.641118498@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/arch] um: Remove BKL from random
Message-ID: <tip-df502e389383b219e44819fe757614450d95f297@git.kernel.org>
Git-Commit-ID: df502e389383b219e44819fe757614450d95f297
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:45:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df502e389383b219e44819fe757614450d95f297
Gitweb:     http://git.kernel.org/tip/df502e389383b219e44819fe757614450d95f297
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 15:36:30 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 15:35:51 +0200

um: Remove BKL from random

cycle_kernel_lock() was added during the big BKL pushdown. It should
ensure the serializiation against driver init code. In this case there
is nothing to serialize. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091010153349.641118498@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/drivers/random.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/random.c b/arch/um/drivers/random.c
index 6eabb70..4949044 100644
--- a/arch/um/drivers/random.c
+++ b/arch/um/drivers/random.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License, incorporated herein by reference.
  */
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
@@ -34,8 +33,6 @@ static DECLARE_WAIT_QUEUE_HEAD(host_read_wait);
 
 static int rng_dev_open (struct inode *inode, struct file *filp)
 {
-	cycle_kernel_lock();
-
 	/* enforce read-only access to this chrdev */
 	if ((filp->f_mode & FMODE_READ) == 0)
 		return -EINVAL;
