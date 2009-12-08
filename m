Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbZLHOQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbZLHOQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 09:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbZLHOQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 09:16:14 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:61371 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbZLHOQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 09:16:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YyzGdWo1OKOW+a9Z5pM1757na1MOeeKW4xmmKt4WYUdn9g0yz18TLuwfNtfNk6lrWs
         +lGd/a/xU7oASJd2LooWH4+OTUV7IkIjz0TMaACIyWIt5T/Nc5WidVWMMPNr3YKbUUyd
         AeMb07R45oUC0lgC93K0x/yOof5Bn/fECPdaE=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: akpm@linux-foundation.org, Wu Zhangjin <wuzhangjin@gmail.com>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH v9 1/8] MIPS: add subdirectory for platform extension drivers
Date: Tue,  8 Dec 2009 22:15:49 +0800
Message-Id: <39d232e3f8359e9c11bad7536f0162444401ec94.1260281599.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1260254344.git.wuzhangjin@gmail.com>
References: <cover.1260254344.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1260281599.git.wuzhangjin@gmail.com>
References: <cover.1260281599.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

It is really hard to split the platform specific subdrivers into
different subsystems, which will generate lots of duplicated source
code, break the whole support into several pieces and also will make the
users be difficult to choose the suitable subdrivers in different
places.

So, I did like the forks have done under drivers/platform/x86, created
the drivers/platform/mips/ for putting the future MIPS netbook/laptop/pc
extension drivers in.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 drivers/platform/Kconfig      |    4 ++++
 drivers/platform/mips/Kconfig |   18 ++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 drivers/platform/mips/Kconfig

diff --git a/drivers/platform/Kconfig b/drivers/platform/Kconfig
index 9652c3f..2319c0b 100644
--- a/drivers/platform/Kconfig
+++ b/drivers/platform/Kconfig
@@ -3,3 +3,7 @@
 if X86
 source "drivers/platform/x86/Kconfig"
 endif
+
+if MIPS
+source "drivers/platform/mips/Kconfig"
+endif
diff --git a/drivers/platform/mips/Kconfig b/drivers/platform/mips/Kconfig
new file mode 100644
index 0000000..2f77693
--- /dev/null
+++ b/drivers/platform/mips/Kconfig
@@ -0,0 +1,18 @@
+#
+# MIPS Platform Specific Drivers
+#
+
+menuconfig MIPS_PLATFORM_DEVICES
+	bool "MIPS Platform Specific Device Drivers"
+	default y
+	help
+	  Say Y here to get to see options for device drivers of various
+	  MIPS platforms, including vendor-specific netbook/laptop/pc extension
+	  drivers.  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if MIPS_PLATFORM_DEVICES
+
+
+endif # MIPS_PLATFORM_DEVICES
-- 
1.6.2.1

