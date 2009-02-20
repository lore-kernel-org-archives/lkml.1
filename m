Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbZBTPsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbZBTPsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758600AbZBTPq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:46:58 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35448 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754145AbZBTPqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:46:54 -0500
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, Kyle McMartin <kyle@mcmartin.ca>,
       David Woodhouse <dwmw2@infradead.org>,
       Richard Zidlicky <rz@linux-m68k.org>, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 3/5] m68k: Enable rtc-generic
Date: Fri, 20 Feb 2009 16:46:47 +0100
Message-Id: <1235144809-32468-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1235144809-32468-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235144809-32468-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235144809-32468-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 arch/m68k/Kconfig       |    4 ++++
 arch/m68k/kernel/time.c |   21 +++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index fb87c08..9d2565e 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -27,6 +27,10 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default n
 
+config ARCH_HAS_GENERIC_RTC
+	bool
+	default y
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 7db4159..b26933f 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/rtc.h>
+#include <linux/platform_device.h>
 
 #include <asm/machdep.h>
 #include <asm/io.h>
@@ -159,3 +160,23 @@ int do_settimeofday(struct timespec *tv)
 }
 
 EXPORT_SYMBOL(do_settimeofday);
+
+
+static struct platform_device rtc_generic_dev = {
+	.name = "rtc-generic",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	int ret;
+
+	ret = platform_device_register(&rtc_generic_dev);
+	if (ret < 0)
+		pr_err("Unable to register rtc device...\n");
+
+	/* not necessarily an error */
+	return 0;
+}
+
+module_init(rtc_init);
-- 
1.6.0.4

