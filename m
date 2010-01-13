Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121Ab0AMBA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0AMBA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396Ab0AMBA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:00:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab0AMBAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:00:55 -0500
Message-Id: <20100113004939.103771236@suse.com>
User-Agent: quilt/0.48-4.4
Date: Tue, 12 Jan 2010 19:48:59 -0500
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Chiang <achiang@hp.com>
Subject: [patch 4/6] acpi: Fix section mismatch
References: <20100113004855.550486769@suse.com>
Content-Disposition: inline; filename=patches.rpmify/acpi-fix-section-mismatch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 acpi_early_processor_set_pdc uses processor_idle_dmi_table, which is
 marked __cpuinitdata. It's only called by acpi_bus_init, which is __init.
 We mark it __cpuinit.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/acpi/processor_pdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/processor_pdc.c
+++ b/drivers/acpi/processor_pdc.c
@@ -151,7 +151,7 @@ early_init_pdc(acpi_handle handle, u32 l
 	return AE_OK;
 }
 
-void acpi_early_processor_set_pdc(void)
+void __cpuinit acpi_early_processor_set_pdc(void)
 {
 	/*
 	 * Check whether the system is DMI table. If yes, OSPM


