Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbXEXCmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbXEXCmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 22:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbXEXCmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 22:42:17 -0400
Received: from critter.phunnypharm.org ([67.97.251.11]:2974 "EHLO critter"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757391AbXEXCmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 22:42:17 -0400
X-Greylist: delayed 2129 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 May 2007 22:42:17 EDT
To: linux-kernel@vger.kernel.org
Message-Id: <17ae6569b9848ca4db6bef17013f2c9904f1b026.1179964369.git.bcollins@ubuntu.com>
In-Reply-To: <98cd38b5.git.bcollins@ubuntu.com>
References: <98cd38b5.git.bcollins@ubuntu.com>
From: Ben Collins <bcollins@ubuntu.com>
Date: Wed, 23 May 2007 18:18:24 -0400
Subject: [PATCH 2/6] PM: Do not require dev spew to get PM_DEBUG
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In order to enable things like PM_TRACE, you're required to enable
PM_DEBUG, which sends a large spew of messages on boot, and often times
can overflow dmesg buffer.

Create new PM_VERBOSE and shift that to be the option that enables
drivers/base/power's messages.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
---
 drivers/base/power/Makefile |    2 +-
 kernel/power/Kconfig        |   17 ++++++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/base/power/Makefile b/drivers/base/power/Makefile
index 91f2309..704d326 100644
--- a/drivers/base/power/Makefile
+++ b/drivers/base/power/Makefile
@@ -5,6 +5,6 @@ obj-$(CONFIG_PM_TRACE)	+= trace.o
 ifeq ($(CONFIG_DEBUG_DRIVER),y)
 EXTRA_CFLAGS += -DDEBUG
 endif
-ifeq ($(CONFIG_PM_DEBUG),y)
+ifeq ($(CONFIG_PM_VERBOSE),y)
 EXTRA_CFLAGS += -DDEBUG
 endif
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 495b7d4..1f8cdbd 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -33,13 +33,20 @@ config PM_DEBUG
 	bool "Power Management Debug Support"
 	depends on PM
 	---help---
-	This option enables verbose debugging support in the Power Management
-	code. This is helpful when debugging and reporting various PM bugs, 
-	like suspend support.
+	This option enables various debugging support in the Power Management
+	code. This is helpful when debugging and reporting PM bugs, like
+	suspend support.
+
+config PM_VERBOSE
+	bool "Verbose Power Management debugging"
+	depends on PM_DEBUG
+	default n
+	---help---
+	This option enables verbose messages from the Power Management code.
 
 config DISABLE_CONSOLE_SUSPEND
 	bool "Keep console(s) enabled during suspend/resume (DANGEROUS)"
-	depends on PM && PM_DEBUG
+	depends on PM_DEBUG
 	default n
 	---help---
 	This option turns off the console suspend mechanism that prevents
@@ -50,7 +57,7 @@ config DISABLE_CONSOLE_SUSPEND
 
 config PM_TRACE
 	bool "Suspend/resume event tracing"
-	depends on PM && PM_DEBUG && X86_32 && EXPERIMENTAL
+	depends on PM_DEBUG && X86_32 && EXPERIMENTAL
 	default n
 	---help---
 	This enables some cheesy code to save the last PM event point in the
-- 
1.5.1.4

