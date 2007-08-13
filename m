Return-Path: <linux-kernel-owner+w=401wt.eu-S945590AbXHMMtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945590AbXHMMtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966883AbXHMHak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:30:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:43665 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966900AbXHMHab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:30:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,253,1183359600"; 
   d="scan'208";a="278034058"
Subject: [PATCH 3/3] x86_64 EFI runtime service support: document for EFI
	runtime services
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>, akpm@linux-foundation.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Aug 2007 15:30:24 +0800
Message-Id: <1186990224.22431.40.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 13 Aug 2007 07:30:02.0342 (UTC) FILETIME=[C2DE6860:01C7DD7B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog between v3 of EFI x86_64 support patch and this version

1. Change 64bit parameter description to 8 bytes in zero-page.txt
2. Add document for EFI related boot options.

---

This patch adds document for EFI x86_64 runtime services support. The
boot parameters added are documented in
Documentation/i386/zero-page.txt. The boot options added are
documented in Documentation/x86_64/boot-options.txt.

---

 i386/zero-page.txt      |   21 ++++++++++++++++-----
 x86_64/boot-options.txt |   10 +++++++++-
 2 files changed, 25 insertions(+), 6 deletions(-)

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

Index: linux-2.6.23-rc2/Documentation/i386/zero-page.txt
===================================================================
--- linux-2.6.23-rc2.orig/Documentation/i386/zero-page.txt	2007-08-13 13:08:39.000000000 +0800
+++ linux-2.6.23-rc2/Documentation/i386/zero-page.txt	2007-08-13 13:08:53.000000000 +0800
@@ -31,11 +31,11 @@
  0xb0 - 0x13f		Free. Add more parameters here if you really need them.
  0x140- 0x1be		EDID_INFO Video mode setup
 
-0x1c4	unsigned long	EFI system table pointer
-0x1c8	unsigned long	EFI memory descriptor size
-0x1cc	unsigned long	EFI memory descriptor version
-0x1d0	unsigned long	EFI memory descriptor map pointer
-0x1d4	unsigned long	EFI memory descriptor map size
+0x1c4	unsigned long	EFI system table pointer*
+0x1c8	unsigned long	EFI memory descriptor size*
+0x1cc	unsigned long	EFI memory descriptor version*
+0x1d0	unsigned long	EFI memory descriptor map pointer*
+0x1d4	unsigned long	EFI memory descriptor map size*
 0x1e0	unsigned long	ALT_MEM_K, alternative mem check, in Kb
 0x1e4	unsigned long	Scratch field for the kernel setup code
 0x1e8	char		number of entries in E820MAP (below)
@@ -87,3 +87,14 @@
 0x2d0 - 0xd00		E820MAP
 0xd00 - 0xeff		EDDBUF (edd.S) for disk signature read sector
 0xd00 - 0xeeb		EDDBUF (edd.S) for edd data
+
+Changes for x86_64 implementation:
+---------------------------------
+For alignment purposes, the following parameters are rearranged.
+
+0x1c0	4 bytes		EFI Loader signature, ="EFIL"
+0x1c4	unsigned long	EFI memory descriptor size
+0x1c8	unsigned long	EFI memory descriptor version
+0x1cc	unsigned long	EFI memory descriptor map size
+0x1d0	8 bytes		EFI memory descriptor map pointer
+0x1d8	8 bytes		EFI system table pointer
Index: linux-2.6.23-rc2/Documentation/x86_64/boot-options.txt
===================================================================
--- linux-2.6.23-rc2.orig/Documentation/x86_64/boot-options.txt	2007-08-13 13:08:39.000000000 +0800
+++ linux-2.6.23-rc2/Documentation/x86_64/boot-options.txt	2007-08-13 13:08:53.000000000 +0800
@@ -110,12 +110,13 @@
 
 Rebooting
 
-   reboot=b[ios] | t[riple] | k[bd] [, [w]arm | [c]old]
+   reboot=b[ios] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old]
    bios	  Use the CPU reboot vector for warm reset
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
    kbd    Use the keyboard controller. cold reset (default)
+   efi	  Use efi reset_system runtime service. cold reset (default)
 
    Using warm reset will be much faster especially on big memory
    systems because the BIOS will not go through the memory check.
@@ -300,4 +301,11 @@
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
