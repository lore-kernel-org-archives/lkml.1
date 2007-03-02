Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbXCBLIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbXCBLIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 06:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933336AbXCBLIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 06:08:01 -0500
Received: from wx-out-0506.google.com ([66.249.82.230]:13119 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933333AbXCBLH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 06:07:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=O9AjcS78fKWuod/tADteAAMUHkfHBhLeTIPWG5VVyGXO+/O55iqSzz9oqgtS/rWvIlD35rXydwgLEHXtJBZWvQkIlXK8i1HCljPdzhMdTZs5hPM9asjt89k7Heh3pUihpW8YztizVLSRb4craHQrVYCunIJXq/hTWYOnjdkwkk0=
Message-ID: <43c301fe0703020307g37f7df7dxd8f94adaac3acaf3@mail.gmail.com>
Date: Fri, 2 Mar 2007 20:07:58 +0900
From: "Takayoshi Kochi" <takayoshi.kochi@gmail.com>
To: linux-acpi@vger.kernel.org
Subject: [PATCH] supporting MMCONFIG over 4GB on x86_64
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently MMCONFIG is ignored if it is located over 4G, but I see no reason
to reject it on x86_64 platform.

This patch is against 2.6.21-rc2 and was tested on
such a machine (MMCONFIG is located at 0xfe10000000)
without any problem.

Any comments?

-- 
Takayoshi Kochi

Signed-off-by: Takayoshi Kochi <takayoshi.kochi@gmail.com>
---
 boot.c |    2 ++
 1 files changed, 2 insertions(+)

--- linux-2.6.20/arch/i386/kernel/acpi/boot.c.orig	2007-03-02
14:34:02.000000000 +0900
+++ linux-2.6.20/arch/i386/kernel/acpi/boot.c	2007-03-02
19:38:10.000000000 +0900
@@ -198,6 +198,7 @@ int __init acpi_parse_mcfg(struct acpi_t

 	memcpy(pci_mmcfg_config, &mcfg[1], config_size);
 	for (i = 0; i < pci_mmcfg_config_num; ++i) {
+#ifndef CONFIG_X86_64
 		if (pci_mmcfg_config[i].address > 0xFFFFFFFF) {
 			printk(KERN_ERR PREFIX
 			       "MMCONFIG not in low 4GB of memory\n");
@@ -205,6 +206,7 @@ int __init acpi_parse_mcfg(struct acpi_t
 			pci_mmcfg_config_num = 0;
 			return -ENODEV;
 		}
+#endif
 	}

 	return 0;
