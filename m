Return-Path: <linux-kernel-owner+w=401wt.eu-S1761455AbYGOVFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455AbYGOVFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbYGOVE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:04:57 -0400
Received: from www.tglx.de ([62.245.132.106]:43804 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254AbYGOVE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:04:56 -0400
Date: Tue, 15 Jul 2008 23:04:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [Git pull] timer updates
Message-ID: <alpine.LFD.1.10.0807152303270.3283@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers/for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers/for-linus

 Thanks,

	tglx

------------------>

Randy Dunlap (1):
      acpi_pm: re-fix printk format


 drivers/clocksource/acpi_pm.c |    6 +++---
 include/linux/acpi_pmtmr.h    |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 5ca1d80..0f38b1b 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -28,7 +28,7 @@
  * The location is detected during setup_arch(),
  * in arch/i386/kernel/acpi/boot.c
  */
-u32 pmtmr_ioport __read_mostly;
+unsigned long pmtmr_ioport __read_mostly;
 
 static inline u32 read_pmtmr(void)
 {
@@ -227,8 +227,8 @@ static int __init parse_pmtmr(char *arg)
 	if (strict_strtoul(arg, 16, &base))
 		return -EINVAL;
 
-	printk(KERN_INFO "PMTMR IOPort override: 0x%04x -> 0x%04lx\n",
-	       (unsigned int)pmtmr_ioport, base);
+	printk(KERN_INFO "PMTMR IOPort override: 0x%04lx -> 0x%04lx\n",
+	       pmtmr_ioport, base);
 	pmtmr_ioport = base;
 
 	return 1;
diff --git a/include/linux/acpi_pmtmr.h b/include/linux/acpi_pmtmr.h
index 7e3d285..503c7f7 100644
--- a/include/linux/acpi_pmtmr.h
+++ b/include/linux/acpi_pmtmr.h
@@ -15,7 +15,7 @@
 #ifdef CONFIG_X86_PM_TIMER
 
 extern u32 acpi_pm_read_verified(void);
-extern u32 pmtmr_ioport;
+extern unsigned long pmtmr_ioport;
 
 static inline u32 acpi_pm_read_early(void)
 {
