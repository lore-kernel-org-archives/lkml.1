Return-Path: <linux-kernel-owner+w=401wt.eu-S1760557AbXJYG4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557AbXJYG4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 02:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760705AbXJYGze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 02:55:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:52686 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760672AbXJYGzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 02:55:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,328,1188802800"; 
   d="scan'208";a="357762037"
Subject: [PATCH 3/3 -v4] x86_64 EFI runtime service support: document for
	EFI runtime services
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Oct 2007 14:58:13 +0800
Message-Id: <1193295493.23935.204.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 25 Oct 2007 06:55:25.0727 (UTC) FILETIME=[0543DAF0:01C816D4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds document for EFI x86_64 runtime services support.

---

 boot-options.txt |   12 +++++++++++-
 uefi.txt         |   10 ++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

Index: linux-2.6.24-rc1/Documentation/x86_64/boot-options.txt
===================================================================
--- linux-2.6.24-rc1.orig/Documentation/x86_64/boot-options.txt	2007-10-25 13:58:14.000000000 +0800
+++ linux-2.6.24-rc1/Documentation/x86_64/boot-options.txt	2007-10-25 13:58:18.000000000 +0800
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
@@ -300,4 +303,11 @@
 		newfallback: use new unwinder but fall back to old if it gets
 			stuck (default)
 
+EFI
+
+  noefi		Disable EFI support
+
+  noefi_time	Disable EFI time runtime service, programming CMOS
+  		hardware directly
+
 Miscellaneous
Index: linux-2.6.24-rc1/Documentation/x86_64/uefi.txt
===================================================================
--- linux-2.6.24-rc1.orig/Documentation/x86_64/uefi.txt	2007-10-25 13:58:18.000000000 +0800
+++ linux-2.6.24-rc1/Documentation/x86_64/uefi.txt	2007-10-25 13:58:18.000000000 +0800
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
@@ -27,3 +31,9 @@
 	can be found in the elilo sourceforge project.
 - Boot to EFI shell and invoke elilo choosing the kernel image built
   in first step.
+- If some or all EFI runtime services don't work, you can try following
+  kernel command line parameters to turn off some or all EFI runtime
+  services.
+	noefi		turn off all EFI runtime services
+	noefi_time	turn off EFI time runtime service
+	reboot_type=k	turn off EFI reboot runtime service
