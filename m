Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbYLYOd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbYLYOd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 09:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYLYOdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 09:33:17 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:51756 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYLYOdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 09:33:16 -0500
Date: Thu, 25 Dec 2008 15:33:11 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: kyle@mcmartin.ca, matthew@wil.cx, grundler@parisc-linux.org,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/7] arch/parisc: Use DEFINE_SPINLOCK
Message-ID: <Pine.LNX.4.64.0812251532430.22039@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

SPIN_LOCK_UNLOCKED is deprecated.  The following makes the change suggested
in Documentation/spinlocks.txt

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
declarer name DEFINE_SPINLOCK;
identifier xxx_lock;
@@

- spinlock_t xxx_lock = SPIN_LOCK_UNLOCKED;
+ DEFINE_SPINLOCK(xxx_lock);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff -u -p a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -52,7 +52,7 @@
 #include <linux/tty.h>
 #include <asm/pdc.h>		/* for iodc_call() proto and friends */
 
-static spinlock_t pdc_console_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(pdc_console_lock);
 
 static void pdc_console_write(struct console *co, const char *s, unsigned count)
 {
