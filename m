Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab0CKOkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:40:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:35446 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab0CKOkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:40:47 -0500
Date: Thu, 11 Mar 2010 14:40:13 GMT
From: tip-bot for Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100310204458.GA28835@sgi.com>
References: <20100310204458.GA28835@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Clean up UV headers for MMR definitions
Message-ID: <tip-6f4edd69e40aba4f45bf9558c1e9a950d79ab4e4@git.kernel.org>
Git-Commit-ID: 6f4edd69e40aba4f45bf9558c1e9a950d79ab4e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Mar 2010 14:40:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f4edd69e40aba4f45bf9558c1e9a950d79ab4e4
Gitweb:     http://git.kernel.org/tip/6f4edd69e40aba4f45bf9558c1e9a950d79ab4e4
Author:     Jack Steiner <steiner@sgi.com>
AuthorDate: Wed, 10 Mar 2010 14:44:58 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 11 Mar 2010 14:11:26 +0100

x86, UV: Clean up UV headers for MMR definitions

Update UV mmr definitions header file. Eliminate definitions no
longer needed. Move 2 definitions from tlb_uv.c into the header
file where they belong.

Signed-off-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20100310204458.GA28835@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_mmrs.h |  528 ++++++-------------------------------
 arch/x86/kernel/tlb_uv.c          |   10 +-
 2 files changed, 85 insertions(+), 453 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_mmrs.h b/arch/x86/include/asm/uv/uv_mmrs.h
index 2cae46c..b2f2d2e 100644
--- a/arch/x86/include/asm/uv/uv_mmrs.h
+++ b/arch/x86/include/asm/uv/uv_mmrs.h
@@ -1,4 +1,3 @@
-
 /*
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
@@ -15,13 +14,25 @@
 #define UV_MMR_ENABLE		(1UL << 63)
 
 /* ========================================================================= */
+/*                          UVH_BAU_DATA_BROADCAST                           */
+/* ========================================================================= */
+#define UVH_BAU_DATA_BROADCAST 0x61688UL
+#define UVH_BAU_DATA_BROADCAST_32 0x0440
+
+#define UVH_BAU_DATA_BROADCAST_ENABLE_SHFT 0
+#define UVH_BAU_DATA_BROADCAST_ENABLE_MASK 0x0000000000000001UL
+
+union uvh_bau_data_broadcast_u {
+    unsigned long	v;
+    struct uvh_bau_data_broadcast_s {
+	unsigned long	enable :  1;  /* RW */
+	unsigned long	rsvd_1_63: 63;  /*    */
+    } s;
+};
+
+/* ========================================================================= */
 /*                           UVH_BAU_DATA_CONFIG                             */
 /* ========================================================================= */
-#define UVH_LB_BAU_MISC_CONTROL 0x320170UL
-#define UV_ENABLE_INTD_SOFT_ACK_MODE_SHIFT 15
-#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHIFT 16
-#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD 0x000000000bUL
-/* 1011 timebase 7 (168millisec) * 3 ticks -> 500ms */
 #define UVH_BAU_DATA_CONFIG 0x61680UL
 #define UVH_BAU_DATA_CONFIG_32 0x0438
 
