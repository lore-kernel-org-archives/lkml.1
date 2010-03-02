Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0CBSad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:30:33 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:38746 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754327Ab0CBS3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:29:44 -0500
Date: Tue, 2 Mar 2010 21:29:43 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] ahci: Export generic AHCI symbols
Message-ID: <20100302182943.GK3445@oksana.dev.rtsoft.ru>
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for non-PCI drivers that will be added soon.

Since the symbols are exported now, ahci and ahci_pci can be built
as a separate modules.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/ata/Makefile |    4 ++--
 drivers/ata/ahci.c   |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 0ab4c52..a220e90 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -1,8 +1,8 @@
 
 obj-$(CONFIG_ATA)		+= libata.o
 
-ahci-pci-objs			+= ahci.o ahci_pci.o
-obj-$(CONFIG_SATA_AHCI_PCI)	+= ahci-pci.o
+obj-$(CONFIG_SATA_AHCI)		+= ahci.o
+obj-$(CONFIG_SATA_AHCI_PCI)	+= ahci_pci.o
 obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
 obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
 obj-$(CONFIG_SATA_PROMISE)	+= sata_promise.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index ce08bc6..23e3060 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -47,6 +47,7 @@
 
 static int ahci_skip_host_reset;
 int ahci_ignore_sss;
+EXPORT_SYMBOL_GPL(ahci_ignore_sss);
 
 module_param_named(skip_host_reset, ahci_skip_host_reset, int, 0444);
 MODULE_PARM_DESC(skip_host_reset, "skip global host reset (0=don't skip, 1=skip)");
@@ -134,6 +135,7 @@ struct scsi_host_template ahci_sht = {
 	.shost_attrs		= ahci_shost_attrs,
 	.sdev_attrs		= ahci_sdev_attrs,
 };
+EXPORT_SYMBOL_GPL(ahci_sht);
 
 struct ata_port_operations ahci_ops = {
 	.inherits		= &sata_pmp_port_ops,
@@ -171,8 +173,10 @@ struct ata_port_operations ahci_ops = {
 	.port_start		= ahci_port_start,
 	.port_stop		= ahci_port_stop,
 };
+EXPORT_SYMBOL_GPL(ahci_ops);
 
 int ahci_em_messages = 1;
+EXPORT_SYMBOL_GPL(ahci_em_messages);
 module_param(ahci_em_messages, int, 0444);
 /* add other LED protocol types when they become supported */
 MODULE_PARM_DESC(ahci_em_messages,
@@ -366,6 +370,7 @@ void ahci_save_initial_config(struct device *dev,
 	hpriv->cap2 = cap2;
 	hpriv->port_map = port_map;
 }
+EXPORT_SYMBOL_GPL(ahci_save_initial_config);
 
 /**
  *	ahci_restore_initial_config - Restore initial config
@@ -440,6 +445,7 @@ void ahci_start_engine(struct ata_port *ap)
 	writel(tmp, port_mmio + PORT_CMD);
 	readl(port_mmio + PORT_CMD); /* flush */
 }
+EXPORT_SYMBOL_GPL(ahci_start_engine);
 
 int ahci_stop_engine(struct ata_port *ap)
 {
@@ -464,6 +470,7 @@ int ahci_stop_engine(struct ata_port *ap)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ahci_stop_engine);
 
 static void ahci_start_fis_rx(struct ata_port *ap)
 {
@@ -781,6 +788,7 @@ int ahci_reset_controller(struct ata_host *host)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ahci_reset_controller);
 
 static void ahci_sw_activity(struct ata_link *link)
 {
@@ -868,6 +876,7 @@ int ahci_reset_em(struct ata_host *host)
 	writel(em_ctl | EM_CTL_RST, mmio + HOST_EM_CTL);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ahci_reset_em);
 
 static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 					ssize_t size)
@@ -1061,6 +1070,7 @@ void ahci_init_controller(struct ata_host *host)
 	tmp = readl(mmio + HOST_CTL);
 	VPRINTK("HOST_CTL 0x%x\n", tmp);
 }
+EXPORT_SYMBOL_GPL(ahci_init_controller);
 
 static void ahci_dev_config(struct ata_device *dev)
 {
@@ -1144,6 +1154,7 @@ int ahci_kick_engine(struct ata_port *ap)
 	ahci_start_engine(ap);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ahci_kick_engine);
 
 static int ahci_exec_polled_cmd(struct ata_port *ap, int pmp,
 				struct ata_taskfile *tf, int is_cmd, u16 flags,
@@ -1250,6 +1261,7 @@ int ahci_check_ready(struct ata_link *link)
 
 	return ata_check_ready(status);
 }
+EXPORT_SYMBOL_GPL(ahci_check_ready);
 
 static int ahci_softreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline)
@@ -1260,6 +1272,7 @@ static int ahci_softreset(struct ata_link *link, unsigned int *class,
 
 	return ahci_do_softreset(link, class, pmp, deadline, ahci_check_ready);
 }
+EXPORT_SYMBOL_GPL(ahci_do_softreset);
 
 static int ahci_hardreset(struct ata_link *link, unsigned int *class,
 			  unsigned long deadline)
@@ -1597,6 +1610,7 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 
 	return IRQ_RETVAL(handled);
 }
+EXPORT_SYMBOL_GPL(ahci_interrupt);
 
 static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
 {
@@ -1865,6 +1879,7 @@ void ahci_print_info(struct ata_host *host, const char *scc_s)
 		cap2 & HOST_CAP2_BOH ? "boh " : ""
 		);
 }
+EXPORT_SYMBOL_GPL(ahci_print_info);
 
 void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 			  struct ata_port_info *pi)
@@ -1888,3 +1903,8 @@ void ahci_set_em_messages(struct ahci_host_priv *hpriv,
 			pi->flags |= ATA_FLAG_SW_ACTIVITY;
 	}
 }
+EXPORT_SYMBOL_GPL(ahci_set_em_messages);
+
+MODULE_AUTHOR("Jeff Garzik");
+MODULE_DESCRIPTION("AHCI SATA low-level routines");
+MODULE_LICENSE("GPL");
-- 
1.7.0

