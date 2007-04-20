Return-Path: <linux-kernel-owner+w=401wt.eu-S1767300AbXDTWml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767300AbXDTWml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767297AbXDTWmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:42:23 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:46095 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbXDTWmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:42:17 -0400
X-IronPort-AV: i="4.14,434,1170662400"; 
   d="scan'208"; a="371297816:sNHT112340124"
Subject: [PATCH 3/6] [RFC]mlx4_core public includes
In-Reply-To: <20074201532.d6hTKIczPSz0SeTA@cisco.com>
X-Mailer: Roland's Patchbomber
Date: Fri, 20 Apr 2007 15:32:36 -0700
Message-Id: <20074201532.7wkxUOPwHNFg96ue@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
From: Roland Dreier <rolandd@cisco.com>
X-OriginalArrivalTime: 20 Apr 2007 22:32:37.0156 (UTC) FILETIME=[CC25FE40:01C7839B]
Authentication-Results: sj-dkim-4; header.From=rolandd@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Include files for hardware/firmware information and interface of
mlx4_core module for protocol-specific drivers (such as mlx4_ib).

Signed-off-by: Roland Dreier <rolandd@cisco.com>

---

 cmd.h      |  178 +++++++++++++++++++++++++++++++++
 cq.h       |  123 +++++++++++++++++++++++
 device.h   |  323 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 doorbell.h |   97 ++++++++++++++++++
 driver.h   |   59 +++++++++++
 qp.h       |  288 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 srq.h      |   42 +++++++
 7 files changed, 1110 insertions(+)

