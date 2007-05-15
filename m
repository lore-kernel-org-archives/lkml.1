Return-Path: <linux-kernel-owner+w=401wt.eu-S933646AbXEOKKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbXEOKKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 06:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759141AbXEOKKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 06:10:42 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:3516 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758782AbXEOKKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 06:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=kW62QoEFdKxGETDxGtz9XNovKir0bJfMBVBU5BV1XV/t2U9mgcMDBGqBEJCWzLdW2ONMDLcqFhHygzUlZ3+szXagkpmP2kWGUMpfUBNAJoVzOzxlWWiQEZXrZAhzGy+1qAypEGrBxkH6GmAsE4vigN0/f+yvDieGRh/8EqnajqM=
Message-ID: <bd345f9c0705150310yca61812s5204ef8449042ddf@mail.gmail.com>
Date: Tue, 15 May 2007 12:10:40 +0200
From: "Morten Banzon" <morten.banzon@gmail.com>
To: galak@kernel.crashing.org
Subject: [PATCH] PPC : MPC82xx MCC parameter structures and definitions
Cc: linux-kernel@vger.kernel.org,
       "Morten Banzon (HA/ETO)" <morten.banzon@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

from: Morten Banzon <morten.banzon@ericsson.com>

Adds MPC82xx MCC parameter structures and definitions to the file
include/asm-ppc/cpm2.h.

signed-off-by: Morten Banzon <morten.banzon@ericsson.com>

---
The patch applies to linux-2.6.21.1


diff -uprN linux-2.6.21.1.orig/include/asm-ppc/cpm2.h
linux-2.6.21.1/include/asm-ppc/cpm2.h
--- linux-2.6.21.1.orig/include/asm-ppc/cpm2.h  2007-04-27
23:49:26.000000000 +0200
+++ linux-2.6.21.1/include/asm-ppc/cpm2.h       2007-05-15
11:09:54.000000000 +0200
@@ -41,6 +41,7 @@
 #define CPM_CR_IDMA3_SBLOCK    (0x16)
 #define CPM_CR_IDMA4_SBLOCK    (0x17)
 #define CPM_CR_MCC1_SBLOCK     (0x1c)
+#define CPM_CR_MCC2_SBLOCK     (0x1d)

 #define CPM_CR_FCC_SBLOCK(x)   (x + 0x10)

@@ -72,11 +73,16 @@
 #define CPM_CR_INIT_RX         ((ushort)0x0001)
 #define CPM_CR_INIT_TX         ((ushort)0x0002)
 #define CPM_CR_HUNT_MODE       ((ushort)0x0003)
+#define CPM_CR_INIT_MCC_TRX    ((ushort)0x0003)
 #define CPM_CR_STOP_TX         ((ushort)0x0004)
 #define CPM_CR_GRA_STOP_TX     ((ushort)0x0005)
+#define CPM_CR_INIT_MCC_TX     ((ushort)0x0005)
+#define CPM_CR_INIT_MCC_RX     ((ushort)0x0006)
 #define CPM_CR_RESTART_TX      ((ushort)0x0006)
+#define CPM_CR_MCC_RESET       ((ushort)0x0007)
 #define CPM_CR_SET_GADDR       ((ushort)0x0008)
 #define CPM_CR_START_IDMA      ((ushort)0x0009)
+#define CPM_CR_STOP_RX         ((ushort)0x0009)
 #define CPM_CR_STOP_IDMA       ((ushort)0x000b)

 #define mk_cr_cmd(PG, SBC, MCN, OP) \
