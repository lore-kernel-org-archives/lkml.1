Return-Path: <linux-kernel-owner+w=401wt.eu-S934863AbZJJU42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863AbZJJU42 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 16:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934838AbZJJU41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 16:56:27 -0400
Received: from smtprelay11.ispgateway.de ([80.67.31.45]:49115 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934832AbZJJU41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 16:56:27 -0400
From: Bernhard Walle <bernhard@bwalle.de>
To: akpm@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Bernhard Walle <bernhard@bwalle.de>
Subject: [PATCH 5/5] Always print panic message on current console
Date: Sat, 10 Oct 2009 22:51:10 +0200
Message-Id: <1255207870-24496-6-git-send-email-bernhard@bwalle.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
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
index 96b45d0..a230459 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/dmi.h>
+#include <linux/vt.h>
 
 int panic_on_oops;
 static unsigned long tainted_mask;
@@ -65,6 +66,9 @@ NORET_TYPE void panic(const char * fmt, ...)
 	 */
 	preempt_disable();
 
+	/* don't redirect the panic message to some hidden console */
+	vt_set_kmsg_redirect(0);
+
 	bust_spinlocks(1);
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
-- 
1.6.3.3

