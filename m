Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089Ab0A0GtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0A0GtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 01:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750703Ab0A0GtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 01:49:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53680 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab0A0GtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 01:49:03 -0500
Date: Wed, 27 Jan 2010 17:49:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: pci tree build failure
Message-Id: <20100127174900.e2f8fcf9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

Today's linux-next build (powerpc allyesconfig) failed like this:

In file included from drivers/pci/pcie/pme/pcie_pme.c:22:
include/linux/pci-acpi.h:42: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'acpi_find_root_bridge_handle'

You seem to have lost the patch below which I have reapplied for today.

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
