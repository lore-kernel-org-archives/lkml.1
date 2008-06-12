Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbYFLWjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbYFLWjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbYFLWjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:39:14 -0400
Received: from relay1.sgi.com ([192.48.171.29]:56881 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753317AbYFLWjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:39:13 -0400
Message-Id: <20080612223802.673729000@polaris-admin.engr.sgi.com>
References: <20080612223802.528617000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 15:38:03 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] x86: Add config option to setup early serial console
Content-Disposition: inline; filename=setup-early-serial-console
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * Add config option EARLY_SERIAL_CONSOLE to enable early
   printk's to be directed to the serial console.

Based on linux-next

Signed-off-by: Mike Travis <travis@sgi.com>
---

---
 arch/x86/Kconfig.debug         |    9 +++++++++
 arch/x86/kernel/early_printk.c |    4 ++++
 2 files changed, 13 insertions(+)

--- linux-2.6-next.orig/arch/x86/Kconfig.debug
+++ linux-2.6-next/arch/x86/Kconfig.debug
@@ -29,6 +29,15 @@ config EARLY_PRINTK
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash.
 
+config EARLY_SERIAL_CONSOLE
+	bool "Early Serial Console"
+	default m
+	help
+	  Initializes the early console to be the serial port.  The default
+	  is to use the VGA console.
+
+	  This is useful for server systems that do not have a VGA console.
+
 config DEBUG_STACKOVERFLOW
 	bool "Check for stack overflows"
 	depends on DEBUG_KERNEL
--- linux-2.6-next.orig/arch/x86/kernel/early_printk.c
+++ linux-2.6-next/arch/x86/kernel/early_printk.c
@@ -193,7 +193,11 @@ static struct console simnow_console = {
 };
 
 /* Direct interface for emergencies */
+#ifdef CONFIG_EARLY_SERIAL_CONSOLE
+static struct console *early_console = &early_serial_console;
+#else
 static struct console *early_console = &early_vga_console;
+#endif
 static int early_console_initialized;
 
 void early_printk(const char *fmt, ...)

-- 

