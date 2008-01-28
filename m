Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbYA1WVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbYA1WVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761773AbYA1WOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:14:18 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52463 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760839AbYA1WOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:14:17 -0500
Date: Tue, 29 Jan 2008 00:14:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: merge the PCI_MMCONFIG options
Message-ID: <20080128221443.GK8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges the 32bit and 64bit PCI_MMCONFIG options.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/Kconfig |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

d9ab553b1bb27c0824dd40516f0ba4ba48a63519 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0e6e74d..7a9261f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1429,19 +1429,16 @@ config PCI_DIRECT
 	default y
 
 config PCI_MMCONFIG
-	bool
-	depends on X86_32 && PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
-	default y
+	bool "Support mmconfig PCI config space access" if X86_64
+	depends on PCI && ACPI
+	depends on X86_64 || (X86_32 && (PCI_GOMMCONFIG || PCI_GOANY))
+	default y if X86_32
 
 config PCI_DOMAINS
 	bool
 	depends on PCI
 	default y
 
-config PCI_MMCONFIG
-	bool "Support mmconfig PCI config space access"
-	depends on X86_64 && PCI && ACPI
-
 config DMAR
 	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
 	depends on X86_64 && PCI_MSI && ACPI && EXPERIMENTAL

