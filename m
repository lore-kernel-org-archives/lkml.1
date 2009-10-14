Return-Path: <linux-kernel-owner+w=401wt.eu-S934758AbZJNPv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934758AbZJNPv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934701AbZJNPv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:51:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:34671 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934600AbZJNPvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:51:55 -0400
Date: Wed, 14 Oct 2009 15:50:59 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jim.cromie@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jim.cromie@gmail.com, tglx@linutronix.de
In-Reply-To: <20091010153350.167321547@linutronix.de>
References: <20091010153350.167321547@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] drivers: Remove BKL from scx200_gpio
Message-ID: <tip-3a8183a2061ba54c4c2b3cd31c3add6fd717e853@git.kernel.org>
Git-Commit-ID: 3a8183a2061ba54c4c2b3cd31c3add6fd717e853
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:51:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a8183a2061ba54c4c2b3cd31c3add6fd717e853
Gitweb:     http://git.kernel.org/tip/3a8183a2061ba54c4c2b3cd31c3add6fd717e853
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 16:02:53 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:53 +0200

drivers: Remove BKL from scx200_gpio

cycle_kernel_lock() was added during the big BKL pushdown. It should
ensure the serializiation against driver init code. In this case there
is nothing to serialize. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091010153350.167321547@linutronix.de>
Acked-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/char/scx200_gpio.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/char/scx200_gpio.c b/drivers/char/scx200_gpio.c
index 1d91005..99e5272 100644
--- a/drivers/char/scx200_gpio.c
+++ b/drivers/char/scx200_gpio.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -52,7 +51,6 @@ static int scx200_gpio_open(struct inode *inode, struct file *file)
 	unsigned m = iminor(inode);
 	file->private_data = &scx200_gpio_ops;
 
-	cycle_kernel_lock();
 	if (m >= MAX_PINS)
 		return -EINVAL;
 	return nonseekable_open(inode, file);
