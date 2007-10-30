Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbXJ3FyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbXJ3FyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 01:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbXJ3FxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 01:53:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:36669 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbXJ3FxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 01:53:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,345,1188802800"; 
   d="scan'208";a="308136332"
Subject: [PATCH 3/4 -v5] x86_64 EFI runtime service support: document for
	EFI runtime services
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 30 Oct 2007 13:55:47 +0800
Message-Id: <1193723747.23935.353.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 30 Oct 2007 05:52:47.0180 (UTC) FILETIME=[190FD8C0:01C81AB9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds document for EFI x86_64 runtime services support.

---

 boot-options.txt |   11 ++++++++++-
 uefi.txt         |    9 +++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

Index: linux-2.6.24-rc1/Documentation/x86_64/boot-options.txt
===================================================================
--- linux-2.6.24-rc1.orig/Documentation/x86_64/boot-options.txt	2007-10-30 10:15:00.000000000 +0800
+++ linux-2.6.24-rc1/Documentation/x86_64/boot-options.txt	2007-10-30 10:23:52.000000000 +0800
@@ -110,12 +110,15 @@
 
 Rebooting
 
-   reboot=b[ios] | t[riple] | k[bd] [, [w]arm | [c]old]
+   reboot=b[ios] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old]
    bios	  Use the CPU reboot vector for warm reset
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
    kbd    Use the keyboard controller. cold reset (default)
+   efi    Use efi reset_system runtime service. If EFI is not configured or the
+          EFI reset does not work, the reboot path attempts the reset using
+          the keyboard controller.
 
    Using warm reset will be much faster especially on big memory
    systems because the BIOS will not go through the memory check.
@@ -300,4 +303,10 @@
 		newfallback: use new unwinder but fall back to old if it gets
 			stuck (default)
 
+EFI
+
+  noefi		Disable EFI support
+
+  efi_time=on	Enable EFI time runtime service
+
 Miscellaneous
Index: linux-2.6.24-rc1/Documentation/x86_64/uefi.txt
===================================================================
--- linux-2.6.24-rc1.orig/Documentation/x86_64/uefi.txt	2007-10-30 10:15:00.000000000 +0800
+++ linux-2.6.24-rc1/Documentation/x86_64/uefi.txt	2007-10-30 10:25:39.000000000 +0800
@@ -19,6 +19,10 @@
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
@@ -27,3 +31,8 @@
 	can be found in the elilo sourceforge project.
 - Boot to EFI shell and invoke elilo choosing the kernel image built
   in first step.
+- If some or all EFI runtime services don't work, you can try following
+  kernel command line parameters to turn off some or all EFI runtime
+  services.
+	noefi		turn off all EFI runtime services
+	reboot_type=k	turn off EFI reboot runtime service
