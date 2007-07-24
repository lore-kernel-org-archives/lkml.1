Return-Path: <linux-kernel-owner+w=401wt.eu-S1764191AbXGXSOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764191AbXGXSOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763303AbXGXSOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:14:24 -0400
Received: from xyzzy.farnsworth.org ([65.39.95.219]:3111 "HELO farnsworth.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763686AbXGXSOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:14:23 -0400
From: "Dale Farnsworth" <dale@farnsworth.org>
Date: Tue, 24 Jul 2007 11:14:21 -0700
To: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] mv64x60_wdt: Fix WDIOC_GETTIMEOUT return value
Message-ID: <20070724181421.GE27445@xyzzy.farnsworth.org>
References: <20070724180738.GA27445@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724180738.GA27445@xyzzy.farnsworth.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WDIOC_GETTIMEOUT returns seconds, not jiffies.

Signed-off-by: Dale Farnsworth <dale@farnsworth.org>
---
 drivers/char/watchdog/mv64x60_wdt.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c
===================================================================
--- linux-2.6-powerpc-wdt.orig/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 19:17:17.000000000 +0000
+++ linux-2.6-powerpc-wdt/drivers/char/watchdog/mv64x60_wdt.c	2007-07-20 19:23:23.000000000 +0000
@@ -118,7 +118,6 @@ static ssize_t mv64x60_wdt_write(struct 
 static int mv64x60_wdt_ioctl(struct inode *inode, struct file *file,
 			     unsigned int cmd, unsigned long arg)
 {
-	int timeout;
 	void __user *argp = (void __user *)arg;
 	static struct watchdog_info info = {
 		.options = WDIOF_KEEPALIVEPING,
@@ -154,8 +153,7 @@ static int mv64x60_wdt_ioctl(struct inod
 		return -EOPNOTSUPP;
 
 	case WDIOC_GETTIMEOUT:
-		timeout = mv64x60_wdt_timeout * HZ;
-		if (put_user(timeout, (int __user *)argp))
+		if (put_user(mv64x60_wdt_timeout, (int __user *)argp))
 			return -EFAULT;
 		break;
 

