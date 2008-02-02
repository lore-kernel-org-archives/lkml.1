Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbYBBF0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbYBBF0K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 00:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760536AbYBBFZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 00:25:59 -0500
Received: from lixom.net ([66.141.50.11]:42139 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759550AbYBBFZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 00:25:58 -0500
Date: Fri, 1 Feb 2008 23:26:28 -0600
From: Olof Johansson <olof@lixom.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Cc: git-commits-head@vger.kernel.org, gregkh@suse.de
Subject: [PATCH] Fix fallout from PCI: PCIE ASPM support
Message-ID: <20080202052628.GB14936@lixom.net>
References: <200802020506.m1256gXG027547@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802020506.m1256gXG027547@hera.kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 05:06:42AM +0000, Linux Kernel Mailing List wrote:

>     PCI: PCIE ASPM support

This one broke almost all defconfigs on powerpc, since they enable
CONFIG_EXPERIMENTAL and CONFIG_PCI, and this option defaults to y.

Make it default to 'n' like most other options, and make it depend on
ACPI. Take out the unneccessary default 'n' from the debug option as well.


Signed-off-by: Olof Johansson <olof@lixom.net>


diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
index 60104cf..4393bb3 100644
--- a/drivers/pci/pcie/Kconfig
+++ b/drivers/pci/pcie/Kconfig
@@ -32,8 +32,7 @@ source "drivers/pci/pcie/aer/Kconfig"
 #
 config PCIEASPM
 	bool "PCI Express ASPM support(Experimental)"
-	depends on PCI && EXPERIMENTAL
-	default y
+	depends on PCI && ACPI && EXPERIMENTAL
 	help
 	  This enables PCI Express ASPM (Active State Power Management) and
 	  Clock Power Management. ASPM supports state L0/L0s/L1.
@@ -42,7 +41,6 @@ config PCIEASPM
 config PCIEASPM_DEBUG
 	bool "Debug PCI Express ASPM"
 	depends on PCIEASPM
-	default n
 	help
 	  This enables PCI Express ASPM debug support. It will add per-device
 	  interface to control ASPM.
