Return-Path: <linux-kernel-owner+w=401wt.eu-S1758977AbZDFW4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977AbZDFW4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZDFW4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:56:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35690 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbZDFW4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:56:32 -0400
Message-ID: <49DA8875.5050009@redhat.com>
Date: Mon, 06 Apr 2009 18:55:49 -0400
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, dannf@hp.com,
       ying.huang@intel.com
Subject: Re: [PATCH] rtc: add x86 support for rtc-efi
References: <49DA40B9.2060804@redhat.com> <49DA817E.8040705@intel.com>
In-Reply-To: <49DA817E.8040705@intel.com>
Content-Type: multipart/mixed;
 boundary="------------090509010601010204030801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090509010601010204030801
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

re-post of the patch, both as inline and as an attachment (which 
hopefully wont cause confusion).


--- a/drivers/rtc/Kconfig    2009-03-26 12:39:59.000000000 -0400
+++ b/drivers/rtc/Kconfig    2009-04-06 18:46:58.000000000 -0400
@@ -442,7 +442,7 @@ config RTC_DRV_DS1742
 
 config RTC_DRV_EFI
     tristate "EFI RTC"
-    depends on IA64
+   depends on EFI
     help
       If you say yes here you will get support for the EFI
       Real Time Clock.
--- a/arch/x86/kernel/time_32.c    2009-03-12 22:39:28.000000000 -0400
+++ b/arch/x86/kernel/time_32.c    2009-03-26 13:06:10.000000000 -0400
@@ -32,6 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/mca.h>
+#include <linux/platform_device.h>
 
 #include <asm/arch_hooks.h>
 #include <asm/hpet.h>
@@ -135,3 +136,21 @@ void __init time_init(void)
     tsc_init();
     late_time_init = choose_time_init();
 }
+
+
+#ifdef CONFIG_RTC_DRV_EFI
+static struct platform_device rtc_efi_dev = {
+    .name = "rtc-efi",
+    .id = -1,
+};
+
+static int __init rtc_init(void)
+{
+    if (platform_device_register(&rtc_efi_dev) < 0)
+        printk(KERN_ERR "unable to register rtc device...\n");
+
+    /* not necessarily an error */
+    return 0;
+}
+module_init(rtc_init);
+#endif
--- a/arch/x86/kernel/time_64.c    2009-03-12 22:39:28.000000000 -0400
+++ b/arch/x86/kernel/time_64.c    2009-03-26 13:06:19.000000000 -0400
@@ -18,6 +18,7 @@
 #include <linux/time.h>
 #include <linux/mca.h>
 #include <linux/nmi.h>
+#include <linux/platform_device.h>
 
 #include <asm/i8253.h>
 #include <asm/hpet.h>
@@ -135,3 +136,20 @@ void __init time_init(void)
 
     late_time_init = choose_time_init();
 }
+
+#ifdef CONFIG_RTC_DRV_EFI
+static struct platform_device rtc_efi_dev = {
+    .name = "rtc-efi",
+    .id = -1,
+};
+
+static int __init rtc_init(void)
+{
+    if (platform_device_register(&rtc_efi_dev) < 0)
+        printk(KERN_ERR "unable to register rtc device...\n");
+
+    /* not necessarily an error */
+    return 0;
+}
+module_init(rtc_init);
+#endif

--------------------------------------------------------------------------------------------


--------------090509010601010204030801
Content-Type: text/x-patch;
 name="2.6.29-add-x86-support-for-efi-rtc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.29-add-x86-support-for-efi-rtc.patch"

--- a/drivers/rtc/Kconfig	2009-03-26 12:39:59.000000000 -0400
+++ b/drivers/rtc/Kconfig	2009-04-06 18:46:58.000000000 -0400
@@ -442,7 +442,7 @@ config RTC_DRV_DS1742
 
 config RTC_DRV_EFI
 	tristate "EFI RTC"
-	depends on IA64
+	depends on EFI
 	help
 	  If you say yes here you will get support for the EFI
 	  Real Time Clock.
--- a/arch/x86/kernel/time_32.c	2009-03-12 22:39:28.000000000 -0400
+++ b/arch/x86/kernel/time_32.c	2009-03-26 13:06:10.000000000 -0400
@@ -32,6 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/time.h>
 #include <linux/mca.h>
+#include <linux/platform_device.h>
 
 #include <asm/arch_hooks.h>
 #include <asm/hpet.h>
@@ -135,3 +136,21 @@ void __init time_init(void)
 	tsc_init();
 	late_time_init = choose_time_init();
 }
+
+
+#ifdef CONFIG_RTC_DRV_EFI
+static struct platform_device rtc_efi_dev = {
+	.name = "rtc-efi",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	if (platform_device_register(&rtc_efi_dev) < 0)
+		printk(KERN_ERR "unable to register rtc device...\n");
+
+	/* not necessarily an error */
+	return 0;
+}
+module_init(rtc_init);
+#endif
--- a/arch/x86/kernel/time_64.c	2009-03-12 22:39:28.000000000 -0400
+++ b/arch/x86/kernel/time_64.c	2009-03-26 13:06:19.000000000 -0400
@@ -18,6 +18,7 @@
 #include <linux/time.h>
 #include <linux/mca.h>
 #include <linux/nmi.h>
+#include <linux/platform_device.h>
 
 #include <asm/i8253.h>
 #include <asm/hpet.h>
@@ -135,3 +136,20 @@ void __init time_init(void)
 
 	late_time_init = choose_time_init();
 }
+
+#ifdef CONFIG_RTC_DRV_EFI
+static struct platform_device rtc_efi_dev = {
+	.name = "rtc-efi",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	if (platform_device_register(&rtc_efi_dev) < 0)
+		printk(KERN_ERR "unable to register rtc device...\n");
+
+	/* not necessarily an error */
+	return 0;
+}
+module_init(rtc_init);
+#endif

--------------090509010601010204030801--
