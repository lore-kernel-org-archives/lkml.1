Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbZJKVGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbZJKVGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 17:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZJKVFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 17:05:49 -0400
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:39422 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbZJKVFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 17:05:48 -0400
From: Bernhard Walle <bernhard@bwalle.de>
To: akpm@linuxfoundation.org
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Bernhard Walle <bernhard@bwalle.de>
Subject: [PATCH 2/2] Always print panic message on current console
Date: Sun, 11 Oct 2009 23:04:31 +0200
Message-Id: <1255295071-13664-3-git-send-email-bernhard@bwalle.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255295071-13664-1-git-send-email-bernhard@bwalle.de>
References: <1255295071-13664-1-git-send-email-bernhard@bwalle.de>
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
index 96b45d0..3c84b01 100644
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
+	vt_kmsg_redirect(0);
+
 	bust_spinlocks(1);
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
-- 
1.6.3.3

