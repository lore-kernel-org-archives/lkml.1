Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZCKDj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZCKDj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 23:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbZCKDil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 23:38:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:40108 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbZCKDij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 23:38:39 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [v2 PATCH 5/7] EDAC: AMD8131 driver header file
Date: Wed, 11 Mar 2009 11:25:55 +0800
Message-Id: <1236741957-3570-6-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1236741957-3570-5-git-send-email-qingtao.cao@windriver.com>
References: <1236741957-3570-1-git-send-email-qingtao.cao@windriver.com>
 <1236741957-3570-2-git-send-email-qingtao.cao@windriver.com>
 <1236741957-3570-3-git-send-email-qingtao.cao@windriver.com>
 <1236741957-3570-4-git-send-email-qingtao.cao@windriver.com>
 <1236741957-3570-5-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 11 Mar 2009 03:38:32.0007 (UTC) FILETIME=[D9857D70:01C9A1FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce AMD8131 EDAC driver header file, which adds register and bits
definitions for the PCI-X Bridge Controller on the AMD8131 HyperTransport
I/O Hub.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 drivers/edac/amd8131_edac.h |  119 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 119 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/amd8131_edac.h

diff --git a/drivers/edac/amd8131_edac.h b/drivers/edac/amd8131_edac.h
new file mode 100644
index 0000000..60e0d1c
--- /dev/null
+++ b/drivers/edac/amd8131_edac.h
@@ -0,0 +1,119 @@
+/*
+ * amd8131_edac.h, EDAC defs for AMD8131 hypertransport chip
+ *
+ * Copyright (c) 2008 Wind River Systems, Inc.
+ *
+ * Authors:	Cao Qingtao <qingtao.cao@windriver.com>
+ * 		Benjamin Walsh <benjamin.walsh@windriver.com>
+ * 		Hu Yongqi <yongqi.hu@windriver.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#ifndef _AMD8131_EDAC_H_
+#define _AMD8131_EDAC_H_
+
+#define DEVFN_PCIX_BRIDGE_NORTH_A	8
+#define DEVFN_PCIX_BRIDGE_NORTH_B	16
+#define DEVFN_PCIX_BRIDGE_SOUTH_A	24
+#define DEVFN_PCIX_BRIDGE_SOUTH_B	32
+
+/************************************************************
+ *	PCI-X Bridge Status and Command Register, DevA:0x04
+ ************************************************************/
+#define REG_STS_CMD	0x04
+enum sts_cmd_bits {
+	STS_CMD_SSE	= BIT(30),
+	STS_CMD_SERREN	= BIT(8)
+};
+
+/************************************************************
+ *	PCI-X Bridge Interrupt and Bridge Control Register,
+ ************************************************************/
+#define REG_INT_CTLR	0x3c
+enum int_ctlr_bits {
+	INT_CTLR_DTSE	= BIT(27),
+	INT_CTLR_DTS	= BIT(26),
+	INT_CTLR_SERR	= BIT(17),
+	INT_CTLR_PERR	= BIT(16)
+};
+
+/************************************************************
+ *	PCI-X Bridge Memory Base-Limit Register, DevA:0x1C
+ ************************************************************/
+#define REG_MEM_LIM	0x1c
+enum mem_limit_bits {
+	MEM_LIMIT_DPE 	= BIT(31),
+	MEM_LIMIT_RSE 	= BIT(30),
+	MEM_LIMIT_RMA 	= BIT(29),
+	MEM_LIMIT_RTA 	= BIT(28),
+	MEM_LIMIT_STA	= BIT(27),
+	MEM_LIMIT_MDPE	= BIT(24),
+	MEM_LIMIT_MASK	= MEM_LIMIT_DPE|MEM_LIMIT_RSE|MEM_LIMIT_RMA|
+				MEM_LIMIT_RTA|MEM_LIMIT_STA|MEM_LIMIT_MDPE
+};
+
+/************************************************************
+ *	Link Configuration And Control Register, side A
+ ************************************************************/
+#define REG_LNK_CTRL_A	0xc4
+
+/************************************************************
+ *	Link Configuration And Control Register, side B
+ ************************************************************/
+#define REG_LNK_CTRL_B  0xc8
+
+enum lnk_ctrl_bits {
+	LNK_CTRL_CRCERR_A	= BIT(9),
+	LNK_CTRL_CRCERR_B	= BIT(8),
+	LNK_CTRL_CRCFEN		= BIT(1)
+};
+
+enum pcix_bridge_inst {
+	NORTH_A = 0,
+	NORTH_B = 1,
+	SOUTH_A = 2,
+	SOUTH_B = 3,
+	NO_BRIDGE = 4
+};
+
+struct amd8131_dev_info {
+	int devfn;
+	enum pcix_bridge_inst inst;
+	struct pci_dev *dev;
+	int edac_idx;	/* pci device index */
+	char *ctl_name;
+	struct edac_pci_ctl_info *edac_dev;
+};
+
+/*
+ * AMD8131 chipset has two pairs of PCIX Bridge and related IOAPIC
+ * Controler, and ATCA-6101 has two AMD8131 chipsets, so there are
+ * four PCIX Bridges on ATCA-6101 altogether.
+ *
+ * These PCIX Bridges share the same PCI Device ID and are all of
+ * Function Zero, they could be discrimated by their pci_dev->devfn.
+ * They share the same set of init/check/exit methods, and their
+ * private structures are collected in the devices[] array.
+ */
+struct amd8131_info {
+	u16 err_dev;	/* PCI Device ID for AMD8131 APIC*/
+	struct amd8131_dev_info *devices;
+	void (*init)(struct amd8131_dev_info *dev_info);
+	void (*exit)(struct amd8131_dev_info *dev_info);
+	void (*check)(struct edac_pci_ctl_info *edac_dev);
+};
+
+#endif /* _AMD8131_EDAC_H_ */
+
-- 
1.5.6.2

