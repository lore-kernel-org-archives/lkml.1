Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbXEKM43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbXEKM43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 08:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760002AbXEKM4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 08:56:20 -0400
Received: from mta11.adelphia.net ([68.168.78.205]:54873 "EHLO
	mta11.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759487AbXEKM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 08:56:18 -0400
Date: Fri, 11 May 2007 07:56:16 -0500
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: Patrick Schoeller <Patrick.Schoeller@hp.com>
Subject: [PATCH] IPMI: fix SI address space settings
Message-ID: <20070511125616.GA6422@localdomain>
Reply-To: minyard@acm.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <minyard@acm.org>
Fix a rather obvious error that Patrick found in the setup routines.
Need to set the proper address space in the ACPI case.

Signed-off-by: Corey Minyard <minyard@acm.org>
Cc: Patrick Schoeller <Patrick.Schoeller@hp.com>

Index: linux-2.6.21/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.21.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.21/drivers/char/ipmi/ipmi_si_intf.c
@@ -1915,10 +1915,10 @@ static __devinit int try_init_acpi(struc
 
 	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) {
 		info->io_setup = mem_setup;
-		info->io.addr_type = IPMI_IO_ADDR_SPACE;
+		info->io.addr_type = IPMI_MEM_ADDR_SPACE;
 	} else if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_IO) {
 		info->io_setup = port_setup;
-		info->io.addr_type = IPMI_MEM_ADDR_SPACE;
+		info->io.addr_type = IPMI_IO_ADDR_SPACE;
 	} else {
 		kfree(info);
 		printk("ipmi_si: Unknown ACPI I/O Address type\n");
