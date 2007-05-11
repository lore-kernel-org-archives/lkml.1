Return-Path: <linux-kernel-owner+w=401wt.eu-S1760555AbXEKM6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555AbXEKM6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 08:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbXEKM6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 08:58:19 -0400
Received: from mta15.adelphia.net ([68.168.78.77]:45896 "EHLO
	mta15.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbXEKM6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 08:58:18 -0400
Date: Fri, 11 May 2007 07:58:17 -0500
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: Christian Krafft <krafft@de.ibm.com>
Subject: [PATCH] IPMI: Add PPC openfirmware unregister
Message-ID: <20070511125817.GB6422@localdomain>
Reply-To: minyard@acm.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Krafft <krafft@de.ibm.com>
When trying to load the ipmi_si module on a powerpc with
no BMC (baseboard management controller) the driver failes to
load correctly, but doesn't unregister itself from of_platform.
So, on a second modprobe the kernel crashes.
This patch adds the missing unregister call.

Signed-off-by: Christian Krafft <krafft@de.ibm.com>
Signed-off-by: Corey Minyard <minyard@acm.org>

Index: linux-2.6.21/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.21.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6.21/drivers/char/ipmi/ipmi_si_intf.c
@@ -2924,6 +2924,10 @@ static __devinit int init_ipmi_si(void)
 #ifdef CONFIG_PCI
 		pci_unregister_driver(&ipmi_pci_driver);
 #endif
+
+#ifdef CONFIG_PPC_OF
+		of_unregister_platform_driver(&ipmi_of_platform_driver);
+#endif
 		driver_unregister(&ipmi_driver);
 		printk("ipmi_si: Unable to find any System Interface(s)\n");
 		return -ENODEV;


