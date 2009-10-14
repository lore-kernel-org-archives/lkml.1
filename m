Return-Path: <linux-kernel-owner+w=401wt.eu-S934635AbZJNPtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934635AbZJNPtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbZJNPtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:49:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:34102 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721AbZJNPtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:49:15 -0400
Date: Wed, 14 Oct 2009 15:48:13 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dbrownell@users.sourceforge.net, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, tglx@linutronix.de
In-Reply-To: <20091010153349.318535932@linutronix.de>
References: <20091010153349.318535932@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] spi: Remove BKL from spidev_open
Message-ID: <tip-4c2aedc2543248c3fdc8c06c662b589d36c93bbb@git.kernel.org>
Git-Commit-ID: 4c2aedc2543248c3fdc8c06c662b589d36c93bbb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:48:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c2aedc2543248c3fdc8c06c662b589d36c93bbb
Gitweb:     http://git.kernel.org/tip/4c2aedc2543248c3fdc8c06c662b589d36c93bbb
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 15:35:52 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:48 +0200

spi: Remove BKL from spidev_open

The BKL was added there with the big pushdown. Remove it as the code
is serialized already.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091010153349.318535932@linutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/spi/spidev.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 5d23983..815a650 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -30,7 +30,6 @@
 #include <linux/errno.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/spidev.h>
@@ -477,7 +476,6 @@ static int spidev_open(struct inode *inode, struct file *filp)
 	struct spidev_data	*spidev;
 	int			status = -ENXIO;
 
-	lock_kernel();
 	mutex_lock(&device_list_lock);
 
 	list_for_each_entry(spidev, &device_list, device_entry) {
@@ -503,7 +501,6 @@ static int spidev_open(struct inode *inode, struct file *filp)
 		pr_debug("spidev: nothing for minor %d\n", iminor(inode));
 
 	mutex_unlock(&device_list_lock);
-	unlock_kernel();
 	return status;
 }
 
