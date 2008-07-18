Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbYGRWTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbYGRWTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760846AbYGRWRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:17:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:47970 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760830AbYGRWRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:17:41 -0400
Date: Fri, 18 Jul 2008 15:17:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu
Subject: [patch 3/3] fastboot: convert a few non-critical ACPI drivers to
 async initcalls
Message-ID: <20080718151735.148819df@infradead.org>
In-Reply-To: <20080718151524.5ef9e29b@infradead.org>
References: <20080718151524.5ef9e29b@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] fastboot: convert a few non-critical ACPI drivers to async initcalls

This patch converts a few non-critical ACPI drivers to async initcalls;
these initcalls (battery, button and thermal) tend to take quite a bit of
time (100's of milliseconds) due to the hardware they need to talk to,
but are otherwise clearly non-essential for the boot process.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/acpi/battery.c |    2 +-
 drivers/acpi/button.c  |    2 +-
 drivers/acpi/thermal.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index b1c723f..d5d30ca 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -904,5 +904,5 @@ static void __exit acpi_battery_exit(void)
 #endif
 }
 
-module_init(acpi_battery_init);
+module_init_async(acpi_battery_init);
 module_exit(acpi_battery_exit);
diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 1dfec41..46b3805 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -545,5 +545,5 @@ static void __exit acpi_button_exit(void)
 	remove_proc_entry(ACPI_BUTTON_CLASS, acpi_root_dir);
 }
 
-module_init(acpi_button_init);
+module_init_async(acpi_button_init);
 module_exit(acpi_button_exit);
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 84c795f..1f529af 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -1833,5 +1833,5 @@ static void __exit acpi_thermal_exit(void)
 	return;
 }
 
-module_init(acpi_thermal_init);
+module_init_async(acpi_thermal_init);
 module_exit(acpi_thermal_exit);
-- 
1.5.5.1