diff --git a/include/linux/mlx4/cmd.h b/include/linux/mlx4/cmd.h
new file mode 100644
index 0000000..4fb552d
--- /dev/null
+++ b/include/linux/mlx4/cmd.h
@@ -0,0 +1,178 @@
+/*
+ * Copyright (c) 2006 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef MLX4_CMD_H
+#define MLX4_CMD_H
+
+#include <linux/dma-mapping.h>
+
+enum {
+	/* initialization and general commands */
+	MLX4_CMD_SYS_EN		 = 0x1,
+	MLX4_CMD_SYS_DIS	 = 0x2,
+	MLX4_CMD_MAP_FA		 = 0xfff,
+	MLX4_CMD_UNMAP_FA	 = 0xffe,
+	MLX4_CMD_RUN_FW		 = 0xff6,
+	MLX4_CMD_MOD_STAT_CFG	 = 0x34,
+	MLX4_CMD_QUERY_DEV_CAP	 = 0x3,
+	MLX4_CMD_QUERY_FW	 = 0x4,
+	MLX4_CMD_ENABLE_LAM	 = 0xff8,
+	MLX4_CMD_DISABLE_LAM	 = 0xff7,
+	MLX4_CMD_QUERY_DDR	 = 0x5,
+	MLX4_CMD_QUERY_ADAPTER	 = 0x6,
+	MLX4_CMD_INIT_HCA	 = 0x7,
+	MLX4_CMD_CLOSE_HCA	 = 0x8,
+	MLX4_CMD_INIT_PORT	 = 0x9,
+	MLX4_CMD_CLOSE_PORT	 = 0xa,
+	MLX4_CMD_QUERY_HCA	 = 0xb,
+	MLX4_CMD_SET_PORT	 = 0xc,
+	MLX4_CMD_ACCESS_DDR	 = 0x2e,
+	MLX4_CMD_MAP_ICM	 = 0xffa,
+	MLX4_CMD_UNMAP_ICM	 = 0xff9,
+	MLX4_CMD_MAP_ICM_AUX	 = 0xffc,
+	MLX4_CMD_UNMAP_ICM_AUX	 = 0xffb,
+	MLX4_CMD_SET_ICM_SIZE	 = 0xffd,
+
+	/* TPT commands */
+	MLX4_CMD_SW2HW_MPT	 = 0xd,
+	MLX4_CMD_QUERY_MPT	 = 0xe,
+	MLX4_CMD_HW2SW_MPT	 = 0xf,
+	MLX4_CMD_READ_MTT	 = 0x10,
+	MLX4_CMD_WRITE_MTT	 = 0x11,
+	MLX4_CMD_SYNC_TPT	 = 0x2f,
+
+	/* EQ commands */
+	MLX4_CMD_MAP_EQ		 = 0x12,
+	MLX4_CMD_SW2HW_EQ	 = 0x13,
+	MLX4_CMD_HW2SW_EQ	 = 0x14,
+	MLX4_CMD_QUERY_EQ	 = 0x15,
+
+	/* CQ commands */
+	MLX4_CMD_SW2HW_CQ	 = 0x16,
+	MLX4_CMD_HW2SW_CQ	 = 0x17,
+	MLX4_CMD_QUERY_CQ	 = 0x18,
+	MLX4_CMD_RESIZE_CQ	 = 0x2c,
+
+	/* SRQ commands */
+	MLX4_CMD_SW2HW_SRQ	 = 0x35,
+	MLX4_CMD_HW2SW_SRQ	 = 0x36,
+	MLX4_CMD_QUERY_SRQ	 = 0x37,
+	MLX4_CMD_ARM_SRQ	 = 0x40,
+
+	/* QP/EE commands */
+	MLX4_CMD_RST2INIT_QP	 = 0x19,
+	MLX4_CMD_INIT2RTR_QP	 = 0x1a,
+	MLX4_CMD_RTR2RTS_QP	 = 0x1b,
+	MLX4_CMD_RTS2RTS_QP	 = 0x1c,
+	MLX4_CMD_SQERR2RTS_QP	 = 0x1d,
+	MLX4_CMD_2ERR_QP	 = 0x1e,
+	MLX4_CMD_RTS2SQD_QP	 = 0x1f,
+	MLX4_CMD_SQD2SQD_QP	 = 0x38,
+	MLX4_CMD_SQD2RTS_QP	 = 0x20,
+	MLX4_CMD_2RST_QP	 = 0x21,
+	MLX4_CMD_QUERY_QP	 = 0x22,
+	MLX4_CMD_INIT2INIT_QP	 = 0x2d,
+	MLX4_CMD_SUSPEND_QP	 = 0x32,
+	MLX4_CMD_UNSUSPEND_QP	 = 0x33,
+	/* special QP and management commands */
+	MLX4_CMD_CONF_SPECIAL_QP = 0x23,
+	MLX4_CMD_MAD_IFC	 = 0x24,
+
+	/* multicast commands */
+	MLX4_CMD_READ_MCG	 = 0x25,
+	MLX4_CMD_WRITE_MCG	 = 0x26,
+	MLX4_CMD_MGID_HASH	 = 0x27,
+
+	/* miscellaneous commands */
+	MLX4_CMD_DIAG_RPRT	 = 0x30,
+	MLX4_CMD_NOP		 = 0x31,
+
+	/* debug commands */
+	MLX4_CMD_QUERY_DEBUG_MSG = 0x2a,
+	MLX4_CMD_SET_DEBUG_MSG	 = 0x2b,
+};
+
+enum {
+	MLX4_CMD_TIME_CLASS_A	= 10000,
+	MLX4_CMD_TIME_CLASS_B	= 10000,
+	MLX4_CMD_TIME_CLASS_C	= 10000,
+};
+
+enum {
+	MLX4_MAILBOX_SIZE	=  4096
+};
+
+struct mlx4_dev;
+
+struct mlx4_cmd_mailbox {
+	void		       *buf;
+	dma_addr_t		dma;
+};
+
+int __mlx4_cmd(struct mlx4_dev *dev, u64 in_param, u64 *out_param,
+	       int out_is_imm, u32 in_modifier, u8 op_modifier,
+	       u16 op, unsigned long timeout);
+
+/* Invoke a command with no output parameter */
+static inline int mlx4_cmd(struct mlx4_dev *dev, u64 in_param, u32 in_modifier,
+			   u8 op_modifier, u16 op, unsigned long timeout)
+{
+	return __mlx4_cmd(dev, in_param, NULL, 0, in_modifier,
+			  op_modifier, op, timeout);
+}
+
+/* Invoke a command with an output mailbox */
+static inline int mlx4_cmd_box(struct mlx4_dev *dev, u64 in_param, u64 out_param,
+			       u32 in_modifier, u8 op_modifier, u16 op,
+			       unsigned long timeout)
+{
+	return __mlx4_cmd(dev, in_param, &out_param, 0, in_modifier,
+			  op_modifier, op, timeout);
+}
+
+/*
+ * Invoke a command with an immediate output parameter (and copy the
+ * output into the caller's out_param pointer after the command
+ * executes).
+ */
+static inline int mlx4_cmd_imm(struct mlx4_dev *dev, u64 in_param, u64 *out_param,
+			       u32 in_modifier, u8 op_modifier, u16 op,
+			       unsigned long timeout)
+{
+	return __mlx4_cmd(dev, in_param, out_param, 1, in_modifier,
+			  op_modifier, op, timeout);
+}
+
+struct mlx4_cmd_mailbox *mlx4_alloc_cmd_mailbox(struct mlx4_dev *dev);
+void mlx4_free_cmd_mailbox(struct mlx4_dev *dev, struct mlx4_cmd_mailbox *mailbox);
+
+#endif /* MLX4_CMD_H */
diff --git a/include/linux/mlx4/cq.h b/include/linux/mlx4/cq.h
new file mode 100644
index 0000000..0181e0a
--- /dev/null
+++ b/include/linux/mlx4/cq.h
@@ -0,0 +1,123 @@
+/*
+ * Copyright (c) 2007 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef MLX4_CQ_H
+#define MLX4_CQ_H
+
+#include <linux/types.h>
+
+#include <linux/mlx4/device.h>
+#include <linux/mlx4/doorbell.h>
+
+struct mlx4_cqe {
+	__be32			my_qpn;
+	__be32			immed_rss_invalid;
+	__be32			g_mlpath_rqpn;
+	u8			sl;
+	u8			reserved1;
+	__be16			rlid;
+	u32			reserved2;
+	__be32			byte_cnt;
+	__be16			wqe_index;
+	__be16			checksum;
+	u8			reserved3[3];
+	u8			owner_sr_opcode;
+};
+
+struct mlx4_err_cqe {
+	__be32			my_qpn;
+	u32			reserved1[5];
+	__be16			wqe_index;
+	u8			vendor_err_syndrome;
+	u8			syndrome;
+	u8			reserved2[3];
+	u8			owner_sr_opcode;
+};
+
+enum {
+	MLX4_CQE_OWNER_MASK	= 0x80,
+	MLX4_CQE_IS_SEND_MASK	= 0x40,
+	MLX4_CQE_OPCODE_MASK	= 0x1f
+};
+
+enum {
+	MLX4_CQE_SYNDROME_LOCAL_LENGTH_ERR		= 0x01,
+	MLX4_CQE_SYNDROME_LOCAL_QP_OP_ERR		= 0x02,
+	MLX4_CQE_SYNDROME_LOCAL_PROT_ERR		= 0x04,
+	MLX4_CQE_SYNDROME_WR_FLUSH_ERR			= 0x05,
+	MLX4_CQE_SYNDROME_MW_BIND_ERR			= 0x06,
+	MLX4_CQE_SYNDROME_BAD_RESP_ERR			= 0x10,
+	MLX4_CQE_SYNDROME_LOCAL_ACCESS_ERR		= 0x11,
+	MLX4_CQE_SYNDROME_REMOTE_INVAL_REQ_ERR		= 0x12,
+	MLX4_CQE_SYNDROME_REMOTE_ACCESS_ERR		= 0x13,
+	MLX4_CQE_SYNDROME_REMOTE_OP_ERR			= 0x14,
+	MLX4_CQE_SYNDROME_TRANSPORT_RETRY_EXC_ERR	= 0x15,
+	MLX4_CQE_SYNDROME_RNR_RETRY_EXC_ERR		= 0x16,
+	MLX4_CQE_SYNDROME_REMOTE_ABORTED_ERR		= 0x22,
+};
+
+static inline void mlx4_cq_arm(struct mlx4_cq *cq, u32 cmd,
+			       void __iomem *uar_page,
+			       spinlock_t *doorbell_lock)
+{
+	__be32 doorbell[2];
+	u32 sn;
+	u32 ci;
+
+	sn = cq->arm_sn & 3;
+	ci = cq->cons_index & 0xffffff;
+
+	*cq->arm_db = cpu_to_be32(sn << 28 | cmd | ci);
+
+	/*
+	 * Make sure that the doorbell record in host memory is
+	 * written before ringing the doorbell via PCI MMIO.
+	 */
+	wmb();
+
+	doorbell[0] = cpu_to_be32(sn << 28 | cmd | cq->cqn);
+	doorbell[1] = cpu_to_be32(ci);
+
+	mlx4_write64(doorbell, uar_page + MLX4_CQ_DOORBELL, doorbell_lock);
+}
+
+static inline void mlx4_cq_set_ci(struct mlx4_cq *cq)
+{
+	*cq->set_ci_db = cpu_to_be32(cq->cons_index & 0xffffff);
+}
+
+enum {
+	MLX4_CQ_DB_REQ_NOT_SOL		= 1 << 24,
+	MLX4_CQ_DB_REQ_NOT		= 2 << 24
+};
+
+#endif /* MLX4_CQ_H */
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
new file mode 100644
index 0000000..54c5509
--- /dev/null
+++ b/include/linux/mlx4/device.h
@@ -0,0 +1,323 @@
+/*
+ * Copyright (c) 2006, 2007 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef MLX4_DEVICE_H
+#define MLX4_DEVICE_H
+
+#include <linux/pci.h>
+#include <linux/completion.h>
+#include <linux/radix-tree.h>
+
+#include <asm/atomic.h>
+
+enum {
+	MLX4_FLAG_MSI_X		= 1 << 0,
+};
+
+enum {
+	MLX4_MAX_PORTS		= 2
+};
+
+enum {
+	MLX4_DEV_CAP_FLAG_RC		= 1 <<  0,
+	MLX4_DEV_CAP_FLAG_UC		= 1 <<  1,
+	MLX4_DEV_CAP_FLAG_UD		= 1 <<  2,
+	MLX4_DEV_CAP_FLAG_SRQ		= 1 <<  6,
+	MLX4_DEV_CAP_FLAG_IPOIB_CSUM	= 1 <<  7,
+	MLX4_DEV_CAP_FLAG_BAD_PKEY_CNTR	= 1 <<  8,
+	MLX4_DEV_CAP_FLAG_BAD_QKEY_CNTR	= 1 <<  9,
+	MLX4_DEV_CAP_FLAG_MEM_WINDOW	= 1 << 16,
+	MLX4_DEV_CAP_FLAG_APM		= 1 << 17,
+	MLX4_DEV_CAP_FLAG_ATOMIC	= 1 << 18,
+	MLX4_DEV_CAP_FLAG_RAW_MCAST	= 1 << 19,
+	MLX4_DEV_CAP_FLAG_UD_AV_PORT	= 1 << 20,
+	MLX4_DEV_CAP_FLAG_UD_MCAST	= 1 << 21
+};
+
+enum mlx4_event {
+	MLX4_EVENT_TYPE_COMP		   = 0x00,
+	MLX4_EVENT_TYPE_PATH_MIG	   = 0x01,
+	MLX4_EVENT_TYPE_COMM_EST	   = 0x02,
+	MLX4_EVENT_TYPE_SQ_DRAINED	   = 0x03,
+	MLX4_EVENT_TYPE_SRQ_QP_LAST_WQE	   = 0x13,
+	MLX4_EVENT_TYPE_SRQ_LIMIT	   = 0x14,
+	MLX4_EVENT_TYPE_CQ_ERROR	   = 0x04,
+	MLX4_EVENT_TYPE_WQ_CATAS_ERROR	   = 0x05,
+	MLX4_EVENT_TYPE_EEC_CATAS_ERROR	   = 0x06,
+	MLX4_EVENT_TYPE_PATH_MIG_FAILED	   = 0x07,
+	MLX4_EVENT_TYPE_WQ_INVAL_REQ_ERROR = 0x10,
+	MLX4_EVENT_TYPE_WQ_ACCESS_ERROR	   = 0x11,
+	MLX4_EVENT_TYPE_SRQ_CATAS_ERROR	   = 0x12,
+	MLX4_EVENT_TYPE_LOCAL_CATAS_ERROR  = 0x08,
+	MLX4_EVENT_TYPE_PORT_CHANGE	   = 0x09,
+	MLX4_EVENT_TYPE_EQ_OVERFLOW	   = 0x0f,
+	MLX4_EVENT_TYPE_ECC_DETECT	   = 0x0e,
+	MLX4_EVENT_TYPE_CMD		   = 0x0a
+};
+
+enum {
+	MLX4_PERM_LOCAL_READ	= 1 << 10,
+	MLX4_PERM_LOCAL_WRITE	= 1 << 11,
+	MLX4_PERM_REMOTE_READ	= 1 << 12,
+	MLX4_PERM_REMOTE_WRITE	= 1 << 13,
+	MLX4_PERM_ATOMIC	= 1 << 14
+};
+
+enum {
+	MLX4_OPCODE_NOP			= 0x00,
+	MLX4_OPCODE_SEND_INVAL		= 0x01,
+	MLX4_OPCODE_RDMA_WRITE		= 0x08,
+	MLX4_OPCODE_RDMA_WRITE_IMM	= 0x09,
+	MLX4_OPCODE_SEND		= 0x0a,
+	MLX4_OPCODE_SEND_IMM		= 0x0b,
+	MLX4_OPCODE_LSO			= 0x0e,
+	MLX4_OPCODE_RDMA_READ		= 0x10,
+	MLX4_OPCODE_ATOMIC_CS		= 0x11,
+	MLX4_OPCODE_ATOMIC_FA		= 0x12,
+	MLX4_OPCODE_ATOMIC_MASK_CS	= 0x14,
+	MLX4_OPCODE_ATOMIC_MASK_FA	= 0x15,
+	MLX4_OPCODE_BIND_MW		= 0x18,
+	MLX4_OPCODE_FMR			= 0x19,
+	MLX4_OPCODE_LOCAL_INVAL		= 0x1b,
+	MLX4_OPCODE_CONFIG_CMD		= 0x1f,
+
+	MLX4_RECV_OPCODE_RDMA_WRITE_IMM	= 0x00,
+	MLX4_RECV_OPCODE_SEND		= 0x01,
+	MLX4_RECV_OPCODE_SEND_IMM	= 0x02,
+	MLX4_RECV_OPCODE_SEND_INVAL	= 0x03,
+
+	MLX4_CQE_OPCODE_ERROR		= 0x1e,
+	MLX4_CQE_OPCODE_RESIZE		= 0x16,
+};
+
+enum {
+	MLX4_STAT_RATE_OFFSET	= 5
+};
+
+struct mlx4_caps {
+	u64			fw_ver;
+	int			num_ports;
+	int			vl_cap;
+	int			mtu_cap;
+	int			gid_table_len;
+	int			pkey_table_len;
+	int			local_ca_ack_delay;
+	int			num_uars;
+	int			max_sq_sg;
+	int			max_rq_sg;
+	int			num_qps;
+	int			max_wqes;
+	int			max_sq_desc_sz;
+	int			max_rq_desc_sz;
+	int			max_qp_init_rdma;
+	int			max_qp_dest_rdma;
+	int			reserved_qps;
+	int			sqp_start;
+	int			num_srqs;
+	int			max_srq_wqes;
+	int			max_srq_sge;
+	int			reserved_srqs;
+	int			num_cqs;
+	int			max_cqes;
+	int			reserved_cqs;
+	int			num_eqs;
+	int			reserved_eqs;
+	int			num_mpts;
+	int			num_mtt_segs;
+	int			fmr_reserved_mtts;
+	int			reserved_mtts;
+	int			reserved_mrws;
+	int			reserved_uars;
+	int			num_mgms;
+	int			num_amgms;
+	int			reserved_mcgs;
+	int			num_pds;
+	int			reserved_pds;
+	int			mtt_entry_sz;
+	u32			page_size_cap;
+	u32			flags;
+	u16			stat_rate_support;
+	u8			port_width_cap;
+};
+
+struct mlx4_buf_list {
+	void		       *buf;
+	dma_addr_t		map;
+};
+
+struct mlx4_buf {
+	union {
+		struct mlx4_buf_list	direct;
+		struct mlx4_buf_list   *page_list;
+	} u;
+	int			nbufs;
+	int			npages;
+	int			page_shift;
+};
+
+struct mlx4_mtt {
+	u32			first_seg;
+	int			order;
+	int			page_shift;
+};
+
+struct mlx4_mr {
+	struct mlx4_mtt		mtt;
+	u64			iova;
+	u64			size;
+	u32			key;
+	u32			pd;
+	u32			access;
+	int			enabled;
+};
+
+struct mlx4_uar {
+	unsigned long		pfn;
+	int			index;
+};
+
+struct mlx4_cq {
+	void (*comp)		(struct mlx4_cq *);
+	void (*event)		(struct mlx4_cq *, enum mlx4_event);
+
+	struct mlx4_uar	       *uar;
+
+	u32			cons_index;
+
+	__be32		       *set_ci_db;
+	__be32		       *arm_db;
+	int			arm_sn;
+
+	int			cqn;
+
+	atomic_t		refcount;
+	struct completion	free;
+};
+
+struct mlx4_qp {
+	void (*event)		(struct mlx4_qp *, enum mlx4_event);
+
+	int			qpn;
+
+	atomic_t		refcount;
+	struct completion	free;
+};
+
+struct mlx4_srq {
+	void (*event)		(struct mlx4_srq *, enum mlx4_event);
+
+	int			srqn;
+	int			max;
+	int			max_gs;
+	int			wqe_shift;
+
+	atomic_t		refcount;
+	struct completion	free;
+};
+
+struct mlx4_av {
+	__be32			port_pd;
+	u8			reserved1;
+	u8			g_slid;
+	__be16			dlid;
+	u8			reserved2;
+	u8			gid_index;
+	u8			stat_rate;
+	u8			hop_limit;
+	__be32			sl_tclass_flowlabel;
+	u8			dgid[16];
+};
+
+struct mlx4_dev {
+	struct pci_dev	       *pdev;
+	unsigned long		flags;
+	struct mlx4_caps	caps;
+	struct radix_tree_root	qp_table_tree;
+};
+
+struct mlx4_init_port_param {
+	int			set_guid0;
+	int			set_node_guid;
+	int			set_si_guid;
+	u16			mtu;
+	int			port_width_cap;
+	u16			vl_cap;
+	u16			max_gid;
+	u16			max_pkey;
+	u64			guid0;
+	u64			node_guid;
+	u64			si_guid;
+};
+
+int mlx4_buf_alloc(struct mlx4_dev *dev, int size, int max_direct,
+		   struct mlx4_buf *buf);
+void mlx4_buf_free(struct mlx4_dev *dev, int size, struct mlx4_buf *buf);
+
+int mlx4_pd_alloc(struct mlx4_dev *dev, u32 *pdn);
+void mlx4_pd_free(struct mlx4_dev *dev, u32 pdn);
+
+int mlx4_uar_alloc(struct mlx4_dev *dev, struct mlx4_uar *uar);
+void mlx4_uar_free(struct mlx4_dev *dev, struct mlx4_uar *uar);
+
+int mlx4_mtt_init(struct mlx4_dev *dev, int npages, int page_shift,
+		  struct mlx4_mtt *mtt);
+void mlx4_mtt_cleanup(struct mlx4_dev *dev, struct mlx4_mtt *mtt);
+u64 mlx4_mtt_addr(struct mlx4_dev *dev, struct mlx4_mtt *mtt);
+
+int mlx4_mr_alloc(struct mlx4_dev *dev, u32 pd, u64 iova, u64 size, u32 access,
+		  int npages, int page_shift, struct mlx4_mr *mr);
+void mlx4_mr_free(struct mlx4_dev *dev, struct mlx4_mr *mr);
+int mlx4_mr_enable(struct mlx4_dev *dev, struct mlx4_mr *mr);
+int mlx4_write_mtt(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
+		   int start_index, int npages, u64 *page_list);
+int mlx4_buf_write_mtt(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
+		       struct mlx4_buf *buf);
+
+int mlx4_cq_alloc(struct mlx4_dev *dev, int nent, struct mlx4_mtt *mtt,
+		  struct mlx4_uar *uar, u64 db_rec, struct mlx4_cq *cq);
+void mlx4_cq_free(struct mlx4_dev *dev, struct mlx4_cq *cq);
+
+int mlx4_qp_alloc(struct mlx4_dev *dev, int sqpn, struct mlx4_qp *qp);
+void mlx4_qp_free(struct mlx4_dev *dev, struct mlx4_qp *qp);
+
+int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, struct mlx4_mtt *mtt,
+		   u64 db_rec, struct mlx4_srq *srq);
+void mlx4_srq_free(struct mlx4_dev *dev, struct mlx4_srq *srq);
+int mlx4_srq_arm(struct mlx4_dev *dev, struct mlx4_srq *srq, int limit_watermark);
+
+int mlx4_INIT_PORT(struct mlx4_dev *dev, struct mlx4_init_port_param *param, int port);
+int mlx4_CLOSE_PORT(struct mlx4_dev *dev, int port);
+
+int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16]);
+int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16]);
+
+#endif /* MLX4_DEVICE_H */
diff --git a/include/linux/mlx4/doorbell.h b/include/linux/mlx4/doorbell.h
new file mode 100644
index 0000000..3f2da44
--- /dev/null
+++ b/include/linux/mlx4/doorbell.h
@@ -0,0 +1,97 @@
+/*
+ * Copyright (c) 2004 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005 Sun Microsystems, Inc. All rights reserved.
+ * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef MLX4_DOORBELL_H
+#define MLX4_DOORBELL_H
+
+#include <linux/types.h>
+#include <linux/io.h>
+
+#define MLX4_SEND_DOORBELL    0x14
+#define MLX4_CQ_DOORBELL      0x20
+
+#if BITS_PER_LONG == 64
+/*
+ * Assume that we can just write a 64-bit doorbell atomically.  s390
+ * actually doesn't have writeq() but S/390 systems don't even have
+ * PCI so we won't worry about it.
+ */
+
+#define MLX4_DECLARE_DOORBELL_LOCK(name)
+#define MLX4_INIT_DOORBELL_LOCK(ptr)    do { } while (0)
+#define MLX4_GET_DOORBELL_LOCK(ptr)      (NULL)
+
+static inline void mlx4_write64_raw(__be64 val, void __iomem *dest)
+{
+	__raw_writeq((__force u64) val, dest);
+}
+
+static inline void mlx4_write64(__be32 val[2], void __iomem *dest,
+				spinlock_t *doorbell_lock)
+{
+	__raw_writeq(*(u64 *) val, dest);
+}
+
+#else
+
+/*
+ * Just fall back to a spinlock to protect the doorbell if
+ * BITS_PER_LONG is 32 -- there's no portable way to do atomic 64-bit
+ * MMIO writes.
+ */
+
+#define MLX4_DECLARE_DOORBELL_LOCK(name) spinlock_t name;
+#define MLX4_INIT_DOORBELL_LOCK(ptr)     spin_lock_init(ptr)
+#define MLX4_GET_DOORBELL_LOCK(ptr)      (ptr)
+
+static inline void mlx4_write64_raw(__be64 val, void __iomem *dest)
+{
+	__raw_writel(((__force u32 *) &val)[0], dest);
+	__raw_writel(((__force u32 *) &val)[1], dest + 4);
+}
+
+static inline void mlx4_write64(__be32 val[2], void __iomem *dest,
+				spinlock_t *doorbell_lock)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(doorbell_lock, flags);
+	__raw_writel((__force u32) val[0], dest);
+	__raw_writel((__force u32) val[1], dest + 4);
+	spin_unlock_irqrestore(doorbell_lock, flags);
+}
+
+#endif
+
+#endif /* MLX4_DOORBELL_H */
diff --git a/include/linux/mlx4/driver.h b/include/linux/mlx4/driver.h
new file mode 100644
index 0000000..61925fc
--- /dev/null
+++ b/include/linux/mlx4/driver.h
@@ -0,0 +1,59 @@
+/*
+ * Copyright (c) 2006 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef MLX4_DRIVER_H
+#define MLX4_DRIVER_H
+
+#include <linux/device.h>
+
+struct mlx4_dev;
+
+enum mlx4_dev_event {
+	MLX4_DEV_EVENT_CATASTROPHIC_ERROR,
+	MLX4_DEV_EVENT_PORT_UP,
+	MLX4_DEV_EVENT_PORT_DOWN,
+	MLX4_DEV_EVENT_PORT_REINIT,
+};
+
+struct mlx4_interface {
+	void *			(*add)	 (struct mlx4_dev *dev);
+	void			(*remove)(struct mlx4_dev *dev, void *context);
+	void			(*event) (struct mlx4_dev *dev,
+					  enum mlx4_dev_event event,
+					  int port);
+	struct list_head	list;
+};
+
+int mlx4_register_interface(struct mlx4_interface *intf);
+void mlx4_unregister_interface(struct mlx4_interface *intf);
+
+#endif /* MLX4_DRIVER_H */
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
new file mode 100644
index 0000000..9eeb61a
--- /dev/null
+++ b/include/linux/mlx4/qp.h
@@ -0,0 +1,288 @@
+/*
+ * Copyright (c) 2007 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef MLX4_QP_H
+#define MLX4_QP_H
+
+#include <linux/types.h>
+
+#include <linux/mlx4/device.h>
+
+#define MLX4_INVALID_LKEY	0x100
+
+enum mlx4_qp_optpar {
+	MLX4_QP_OPTPAR_ALT_ADDR_PATH		= 1 << 0,
+	MLX4_QP_OPTPAR_RRE			= 1 << 1,
+	MLX4_QP_OPTPAR_RAE			= 1 << 2,
+	MLX4_QP_OPTPAR_RWE			= 1 << 3,
+	MLX4_QP_OPTPAR_PKEY_INDEX		= 1 << 4,
+	MLX4_QP_OPTPAR_Q_KEY			= 1 << 5,
+	MLX4_QP_OPTPAR_RNR_TIMEOUT		= 1 << 6,
+	MLX4_QP_OPTPAR_PRIMARY_ADDR_PATH	= 1 << 7,
+	MLX4_QP_OPTPAR_SRA_MAX			= 1 << 8,
+	MLX4_QP_OPTPAR_RRA_MAX			= 1 << 9,
+	MLX4_QP_OPTPAR_PM_STATE			= 1 << 10,
+	MLX4_QP_OPTPAR_RETRY_COUNT		= 1 << 12,
+	MLX4_QP_OPTPAR_RNR_RETRY		= 1 << 13,
+	MLX4_QP_OPTPAR_ACK_TIMEOUT		= 1 << 14,
+	MLX4_QP_OPTPAR_SCHED_QUEUE		= 1 << 16
+};
+
+enum mlx4_qp_state {
+	MLX4_QP_STATE_RST			= 0,
+	MLX4_QP_STATE_INIT			= 1,
+	MLX4_QP_STATE_RTR			= 2,
+	MLX4_QP_STATE_RTS			= 3,
+	MLX4_QP_STATE_SQER			= 4,
+	MLX4_QP_STATE_SQD			= 5,
+	MLX4_QP_STATE_ERR			= 6,
+	MLX4_QP_STATE_SQ_DRAINING		= 7,
+	MLX4_QP_NUM_STATE
+};
+
+enum {
+	MLX4_QP_ST_RC				= 0x0,
+	MLX4_QP_ST_UC				= 0x1,
+	MLX4_QP_ST_RD				= 0x2,
+	MLX4_QP_ST_UD				= 0x3,
+	MLX4_QP_ST_MLX				= 0x7
+};
+
+enum {
+	MLX4_QP_PM_MIGRATED			= 0x3,
+	MLX4_QP_PM_ARMED			= 0x0,
+	MLX4_QP_PM_REARM			= 0x1
+};
+
+enum {
+	/* params1 */
+	MLX4_QP_BIT_SRE				= 1 << 15,
+	MLX4_QP_BIT_SWE				= 1 << 14,
+	MLX4_QP_BIT_SAE				= 1 << 13,
+	/* params2 */
+	MLX4_QP_BIT_RRE				= 1 << 15,
+	MLX4_QP_BIT_RWE				= 1 << 14,
+	MLX4_QP_BIT_RAE				= 1 << 13,
+	MLX4_QP_BIT_RIC				= 1 <<	4,
+};
+
+struct mlx4_qp_path {
+	u8			fl;
+	u8			reserved1[2];
+	u8			pkey_index;
+	u8			reserved2;
+	u8			grh_mylmc;
+	__be16			rlid;
+	u8			ackto;
+	u8			mgid_index;
+	u8			static_rate;
+	u8			hop_limit;
+	__be32			tclass_flowlabel;
+	u8			rgid[16];
+	u8			sched_queue;
+	u8			snooper_flags;
+	u8			reserved3[2];
+	u8			counter_index;
+	u8			reserved4[7];
+};
+
+struct mlx4_qp_context {
+	__be32			flags;
+	__be32			pd;
+	u8			mtu_msgmax;
+	u8			rq_size_stride;
+	u8			sq_size_stride;
+	u8			rlkey;
+	__be32			usr_page;
+	__be32			local_qpn;
+	__be32			remote_qpn;
+	struct			mlx4_qp_path pri_path;
+	struct			mlx4_qp_path alt_path;
+	__be32			params1;
+	u32			reserved1;
+	__be32			next_send_psn;
+	__be32			cqn_send;
+	u32			reserved2[2];
+	__be32			last_acked_psn;
+	__be32			ssn;
+	__be32			params2;
+	__be32			rnr_nextrecvpsn;
+	__be32			srcd;
+	__be32			cqn_recv;
+	__be64			db_rec_addr;
+	__be32			qkey;
+	__be32			srqn;
+	__be32			msn;
+	__be16			rq_wqe_counter;
+	__be16			sq_wqe_counter;
+	u32			reserved3[2];
+	__be32			param3;
+	__be32			nummmcpeers_basemkey;
+	u8			log_page_size;
+	u8			reserved4[2];
+	u8			mtt_base_addr_h;
+	__be32			mtt_base_addr_l;
+	u32			reserved5[10];
+};
+
+enum {
+	MLX4_WQE_CTRL_FENCE	= 1 << 6,
+	MLX4_WQE_CTRL_CQ_UPDATE	= 3 << 2,
+	MLX4_WQE_CTRL_SOLICITED	= 1 << 1,
+};
+
+struct mlx4_wqe_ctrl_seg {
+	__be32			owner_opcode;
+	u8			reserved2[3];
+	u8			fence_size;
+	/*
+	 * High 24 bits are SRC remote buffer; low 8 bits are flags:
+	 * [7]   SO (strong ordering)
+	 * [5]   TCP/UDP checksum
+	 * [4]   IP checksum
+	 * [3:2] C (generate completion queue entry)
+	 * [1]   SE (solicited event)
+	 */
+	__be32			srcrb_flags;
+	/*
+	 * imm is immediate data for send/RDMA write w/ immediate;
+	 * also invalidation key for send with invalidate; input
+	 * modifier for WQEs on CCQs.
+	 */
+	__be32			imm;
+};
+
+enum {
+	MLX4_WQE_MLX_VL15	= 1 << 17,
+	MLX4_WQE_MLX_SLR	= 1 << 16
+};
+
+struct mlx4_wqe_mlx_seg {
+	u8			owner;
+	u8			reserved1[2];
+	u8			opcode;
+	u8			reserved2[3];
+	u8			size;
+	/*
+	 * [17]    VL15
+	 * [16]    SLR
+	 * [15:12] static rate
+	 * [11:8]  SL
+	 * [4]     ICRC
+	 * [3:2]   C
+	 * [0]     FL (force loopback)
+	 */
+	__be32			flags;
+	__be16			rlid;
+	u16			reserved3;
+};
+
+struct mlx4_wqe_datagram_seg {
+	__be32			av[8];
+	__be32			dqpn;
+	__be32			qkey;
+	__be32			reservd[2];
+};
+
+struct mlx4_wqe_bind_seg {
+	__be32			flags1;
+	__be32			flags2;
+	__be32			new_rkey;
+	__be32			lkey;
+	__be64			addr;
+	__be64			length;
+};
+
+struct mlx4_wqe_fmr_seg {
+	__be32			flags;
+	__be32			mem_key;
+	__be64			buf_list;
+	__be64			start_addr;
+	__be64			reg_len;
+	__be32			offset;
+	__be32			page_size;
+	u32			reserved[2];
+};
+
+struct mlx4_wqe_fmr_ext_seg {
+	u8			flags;
+	u8			reserved;
+	__be16			app_mask;
+	__be16			wire_app_tag;
+	__be16			mem_app_tag;
+	__be32			wire_ref_tag_base;
+	__be32			mem_ref_tag_base;
+};
+
+struct mlx4_wqe_local_inval_seg {
+	u8			flags;
+	u8			reserved1[3];
+	__be32			mem_key;
+	u8			reserved2[3];
+	u8			guest_id;
+	__be64			pa;
+};
+
+struct mlx4_wqe_raddr_seg {
+	__be64			raddr;
+	__be32			rkey;
+	u32			reserved;
+};
+
+struct mlx4_wqe_atomic_seg {
+	__be64			swap_add;
+	__be64			compare;
+};
+
+struct mlx4_wqe_data_seg {
+	__be32			byte_count;
+	__be32			lkey;
+	__be64			addr;
+};
+
+struct mlx4_wqe_inline_seg {
+	__be32			byte_count;
+};
+
+int mlx4_qp_modify(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
+		   enum mlx4_qp_state cur_state, enum mlx4_qp_state new_state,
+		   struct mlx4_qp_context *context, enum mlx4_qp_optpar optpar,
+		   int sqd_event, struct mlx4_qp *qp);
+
+static inline struct mlx4_qp *__mlx4_qp_lookup(struct mlx4_dev *dev, u32 qpn)
+{
+	return radix_tree_lookup(&dev->qp_table_tree, qpn & (dev->caps.num_qps - 1));
+}
+
+void mlx4_qp_remove(struct mlx4_dev *dev, struct mlx4_qp *qp);
+
+#endif /* MLX4_QP_H */
diff --git a/include/linux/mlx4/srq.h b/include/linux/mlx4/srq.h
new file mode 100644
index 0000000..799a069
--- /dev/null
+++ b/include/linux/mlx4/srq.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (c) 2007 Cisco Systems, Inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef MLX4_SRQ_H
+#define MLX4_SRQ_H
+
+struct mlx4_wqe_srq_next_seg {
+	u16			reserved1;
+	__be16			next_wqe_index;
+	u32			reserved2[3];
+};
+
+#endif /* MLX4_SRQ_H */
