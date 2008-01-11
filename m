Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbYAKI4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbYAKI4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYAKI4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:56:00 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:31319
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754963AbYAKI4A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:56:00 -0500
Message-Id: <47873D40.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 11 Jan 2008 08:56:16 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: <len.brown@intel.com>, "Andi Kleen" <ak@suse.de>
Subject: [PATCH 1/4] introduce __cpuinitconst
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch doesn't change all instances where 'const' could have been
added as a result of the base structure changes, only where the change
has a real effect (the module loader doesn't enforce read-only section
attributes at present, so only built-in files make a real difference).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Andi Kleen <ak@suse.de>

---
 drivers/acpi/processor_idle.c |    2 +-
 include/linux/init.h          |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- 2.6.24-rc7-initconst.orig/drivers/acpi/processor_idle.c
+++ 2.6.24-rc7-initconst/drivers/acpi/processor_idle.c
@@ -118,7 +118,7 @@ static int set_max_cstate(const struct d
 
 /* Actually this shouldn't be __cpuinitdata, would be better to fix the
    callers to only run once -AK */
-static struct dmi_system_id __cpuinitdata processor_power_dmi_table[] = {
+static struct dmi_system_id __cpuinitconst processor_power_dmi_table[] = {
 	{ set_max_cstate, "IBM ThinkPad R40e", {
 	  DMI_MATCH(DMI_BIOS_VENDOR,"IBM"),
 	  DMI_MATCH(DMI_BIOS_VERSION,"1SET70WW")}, (void *)1},
--- 2.6.24-rc7-initconst.orig/include/linux/init.h
+++ 2.6.24-rc7-initconst/include/linux/init.h
@@ -269,11 +269,13 @@ void __init parse_early_param(void);
 #ifdef CONFIG_HOTPLUG_CPU
 #define __cpuinit
 #define __cpuinitdata
+#define __cpuinitconst const
 #define __cpuexit
 #define __cpuexitdata
 #else
 #define __cpuinit	__init
 #define __cpuinitdata __initdata
+#define __cpuinitconst __initdata
 #define __cpuexit __exit
 #define __cpuexitdata	__exitdata
 #endif



