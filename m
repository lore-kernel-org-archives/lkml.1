Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZCNPkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZCNPkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 11:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZCNPko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 11:40:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:41539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbZCNPko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 11:40:44 -0400
Subject: [PATCH -tip] x86: rtc.c cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 21:10:12 +0530
Message-Id: <1237045212.4546.21.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86: rtc.c cleanup

Impact: cleanup

 - fix various style problems
  - fix header file issues

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/rtc.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index dd6f2b7..5c77a34 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -1,14 +1,14 @@
 /*
  * RTC related functions
  */
+#include <linux/platform_device.h>
+#include <linux/mc146818rtc.h>
 #include <linux/acpi.h>
 #include <linux/bcd.h>
-#include <linux/mc146818rtc.h>
-#include <linux/platform_device.h>
 #include <linux/pnp.h>
 
-#include <asm/time.h>
 #include <asm/vsyscall.h>
+#include <asm/time.h>
 
 #ifdef CONFIG_X86_32
 /*
@@ -16,9 +16,9 @@
  * register we are working with.  It is required for NMI access to the
  * CMOS/RTC registers.  See include/asm-i386/mc146818rtc.h for details.
  */
-volatile unsigned long cmos_lock = 0;
+volatile unsigned long cmos_lock;
 EXPORT_SYMBOL(cmos_lock);
-#endif
+#endif /* CONFIG_X86_32 */
 
 /* For two digit years assume time is always after that */
 #define CMOS_YEARS_OFFS 2000
@@ -72,8 +72,8 @@ int mach_set_rtc_mmss(unsigned long nowtime)
 			real_seconds = bin2bcd(real_seconds);
 			real_minutes = bin2bcd(real_minutes);
 		}
-		CMOS_WRITE(real_seconds,RTC_SECONDS);
-		CMOS_WRITE(real_minutes,RTC_MINUTES);
+		CMOS_WRITE(real_seconds, RTC_SECONDS);
+		CMOS_WRITE(real_minutes, RTC_MINUTES);
 	} else {
 		printk(KERN_WARNING
 		       "set_rtc_mmss: can't update from %d to %d\n",
@@ -118,7 +118,7 @@ unsigned long mach_get_cmos_time(void)
 	if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
 	    acpi_gbl_FADT.century)
 		century = CMOS_READ(acpi_gbl_FADT.century);
-#endif
+#endif /* CONFIG_ACPI */
 
 	status = CMOS_READ(RTC_CONTROL);
 	WARN_ON_ONCE(RTC_ALWAYS_BCD && (status & RTC_DM_BINARY));
@@ -151,6 +151,7 @@ unsigned char rtc_cmos_read(unsigned char addr)
 	outb(addr, RTC_PORT(0));
 	val = inb(RTC_PORT(1));
 	lock_cmos_suffix(addr);
+
 	return val;
 }
 EXPORT_SYMBOL(rtc_cmos_read);
@@ -166,8 +167,8 @@ EXPORT_SYMBOL(rtc_cmos_write);
 
 static int set_rtc_mmss(unsigned long nowtime)
 {
-	int retval;
 	unsigned long flags;
+	int retval;
 
 	spin_lock_irqsave(&rtc_lock, flags);
 	retval = set_wallclock(nowtime);
@@ -237,11 +238,12 @@ static __init int add_rtc_cmos(void)
 			}
 		}
 	}
-#endif
+#endif /* CONFIG_PNP */
 
 	platform_device_register(&rtc_device);
 	dev_info(&rtc_device.dev,
 		 "registered platform RTC device (no PNP device found)\n");
+
 	return 0;
 }
 device_initcall(add_rtc_cmos);
-- 
1.6.0.6



