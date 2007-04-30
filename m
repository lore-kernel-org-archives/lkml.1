Return-Path: <linux-kernel-owner+w=401wt.eu-S1031096AbXD3Lgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031096AbXD3Lgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031104AbXD3Lgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:36:53 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41760 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031096AbXD3Lgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:36:52 -0400
Date: Mon, 30 Apr 2007 13:32:54 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Roland Dreier <rolandd@cisco.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sean Hefty <mshefty@ichips.intel.com>,
       Hal Rosenstock <halr@voltaire.com>, openib-general@openib.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/36] Use menuconfig objects II - Infiniband
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301332060.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/infiniband/Kconfig             |   14 ++++++--------
 drivers/infiniband/hw/amso1100/Kconfig |    2 +-
 drivers/infiniband/hw/cxgb3/Kconfig    |    2 +-
 drivers/infiniband/hw/ehca/Kconfig     |    2 +-
 drivers/infiniband/hw/ipath/Kconfig    |    2 +-
 drivers/infiniband/hw/mlx4/Kconfig     |    1 -
 drivers/infiniband/hw/mthca/Kconfig    |    2 +-
 drivers/infiniband/ulp/ipoib/Kconfig   |    2 +-
 drivers/infiniband/ulp/iser/Kconfig    |    2 +-
 drivers/infiniband/ulp/srp/Kconfig     |    2 +-
 10 files changed, 14 insertions(+), 17 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/infiniband/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/infiniband/Kconfig
@@ -1,16 +1,15 @@
-menu "InfiniBand support"
-
-config INFINIBAND
-	depends on PCI || BROKEN
+menuconfig INFINIBAND
 	tristate "InfiniBand support"
+	depends on PCI || BROKEN
 	---help---
 	  Core support for InfiniBand (IB).  Make sure to also select
 	  any protocols you wish to use as well as drivers for your
 	  InfiniBand hardware.
 
+if INFINIBAND
+
 config INFINIBAND_USER_MAD
 	tristate "InfiniBand userspace MAD support"
-	depends on INFINIBAND
 	---help---
 	  Userspace InfiniBand Management Datagram (MAD) support.  This
 	  is the kernel side of the userspace MAD support, which allows
@@ -19,7 +18,6 @@ config INFINIBAND_USER_MAD
 
 config INFINIBAND_USER_ACCESS
 	tristate "InfiniBand userspace access (verbs and CM)"
-	depends on INFINIBAND
 	---help---
 	  Userspace InfiniBand access support.  This enables the
 	  kernel side of userspace verbs and the userspace
@@ -36,7 +34,7 @@ config INFINIBAND_USER_MEM
 
 config INFINIBAND_ADDR_TRANS
 	bool
-	depends on INFINIBAND && INET
+	depends on INET
 	default y
 
 source "drivers/infiniband/hw/mthca/Kconfig"
@@ -53,4 +51,4 @@ source "drivers/infiniband/ulp/srp/Kconf
 
 source "drivers/infiniband/ulp/iser/Kconfig"
 
-endmenu
+endif # INFINIBAND
--- linux-2.6.21-mm_20070428.orig/drivers/infiniband/hw/amso1100/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/infiniband/hw/amso1100/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_AMSO1100
 	tristate "Ammasso 1100 HCA support"
-	depends on PCI && INET && INFINIBAND
+	depends on PCI && INET
 	---help---
 	  This is a low-level driver for the Ammasso 1100 host
 	  channel adapter (HCA).
--- linux-2.6.21-mm_20070428.orig/drivers/infiniband/hw/cxgb3/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/infiniband/hw/cxgb3/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_CXGB3
 	tristate "Chelsio RDMA Driver"
-	depends on CHELSIO_T3 && INFINIBAND && INET
+	depends on CHELSIO_T3 && INET
 	select GENERIC_ALLOCATOR
 	---help---
 	  This is an iWARP/RDMA driver for the Chelsio T3 1GbE and
--- linux-2.6.21-mm_20070428.orig/drivers/infiniband/hw/ehca/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/infiniband/hw/ehca/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_EHCA
 	tristate "eHCA support"
-	depends on IBMEBUS && INFINIBAND
+	depends on IBMEBUS
 	---help---
 	This driver supports the IBM pSeries eHCA InfiniBand adapter.
 
--- linux-2.6.21-mm_20070428.orig/drivers/infiniband/hw/ipath/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/infiniband/hw/ipath/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_IPATH
 	tristate "QLogic InfiniPath Driver"
-	depends on (PCI_MSI || HT_IRQ) && 64BIT && INFINIBAND && NET
+	depends on (PCI_MSI || HT_IRQ) && 64BIT && NET
 	---help---
 	This is a driver for QLogic InfiniPath host channel adapters,
 	including InfiniBand verbs support.  This driver allows these
--- linux-2.6.21-mm_20070428.orig/drivers/infiniband/hw/mlx4/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/infiniband/hw/mlx4/Kconfig
@@ -1,6 +1,5 @@
 config MLX4_INFINIBAND
 	tristate "Mellanox ConnectX HCA support"
-	depends on INFINIBAND
 	select MLX4_CORE
 	---help---
 	  This driver provides low-level InfiniBand support for
--- linux-2.6.21-mm_20070428.orig/drivers/infiniband/hw/mthca/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/infiniband/hw/mthca/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_MTHCA
 	tristate "Mellanox HCA support"
-	depends on PCI && INFINIBAND
+	depends on PCI
 	---help---
 	  This is a low-level driver for Mellanox InfiniHost host
 	  channel adapters (HCAs), including the MT23108 PCI-X HCA
--- linux-2.6.21-mm_20070428.orig/drivers/infiniband/ulp/ipoib/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/infiniband/ulp/ipoib/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_IPOIB
 	tristate "IP-over-InfiniBand"
-	depends on INFINIBAND && NETDEVICES && INET && (IPV6 || IPV6=n)
+	depends on NETDEVICES && INET && (IPV6 || IPV6=n)
 	---help---
 	  Support for the IP-over-InfiniBand protocol (IPoIB). This
 	  transports IP packets over InfiniBand so you can use your IB
--- linux-2.6.21-mm_20070428.orig/drivers/infiniband/ulp/iser/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/infiniband/ulp/iser/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_ISER
 	tristate "iSCSI Extensions for RDMA (iSER)"
-	depends on INFINIBAND && SCSI && INET
+	depends on SCSI && INET
 	select SCSI_ISCSI_ATTRS
 	---help---
 	  Support for the iSCSI Extensions for RDMA (iSER) Protocol
--- linux-2.6.21-mm_20070428.orig/drivers/infiniband/ulp/srp/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/infiniband/ulp/srp/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_SRP
 	tristate "InfiniBand SCSI RDMA Protocol"
-	depends on INFINIBAND && SCSI
+	depends on SCSI
 	---help---
 	  Support for the SCSI RDMA Protocol over InfiniBand.  This
 	  allows you to access storage devices that speak SRP over
