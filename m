Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbYIYEH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbYIYEH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 00:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbYIYEHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 00:07:49 -0400
Received: from mx30.brocade.com ([144.49.194.4]:30051 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbYIYEHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 00:07:48 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2008 00:07:47 EDT
X-IronPort-AV: E=Sophos;i="4.33,305,1220252400"; 
   d="scan'208";a="48025079"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 4/6] bfa: Brocade BFA FC SCSI Driver submission
Date: Wed, 24 Sep 2008 21:07:21 -0700
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E01F27D1D@HQ-EXCH-5.corp.brocade.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/6] bfa: Brocade BFA FC SCSI Driver submission
Thread-Index: AckexDVf7GJ5IYjyTx6anEza+LdfKg==
From: "Jing Huang" <huangj@Brocade.COM>
To: <James.Bottomley@HansenPartnership.com>
Cc: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Ramkumar Vadivelu" <rvadivel@Brocade.COM>,
       "Vinodh Ravindran" <vravindr@Brocade.COM>,
       "Srikanth Rayas (CW)" <srayas@Brocade.COM>
X-OriginalArrivalTime: 25 Sep 2008 04:07:47.0287 (UTC) FILETIME=[44C3B670:01C91EC4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jing Huang <huangj@brocade.com>

This patch contains Makefile and Kconfig file for scsi and bfa. It is
created using 2.6.27-rc7 kernel.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/Kconfig      |    6 ++++++
 drivers/scsi/Makefile     |    1 +
 drivers/scsi/bfa/Kconfig  |    6 ++++++
 drivers/scsi/bfa/Makefile |   25 +++++++++++++++++++++++++
 4 files changed, 38 insertions(+)

diff -urpN orig/drivers/scsi/bfa/Kconfig patch/drivers/scsi/bfa/Kconfig
--- orig/drivers/scsi/bfa/Kconfig	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/Kconfig	2008-09-24 12:08:25.000000000
-0700
@@ -0,0 +1,6 @@
+config SCSI_BFA_FC
+	tristate "Brocade BFA Fibre Channel Support"
+	depends on PCI && SCSI
+	---help---
+	Select M for building module
+
diff -urpN orig/drivers/scsi/bfa/Makefile
patch/drivers/scsi/bfa/Makefile
--- orig/drivers/scsi/bfa/Makefile	1969-12-31 16:00:00.000000000
-0800
+++ patch/drivers/scsi/bfa/Makefile	2008-09-24 12:08:24.000000000
-0700
@@ -0,0 +1,25 @@
+#
+# Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+# All rights reserved
+# www.brocade.com
+#
+# Linux driver for Brocade Fibre Channel Host Bus Adapter.
+#
+# This program is free software; you can redistribute it and/or modify 
+it # under the terms of the GNU General Public License (GPL) Version 2 
+as # published by the Free Software Foundation # # This program is 
+distributed in the hope that it will be useful, but # WITHOUT ANY 
+WARRANTY; without even the implied warranty of # MERCHANTABILITY or 
+FITNESS FOR A PARTICULAR PURPOSE.  See the GNU # General Public License

+for more details.
+#
+obj-$(CONFIG_SCSI_BFA_FC) := bfa.o
+
+bfa-objs := bfad.o bfad_sysfs.o bfad_intr.o bfad_os.o bfad_im.o \
+	bfad_attr.o bfad_fwimg.o bfa_fcs.o bfa_core.o bfa_ioc.o
bfa_iocfc.o \
+	bfa_fcxp.o bfa_intr.o bfa_timer.o bfa_rport.o bfa_port.o
bfa_uf.o \
+	bfa_sgpg.o bfa_module.o bfa_ioim.o bfa_itnim.o bfa_fcpim.o
bfa_tskim.o \
+	bfa_log.o bfa_log_module.o bfa_csdebug.o bfa_sm.o plog.o
+
+EXTRA_CFLAGS += -I$(obj) -I$(obj)/include
diff -urpN orig/drivers/scsi/Kconfig patch/drivers/scsi/Kconfig
--- orig/drivers/scsi/Kconfig	2008-09-22 22:43:21.000000000 -0700
+++ patch/drivers/scsi/Kconfig	2008-09-24 12:08:23.000000000 -0700
@@ -1789,6 +1789,12 @@ config SCSI_SRP
 	  To compile this driver as a module, choose M here: the
 	  module will be called libsrp.
 
+config SCSI_BFA_FC
+	tristate "Brocade BFA Fibre Channel Support"
+	depends on PCI && SCSI
+	---help---
+	  To compile this driver as a module, choose M here. The module
will 
+be called bfa
+
 endif # SCSI_LOWLEVEL
 
 source "drivers/scsi/pcmcia/Kconfig"
diff -urpN orig/drivers/scsi/Makefile patch/drivers/scsi/Makefile
--- orig/drivers/scsi/Makefile	2008-09-22 22:43:21.000000000 -0700
+++ patch/drivers/scsi/Makefile	2008-09-24 12:08:23.000000000 -0700
@@ -82,6 +82,7 @@ obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla128
 obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
 obj-$(CONFIG_SCSI_QLA_ISCSI)	+= qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
+obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_PAS16)	+= pas16.o
 obj-$(CONFIG_SCSI_T128)		+= t128.o
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
