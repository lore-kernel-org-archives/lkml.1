Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZBQUy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZBQUy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZBQUyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:54:16 -0500
Received: from gw.goop.org ([64.81.55.164]:41469 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbZBQUyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:54:15 -0500
Message-ID: <499B23F2.1080802@goop.org>
Date: Tue, 17 Feb 2009 12:54:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Brown, Len" <len.brown@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] acpi: add some missing section markers
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_acpi_os_unmap_memory() is an __init function, and
acpi_os_unmap_memory() is allowed to access an __init function
until acpi_gbl_permanent_mmap is set up.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index d1dd516..dd6f249 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -272,7 +272,7 @@ acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
 }
 EXPORT_SYMBOL_GPL(acpi_os_map_memory);
 
-void acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
+void __ref acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
 {
 	if (acpi_gbl_permanent_mmap)
 		iounmap(virt);
@@ -281,7 +281,7 @@ void acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
 }
 EXPORT_SYMBOL_GPL(acpi_os_unmap_memory);
 
-void early_acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
+void __init early_acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
 {
 	if (!acpi_gbl_permanent_mmap)
 		__acpi_unmap_table(virt, size);


