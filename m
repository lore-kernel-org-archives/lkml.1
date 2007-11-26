Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbXKZIT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbXKZIT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 03:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbXKZITs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 03:19:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:28491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbXKZITr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 03:19:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,466,1188802800"; 
   d="scan'208";a="215581905"
Subject: [PATCH -mm 3/4 -v6] x86_64 EFI runtime service support: document
	for EFI runtime services
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Nov 2007 16:23:49 +0800
Message-Id: <1196065429.14142.17.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 26 Nov 2007 08:19:39.0014 (UTC) FILETIME=[167A4260:01C83005]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds document for EFI x86_64 runtime services support.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 Documentation/x86_64/boot-options.txt |    9 ++++++++-
 Documentation/x86_64/uefi.txt         |    9 +++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

--- a/Documentation/x86_64/boot-options.txt
+++ b/Documentation/x86_64/boot-options.txt
@@ -110,7 +110,7 @@ Idle loop
 
 Rebooting
 
-   reboot=b[ios] | t[riple] | k[bd] | a[cpi] [, [w]arm | [c]old]
+   reboot=b[ios] | t[riple] | k[bd] | a[cpi] | e[fi] [, [w]arm | [c]old]
    bios	  Use the CPU reboot vector for warm reset
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
@@ -119,6 +119,9 @@ Rebooting
    acpi   Use the ACPI RESET_REG in the FADT. If ACPI is not configured or the
           ACPI reset does not work, the reboot path attempts the reset using
           the keyboard controller.
+   efi    Use efi reset_system runtime service. If EFI is not configured or the
+          EFI reset does not work, the reboot path attempts the reset using
+          the keyboard controller.
 
    Using warm reset will be much faster especially on big memory
    systems because the BIOS will not go through the memory check.
@@ -303,4 +306,8 @@ Debugging
 		newfallback: use new unwinder but fall back to old if it gets
 			stuck (default)
 
+EFI
+
+  noefi		Disable EFI support
+
 Miscellaneous
--- a/Documentation/x86_64/uefi.txt
+++ b/Documentation/x86_64/uefi.txt
@@ -19,6 +19,10 @@ Mechanics:
 - Build the kernel with the following configuration.
 	CONFIG_FB_EFI=y
 	CONFIG_FRAMEBUFFER_CONSOLE=y
+  If EFI runtime services are expected, the following configuration should
+  be selected.
+	CONFIG_EFI=y
+	CONFIG_EFI_VARS=y or m		# optional
 - Create a VFAT partition on the disk
 - Copy the following to the VFAT partition:
 	elilo bootloader with x86_64 support, elilo configuration file,
@@ -27,3 +31,8 @@ Mechanics:
 	can be found in the elilo sourceforge project.
 - Boot to EFI shell and invoke elilo choosing the kernel image built
   in first step.
+- If some or all EFI runtime services don't work, you can try following
+  kernel command line parameters to turn off some or all EFI runtime
+  services.
+	noefi		turn off all EFI runtime services
+	reboot_type=k	turn off EFI reboot runtime service
