Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYHZWOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYHZWOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYHZWO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:14:27 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:24685 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYHZWO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:14:26 -0400
Message-ID: <48B48019.6080803@ct.jp.nec.com>
Date: Tue, 26 Aug 2008 15:13:45 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: John Keller <jpk@sgi.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: [RESEND][PATCH -tip] x86: acpi: move acpi_mcfg_64bit_base_addr into
 CONFIG_PCI_MMCONFIG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

acpi_mcfg_64bit_base_addr is used when CONFIG_PCI_MMCONFIG is enabled.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/acpi/boot.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index fc64412..8a1c9f9 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -96,8 +96,6 @@ static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 #warning ACPI uses CMPXCHG, i486 and later hardware
 #endif
 
-static int acpi_mcfg_64bit_base_addr __initdata = FALSE;
-
 /* --------------------------------------------------------------------------
                               Boot-time Configuration
    -------------------------------------------------------------------------- */
@@ -159,6 +157,8 @@ char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 struct acpi_mcfg_allocation *pci_mmcfg_config;
 int pci_mmcfg_config_num;
 
+static int acpi_mcfg_64bit_base_addr __initdata = FALSE;
+
 static int __init acpi_mcfg_oem_check(struct acpi_table_mcfg *mcfg)
 {
 	if (!strcmp(mcfg->header.oem_id, "SGI"))
-- 
1.5.6

