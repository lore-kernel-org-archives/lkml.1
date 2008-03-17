Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbYCQUbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbYCQUbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYCQUa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:30:58 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:54392 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbYCQUa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:30:57 -0400
Date: Mon, 17 Mar 2008 22:30:38 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Meyer <thomas@m3y3r.de>, lenb@kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, htejun@gmail.com,
       jeff@garzik.org, linux-acpi@vger.kernel.org
Subject: [2.6.25 patch] acpi_drivers.h: fix dock dummy functions
Message-ID: <20080317203038.GE9550@cs181133002.pp.htv.fi>
References: <47DEC970.2050402@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47DEC970.2050402@m3y3r.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Built-in code can't use functions in a modular ACPI dock driver.

This patch fixes the following build error reported by Thomas Meyer:

<--  snip  -->

...
 LD      .tmp_vmlinux1
drivers/built-in.o: In function `ata_acpi_associate':
(.text+0x7106a): undefined reference to `register_hotplug_dock_device'
drivers/built-in.o: In function `ata_acpi_associate':
(.text+0x710bd): undefined reference to `register_hotplug_dock_device'
make: *** [.tmp_vmlinux1] Fehler 1

<--  snip  -->

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

---
74baa78e04fe0f1aa04d3f09ab63a15da4d92fbd diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index 9757a04..f70b246 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -113,7 +113,7 @@ int acpi_processor_set_thermal_limit(acpi_handle handle, int type);
 /*--------------------------------------------------------------------------
                                   Dock Station
   -------------------------------------------------------------------------- */
-#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
+#if defined(CONFIG_ACPI_DOCK) || (defined(CONFIG_ACPI_DOCK_MODULE) && defined (MODULE))
 extern int is_dock_device(acpi_handle handle);
 extern int register_dock_notifier(struct notifier_block *nb);
 extern void unregister_dock_notifier(struct notifier_block *nb);

