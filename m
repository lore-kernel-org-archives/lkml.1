Return-Path: <linux-kernel-owner+w=401wt.eu-S965351AbZLQTLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351AbZLQTLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965321AbZLQTLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:11:10 -0500
Received: from ox1.aei.mpg.de ([194.94.224.6]:60491 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965317AbZLQTLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:11:09 -0500
X-Greylist: delayed 1336 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Dec 2009 14:11:09 EST
Date: Thu, 17 Dec 2009 19:48:31 +0100
From: "Carlos R. Mafra" <crmafra@aei.mpg.de>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH] acpi: Do not select ACPI_DOCK from ATA_ACPI
Message-ID: <20091217184831.GA10604@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In March 2008 commit 0ac4a3c2fbbcadc3e96e4dc47d4ae802d66e6f67 ("ACPI: fix
ATA_ACPI build") made CONFIG_ACPI_DOCK be selected by CONFIG_ATA_ACPI because
of a build error when CONFIG_ATA_ACPI=y and CONFIG_ACPI_DOCK=m.

However, in September 2008 commit 898b054f3eec5921320ae8614b5bdd7b07ea5b43
("dock: make dock driver not a module") removed the possibility of having
CONFIG_ACPI_DOCK=m and therefore there is no need for selecting it when
CONFIG_ATA_ACPI=y.

This makes the kernel ~5 Kb smaller for people who don't have a dock by
allowing them to not have ACPI_DOCK compiled-in because of ATA_ACPI=y.

Signed-off-by: Carlos R. Mafra <crmafra@aei.mpg.de>
---

I was puzzled by not being able to unselect DOCK even though my laptop
has no dock...

Compile tested with CONFIG_ATA_ACPI=y and CONFIG_ACPI_DOCK not set.

 drivers/ata/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 85844d0..56c6374 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -40,7 +40,6 @@ config ATA_VERBOSE_ERROR
 config ATA_ACPI
 	bool "ATA ACPI Support"
 	depends on ACPI && PCI
-	select ACPI_DOCK
 	default y
 	help
 	  This option adds support for ATA-related ACPI objects.
-- 
1.6.6.rc0.61.g41d5b

