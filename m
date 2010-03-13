Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277Ab0CMBck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:32:40 -0500
Received: from kroah.org ([198.145.64.141]:60616 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934855Ab0CMATs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:48 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:07 2010
Message-Id: <20100313001507.187937564@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: [patch 023/123] Staging: hv: add a pci device table
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 9a775dbd4e8c87b7d35549183145321c7205404e upstream.

This allows the HV core to be properly found and autoloaded
by the system tools.

It uses the Microsoft virtual VGA device to trigger this.

Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/vmbus_drv.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -24,6 +24,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/sysctl.h>
+#include <linux/pci.h>
 #include "osd.h"
 #include "logging.h"
 #include "vmbus.h"
@@ -973,6 +974,22 @@ static void __exit vmbus_exit(void)
 	return;
 }
 
+/*
+ * We use a PCI table to determine if we should autoload this driver  This is
+ * needed by distro tools to determine if the hyperv drivers should be
+ * installed and/or configured.  We don't do anything else with the table, but
+ * it needs to be present.
+ *
+ * We might consider triggering off of DMI table info as well, as that does
+ * decribe the virtual machine being run on, but not all configuration tools
+ * seem to be able to handle DMI device ids properly.
+ */
+const static struct pci_device_id microsoft_hv_pci_table[] = {
+	{ PCI_DEVICE(0x1414, 0x5353) },	/* VGA compatible controller */
+	{ 0 }
+};
+MODULE_DEVICE_TABLE(pci, microsoft_hv_pci_table);
+
 MODULE_LICENSE("GPL");
 module_param(vmbus_irq, int, S_IRUGO);
 module_param(vmbus_loglevel, int, S_IRUGO);


