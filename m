Return-Path: <linux-kernel-owner+w=401wt.eu-S934754AbZJNPvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934754AbZJNPvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934726AbZJNPvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:51:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:34657 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934724AbZJNPvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:51:41 -0400
Date: Wed, 14 Oct 2009 15:50:44 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jim.cromie@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jim.cromie@gmail.com, tglx@linutronix.de
In-Reply-To: <20091010153350.127093710@linutronix.de>
References: <20091010153350.127093710@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] drivers: Remove BKL from pc8736x_gpio
Message-ID: <tip-71d69bc2c0202f438669073d849999d2f6b6ca31@git.kernel.org>
Git-Commit-ID: 71d69bc2c0202f438669073d849999d2f6b6ca31
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:50:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71d69bc2c0202f438669073d849999d2f6b6ca31
Gitweb:     http://git.kernel.org/tip/71d69bc2c0202f438669073d849999d2f6b6ca31
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 15:56:00 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:52 +0200

drivers: Remove BKL from pc8736x_gpio

cycle_kernel_lock() was added during the big BKL pushdown. It should
ensure the serializiation against driver init code. In this case there
is nothing to serialize. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091010153350.127093710@linutronix.de>
Acked-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/char/pc8736x_gpio.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/char/pc8736x_gpio.c b/drivers/char/pc8736x_gpio.c
index 3f7da8c..8ecbcc1 100644
--- a/drivers/char/pc8736x_gpio.c
+++ b/drivers/char/pc8736x_gpio.c
@@ -20,7 +20,6 @@
 #include <linux/mutex.h>
 #include <linux/nsc_gpio.h>
 #include <linux/platform_device.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
 #define DEVNAME "pc8736x_gpio"
@@ -223,7 +222,6 @@ static int pc8736x_gpio_open(struct inode *inode, struct file *file)
 	unsigned m = iminor(inode);
 	file->private_data = &pc8736x_gpio_ops;
 
-	cycle_kernel_lock();
 	dev_dbg(&pdev->dev, "open %d\n", m);
 
 	if (m >= PC8736X_GPIO_CT)
