Return-Path: <linux-kernel-owner+w=401wt.eu-S1762402AbYGOTBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762402AbYGOTBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758622AbYGOTBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:01:15 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49330 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237AbYGOTBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:01:14 -0400
Date: Tue, 15 Jul 2008 11:59:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] acpi_pm: re-fix printk format (was: timer updates for
 2.6.27)
Message-Id: <20080715115951.95f7917d.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.1.10.0807151100140.3017@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807141827340.3283@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0807151046180.3017@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807151100140.3017@woody.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Re-fix printk format warning in acpi_pm clocksource.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/clocksource/acpi_pm.c |    6 +++---
 include/linux/acpi_pmtmr.h    |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

[still looking for penance task]

--- linhead.orig/drivers/clocksource/acpi_pm.c
+++ linhead/drivers/clocksource/acpi_pm.c
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
--- linhead.orig/include/linux/acpi_pmtmr.h
+++ linhead/include/linux/acpi_pmtmr.h
@@ -15,7 +15,7 @@
 #ifdef CONFIG_X86_PM_TIMER
 
 extern u32 acpi_pm_read_verified(void);
-extern u32 pmtmr_ioport;
+extern unsigned long pmtmr_ioport;
 
 static inline u32 acpi_pm_read_early(void)
 {





---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