@@ -604,6 +615,68 @@ union uvh_lb_bau_intd_software_acknowledge_u {
 #define UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS_32 0x0a70
 
 /* ========================================================================= */
+/*                         UVH_LB_BAU_MISC_CONTROL                           */
+/* ========================================================================= */
+#define UVH_LB_BAU_MISC_CONTROL 0x320170UL
+#define UVH_LB_BAU_MISC_CONTROL_32 0x00a10
+
+#define UVH_LB_BAU_MISC_CONTROL_REJECTION_DELAY_SHFT 0
+#define UVH_LB_BAU_MISC_CONTROL_REJECTION_DELAY_MASK 0x00000000000000ffUL
+#define UVH_LB_BAU_MISC_CONTROL_APIC_MODE_SHFT 8
+#define UVH_LB_BAU_MISC_CONTROL_APIC_MODE_MASK 0x0000000000000100UL
+#define UVH_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_SHFT 9
+#define UVH_LB_BAU_MISC_CONTROL_FORCE_BROADCAST_MASK 0x0000000000000200UL
+#define UVH_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_SHFT 10
+#define UVH_LB_BAU_MISC_CONTROL_FORCE_LOCK_NOP_MASK 0x0000000000000400UL
+#define UVH_LB_BAU_MISC_CONTROL_CSI_AGENT_PRESENCE_VECTOR_SHFT 11
+#define UVH_LB_BAU_MISC_CONTROL_CSI_AGENT_PRESENCE_VECTOR_MASK 0x0000000000003800UL
+#define UVH_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_SHFT 14
+#define UVH_LB_BAU_MISC_CONTROL_DESCRIPTOR_FETCH_MODE_MASK 0x0000000000004000UL
+#define UVH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT 15
+#define UVH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_MASK 0x0000000000008000UL
+#define UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT 16
+#define UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_MASK 0x00000000000f0000UL
+#define UVH_LB_BAU_MISC_CONTROL_ENABLE_DUAL_MAPPING_MODE_SHFT 20
+#define UVH_LB_BAU_MISC_CONTROL_ENABLE_DUAL_MAPPING_MODE_MASK 0x0000000000100000UL
+#define UVH_LB_BAU_MISC_CONTROL_VGA_IO_PORT_DECODE_ENABLE_SHFT 21
+#define UVH_LB_BAU_MISC_CONTROL_VGA_IO_PORT_DECODE_ENABLE_MASK 0x0000000000200000UL
+#define UVH_LB_BAU_MISC_CONTROL_VGA_IO_PORT_16_BIT_DECODE_SHFT 22
+#define UVH_LB_BAU_MISC_CONTROL_VGA_IO_PORT_16_BIT_DECODE_MASK 0x0000000000400000UL
+#define UVH_LB_BAU_MISC_CONTROL_SUPPRESS_DEST_REGISTRATION_SHFT 23
+#define UVH_LB_BAU_MISC_CONTROL_SUPPRESS_DEST_REGISTRATION_MASK 0x0000000000800000UL
+#define UVH_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_SHFT 24
+#define UVH_LB_BAU_MISC_CONTROL_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000007000000UL
+#define UVH_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_SHFT 27
+#define UVH_LB_BAU_MISC_CONTROL_USE_INCOMING_PRIORITY_MASK 0x0000000008000000UL
+#define UVH_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_SHFT 28
+#define UVH_LB_BAU_MISC_CONTROL_ENABLE_PROGRAMMED_INITIAL_PRIORITY_MASK 0x0000000010000000UL
+#define UVH_LB_BAU_MISC_CONTROL_FUN_SHFT 48
+#define UVH_LB_BAU_MISC_CONTROL_FUN_MASK 0xffff000000000000UL
+
+union uvh_lb_bau_misc_control_u {
+    unsigned long	v;
+    struct uvh_lb_bau_misc_control_s {
+	unsigned long	rejection_delay                    :  8;  /* RW */
+	unsigned long	apic_mode                          :  1;  /* RW */
+	unsigned long	force_broadcast                    :  1;  /* RW */
+	unsigned long	force_lock_nop                     :  1;  /* RW */
+	unsigned long	csi_agent_presence_vector          :  3;  /* RW */
+	unsigned long	descriptor_fetch_mode              :  1;  /* RW */
+	unsigned long	enable_intd_soft_ack_mode          :  1;  /* RW */
+	unsigned long	intd_soft_ack_timeout_period       :  4;  /* RW */
+	unsigned long	enable_dual_mapping_mode           :  1;  /* RW */
+	unsigned long	vga_io_port_decode_enable          :  1;  /* RW */
+	unsigned long	vga_io_port_16_bit_decode          :  1;  /* RW */
+	unsigned long	suppress_dest_registration         :  1;  /* RW */
+	unsigned long	programmed_initial_priority        :  3;  /* RW */
+	unsigned long	use_incoming_priority              :  1;  /* RW */
+	unsigned long	enable_programmed_initial_priority :  1;  /* RW */
+	unsigned long	rsvd_29_47                         : 19;  /*    */
+	unsigned long	fun                                : 16;  /* RW */
+    } s;
+};
+
+/* ========================================================================= */
 /*                     UVH_LB_BAU_SB_ACTIVATION_CONTROL                      */
 /* ========================================================================= */
 #define UVH_LB_BAU_SB_ACTIVATION_CONTROL 0x320020UL
@@ -681,334 +754,6 @@ union uvh_lb_bau_sb_descriptor_base_u {
 };
 
 /* ========================================================================= */
-/*                      UVH_LB_MCAST_AOERR0_RPT_ENABLE                       */
-/* ========================================================================= */
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE 0x50b20UL
-
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_OBESE_MSG_SHFT 0
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_OBESE_MSG_MASK 0x0000000000000001UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_DATA_SB_ERR_SHFT 1
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_DATA_SB_ERR_MASK 0x0000000000000002UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_NACK_BUFF_PARITY_SHFT 2
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_NACK_BUFF_PARITY_MASK 0x0000000000000004UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_TIMEOUT_SHFT 3
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_TIMEOUT_MASK 0x0000000000000008UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_INACTIVE_REPLY_SHFT 4
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_INACTIVE_REPLY_MASK 0x0000000000000010UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_UPGRADE_ERROR_SHFT 5
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_UPGRADE_ERROR_MASK 0x0000000000000020UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_REG_COUNT_UNDERFLOW_SHFT 6
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_REG_COUNT_UNDERFLOW_MASK 0x0000000000000040UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_REP_OBESE_MSG_SHFT 7
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MCAST_REP_OBESE_MSG_MASK 0x0000000000000080UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REQ_RUNT_MSG_SHFT 8
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REQ_RUNT_MSG_MASK 0x0000000000000100UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REQ_OBESE_MSG_SHFT 9
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REQ_OBESE_MSG_MASK 0x0000000000000200UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REQ_DATA_SB_ERR_SHFT 10
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REQ_DATA_SB_ERR_MASK 0x0000000000000400UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_RUNT_MSG_SHFT 11
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_RUNT_MSG_MASK 0x0000000000000800UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_OBESE_MSG_SHFT 12
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_OBESE_MSG_MASK 0x0000000000001000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_DATA_SB_ERR_SHFT 13
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_DATA_SB_ERR_MASK 0x0000000000002000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_COMMAND_ERR_SHFT 14
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_REP_COMMAND_ERR_MASK 0x0000000000004000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_PEND_TIMEOUT_SHFT 15
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_UCACHE_PEND_TIMEOUT_MASK 0x0000000000008000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REQ_RUNT_MSG_SHFT 16
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REQ_RUNT_MSG_MASK 0x0000000000010000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REQ_OBESE_MSG_SHFT 17
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REQ_OBESE_MSG_MASK 0x0000000000020000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REQ_DATA_SB_ERR_SHFT 18
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REQ_DATA_SB_ERR_MASK 0x0000000000040000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_RUNT_MSG_SHFT 19
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_RUNT_MSG_MASK 0x0000000000080000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_OBESE_MSG_SHFT 20
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_OBESE_MSG_MASK 0x0000000000100000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_DATA_SB_ERR_SHFT 21
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_REP_DATA_SB_ERR_MASK 0x0000000000200000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_AMO_TIMEOUT_SHFT 22
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_AMO_TIMEOUT_MASK 0x0000000000400000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_PUT_TIMEOUT_SHFT 23
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_PUT_TIMEOUT_MASK 0x0000000000800000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_SPURIOUS_EVENT_SHFT 24
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_MACC_SPURIOUS_EVENT_MASK 0x0000000001000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IOH_DESTINATION_TABLE_PARITY_SHFT 25
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IOH_DESTINATION_TABLE_PARITY_MASK 0x0000000002000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_HAD_ERROR_REPLY_SHFT 26
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_HAD_ERROR_REPLY_MASK 0x0000000004000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_TIMEOUT_SHFT 27
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_GET_TIMEOUT_MASK 0x0000000008000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_LOCK_MANAGER_HAD_ERROR_REPLY_SHFT 28
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_LOCK_MANAGER_HAD_ERROR_REPLY_MASK 0x0000000010000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_HAD_ERROR_REPLY_SHFT 29
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_HAD_ERROR_REPLY_MASK 0x0000000020000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_TIMEOUT_SHFT 30
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_PUT_TIMEOUT_MASK 0x0000000040000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SB_ACTIVATION_OVERRUN_SHFT 31
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SB_ACTIVATION_OVERRUN_MASK 0x0000000080000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_HAD_ERROR_REPLY_SHFT 32
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_HAD_ERROR_REPLY_MASK 0x0000000100000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_TIMEOUT_SHFT 33
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_COMPLETED_GB_ACTIVATION_TIMEOUT_MASK 0x0000000200000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_0_PARITY_SHFT 34
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_0_PARITY_MASK 0x0000000400000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_1_PARITY_SHFT 35
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_DESCRIPTOR_BUFFER_1_PARITY_MASK 0x0000000800000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SOCKET_DESTINATION_TABLE_PARITY_SHFT 36
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_SOCKET_DESTINATION_TABLE_PARITY_MASK 0x0000001000000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_BAU_REPLY_PAYLOAD_CORRUPTION_SHFT 37
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_BAU_REPLY_PAYLOAD_CORRUPTION_MASK 0x0000002000000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IO_PORT_DESTINATION_TABLE_PARITY_SHFT 38
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_IO_PORT_DESTINATION_TABLE_PARITY_MASK 0x0000004000000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INTD_SOFT_ACK_TIMEOUT_SHFT 39
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INTD_SOFT_ACK_TIMEOUT_MASK 0x0000008000000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_OBESE_MSG_SHFT 40
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_OBESE_MSG_MASK 0x0000010000000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_COMMAND_ERR_SHFT 41
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_REP_COMMAND_ERR_MASK 0x0000020000000000UL
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_TIMEOUT_SHFT 42
-#define UVH_LB_MCAST_AOERR0_RPT_ENABLE_INT_TIMEOUT_MASK 0x0000040000000000UL
-
-union uvh_lb_mcast_aoerr0_rpt_enable_u {
-    unsigned long	v;
-    struct uvh_lb_mcast_aoerr0_rpt_enable_s {
-	unsigned long	mcast_obese_msg                         :  1;  /* RW */
-	unsigned long	mcast_data_sb_err                       :  1;  /* RW */
-	unsigned long	mcast_nack_buff_parity                  :  1;  /* RW */
-	unsigned long	mcast_timeout                           :  1;  /* RW */
-	unsigned long	mcast_inactive_reply                    :  1;  /* RW */
-	unsigned long	mcast_upgrade_error                     :  1;  /* RW */
-	unsigned long	mcast_reg_count_underflow               :  1;  /* RW */
-	unsigned long	mcast_rep_obese_msg                     :  1;  /* RW */
-	unsigned long	ucache_req_runt_msg                     :  1;  /* RW */
-	unsigned long	ucache_req_obese_msg                    :  1;  /* RW */
-	unsigned long	ucache_req_data_sb_err                  :  1;  /* RW */
-	unsigned long	ucache_rep_runt_msg                     :  1;  /* RW */
-	unsigned long	ucache_rep_obese_msg                    :  1;  /* RW */
-	unsigned long	ucache_rep_data_sb_err                  :  1;  /* RW */
-	unsigned long	ucache_rep_command_err                  :  1;  /* RW */
-	unsigned long	ucache_pend_timeout                     :  1;  /* RW */
-	unsigned long	macc_req_runt_msg                       :  1;  /* RW */
-	unsigned long	macc_req_obese_msg                      :  1;  /* RW */
-	unsigned long	macc_req_data_sb_err                    :  1;  /* RW */
-	unsigned long	macc_rep_runt_msg                       :  1;  /* RW */
-	unsigned long	macc_rep_obese_msg                      :  1;  /* RW */
-	unsigned long	macc_rep_data_sb_err                    :  1;  /* RW */
-	unsigned long	macc_amo_timeout                        :  1;  /* RW */
-	unsigned long	macc_put_timeout                        :  1;  /* RW */
-	unsigned long	macc_spurious_event                     :  1;  /* RW */
-	unsigned long	ioh_destination_table_parity            :  1;  /* RW */
-	unsigned long	get_had_error_reply                     :  1;  /* RW */
-	unsigned long	get_timeout                             :  1;  /* RW */
-	unsigned long	lock_manager_had_error_reply            :  1;  /* RW */
-	unsigned long	put_had_error_reply                     :  1;  /* RW */
-	unsigned long	put_timeout                             :  1;  /* RW */
-	unsigned long	sb_activation_overrun                   :  1;  /* RW */
-	unsigned long	completed_gb_activation_had_error_reply :  1;  /* RW */
-	unsigned long	completed_gb_activation_timeout         :  1;  /* RW */
-	unsigned long	descriptor_buffer_0_parity              :  1;  /* RW */
-	unsigned long	descriptor_buffer_1_parity              :  1;  /* RW */
-	unsigned long	socket_destination_table_parity         :  1;  /* RW */
-	unsigned long	bau_reply_payload_corruption            :  1;  /* RW */
-	unsigned long	io_port_destination_table_parity        :  1;  /* RW */
-	unsigned long	intd_soft_ack_timeout                   :  1;  /* RW */
-	unsigned long	int_rep_obese_msg                       :  1;  /* RW */
-	unsigned long	int_rep_command_err                     :  1;  /* RW */
-	unsigned long	int_timeout                             :  1;  /* RW */
-	unsigned long	rsvd_43_63                              : 21;  /*    */
-    } s;
-};
-
-/* ========================================================================= */
-/*                          UVH_LOCAL_INT0_CONFIG                            */
-/* ========================================================================= */
-#define UVH_LOCAL_INT0_CONFIG 0x61000UL
-
-#define UVH_LOCAL_INT0_CONFIG_VECTOR_SHFT 0
-#define UVH_LOCAL_INT0_CONFIG_VECTOR_MASK 0x00000000000000ffUL
-#define UVH_LOCAL_INT0_CONFIG_DM_SHFT 8
-#define UVH_LOCAL_INT0_CONFIG_DM_MASK 0x0000000000000700UL
-#define UVH_LOCAL_INT0_CONFIG_DESTMODE_SHFT 11
-#define UVH_LOCAL_INT0_CONFIG_DESTMODE_MASK 0x0000000000000800UL
-#define UVH_LOCAL_INT0_CONFIG_STATUS_SHFT 12
-#define UVH_LOCAL_INT0_CONFIG_STATUS_MASK 0x0000000000001000UL
-#define UVH_LOCAL_INT0_CONFIG_P_SHFT 13
-#define UVH_LOCAL_INT0_CONFIG_P_MASK 0x0000000000002000UL
-#define UVH_LOCAL_INT0_CONFIG_T_SHFT 15
-#define UVH_LOCAL_INT0_CONFIG_T_MASK 0x0000000000008000UL
-#define UVH_LOCAL_INT0_CONFIG_M_SHFT 16
-#define UVH_LOCAL_INT0_CONFIG_M_MASK 0x0000000000010000UL
-#define UVH_LOCAL_INT0_CONFIG_APIC_ID_SHFT 32
-#define UVH_LOCAL_INT0_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
-
-union uvh_local_int0_config_u {
-    unsigned long	v;
-    struct uvh_local_int0_config_s {
-	unsigned long	vector_  :  8;  /* RW */
-	unsigned long	dm       :  3;  /* RW */
-	unsigned long	destmode :  1;  /* RW */
-	unsigned long	status   :  1;  /* RO */
-	unsigned long	p        :  1;  /* RO */
-	unsigned long	rsvd_14  :  1;  /*    */
-	unsigned long	t        :  1;  /* RO */
-	unsigned long	m        :  1;  /* RW */
-	unsigned long	rsvd_17_31: 15;  /*    */
-	unsigned long	apic_id  : 32;  /* RW */
-    } s;
-};
-
-/* ========================================================================= */
-/*                          UVH_LOCAL_INT0_ENABLE                            */
-/* ========================================================================= */
-#define UVH_LOCAL_INT0_ENABLE 0x65000UL
-
-#define UVH_LOCAL_INT0_ENABLE_LB_HCERR_SHFT 0
-#define UVH_LOCAL_INT0_ENABLE_LB_HCERR_MASK 0x0000000000000001UL
-#define UVH_LOCAL_INT0_ENABLE_GR0_HCERR_SHFT 1
-#define UVH_LOCAL_INT0_ENABLE_GR0_HCERR_MASK 0x0000000000000002UL
-#define UVH_LOCAL_INT0_ENABLE_GR1_HCERR_SHFT 2
-#define UVH_LOCAL_INT0_ENABLE_GR1_HCERR_MASK 0x0000000000000004UL
-#define UVH_LOCAL_INT0_ENABLE_LH_HCERR_SHFT 3
-#define UVH_LOCAL_INT0_ENABLE_LH_HCERR_MASK 0x0000000000000008UL
-#define UVH_LOCAL_INT0_ENABLE_RH_HCERR_SHFT 4
-#define UVH_LOCAL_INT0_ENABLE_RH_HCERR_MASK 0x0000000000000010UL
-#define UVH_LOCAL_INT0_ENABLE_XN_HCERR_SHFT 5
-#define UVH_LOCAL_INT0_ENABLE_XN_HCERR_MASK 0x0000000000000020UL
-#define UVH_LOCAL_INT0_ENABLE_SI_HCERR_SHFT 6
-#define UVH_LOCAL_INT0_ENABLE_SI_HCERR_MASK 0x0000000000000040UL
-#define UVH_LOCAL_INT0_ENABLE_LB_AOERR0_SHFT 7
-#define UVH_LOCAL_INT0_ENABLE_LB_AOERR0_MASK 0x0000000000000080UL
-#define UVH_LOCAL_INT0_ENABLE_GR0_AOERR0_SHFT 8
-#define UVH_LOCAL_INT0_ENABLE_GR0_AOERR0_MASK 0x0000000000000100UL
-#define UVH_LOCAL_INT0_ENABLE_GR1_AOERR0_SHFT 9
-#define UVH_LOCAL_INT0_ENABLE_GR1_AOERR0_MASK 0x0000000000000200UL
-#define UVH_LOCAL_INT0_ENABLE_LH_AOERR0_SHFT 10
-#define UVH_LOCAL_INT0_ENABLE_LH_AOERR0_MASK 0x0000000000000400UL
-#define UVH_LOCAL_INT0_ENABLE_RH_AOERR0_SHFT 11
-#define UVH_LOCAL_INT0_ENABLE_RH_AOERR0_MASK 0x0000000000000800UL
-#define UVH_LOCAL_INT0_ENABLE_XN_AOERR0_SHFT 12
-#define UVH_LOCAL_INT0_ENABLE_XN_AOERR0_MASK 0x0000000000001000UL
-#define UVH_LOCAL_INT0_ENABLE_SI_AOERR0_SHFT 13
-#define UVH_LOCAL_INT0_ENABLE_SI_AOERR0_MASK 0x0000000000002000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_AOERR1_SHFT 14
-#define UVH_LOCAL_INT0_ENABLE_LB_AOERR1_MASK 0x0000000000004000UL
-#define UVH_LOCAL_INT0_ENABLE_GR0_AOERR1_SHFT 15
-#define UVH_LOCAL_INT0_ENABLE_GR0_AOERR1_MASK 0x0000000000008000UL
-#define UVH_LOCAL_INT0_ENABLE_GR1_AOERR1_SHFT 16
-#define UVH_LOCAL_INT0_ENABLE_GR1_AOERR1_MASK 0x0000000000010000UL
-#define UVH_LOCAL_INT0_ENABLE_LH_AOERR1_SHFT 17
-#define UVH_LOCAL_INT0_ENABLE_LH_AOERR1_MASK 0x0000000000020000UL
-#define UVH_LOCAL_INT0_ENABLE_RH_AOERR1_SHFT 18
-#define UVH_LOCAL_INT0_ENABLE_RH_AOERR1_MASK 0x0000000000040000UL
-#define UVH_LOCAL_INT0_ENABLE_XN_AOERR1_SHFT 19
-#define UVH_LOCAL_INT0_ENABLE_XN_AOERR1_MASK 0x0000000000080000UL
-#define UVH_LOCAL_INT0_ENABLE_SI_AOERR1_SHFT 20
-#define UVH_LOCAL_INT0_ENABLE_SI_AOERR1_MASK 0x0000000000100000UL
-#define UVH_LOCAL_INT0_ENABLE_RH_VPI_INT_SHFT 21
-#define UVH_LOCAL_INT0_ENABLE_RH_VPI_INT_MASK 0x0000000000200000UL
-#define UVH_LOCAL_INT0_ENABLE_SYSTEM_SHUTDOWN_INT_SHFT 22
-#define UVH_LOCAL_INT0_ENABLE_SYSTEM_SHUTDOWN_INT_MASK 0x0000000000400000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_0_SHFT 23
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_0_MASK 0x0000000000800000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_1_SHFT 24
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_1_MASK 0x0000000001000000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_2_SHFT 25
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_2_MASK 0x0000000002000000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_3_SHFT 26
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_3_MASK 0x0000000004000000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_4_SHFT 27
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_4_MASK 0x0000000008000000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_5_SHFT 28
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_5_MASK 0x0000000010000000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_6_SHFT 29
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_6_MASK 0x0000000020000000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_7_SHFT 30
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_7_MASK 0x0000000040000000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_8_SHFT 31
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_8_MASK 0x0000000080000000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_9_SHFT 32
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_9_MASK 0x0000000100000000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_10_SHFT 33
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_10_MASK 0x0000000200000000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_11_SHFT 34
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_11_MASK 0x0000000400000000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_12_SHFT 35
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_12_MASK 0x0000000800000000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_13_SHFT 36
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_13_MASK 0x0000001000000000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_14_SHFT 37
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_14_MASK 0x0000002000000000UL
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_15_SHFT 38
-#define UVH_LOCAL_INT0_ENABLE_LB_IRQ_INT_15_MASK 0x0000004000000000UL
-#define UVH_LOCAL_INT0_ENABLE_L1_NMI_INT_SHFT 39
-#define UVH_LOCAL_INT0_ENABLE_L1_NMI_INT_MASK 0x0000008000000000UL
-#define UVH_LOCAL_INT0_ENABLE_STOP_CLOCK_SHFT 40
-#define UVH_LOCAL_INT0_ENABLE_STOP_CLOCK_MASK 0x0000010000000000UL
-#define UVH_LOCAL_INT0_ENABLE_ASIC_TO_L1_SHFT 41
-#define UVH_LOCAL_INT0_ENABLE_ASIC_TO_L1_MASK 0x0000020000000000UL
-#define UVH_LOCAL_INT0_ENABLE_L1_TO_ASIC_SHFT 42
-#define UVH_LOCAL_INT0_ENABLE_L1_TO_ASIC_MASK 0x0000040000000000UL
-#define UVH_LOCAL_INT0_ENABLE_LTC_INT_SHFT 43
-#define UVH_LOCAL_INT0_ENABLE_LTC_INT_MASK 0x0000080000000000UL
-#define UVH_LOCAL_INT0_ENABLE_LA_SEQ_TRIGGER_SHFT 44
-#define UVH_LOCAL_INT0_ENABLE_LA_SEQ_TRIGGER_MASK 0x0000100000000000UL
-
-union uvh_local_int0_enable_u {
-    unsigned long	v;
-    struct uvh_local_int0_enable_s {
-	unsigned long	lb_hcerr            :  1;  /* RW */
-	unsigned long	gr0_hcerr           :  1;  /* RW */
-	unsigned long	gr1_hcerr           :  1;  /* RW */
-	unsigned long	lh_hcerr            :  1;  /* RW */
-	unsigned long	rh_hcerr            :  1;  /* RW */
-	unsigned long	xn_hcerr            :  1;  /* RW */
-	unsigned long	si_hcerr            :  1;  /* RW */
-	unsigned long	lb_aoerr0           :  1;  /* RW */
-	unsigned long	gr0_aoerr0          :  1;  /* RW */
-	unsigned long	gr1_aoerr0          :  1;  /* RW */
-	unsigned long	lh_aoerr0           :  1;  /* RW */
-	unsigned long	rh_aoerr0           :  1;  /* RW */
-	unsigned long	xn_aoerr0           :  1;  /* RW */
-	unsigned long	si_aoerr0           :  1;  /* RW */
-	unsigned long	lb_aoerr1           :  1;  /* RW */
-	unsigned long	gr0_aoerr1          :  1;  /* RW */
-	unsigned long	gr1_aoerr1          :  1;  /* RW */
-	unsigned long	lh_aoerr1           :  1;  /* RW */
-	unsigned long	rh_aoerr1           :  1;  /* RW */
-	unsigned long	xn_aoerr1           :  1;  /* RW */
-	unsigned long	si_aoerr1           :  1;  /* RW */
-	unsigned long	rh_vpi_int          :  1;  /* RW */
-	unsigned long	system_shutdown_int :  1;  /* RW */
-	unsigned long	lb_irq_int_0        :  1;  /* RW */
-	unsigned long	lb_irq_int_1        :  1;  /* RW */
-	unsigned long	lb_irq_int_2        :  1;  /* RW */
-	unsigned long	lb_irq_int_3        :  1;  /* RW */
-	unsigned long	lb_irq_int_4        :  1;  /* RW */
-	unsigned long	lb_irq_int_5        :  1;  /* RW */
-	unsigned long	lb_irq_int_6        :  1;  /* RW */
-	unsigned long	lb_irq_int_7        :  1;  /* RW */
-	unsigned long	lb_irq_int_8        :  1;  /* RW */
-	unsigned long	lb_irq_int_9        :  1;  /* RW */
-	unsigned long	lb_irq_int_10       :  1;  /* RW */
-	unsigned long	lb_irq_int_11       :  1;  /* RW */
-	unsigned long	lb_irq_int_12       :  1;  /* RW */
-	unsigned long	lb_irq_int_13       :  1;  /* RW */
-	unsigned long	lb_irq_int_14       :  1;  /* RW */
-	unsigned long	lb_irq_int_15       :  1;  /* RW */
-	unsigned long	l1_nmi_int          :  1;  /* RW */
-	unsigned long	stop_clock          :  1;  /* RW */
-	unsigned long	asic_to_l1          :  1;  /* RW */
-	unsigned long	l1_to_asic          :  1;  /* RW */
-	unsigned long	ltc_int             :  1;  /* RW */
-	unsigned long	la_seq_trigger      :  1;  /* RW */
-	unsigned long	rsvd_45_63          : 19;  /*    */
-    } s;
-};
-
-/* ========================================================================= */
 /*                               UVH_NODE_ID                                 */
 /* ========================================================================= */
 #define UVH_NODE_ID 0x0UL
@@ -1112,26 +857,6 @@ union uvh_rh_gam_alias210_redirect_config_2_mmr_u {
 };
 
 /* ========================================================================= */
-/*                    UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR                      */
-/* ========================================================================= */
-#define UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR 0x1600020UL
-
-#define UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR_BASE_SHFT 26
-#define UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR_BASE_MASK 0x00003ffffc000000UL
-#define UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR_ENABLE_SHFT 63
-#define UVH_RH_GAM_CFG_OVERLAY_CONFIG_MMR_ENABLE_MASK 0x8000000000000000UL
-
-union uvh_rh_gam_cfg_overlay_config_mmr_u {
-    unsigned long	v;
-    struct uvh_rh_gam_cfg_overlay_config_mmr_s {
-	unsigned long	rsvd_0_25: 26;  /*    */
-	unsigned long	base   : 20;  /* RW */
-	unsigned long	rsvd_46_62: 17;  /*    */
-	unsigned long	enable :  1;  /* RW */
-    } s;
-};
-
-/* ========================================================================= */
 /*                    UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR                      */
 /* ========================================================================= */
 #define UVH_RH_GAM_GRU_OVERLAY_CONFIG_MMR 0x1600010UL
@@ -1263,101 +988,6 @@ union uvh_rtc1_int_config_u {
 };
 
 /* ========================================================================= */
-/*                           UVH_RTC2_INT_CONFIG                             */
-/* ========================================================================= */
-#define UVH_RTC2_INT_CONFIG 0x61600UL
-
-#define UVH_RTC2_INT_CONFIG_VECTOR_SHFT 0
-#define UVH_RTC2_INT_CONFIG_VECTOR_MASK 0x00000000000000ffUL
-#define UVH_RTC2_INT_CONFIG_DM_SHFT 8
-#define UVH_RTC2_INT_CONFIG_DM_MASK 0x0000000000000700UL
-#define UVH_RTC2_INT_CONFIG_DESTMODE_SHFT 11
-#define UVH_RTC2_INT_CONFIG_DESTMODE_MASK 0x0000000000000800UL
-#define UVH_RTC2_INT_CONFIG_STATUS_SHFT 12
-#define UVH_RTC2_INT_CONFIG_STATUS_MASK 0x0000000000001000UL
-#define UVH_RTC2_INT_CONFIG_P_SHFT 13
-#define UVH_RTC2_INT_CONFIG_P_MASK 0x0000000000002000UL
-#define UVH_RTC2_INT_CONFIG_T_SHFT 15
-#define UVH_RTC2_INT_CONFIG_T_MASK 0x0000000000008000UL
-#define UVH_RTC2_INT_CONFIG_M_SHFT 16
-#define UVH_RTC2_INT_CONFIG_M_MASK 0x0000000000010000UL
-#define UVH_RTC2_INT_CONFIG_APIC_ID_SHFT 32
-#define UVH_RTC2_INT_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
-
-union uvh_rtc2_int_config_u {
-    unsigned long	v;
-    struct uvh_rtc2_int_config_s {
-	unsigned long	vector_  :  8;  /* RW */
-	unsigned long	dm       :  3;  /* RW */
-	unsigned long	destmode :  1;  /* RW */
-	unsigned long	status   :  1;  /* RO */
-	unsigned long	p        :  1;  /* RO */
-	unsigned long	rsvd_14  :  1;  /*    */
-	unsigned long	t        :  1;  /* RO */
-	unsigned long	m        :  1;  /* RW */
-	unsigned long	rsvd_17_31: 15;  /*    */
-	unsigned long	apic_id  : 32;  /* RW */
-    } s;
-};
-
-/* ========================================================================= */
-/*                           UVH_RTC3_INT_CONFIG                             */
-/* ========================================================================= */
-#define UVH_RTC3_INT_CONFIG 0x61640UL
-
-#define UVH_RTC3_INT_CONFIG_VECTOR_SHFT 0
-#define UVH_RTC3_INT_CONFIG_VECTOR_MASK 0x00000000000000ffUL
-#define UVH_RTC3_INT_CONFIG_DM_SHFT 8
-#define UVH_RTC3_INT_CONFIG_DM_MASK 0x0000000000000700UL
-#define UVH_RTC3_INT_CONFIG_DESTMODE_SHFT 11
-#define UVH_RTC3_INT_CONFIG_DESTMODE_MASK 0x0000000000000800UL
-#define UVH_RTC3_INT_CONFIG_STATUS_SHFT 12
-#define UVH_RTC3_INT_CONFIG_STATUS_MASK 0x0000000000001000UL
-#define UVH_RTC3_INT_CONFIG_P_SHFT 13
-#define UVH_RTC3_INT_CONFIG_P_MASK 0x0000000000002000UL
-#define UVH_RTC3_INT_CONFIG_T_SHFT 15
-#define UVH_RTC3_INT_CONFIG_T_MASK 0x0000000000008000UL
-#define UVH_RTC3_INT_CONFIG_M_SHFT 16
-#define UVH_RTC3_INT_CONFIG_M_MASK 0x0000000000010000UL
-#define UVH_RTC3_INT_CONFIG_APIC_ID_SHFT 32
-#define UVH_RTC3_INT_CONFIG_APIC_ID_MASK 0xffffffff00000000UL
-
-union uvh_rtc3_int_config_u {
-    unsigned long	v;
-    struct uvh_rtc3_int_config_s {
-	unsigned long	vector_  :  8;  /* RW */
-	unsigned long	dm       :  3;  /* RW */
-	unsigned long	destmode :  1;  /* RW */
-	unsigned long	status   :  1;  /* RO */
-	unsigned long	p        :  1;  /* RO */
-	unsigned long	rsvd_14  :  1;  /*    */
-	unsigned long	t        :  1;  /* RO */
-	unsigned long	m        :  1;  /* RW */
-	unsigned long	rsvd_17_31: 15;  /*    */
-	unsigned long	apic_id  : 32;  /* RW */
-    } s;
-};
-
-/* ========================================================================= */
-/*                            UVH_RTC_INC_RATIO                              */
-/* ========================================================================= */
-#define UVH_RTC_INC_RATIO 0x350000UL
-
-#define UVH_RTC_INC_RATIO_FRACTION_SHFT 0
-#define UVH_RTC_INC_RATIO_FRACTION_MASK 0x00000000000fffffUL
-#define UVH_RTC_INC_RATIO_RATIO_SHFT 20
-#define UVH_RTC_INC_RATIO_RATIO_MASK 0x0000000000700000UL
-
-union uvh_rtc_inc_ratio_u {
-    unsigned long	v;
-    struct uvh_rtc_inc_ratio_s {
-	unsigned long	fraction : 20;  /* RW */
-	unsigned long	ratio    :  3;  /* RW */
-	unsigned long	rsvd_23_63: 41;  /*    */
-    } s;
-};
-
-/* ========================================================================= */
 /*                          UVH_SI_ADDR_MAP_CONFIG                           */
 /* ========================================================================= */
 #define UVH_SI_ADDR_MAP_CONFIG 0xc80000UL
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 364d015..ef68ba4 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -20,6 +20,8 @@
 #include <asm/tsc.h>
 #include <asm/irq_vectors.h>
 
+#define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD	0x000000000bUL
+
 static struct bau_control	**uv_bau_table_bases __read_mostly;
 static int			uv_bau_retry_limit __read_mostly;
 
@@ -478,16 +480,16 @@ static void uv_enable_timeouts(void)
 		 * To program the period, the SOFT_ACK_MODE must be off.
 		 */
 		mmr_image &= ~((unsigned long)1 <<
-			       UV_ENABLE_INTD_SOFT_ACK_MODE_SHIFT);
+		    UVH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT);
 		uv_write_global_mmr64
 		    (pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
 		/*
 		 * Set the 4-bit period.
 		 */
 		mmr_image &= ~((unsigned long)0xf <<
-			UV_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHIFT);
+		     UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT);
 		mmr_image |= (UV_INTD_SOFT_ACK_TIMEOUT_PERIOD <<
-			     UV_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHIFT);
+		     UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT);
 		uv_write_global_mmr64
 		    (pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
 		/*
@@ -496,7 +498,7 @@ static void uv_enable_timeouts(void)
 		 * indicated in bits 2:0 (7 causes all of them to timeout).
 		 */
 		mmr_image |= ((unsigned long)1 <<
-			      UV_ENABLE_INTD_SOFT_ACK_MODE_SHIFT);
+		    UVH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT);
 		uv_write_global_mmr64
 		    (pnode, UVH_LB_BAU_MISC_CONTROL, mmr_image);
 	}
