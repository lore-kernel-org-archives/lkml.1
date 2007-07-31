Return-Path: <linux-kernel-owner+w=401wt.eu-S967810AbXGaDP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967810AbXGaDP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967412AbXGaDNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:13:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:38983 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967315AbXGaDNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:13:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,201,1183359600"; 
   d="scan'208";a="256697420"
Subject: [PATCH 5/5] x86_64 EFI support -v3: EFI document
From: "Huang, Ying" <ying.huang@intel.com>
To: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2007 11:13:03 +0800
Message-Id: <1185851583.23149.30.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 31 Jul 2007 03:13:14.0385 (UTC) FILETIME=[BBA40010:01C7D320]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds document for EFI x86_64 support. The boot parameters
added are documented in Documentation/i386/zero-page.txt. The setup
and operation guide of EFI based system is documented in
Documentation/x86_64/uefi.txt.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 i386/zero-page.txt |   18 ++++++++++++++----
 x86_64/uefi.txt    |   42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 4 deletions(-)

Index: linux-2.6.23-rc1/Documentation/i386/zero-page.txt
===================================================================
--- linux-2.6.23-rc1.orig/Documentation/i386/zero-page.txt	2007-07-30 11:28:45.000000000 +0800
+++ linux-2.6.23-rc1/Documentation/i386/zero-page.txt	2007-07-30 11:29:28.000000000 +0800
@@ -31,11 +31,11 @@
  0xb0 - 0x13f		Free. Add more parameters here if you really need them.
  0x140- 0x1be		EDID_INFO Video mode setup
 
-0x1c4	unsigned long	EFI system table pointer
-0x1c8	unsigned long	EFI memory descriptor size
-0x1cc	unsigned long	EFI memory descriptor version
+0x1c4	unsigned long	EFI system table pointer*
+0x1c8	unsigned long	EFI memory descriptor size*
+0x1cc	unsigned long	EFI memory descriptor version*
 0x1d0	unsigned long	EFI memory descriptor map pointer
-0x1d4	unsigned long	EFI memory descriptor map size
+0x1d4	unsigned long	EFI memory descriptor map size*
 0x1e0	unsigned long	ALT_MEM_K, alternative mem check, in Kb
 0x1e4	unsigned long	Scratch field for the kernel setup code
 0x1e8	char		number of entries in E820MAP (below)
@@ -87,3 +87,13 @@
 0x2d0 - 0xd00		E820MAP
 0xd00 - 0xeff		EDDBUF (edd.S) for disk signature read sector
 0xd00 - 0xeeb		EDDBUF (edd.S) for edd data
+
+Changes for x86_64 implementation:
+---------------------------------
+For alignment purposes, the following parameters are rearranged.
+
+0x1b8	unsigned long	EFI system table pointer
+0x1c0	unsigned long	EFI Loader signature
+0x1c4	unsigned long	EFI memory descriptor size
+0x1c8	unsigned long	EFI memory descriptor version
+0x1cc	unsigned long	EFI memory descriptor map size
Index: linux-2.6.23-rc1/Documentation/x86_64/uefi.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23-rc1/Documentation/x86_64/uefi.txt	2007-07-30 11:29:28.000000000 +0800
@@ -0,0 +1,42 @@
+General note on [U]EFI x86_64 support
+-------------------------------------
+
+This provides documentation on [U]EFI support for x86_64 architecture.
+The nomenclature EFI and UEFI are used intechangeably in this document.
+
+Although the tools below are _not_ needed for building the kernel,
+the needed bootloader support and associated tools for x86_64 platforms
+with EFI firmware and specifications are listed below.
+
+1. UEFI specification:  http://www.uefi.org
+
+2. Booting EFI64 enabled kernel requires boot loader support.
+Patches to elilo and gnu-efi library with x86_64 support and documentation
+have been submitted to respective project maintainers.
+	elilo: http://sourceforge.net/projects/elilo
+	gnu-efi library: http://sourceforge.net/projects/gnu-efi/
+	gnu-efi-3.0d release now supports [U]EFI x86_64.
+
+3. The tool to convert ELF to PE-COFF image:
+	binutils-2.17.50.0.14 supports Intel64 EFI.
+	see http://www.kernel.org/pub/linux/devel/binutils/
+	[ elilo/gnu-efi with x86_64 support need this binutils support ]
+
+4. x86_64 platform with EFI/UEFI firmware.
+
+Mechanics:
+---------
+- Apply the EFI64 kernel patches and build with the following configuration.
+	CONFIG_EFI=y
+	EFI_FB=y
+	CONFIG_FRAMEBUFFER_CONSOLE=y
+	CONFIG_EFI_VARS=y
+
+- Create a VFAT partition on the disk
+- Copy the following to the VFAT partition:
+	elilo bootloader with x86_64 support and elilo configuration file
+	efi64 kernel image and initrd. Instructions on building elilo
+	and its dependencies can be found in the elilo sourceforge project.
+- Boot to EFI shell and invoke elilo choosing efi64 kernel image
+- On UEFI2.0 firmware systems, pass vga=normal for boot messages to show up
+  console. You can pass along the 'resume' boot option to test suspend/resume.
