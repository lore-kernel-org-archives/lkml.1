Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbZCKTm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbZCKTm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZCKTmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:42:47 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:33975 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZCKTmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:42:46 -0400
Message-ID: <49B81430.70606@linux.vnet.ibm.com>
Date: Wed, 11 Mar 2009 16:42:40 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 1/2] icom: Converting space to tabs
References: <49B7D63E.9050006@linux.vnet.ibm.com> <49B7D830.10601@gmail.com>
In-Reply-To: <49B7D830.10601@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting spaces to tabs and removing wrong spaces

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 drivers/serial/icom.c |   54 +++++++++++++++++++++++-------------------------
 1 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index 2b7531d..60d87db 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -302,7 +302,7 @@ static void stop_processor(struct icom_port *icom_port)
 	if (port < 4) {
 		temp = readl(stop_proc[port].global_control_reg);
 		temp =
-	    		(temp & ~start_proc[port].processor_id) | stop_proc[port].processor_id;
+			(temp & ~start_proc[port].processor_id) | stop_proc[port].processor_id;
 		writel(temp, stop_proc[port].global_control_reg);
 
 		/* write flush */
@@ -331,7 +331,7 @@ static void start_processor(struct icom_port *icom_port)
 	if (port < 4) {
 		temp = readl(start_proc[port].global_control_reg);
 		temp =
-	    		(temp & ~stop_proc[port].processor_id) | start_proc[port].processor_id;
+			(temp & ~stop_proc[port].processor_id) | start_proc[port].processor_id;
 		writel(temp, start_proc[port].global_control_reg);
 
 		/* write flush */
@@ -504,8 +504,8 @@ static void load_code(struct icom_port *icom_port)
 		dev_err(&icom_port->adapter->pci_dev->dev,"Port not opertional\n");
 	}
 
-      if (new_page != NULL)
-	      pci_free_consistent(dev, 4096, new_page, temp_pci);
+	if (new_page != NULL)
+		pci_free_consistent(dev, 4096, new_page, temp_pci);
 }
 
 static int startup(struct icom_port *icom_port)
@@ -1498,15 +1498,15 @@ static int __devinit icom_probe(struct pci_dev *dev,
 				const struct pci_device_id *ent)
 {
 	int index;
-        unsigned int command_reg;
-        int retval;
-        struct icom_adapter *icom_adapter;
-        struct icom_port *icom_port;
+	unsigned int command_reg;
+	int retval;
+	struct icom_adapter *icom_adapter;
+	struct icom_port *icom_port;
 
-        retval = pci_enable_device(dev);
-        if (retval) {
+	retval = pci_enable_device(dev);
+	if (retval) {
 		dev_err(&dev->dev, "Device enable FAILED\n");
-                return retval;
+		return retval;
 	}
 
 	if ( (retval = pci_request_regions(dev, "icom"))) {
@@ -1515,23 +1515,23 @@ static int __devinit icom_probe(struct pci_dev *dev,
 		 return retval;
 	 }
 
-        pci_set_master(dev);
+	pci_set_master(dev);
 
-        if ( (retval = pci_read_config_dword(dev, PCI_COMMAND, &command_reg))) {
+	if ( (retval = pci_read_config_dword(dev, PCI_COMMAND, &command_reg))) {
 		dev_err(&dev->dev, "PCI Config read FAILED\n");
-                return retval;
-        }
+		return retval;
+	}
 
 	pci_write_config_dword(dev, PCI_COMMAND,
 		command_reg | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER
  		| PCI_COMMAND_PARITY | PCI_COMMAND_SERR);
 
-        if (ent->driver_data == ADAPTER_V1) {
+	if (ent->driver_data == ADAPTER_V1) {
 		pci_write_config_dword(dev, 0x44, 0x8300830A);
-	 } else {
+	} else {
 		pci_write_config_dword(dev, 0x44, 0x42004200);
 		pci_write_config_dword(dev, 0x48, 0x42004200);
-         }
+	}
 
 
 	retval = icom_alloc_adapter(&icom_adapter);
@@ -1541,10 +1541,10 @@ static int __devinit icom_probe(struct pci_dev *dev,
 		 goto probe_exit0;
 	}
 
-	 icom_adapter->base_addr_pci = pci_resource_start(dev, 0);
-	 icom_adapter->pci_dev = dev;
-	 icom_adapter->version = ent->driver_data;
-	 icom_adapter->subsystem_id = ent->subdevice;
+	icom_adapter->base_addr_pci = pci_resource_start(dev, 0);
+	icom_adapter->pci_dev = dev;
+	icom_adapter->version = ent->driver_data;
+	icom_adapter->subsystem_id = ent->subdevice;
 
 
 	retval = icom_init_ports(icom_adapter);
@@ -1553,7 +1553,7 @@ static int __devinit icom_probe(struct pci_dev *dev,
 		goto probe_exit1;
 	}
 
-	 icom_adapter->base_addr = ioremap(icom_adapter->base_addr_pci,
+	icom_adapter->base_addr = ioremap(icom_adapter->base_addr_pci,
 						pci_resource_len(dev, 0));
 
 	if (!icom_adapter->base_addr)
@@ -1568,7 +1568,7 @@ static int __devinit icom_probe(struct pci_dev *dev,
 
 	retval = icom_load_ports(icom_adapter);
 
-        for (index = 0; index < icom_adapter->numb_ports; index++) {
+	for (index = 0; index < icom_adapter->numb_ports; index++) {
 		icom_port = &icom_adapter->port_info[index];
 
 		if (icom_port->status == ICOM_PORT_ACTIVE) {
@@ -1585,7 +1585,7 @@ static int __devinit icom_probe(struct pci_dev *dev,
 				icom_port->status = ICOM_PORT_OFF;
 				dev_err(&dev->dev, "Device add failed\n");
 			 } else
-			        dev_info(&dev->dev, "Device added\n");
+				dev_info(&dev->dev, "Device added\n");
 		}
 	}
 
@@ -1601,9 +1601,7 @@ probe_exit0:
 	pci_release_regions(dev);
 	pci_disable_device(dev);
 
-        return retval;
-
-
+	return retval;
 }
 
 static void __devexit icom_remove(struct pci_dev *dev)
-- 
1.6.0.2

