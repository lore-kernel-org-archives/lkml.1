Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292Ab0ARIkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab0ARIkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092Ab0ARIky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:40:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38976 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab0ARIkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:40:53 -0500
Date: Mon, 18 Jan 2010 19:40:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Shaohua Li <shaohua.li@intel.com>
Subject: linux-next: pci tree build failure
Message-Id: <20100118194050.7ea0c406.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

Today's linux-next build (ppc64 allyesconfig) failed like this:

In file included from drivers/pci/pcie/pme/pcie_pme.c:22:
include/linux/pci-acpi.h:42: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'acpi_find_root_bridge_handle'

This file was added in commit f3adb5a4f2e1dfdf9482af05481d0928a39477e8
("PCI PM: PCIe PME root port service driver") from the pci tree and seems
to depend on ACPI.  Maybe its building should depend on CONFIG_ACPI?

I added the following patch for today (I presume there is a better fix):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 18 Jan 2010 19:36:11 +1100
Subject: [PATCH] pci: PCIE_PME seems to depend on ACPI

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/pci/pcie/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
index cf3c35f..b8b494b 100644
--- a/drivers/pci/pcie/Kconfig
+++ b/drivers/pci/pcie/Kconfig
@@ -49,4 +49,4 @@ config PCIEASPM_DEBUG
 
 config PCIE_PME
 	def_bool y
-	depends on PCIEPORTBUS && PM_RUNTIME && EXPERIMENTAL
+	depends on PCIEPORTBUS && PM_RUNTIME && EXPERIMENTAL && ACPI
-- 
1.6.6

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
