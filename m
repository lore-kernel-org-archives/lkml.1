Return-Path: <linux-kernel-owner+w=401wt.eu-S1752353AbZI0Mpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbZI0Mpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 08:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbZI0Mpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 08:45:40 -0400
Received: from smtprelay09.ispgateway.de ([80.67.31.32]:42631 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZI0Mpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 08:45:39 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Sep 2009 08:45:39 EDT
From: Bernhard Walle <bernhard@bwalle.de>
To: linux-kernel@vger.kernel.org
Cc: Bernhard Walle <bernhard@bwalle.de>
Subject: [PATCH] Always print panic message on current console
Date: Sun, 27 Sep 2009 14:36:54 +0200
Message-Id: <1254055014-4441-1-git-send-email-bernhard@bwalle.de>
X-Mailer: git-send-email 1.6.0.4
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel offers with TIOCL_GETKMSGREDIRECT ioctl() the possibility to
redirect the kernel messages to a specific console.

However, since it's not possible to switch to the kernel message console after
a panic(), it would be nice if the kernel would print the panic message on the
current console.


Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
---
 kernel/panic.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index bcdef26..f9950e3 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/dmi.h>
+#include <linux/tty.h>
 
 int panic_on_oops;
 static unsigned long tainted_mask;
@@ -65,6 +66,9 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	preempt_disable();
 
+	/* don't redirect the panic message to some hidden console */
+	kmsg_redirect = 0;
+
 	bust_spinlocks(1);
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
-- 
1.6.0.4

