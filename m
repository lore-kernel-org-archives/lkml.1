Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYJCLxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYJCLxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 07:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYJCLxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 07:53:11 -0400
Received: from smtp.nokia.com ([192.100.105.134]:32309 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbYJCLxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 07:53:09 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [RFC][PATCH 1/5] OMAP SSI hardware interface definitions
Date: Fri,  3 Oct 2008 14:52:26 +0300
Message-Id: <1223034750-18690-1-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1223034606.32631.156.camel@groo.research.nokia.com>
References: <1223034606.32631.156.camel@groo.research.nokia.com>
X-OriginalArrivalTime: 03 Oct 2008 11:52:57.0092 (UTC) FILETIME=[939BFC40:01C9254E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
---
 arch/arm/plat-omap/include/mach/ssi/ssi_gdd_reg.h  |  145 ++++++++++++++++++++
 .../plat-omap/include/mach/ssi/ssi_reg_common.h    |   73 ++++++++++
 arch/arm/plat-omap/include/mach/ssi/ssi_ssr_reg.h  |   56 ++++++++
 arch/arm/plat-omap/include/mach/ssi/ssi_sst_reg.h  |   65 +++++++++
 arch/arm/plat-omap/include/mach/ssi/ssi_sys_reg.h  |  107 ++++++++++++++
 5 files changed, 446 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-omap/include/mach/ssi/ssi_gdd_reg.h
 create mode 100644 arch/arm/plat-omap/include/mach/ssi/ssi_reg_common.h
 create mode 100644 arch/arm/plat-omap/include/mach/ssi/ssi_ssr_reg.h
 create mode 100644 arch/arm/plat-omap/include/mach/ssi/ssi_sst_reg.h
 create mode 100644 arch/arm/plat-omap/include/mach/ssi/ssi_sys_reg.h

diff --git a/arch/arm/plat-omap/include/mach/ssi/ssi_gdd_reg.h b/arch/arm/plat-omap/include/mach/ssi/ssi_gdd_reg.h
new file mode 100644
index 0000000..5ed91cc
--- /dev/null
+++ b/arch/arm/plat-omap/include/mach/ssi/ssi_gdd_reg.h
@@ -0,0 +1,145 @@
+/*
+ * ssi_gdd_reg.h
+ *
+ * Hardware defintions for SSI Controller GDD registers.
+ *
+ * HARDWARE: OMAP 2420, OMAP 3430
+ *
+ * Copyright (C) 2007-2008 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+#ifndef __SSI_GDD_REG_H__
+#define __SSI_GDD_REG_H__
+
+#include "ssi_reg_common.h"
+
+#define SSI_GDD_HW_ID_REG		SSI_GDD_REG32(0x0000)
+#define SSI_GDD_PPORT_ID_REG		SSI_GDD_REG32(0x0010)
+#define SSI_GDD_MPORT_ID_REG		SSI_GDD_REG32(0x0014)
+
+#define SSI_GDD_PPORT_SR_REG		SSI_GDD_REG32(0x0020)
+#	define SSI_PPORT_ACTIVE_LCH_NUMBER_MASK	0xFF
+
+#define SSI_GDD_MPORT_SR_REG		SSI_GDD_REG32(0x0024)
+#	define SSI_MPORT_ACTIVE_LCH_NUMBER_MASK	0xFF
+
+#define SSI_GDD_TEST_REG 		SSI_GDD_REG32(0x0040)
+#	define SSI_TEST			0x1
+
+#define SSI_GDD_GCR_REG			SSI_GDD_REG32(0x0100)
+#	define	SSI_CLK_AUTOGATING_ON	(1<<3)
+#	define	SSI_FREE		(1<<2)
+#	define	SSI_SWITCH_OFF		0x1
+
+#define SSI_GDD_GRST_REG 		SSI_GDD_REG32(0x0200)
+#	define SSI_SWRESET		0x1
+
+#define SSI_GDD_CSDP_BASE		0x0800
+#define SSI_GDD_CSDP_OFFSET		0x40
+#define SSI_GDD_CSDP_REG(channel) 	SSI_GDD_REG16(SSI_GDD_CSDP_BASE +\
+					 (channel*SSI_GDD_CSDP_OFFSET))
+#	define SSI_DST_BURST_EN_MASK	0xC000
+#	define SSI_DST_SINGLE_ACCESS0	0x0
+#	define SSI_DST_SINGLE_ACCESS	(0x1<<14)
+#	define SSI_DST_BURST_4X32_BIT	(0x2<<14)
+#	define SSI_DST_BURST_8x32_BIT	(0x3<<14)	/*NOTE: NOT SUPPORTED */
+
+#	define SSI_DST_MASK		0x1E00
+#	define SSI_DST_MEMORY_PORT	(0x8<<9)
+#	define SSI_DST_PERIPHERAL_PORT	(0x9<<9)
+
+#	define SSI_SRC_BURST_EN_MASK	0x0180
+#	define SSI_SRC_SINGLE_ACCESS0	0x0
+#	define SSI_SRC_SINGLE_ACCESS	(0x1<<7)
+#	define SSI_SRC_BURST_4x32_BIT	(0x2<<7)
+#	define SSI_SRC_BURST_8x32_BIT	(0x3<<7)	/*NOTE: NOT SUPPORTED */
+
+#	define SSI_SRC_MASK		0x003C
+#	define SSI_SRC_MEMORY_PORT	(0x8<<2)
+#	define SSI_SRC_PERIPHERAL_PORT	(0x9<<2)
+
+#	define SSI_DATA_TYPE_MASK	0x0003
+#	define SSI_DATA_TYPE_S32	0x2
+
+#define SSI_GDD_CCR_BASE 		0x0802
+#define SSI_GDD_CCR_OFFSET 		0x40
+#define SSI_GDD_CCR_REG(channel)	SSI_GDD_REG16(SSI_GDD_CCR_BASE +\
+					 (channel*SSI_GDD_CCR_OFFSET))
+#	define SSI_DST_AMODE_MASK	(0x3<<14)
+#	define SSI_DST_AMODE_CONST	0x0
+#	define SSI_DST_AMODE_POSTINC	(0x1<<12)
+
+#	define SSI_SRC_AMODE_MASK	(0x3<<12)
+#	define SSI_SRC_AMODE_CONST	0x0
+#	define SSI_SRC_AMODE_POSTINC	(0x1<<12)
+
+#	define SSI_CCR_ENABLE		(0x1<<7)
+
+#	define SSI_CCR_SYNC_MASK	0x001F
+
+#define SSI_GDD_CICR_BASE 		0x0804
+#define SSI_GDD_CICR_OFFSET		0x40
+#define SSI_GDD_CICR_REG(channel)	SSI_GDD_REG16(SSI_GDD_CICR_BASE +\
+					 (channel*SSI_GDD_CICR_OFFSET))
+#	define SSI_BLOCK_IE		(0x1<<5)
+#	define SSI_HALF_IE		(0x1<<2)
+#	define SSI_TOUT_IE		0x1
+
+#define SSI_GDD_CSR_BASE 		0x0806
+#define SSI_GDD_CSR_OFFSET 		0x40
+#define SSI_GDD_CSR_REG(channel)	SSI_GDD_REG16(SSI_GDD_CSR_BASE +\
+					 (channel*SSI_GDD_CSR_OFFSET))
+#	define SSI_CSR_SYNC		(0x1<<6)
+#	define SSI_CSR_BLOCK		(0x1<<5)
+#	define SSI_CSR_HALF		(0x1<<2)
+#	define SSI_CSR_TOUR		0x1
+
+#define SSI_GDD_CSSA_BASE 		0x0808
+#define SSI_GDD_CSSA_OFFSET		0x40
+#define SSI_GDD_CSSA_REG(channel)	SSI_GDD_REG32(SSI_GDD_CSSA_BASE +\
+					 (channel*SSI_GDD_CSSA_OFFSET))
+
+#define SSI_GDD_CDSA_BASE 		0x080C
+#define SSI_GDD_CDSA_OFFSET		0x40
+#define SSI_GDD_CDSA_REG(channel)	SSI_GDD_REG32(SSI_GDD_CDSA_BASE +\
+					 (channel*SSI_GDD_CDSA_OFFSET))
+
+#define SSI_GDD_CEN_BASE		0x0810
+#define SSI_GDD_CEN_OFFSET		0x40
+#define SSI_GDD_CEN_REG(channel)	SSI_GDD_REG16(SSI_GDD_CEN_BASE +\
+					 (channel*SSI_GDD_CEN_OFFSET))
+
+#define SSI_GDD_CSAC_BASE 		0x0818
+#define SSI_GDD_CSAC_OFFSET		0x40
+#define SSI_GDD_CSAC_REG(channel) 	SSI_GDD_REG16(SSI_GDD_CSAC_BASE +\
+					 (channel*SSI_GDD_CSAC_OFFSET))
+
+#define SSI_GDD_CDAC_BASE 		0x081A
+#define SSI_GDD_CDAC_OFFSET		0x40
+#define SSI_GDD_CDAC_REG(channel) 	SSI_GDD_REG16(SSI_GDD_CDAC_BASE +\
+					 (channel*SSI_GDD_CDAC_OFFSET))
+
+#define SSI_GDD_CLNK_CTRL_BASE		0x0828
+#define SSI_GDD_CLNK_CTRL_OFFSET	0x40
+#define SSI_GDD_CLNK_CTRL_REG(channel)	SSI_GDD_REG16(SSI_GDD_CLNK_CTRL_BASE +\
+					 (channel*SSI_GDD_CLNK_CTRL_OFFSET))
+#	define SSI_ENABLE_LNK		(0x1<<15)
+#	define SSI_STOP_LNK		(0x1<<14)
+#	define NEXT_CH_ID_MASK		0xF
+
+#endif
diff --git a/arch/arm/plat-omap/include/mach/ssi/ssi_reg_common.h b/arch/arm/plat-omap/include/mach/ssi/ssi_reg_common.h
new file mode 100644
index 0000000..e66fb43
--- /dev/null
+++ b/arch/arm/plat-omap/include/mach/ssi/ssi_reg_common.h
@@ -0,0 +1,73 @@
+/*
+ * ssi_reg_common.h
+ *
+ * Common hardware definitions for SSI.
+ *
+ * HARDWARE: OMAP 2420, 3430
+ *
+ * Copyright (C) 2007-2008 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __SSI_REG_COMMON_H__
+#define __SSI_REG_COMMON_H__
+
+#define SSI_COMMON_BASE_ADDR		0x48050000
+
+/* SSI system registers */
+#define SSI_SYS_OFFSET			0x8000
+#define SSI_SYS_REG32(offset)		(SSI_SYS_OFFSET + (offset))
+/* SSI GDD registers */
+#define SSI_GDD_OFFSET			0x9000
+#define SSI_GDD_REG32(offset)		(SSI_GDD_OFFSET + (offset))
+#define SSI_GDD_REG16(offset)		(SSI_GDD_OFFSET + (offset))
+
+/* SSI SST registers */
+/* General offset of SST port 1. First SST port register.*/
+#define SSI_SST1_OFFSET			0xA000
+/* General offset of SST port 2.*/
+#define SSI_SST2_OFFSET			0xB000
+/* Offset among the SST ports.*/
+#define SSI_SST_PORT_OFFSET		0x1000
+#define SSI_SST_OFFSET(port)		(SSI_SST1_OFFSET +\
+					 ((port-1)*(SSI_SST_PORT_OFFSET)))
+#define SSI_SST_REG(port, offset)	(SSI_SST_OFFSET(port) + (offset))
+
+/* SSI SSR registers */
+/* General offset of SSR port 1. First SSR port register.*/
+#define SSI_SSR1_OFFSET			0xA800
+/* General offset of SSR port 2.*/
+#define SSI_SSR2_OFFSET			0xB800
+/* Offset among the SSR ports.*/
+#define SSI_SSR_PORT_OFFSET		0x1000
+#define SSI_SSR_OFFSET(port)		(SSI_SSR1_OFFSET +\
+					 ((port-1)*(SSI_SSR_PORT_OFFSET)))
+#define SSI_SSR_REG(port, offset)	(SSI_SSR_OFFSET(port) + (offset))
+
+#define SSI_IOMEM_BASE_ADDR		SSI_COMMON_BASE_ADDR
+#define SSI_IOMEM_SIZE			0x3C00
+
+/*
+ * FIXME: Following definitions to be removed.
+ * They are used for checking that the SSI clocks are stable before accessing
+ * the SSI registers.
+ */
+#define OMAP_COMMON_BASE                0x48000000
+#define CM_IDLEST1_CORE_REG		0x4A20
+#define ST_SSI				1
+#endif
diff --git a/arch/arm/plat-omap/include/mach/ssi/ssi_ssr_reg.h b/arch/arm/plat-omap/include/mach/ssi/ssi_ssr_reg.h
new file mode 100644
index 0000000..b272047
--- /dev/null
+++ b/arch/arm/plat-omap/include/mach/ssi/ssi_ssr_reg.h
@@ -0,0 +1,56 @@
+/*
+ * ssi_sst_reg.h
+ *
+ * Hardware definitions for SSI controller SSR registers.
+ *
+ * HARDWARE: OMAP 2420, 3430
+ *
+ * Copyright (C) 2007-2008 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __SSI_SSR_REG_H__
+#define __SSI_SSR_REG_H__
+
+#include "ssi_reg_common.h"
+
+#define SSI_SSR_ID_REG(port)			SSI_SSR_REG(port, 0x0000)
+#define SSI_SSR_MODE_REG(port)			SSI_SSR_REG(port, 0x0004)
+#define SSI_SSR_FRAMESIZE_REG(port)		SSI_SSR_REG(port, 0x0008)
+#define SSI_SSR_RXSTATE_REG(port)  		SSI_SSR_REG(port, 0x000C)
+#define SSI_SSR_BUFSTATE_REG(port) 		SSI_SSR_REG(port, 0x0010)
+#	define NOTEMPTY(channel)		(1<<channel)
+#define SSI_SSR_BREAK_REG(port)			SSI_SSR_REG(port, 0x001C)
+#define SSI_SSR_ERROR_REG(port)			SSI_SSR_REG(port, 0x0020)
+#define SSI_SSR_ERRORACK_REG(port)		SSI_SSR_REG(port, 0x0024)
+#define SSI_SSR_OVERRUN_REG(port)		SSI_SSR_REG(port, 0x002C)
+#define SSI_SSR_OVERRUNACK_REG(port)		SSI_SSR_REG(port, 0x0030)
+#define SSI_SSR_TIMEOUT_REG(port)		SSI_SSR_REG(port, 0x0030)
+#	define SSI_TIMEOUT_DEFAULT		0
+#define SSI_SSR_CHANNELS_REG(port)		SSI_SSR_REG(port, 0x0028)
+
+#define SSI_SSR_BUFFER_OFFSET_BASE		0x0080
+#define SSI_SSR_BUFFER_CH_REG(port, channel)	SSI_SSR_REG(port, \
+						(SSI_SSR_BUFFER_OFFSET_BASE +\
+						 (channel * 0x04)))
+
+#define SSI_SSR_SWAPBUFFER_OFFSET_BASE		0x00C0
+#define SSI_SSR_SWAPBUFFER_CH_REG(port, channel) SSI_SSR_REG(port, \
+						(SSI_SSR_SWAPBUFFER_OFFSET_BASE\
+						 + (channel * 0x04)))
+#endif
diff --git a/arch/arm/plat-omap/include/mach/ssi/ssi_sst_reg.h b/arch/arm/plat-omap/include/mach/ssi/ssi_sst_reg.h
new file mode 100644
index 0000000..ed15908
--- /dev/null
+++ b/arch/arm/plat-omap/include/mach/ssi/ssi_sst_reg.h
@@ -0,0 +1,65 @@
+/*
+ * ssi_sst_reg.h
+ *
+ * Hardware definitions for SSI controller SST registers.
+ *
+ * HARDWARE: OMAP 2420, 3430
+ *
+ * Copyright (C) 2007-2008 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __SSI_SST_REG_H__
+#define __SSI_SST_REG_H__
+
+#include "ssi_reg_common.h"
+
+#define SSI_SST_ID_REG(port)			SSI_SST_REG(port, 0x0000)
+#define SSI_SST_MODE_REG(port)			SSI_SST_REG(port, 0x0004)
+#	define SSI_MODE_VAL_MASK		0x3
+#	define SSI_MODE_SLEEP			0x0
+#	define SSI_MODE_STREAM			0x1
+#	define SSI_MODE_FRAME			0x2
+#	define SSI_MODE_MULTIPOINTS		0x3
+#define SSI_SST_FRAMESIZE_REG(port)		SSI_SST_REG(port, 0x0008)
+#	define SSI_FRAMESIZE_DEFAULT		31
+#define SSI_SST_TXSTATE_REG(port)  		SSI_SST_REG(port, 0x000C)
+#	define	TXSTATE_IDLE			0x0
+#define SSI_SST_BUFSTATE_REG(port) 		SSI_SST_REG(port, 0x0010)
+#	define 	NOTFULL(channel)		(1<<channel)
+#define SSI_SST_DIVISOR_REG(port)		SSI_SST_REG(port, 0x0018)
+#	define SSI_DIVISOR_DEFAULT		1
+
+#define SSI_SST_BREAK_REG(port)			SSI_SST_REG(port, 0x0020)
+#define SSI_SST_CHANNELS_REG(port)		SSI_SST_REG(port, 0x0024)
+#	define SSI_CHANNELS_DEFAULT		4
+
+#define SSI_SST_ARBMODE_REG(port)		SSI_SST_REG(port, 0x0028)
+#	define SSI_ARBMODE_ROUNDROBIN		0x0
+#	define SSI_ARBMODE_PRIORITY		0x1
+
+#define SSI_SST_BUFFER_OFFSET_BASE		0x0080
+#define SSI_SST_BUFFER_CH_REG(port, channel)	SSI_SST_REG(port, \
+						(SSI_SST_BUFFER_OFFSET_BASE +\
+						 (channel * 0x4)))
+
+#define SSI_SST_SWAPBUF_OFFSET_BASE		0x00C0
+#define SSI_SST_SWAPBUF_CH_REG(port, channel)	SSI_SST_REG(port, \
+						(SSI_SST_SWAPBUF_OFFSET_BASE +\
+						(channel * 0x4)))
+#endif
diff --git a/arch/arm/plat-omap/include/mach/ssi/ssi_sys_reg.h b/arch/arm/plat-omap/include/mach/ssi/ssi_sys_reg.h
new file mode 100644
index 0000000..2f1e1f5
--- /dev/null
+++ b/arch/arm/plat-omap/include/mach/ssi/ssi_sys_reg.h
@@ -0,0 +1,107 @@
+/*
+ * ssi_sys_reg.h
+ *
+ * Hardware defintions for SSI Controller system registers.
+ *
+ * HARDWARE: OMAP 2420, 3430
+ *
+ * Copyright (C) 2007-2008 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __SSI_SYS_REG_H__
+#define __SSI_SYS_REG_H__
+
+#include "ssi_reg_common.h"
+
+#define SSI_SYS_REVISION_REG		SSI_SYS_REG32(0x0000)
+#	define SSI_REV_MASK		0x000000FF
+#	define SSI_REV_MAJOR		0xF0
+#	define SSI_REV_MINOR		0x0F
+
+#define SSI_SYS_SYSCONFIG_REG		SSI_SYS_REG32(0x0010)
+#	define SSI_AUTOIDLE		1
+#	define SSI_SOFTRESET		(1<<1)
+#	define SSI_SIDLEMODE_FORCE	0
+#	define SSI_SIDLEMODE_NO		(1<<3)
+#	define SSI_SIDLEMODE_SMART	(1<<4)
+#	define SSI_SIDLEMODE_MASK	0x00000018
+#	define SSI_MIDLEMODE_FORCE	0
+#	define SSI_MIDLEMODE_NO		(1<<12)
+#	define SSI_MIDLEMODE_SMART	(1<<13)
+#	define SSI_MIDLEMODE_MASK	0x00003000
+
+#define SSI_SYS_SYSSTATUS_REG		SSI_SYS_REG32(0x0014)
+#	define SSI_RESETDONE		1
+
+#define SSI_SYS_MPU_STATUS_BASE		0x0808
+#define SSI_SYS_MPU_STATUS_PORT_OFFSET	0x10
+#define SSI_SYS_MPU_STATUS_IRQ_OFFSET	0x2
+#define SSI_SYS_MPU_STATUS_REG(port, irq) \
+		SSI_SYS_REG32(SSI_SYS_MPU_STATUS_BASE +\
+		 (((port-1)*SSI_SYS_MPU_STATUS_PORT_OFFSET) +\
+		 (irq*SSI_SYS_MPU_STATUS_IRQ_OFFSET)))
+
+#define SSI_SYS_MPU_ENABLE_BASE		0x080C
+#define SSI_SYS_MPU_ENABLE_PORT_OFFSET	0x10
+#define SSI_SYS_MPU_ENABLE_IRQ_OFFSET	0x8
+#define SSI_SYS_MPU_ENABLE_REG(port, irq) \
+		SSI_SYS_REG32(SSI_SYS_MPU_ENABLE_BASE +\
+		 (((port-1)*SSI_SYS_MPU_ENABLE_PORT_OFFSET) +\
+		 (irq*SSI_SYS_MPU_ENABLE_IRQ_OFFSET)))
+
+#define SSI_SYS_DSP_STATUS_BASE		0x0830
+#define SSI_SYS_DSP_STATUS_PORT_OFFSET	0x10
+#define SSI_SYS_DSP_STATUS_IRQ_OFFSET	0x8
+#define SSI_SYS_DSP_STATUS_REG(port, irq) \
+		SSI_SYS_REG32(SSI_SYS_DSP_STATUS_BASE +\
+		 (((port-1)*SSI_SYS_DSP_STATUS_PORT_OFFSET) +\
+		 (irq*SSI_SYS_DSP_STATUS_IRQ_OFFSET)))
+
+#define SSI_SYS_DSP_ENABLE_BASE		0x0834
+#define SSI_SYS_DSP_ENABLE_PORT_OFFSET	0x10
+#define SSI_SYS_DSP_ENABLE_IRQ_OFFSET	0x8
+#define SSI_SYS_DSP_ENABLE_REG(port, irq) \
+		SSI_SYS_REG32(SSI_SYS_DSP_ENABLE_BASE +\
+		 (((port-1)*SSI_SYS_DSP_ENABLE_PORT_OFFSET) +\
+		 (irq*SSI_SYS_DSP_ENABLE_IRQ_OFFSET)))
+#	define SSI_SST_DATAACCEPT(channel)	(1<<channel)
+#	define SSI_SSR_DATAAVAILABLE(channel)	(1<<(channel + 8))
+#	define SSI_SSR_DATAOVERRUN(channel)	(1<<(channel + 16))
+#	define SSI_ERROROCCURED			(1<<24)
+#	define SSI_BREAKDETECTED		(1<<25)
+
+#define SSI_SYS_GDD_MPU_IRQ_STATUS_REG	SSI_SYS_REG32(0x0800)
+#define SSI_SYS_GDD_MPU_IRQ_ENABLE_REG	SSI_SYS_REG32(0x0804)
+#define SSI_SYS_GDD_DSP_IRQ_STATUS_REG 	SSI_SYS_REG32(0x0828)
+#define SSI_SYS_GDD_DSP_IRQ_ENABLE_REG 	SSI_SYS_REG32(0x082C)
+#	define SSI_GDD_LCH(channel)	(1<<channel)
+
+#define SSI_SYS_WAKE_OFFSET		0x10
+#define SSI_SYS_WAKE_BASE		0x0C00
+#define SSI_SYS_WAKE_REG(port) 		SSI_SYS_REG32(SSI_SYS_WAKE_BASE +\
+					 ((port-1)*SSI_SYS_WAKE_OFFSET))
+#define SSI_SYS_CLEAR_WAKE_BASE		0x0C04
+#define SSI_SYS_CLEAR_WAKE_REG(port)	SSI_SYS_REG32(SSI_SYS_CLEAR_WAKE_BASE +\
+					 ((port-1)*SSI_SYS_WAKE_OFFSET))
+#define SSI_SYS_SET_WAKE_BASE		0x0C08
+#define SSI_SYS_SET_WAKE_REG(port)	SSI_SYS_REG32(SSI_SYS_SET_WAKE_BASE +\
+					 ((port-1)*SSI_SYS_WAKE_OFFSET))
+#	define SSI_WAKE(channel)	(1<<channel)
+#	define SSI_WAKE_MASK		0xFF
+#endif
-- 
1.5.3.6

