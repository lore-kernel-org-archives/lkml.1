Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYCREMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYCREMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 00:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYCREM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 00:12:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:34821 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbYCREM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 00:12:27 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] Re: In function `ata_acpi_associate': undefined reference =?utf-8?q?to=09=60register=5Fhotplug=5Fdock=5Fdevice=27?=
Date: Tue, 18 Mar 2008 00:11:48 -0400
User-Agent: KMail/1.9.9
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-acpi@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       htejun@gmail.com, jeff@garzik.org
References: <47DEC970.2050402@m3y3r.de> <47DECD54.5060202@m3y3r.de> <200803172357.54253.lenb@kernel.org>
In-Reply-To: <200803172357.54253.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803180011.49190.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: fix ATA_ACPI build
From: Len Brown <len.brown@intel.com>

drivers/ata/libata-acpi.c fails to build

drivers/built-in.o: In function `ata_acpi_associate':
(.text+0x7106a): undefined reference to `register_hotplug_dock_device'

When CONFIG_ATA_ACPI=y and CONFIG_ACPI_DOCK=m
But if dock is selected from ata_acpi, dock will =y
when ata_acpi=y, avoiding this problem.

Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index e469647..25aba69 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -30,6 +30,7 @@ config ATA_NONSTANDARD
 config ATA_ACPI
 	bool
 	depends on ACPI && PCI
+	select ACPI_DOCK
 	default y
 	help
 	  This option adds support for ATA-related ACPI objects.