@@ -555,6 +561,186 @@ typedef struct scc_trans {

 #define BD_SCC_TX_LAST         ((ushort)0x0800)

+
+/* Global MCC Parameters.
+ * These parameters are stored in Parameter RAM, i.e. DPRAM2.
+ * MCC1 global parameters are stored in the first 128 bytes of page 8.
+ * MCC2 global parameters are stored in the first 128 bytes of page 9.
+ */
+typedef struct mcc_param {
+       uint    mccbase;        /* Multi-channel controller base pointer */
+       ushort  mccstate;       /* Multi-channel controller state */
+       ushort  mrblr;          /* Max. receive buffer length */
+       ushort  grfthr;         /* Global receive frame threshold */
+       ushort  grfcnt;         /* Global receive frame count */
+       uint    rinttmp;        /* Temp. location for holding the receive */
+                               /* interrupt queue entry */
+       uint    data0;          /* Temp. location for holding data */
+       uint    data1;          /* Temp. location for holding data */
+       uint    tintbase;       /* Multi-channel transmitter circular */
+                               /* interrupt table base address */
+       uint    tintptr;        /* Pointer to the transmitter circular */
+                               /* interrupt table. */
+       uint    tinttmp;        /* Temp. location for holding the transmit */
+                               /* interrrupt queue entry */
+       ushort  sctpbase;       /* Internal pointer for the super channel */
+                               /* transmit table */
+       ushort  reserved;
+       uint    c_mask32;       /* CRC constant */
+       ushort  xtrabase;       /* Pointer to the beginning of the extra */
+                               /* parameters information */
+       ushort  c_mask16;       /* CRC constant */
+       uint    rinttmp0;       /* Temp. location for holding a receive */
+       uint    rinttmp1;       /* circular interrupt table entry for */
+       uint    rinttmp2;       /* tables 0-3 */
+       uint    rinttmp3;
+       uint    rintbase0;      /* Multi-channel receiver circular interrupt */
+                               /* table base address */
+       uint    rintptr0;       /* Pointer to the receiver circular table. */
+       uint    rintbase1;
+       uint    rintptr1;
+       uint    rintbase2;
+       uint    rintptr2;
+       uint    rintbase3;
+       uint    rintptr3;
+       uint    ts_tmp;         /* Temp. place for time stamp */
+} mcc_param_t;
+
+
+/* MCC Channel Extra Parameters.
+ */
+typedef struct mcc_chan_xtra {
+       ushort  tbase;          /* TxBD base address */
+       ushort  tbptr;          /* TxBD pointer */
+       ushort  rbase;          /* RxBD base address */
+       ushort  rbptr;          /* RxBD pointer */
+} mcc_chan_xtra_t;
+
+
+/* MCC Channel-Specific HDLC Parameters.
+ * MCC Internal Transmitter State (TSTATE)
+ */
+#define MCC_TSTATE_GBL         ((uint)0x20000000)      /* Activates snooping */
+#define MCC_TSTATE_BO_BIG      ((uint)0x18000000)      /* Byte ordering */
+#define MCC_TSTATE_BO_LITTLE   ((uint)0x08000000)
+#define MCC_TSTATE_TC2         ((uint)0x04000000)      /* Transfer code */
+#define MCC_TSTATE_DTB         ((uint)0x02000000)      /* Data bus */
+#define MCC_TSTATE_BDB         ((uint)0x01000000)      /* BD bus */
+
+
+/* MCC Channel Mode Register (CHAMR)
+ */
+#define MCC_CHAMR_MODE ((ushort)0x8000)        /* Channel mode */
+#define MCC_CHAMR_POL  ((ushort)0x4000)        /* Polling */
+#define MCC_CHAMR_MBS  ((ushort)0x2000)        /* Must be set */
+#define MCC_CHAMR_IDLM ((ushort)0x1000)        /* Idle mode */
+#define MCC_CHAMR_CRC  ((ushort)0x0080)        /* CRC mode */
+#define MCC_CHAMR_TS   ((ushort)0x0020)        /* Time stamp */
+#define MCC_CHAMR_RQN3 ((ushort)0x0018)        /* Receive queue number 3 */
+#define MCC_CHAMR_RQN2 ((ushort)0x0010)        /* Receive queue number 2 */
+#define MCC_CHAMR_RQN1 ((ushort)0x0008)        /* Receive queue number 1 */
+#define MCC_CHAMR_RQN0 ((ushort)0x0000)        /* Receive queue number 0 */
+
+
+/* MCC Internal Receiver State (RSTATE)
+ */
+#define MCC_RSTATE_GBL         ((uint)0x20000000)      /* Activates snooping */
+#define MCC_RSTATE_BO_BIG      ((uint)0x18000000)      /* Byte ordering */
+#define MCC_RSTATE_BO_LITTLE   ((uint)0x08000000)
+#define MCC_RSTATE_TC2         ((uint)0x04000000)      /* Transfer code */
+#define MCC_RSTATE_DTB         ((uint)0x02000000)      /* Data bus */
+#define MCC_RSTATE_BDB         ((uint)0x01000000)      /* BD bus */
+
+
+typedef struct mcc_chan_hdlc {
+       uint    tstate;         /* Tx internal state */
+       uint    zistate;        /* Zero-insertion machine state */
+       uint    zidata0;        /* Zero-insertion high word data buffer */
+       uint    zidata1;        /* Zero-insertion low word data buffer */
+       ushort  tbdflags;       /* TxBD flags */
+       ushort  tbdcnt;         /* Tx internal byte count */
+       uint    tbdptr;         /* Tx internal data pointer */
+       ushort  intmsk;         /* Channel's interrupt mask */
+       ushort  chamr;          /* Channel mode register */
+       uint    tcrc;           /* Temp transmit CRC */
+       uint    rstate;         /* Rx internal state */
+       uint    zdstate;        /* Zero-deletion machine state */
+       uint    zddata0;        /* Zero-deletion high word data buffer */
+       uint    zddata1;        /* Zero-deletion low word data buffer */
+       ushort  rbdflags;       /* RxBD flags */
+       ushort  rbdcnt;         /* Rx internal byte count */
+       uint    rbdptr;         /* Rx internal data pointer */
+       ushort  mflr;           /* Max. frame length register */
+       ushort  max_cnt;        /* Max_length counter */
+       uint    rcrc;           /* Temp. receive CRC */
+} mcc_chan_hdlc_t;
+
+
+/* MCC Configuration Register (MCCFx)
+ */
+#define MCC_MCCF_TDM_D ((u_char)0x03)
+#define MCC_MCCF_TDM_C ((u_char)0x02)
+#define MCC_MCCF_TDM_B ((u_char)0x01)
+#define MCC_MCCF_TDM_A ((u_char)0x00)
+
+
+/* MCC Event and Mask Register.
+ */
+#define MCCM_QOV0      ((ushort)0x8000)        /* Rx int. queue overflow */
+#define MCCM_RINT0     ((ushort)0x4000)        /* Rx interrupt */
+#define MCCM_QOV1      ((ushort)0x2000)
+#define MCCM_RINT1     ((ushort)0x1000)
+#define MCCM_QOV2      ((ushort)0x0800)
+#define MCCM_RINT2     ((ushort)0x0400)
+#define MCCM_QOV3      ((ushort)0x0200)
+#define MCCM_RINT3     ((ushort)0x0100)
+#define MCCM_TQOV      ((ushort)0x0008)        /* Tx int. queue overflow */
+#define MCCM_TINT      ((ushort)0x0004)        /* Tx interrupt */
+#define MCCM_GUN       ((ushort)0x0002)        /* Global tx underrun */
+#define MCCM_GOV       ((ushort)0x0001)        /* Global rx overrun */
+
+
+/* MCC Interrupt Table Entries.
+ */
+#define MCCI_V         ((uint)0x80000000)      /* Valid bit */
+#define MCCI_W         ((uint)0x40000000)      /* Wrap bit */
+#define MCCI_UN                ((uint)0x02000000)      /* Tx no data */
+#define MCCI_TXB       ((uint)0x01000000)      /* Tx buffer */
+#define MCCI_NID       ((uint)0x00200000)      /* Not idle pattern */
+#define MCCI_IDL       ((uint)0x00100000)      /* Idle */
+#define MCCI_MRF       ((uint)0x00080000)      /* Rx frame length violation */
+#define MCCI_RXF       ((uint)0x00040000)      /* Rx frame */
+#define MCCI_BSY       ((uint)0x00020000)      /* Busy */
+#define MCCI_RXB       ((uint)0x00010000)      /* Rx buffer */
+#define MCCI_CHAN      ((uint)0x00003FC0)      /* Channel number mask */
+
+
+/* MCC Receive Buffer Descriptor.
+ */
+#define BD_MCC_RX_E    ((ushort)0x8000)        /* Empty */
+#define BD_MCC_RX_W    ((ushort)0x2000)        /* Wrap */
+#define BD_MCC_RX_I    ((ushort)0x1000)        /* Interrupt */
+#define BD_MCC_RX_L    ((ushort)0x0800)        /* Last */
+#define BD_MCC_RX_F    ((ushort)0x0400)        /* First in frame */
+#define BD_MCC_RX_CM   ((ushort)0x0200)        /* Continuous mode */
+#define BD_MCC_RX_UB   ((ushort)0x0080)        /* User bit */
+#define BD_MCC_RX_LG   ((ushort)0x0020)        /* Frame length violation */
+#define BD_MCC_RX_NO   ((ushort)0x0010)        /* Nonoctet-aligned frame */
+#define BD_MCC_RX_AB   ((ushort)0x0008)        /* Abort sequence */
+#define BD_MCC_RX_CR   ((ushort)0x0004)        /* CRC error */
+
+
+/* MCC Transmit Buffer Descriptor.
+ */
+#define BD_MCC_TX_R    ((ushort)0x8000)        /* Ready */
+#define BD_MCC_TX_W    ((ushort)0x2000)        /* Wrap */
+#define BD_MCC_TX_I    ((ushort)0x1000)        /* Interrupt */
+#define BD_MCC_TX_L    ((ushort)0x0800)        /* Last */
+#define BD_MCC_TX_TC   ((ushort)0x0400)        /* CRC */
+#define BD_MCC_TX_CM   ((ushort)0x0200)        /* Continuous mode */
+#define BD_MCC_TX_UB   ((ushort)0x0080)        /* User bit */
+
+
 /* How about some FCCs.....
 */
 #define FCC_GFMR_DIAG_NORM     ((uint)0x00000000)
