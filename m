Return-Path: <linux-kernel-owner+w=401wt.eu-S932893AbXC3XGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbXC3XGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 19:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbXC3XGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 19:06:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:42245 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903AbXC3XGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 19:06:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,355,1170662400"; 
   d="scan'208"; a="205856221:sNHT211476349"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2.6.21-rc5 1/3] msi: introduce ARCH_SUPPORTS_MSI Kconfig
	option (rev2)
To: greg@kroah.com
Cc: linux@arm.linux.org.uk, linux-pci@atrey.karlin.mff.cuni.cz,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org
Date: Fri, 30 Mar 2007 16:05:50 -0700
Message-ID: <20070330230549.14060.70172.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070330220243.14060.14389.stgit@dwillia2-linux.ch.intel.com>
References: <20070330220243.14060.14389.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allows architectures to advertise that they support MSI rather than listing
each architecture as a PCI_MSI dependency.

rev2:
* update i386 and x86_64 as well

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

 arch/arm/Kconfig     |    1 +
 arch/i386/Kconfig    |    1 +
 arch/ia64/Kconfig    |    1 +
 arch/sparc64/Kconfig |    1 +
 arch/x86_64/Kconfig  |    1 +
 drivers/pci/Kconfig  |    6 +++++-
 6 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e7baca2..db00376 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -255,6 +255,7 @@ config ARCH_IOP13XX
 	depends on MMU
 	select PLAT_IOP
 	select PCI
+	select ARCH_SUPPORTS_MSI
 	help
 	  Support for Intel's IOP13XX (XScale) family of processors.
 
diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index 53d6237..bcf2fc4 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -1073,6 +1073,7 @@ config PCI
 	bool "PCI support" if !X86_VISWS
 	depends on !X86_VOYAGER
 	default y if X86_VISWS
+	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
 	help
 	  Find out whether you have a PCI motherboard. PCI is the name of a
 	  bus system, i.e. the way the CPU talks to the other stuff inside
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index e19185d..3b71f97 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -14,6 +14,7 @@ config IA64
 	select PCI if (!IA64_HP_SIM)
 	select ACPI if (!IA64_HP_SIM)
 	select PM if (!IA64_HP_SIM)
+	select ARCH_SUPPORTS_MSI
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/sparc64/Kconfig b/arch/sparc64/Kconfig
index 1a6348b..b9b2b52 100644
--- a/arch/sparc64/Kconfig
+++ b/arch/sparc64/Kconfig
@@ -299,6 +299,7 @@ config SUN_IO
 
 config PCI
 	bool "PCI support"
+	select ARCH_SUPPORTS_MSI
 	help
 	  Find out whether you have a PCI motherboard. PCI is the name of a
 	  bus system, i.e. the way the CPU talks to the other stuff inside
diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 56eb14c..e9b4f05 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -676,6 +676,7 @@ menu "Bus options (PCI etc.)"
 
 config PCI
 	bool "PCI support"
+	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
 
 # x86-64 doesn't support PCI BIOS access from long mode so always go direct.
 config PCI_DIRECT
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 5ea5bc7..70efe8f 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -1,10 +1,14 @@
 #
 # PCI configuration
 #
+config ARCH_SUPPORTS_MSI
+	bool
+	default n
+
 config PCI_MSI
 	bool "Message Signaled Interrupts (MSI and MSI-X)"
 	depends on PCI
-	depends on (X86_LOCAL_APIC && X86_IO_APIC) || IA64 || SPARC64
+	depends on ARCH_SUPPORTS_MSI
 	help
 	   This allows device drivers to enable MSI (Message Signaled
 	   Interrupts).  Message Signaled Interrupts enable a device to
