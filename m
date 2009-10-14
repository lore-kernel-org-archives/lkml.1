Return-Path: <linux-kernel-owner+w=401wt.eu-S934686AbZJNPsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686AbZJNPsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934675AbZJNPsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:48:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:34074 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934636AbZJNPsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:48:43 -0400
Date: Wed, 14 Oct 2009 15:47:56 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <20091010153349.277882707@linutronix.de>
References: <20091010153349.277882707@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] drivers: Remove BKL from cs5535_gpio
Message-ID: <tip-a7e63bb5f08378620d913824ab42e49027f22194@git.kernel.org>
Git-Commit-ID: a7e63bb5f08378620d913824ab42e49027f22194
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:47:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7e63bb5f08378620d913824ab42e49027f22194
Gitweb:     http://git.kernel.org/tip/a7e63bb5f08378620d913824ab42e49027f22194
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 15:35:48 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:48 +0200

drivers: Remove BKL from cs5535_gpio

The big BKL pushdown added cycle_kernel_lock(). There is nothing to
wait for in this driver. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091010153349.277882707@linutronix.de>
---
 drivers/char/cs5535_gpio.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/cs5535_gpio.c b/drivers/char/cs5535_gpio.c
index 04ba906..4d830dc 100644
--- a/drivers/char/cs5535_gpio.c
+++ b/drivers/char/cs5535_gpio.c
@@ -17,7 +17,7 @@
 #include <linux/cdev.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
-#include <linux/smp_lock.h>
+
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -158,7 +158,6 @@ static int cs5535_gpio_open(struct inode *inode, struct file *file)
 {
 	u32 m = iminor(inode);
 
-	cycle_kernel_lock();
 	/* the mask says which pins are usable by this driver */
 	if ((mask & (1 << m)) == 0)
 		return -EINVAL;
