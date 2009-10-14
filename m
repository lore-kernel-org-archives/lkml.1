Return-Path: <linux-kernel-owner+w=401wt.eu-S934732AbZJNPvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934732AbZJNPvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756721AbZJNPv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:51:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:34641 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306AbZJNPv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:51:26 -0400
Date: Wed, 14 Oct 2009 15:50:29 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, kyle@parisc-linux.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, kyle@parisc-linux.org
In-Reply-To: <20091010153350.086917493@linutronix.de>
References: <20091010153350.086917493@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] parisc: Remove BKL from eisa_eeprom
Message-ID: <tip-eb29b758a8b0b2dbffd8dc898490237d3ee783e4@git.kernel.org>
Git-Commit-ID: eb29b758a8b0b2dbffd8dc898490237d3ee783e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:50:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb29b758a8b0b2dbffd8dc898490237d3ee783e4
Gitweb:     http://git.kernel.org/tip/eb29b758a8b0b2dbffd8dc898490237d3ee783e4
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 15:33:17 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:52 +0200

parisc: Remove BKL from eisa_eeprom

Remove the empty ioctl and the cycle_kernel_lock() in
eisa_eeprom_open() which got there with the big BKL push down. There
is nothing to wait for and sychronize with after the misc device has
been registered.

Remove the empty ioctl as well. The generic code handles the -ENOTTY
if no ioctl function is provided.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091010153350.086917493@linutronix.de>
Cc: Kyle McMartin <kyle@parisc-linux.org>
---
 drivers/parisc/eisa_eeprom.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/parisc/eisa_eeprom.c b/drivers/parisc/eisa_eeprom.c
index 8c0b26e..cce00ed 100644
--- a/drivers/parisc/eisa_eeprom.c
+++ b/drivers/parisc/eisa_eeprom.c
@@ -75,17 +75,8 @@ static ssize_t eisa_eeprom_read(struct file * file,
 	return ret;
 }
 
-static int eisa_eeprom_ioctl(struct inode *inode, struct file *file, 
-			   unsigned int cmd,
-			   unsigned long arg)
-{
-	return -ENOTTY;
-}
-
 static int eisa_eeprom_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
-
 	if (file->f_mode & FMODE_WRITE)
 		return -EINVAL;
    
@@ -104,7 +95,6 @@ static const struct file_operations eisa_eeprom_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	eisa_eeprom_llseek,
 	.read =		eisa_eeprom_read,
-	.ioctl =	eisa_eeprom_ioctl,
 	.open =		eisa_eeprom_open,
 	.release =	eisa_eeprom_release,
 };
