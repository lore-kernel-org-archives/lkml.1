Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYAXPUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYAXPUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 10:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYAXPUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 10:20:22 -0500
Received: from mail0.scram.de ([78.47.204.202]:36487 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbYAXPUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 10:20:19 -0500
X-Spam-Score: -4.277
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.1 AWL AWL: From: address is in the auto white-list
Message-ID: <4798ACA5.5050106@scram.de>
Date: Thu, 24 Jan 2008 16:20:05 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: [PATCHv3 7/7] [POWERPC] Move definition of buffer descriptor to cpm.h
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buffer descriptors are used by both CPM1 and CPM2. Move the definitions
from the cpm dependent include file to common cpm.h

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 include/asm-powerpc/cpm.h  |   73 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-powerpc/cpm1.h |   65 ---------------------------------------
 include/asm-powerpc/cpm2.h |   64 --------------------------------------
 3 files changed, 73 insertions(+), 129 deletions(-)

diff --git a/include/asm-powerpc/cpm.h b/include/asm-powerpc/cpm.h
index fae83b1..77e39da 100644
--- a/include/asm-powerpc/cpm.h
+++ b/include/asm-powerpc/cpm.h
@@ -4,6 +4,79 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 
+/* Buffer descriptors used by many of the CPM protocols. */
+typedef struct cpm_buf_desc {
+	ushort	cbd_sc;		/* Status and Control */
+	ushort	cbd_datlen;	/* Data length in buffer */
+	uint	cbd_bufaddr;	/* Buffer address in host memory */
+} cbd_t;
+
+/* Buffer descriptor control/status used by serial
+ */
+
+#define BD_SC_EMPTY	(0x8000)	/* Receive is empty */
+#define BD_SC_READY	(0x8000)	/* Transmit is ready */
+#define BD_SC_WRAP	(0x2000)	/* Last buffer descriptor */
+#define BD_SC_INTRPT	(0x1000)	/* Interrupt on change */
+#define BD_SC_LAST	(0x0800)	/* Last buffer in frame */
+#define BD_SC_TC	(0x0400)	/* Transmit CRC */
+#define BD_SC_CM	(0x0200)	/* Continous mode */
+#define BD_SC_ID	(0x0100)	/* Rec'd too many idles */
+#define BD_SC_P		(0x0100)	/* xmt preamble */
+#define BD_SC_BR	(0x0020)	/* Break received */
+#define BD_SC_FR	(0x0010)	/* Framing error */
+#define BD_SC_PR	(0x0008)	/* Parity error */
+#define BD_SC_NAK	(0x0004)	/* NAK - did not respond */
+#define BD_SC_OV	(0x0002)	/* Overrun */
+#define BD_SC_UN	(0x0002)	/* Underrun */
+#define BD_SC_CD	(0x0001)	/* */
+#define BD_SC_CL	(0x0001)	/* Collision */
+
+/* Buffer descriptor control/status used by Ethernet receive.
+ * Common to SCC and FCC.
+ */
+#define BD_ENET_RX_EMPTY	(0x8000)
+#define BD_ENET_RX_WRAP		(0x2000)
+#define BD_ENET_RX_INTR		(0x1000)
+#define BD_ENET_RX_LAST		(0x0800)
+#define BD_ENET_RX_FIRST	(0x0400)
+#define BD_ENET_RX_MISS		(0x0100)
+#define BD_ENET_RX_BC		(0x0080)	/* FCC Only */
+#define BD_ENET_RX_MC		(0x0040)	/* FCC Only */
+#define BD_ENET_RX_LG		(0x0020)
+#define BD_ENET_RX_NO		(0x0010)
+#define BD_ENET_RX_SH		(0x0008)
+#define BD_ENET_RX_CR		(0x0004)
+#define BD_ENET_RX_OV		(0x0002)
+#define BD_ENET_RX_CL		(0x0001)
+#define BD_ENET_RX_STATS	(0x01ff)	/* All status bits */
+
+/* Buffer descriptor control/status used by Ethernet transmit.
+ * Common to SCC and FCC.
+ */
+#define BD_ENET_TX_READY	(0x8000)
+#define BD_ENET_TX_PAD		(0x4000)
+#define BD_ENET_TX_WRAP		(0x2000)
+#define BD_ENET_TX_INTR		(0x1000)
+#define BD_ENET_TX_LAST		(0x0800)
+#define BD_ENET_TX_TC		(0x0400)
+#define BD_ENET_TX_DEF		(0x0200)
+#define BD_ENET_TX_HB		(0x0100)
+#define BD_ENET_TX_LC		(0x0080)
+#define BD_ENET_TX_RL		(0x0040)
+#define BD_ENET_TX_RCMASK	(0x003c)
+#define BD_ENET_TX_UN		(0x0002)
+#define BD_ENET_TX_CSL		(0x0001)
+#define BD_ENET_TX_STATS	(0x03ff)	/* All status bits */
+
+/* Buffer descriptor control/status used by Transparent mode SCC.
+ */
+#define BD_SCC_TX_LAST		(0x0800)
+
+/* Buffer descriptor control/status used by I2C.
+ */
+#define BD_I2C_START		(0x0400)
+
 int cpm_muram_init(void);
 unsigned long cpm_muram_alloc(unsigned long size, unsigned long align);
 int cpm_muram_free(unsigned long offset);
diff --git a/include/asm-powerpc/cpm1.h b/include/asm-powerpc/cpm1.h
index 901a00b..b2ebd6a 100644
--- a/include/asm-powerpc/cpm1.h
+++ b/include/asm-powerpc/cpm1.h
@@ -91,32 +91,6 @@ extern void cpm_load_patch(cpm8xx_t *cp);
 
 extern void cpm_reset(void);
 
-/* Buffer descriptors used by many of the CPM protocols.
-*/
-typedef struct cpm_buf_desc {
-	ushort	cbd_sc;		/* Status and Control */
-	ushort	cbd_datlen;	/* Data length in buffer */
-	uint	cbd_bufaddr;	/* Buffer address in host memory */
-} cbd_t;
-
-#define BD_SC_EMPTY	((ushort)0x8000)	/* Receive is empty */
-#define BD_SC_READY	((ushort)0x8000)	/* Transmit is ready */
-#define BD_SC_WRAP	((ushort)0x2000)	/* Last buffer descriptor */
-#define BD_SC_INTRPT	((ushort)0x1000)	/* Interrupt on change */
-#define BD_SC_LAST	((ushort)0x0800)	/* Last buffer in frame */
-#define BD_SC_TC	((ushort)0x0400)	/* Transmit CRC */
-#define BD_SC_CM	((ushort)0x0200)	/* Continous mode */
-#define BD_SC_ID	((ushort)0x0100)	/* Rec'd too many idles */
-#define BD_SC_P		((ushort)0x0100)	/* xmt preamble */
-#define BD_SC_BR	((ushort)0x0020)	/* Break received */
-#define BD_SC_FR	((ushort)0x0010)	/* Framing error */
-#define BD_SC_PR	((ushort)0x0008)	/* Parity error */
-#define BD_SC_NAK	((ushort)0x0004)	/* NAK - did not respond */
-#define BD_SC_OV	((ushort)0x0002)	/* Overrun */
-#define BD_SC_UN	((ushort)0x0002)	/* Underrun */
-#define BD_SC_CD	((ushort)0x0001)	/* ?? */
-#define BD_SC_CL	((ushort)0x0001)	/* Collision */
-
 /* Parameter RAM offsets.
 */
 #define PROFF_SCC1	((uint)0x0000)
@@ -446,41 +420,6 @@ typedef struct scc_enet {
 #define SCC_PSMR_NIB22	((ushort)0x000a)	/* Start frame search */
 #define SCC_PSMR_FDE	((ushort)0x0001)	/* Full duplex enable */
 
-/* Buffer descriptor control/status used by Ethernet receive.
-*/
-#define BD_ENET_RX_EMPTY	((ushort)0x8000)
-#define BD_ENET_RX_WRAP		((ushort)0x2000)
-#define BD_ENET_RX_INTR		((ushort)0x1000)
-#define BD_ENET_RX_LAST		((ushort)0x0800)
-#define BD_ENET_RX_FIRST	((ushort)0x0400)
-#define BD_ENET_RX_MISS		((ushort)0x0100)
-#define BD_ENET_RX_LG		((ushort)0x0020)
-#define BD_ENET_RX_NO		((ushort)0x0010)
-#define BD_ENET_RX_SH		((ushort)0x0008)
-#define BD_ENET_RX_CR		((ushort)0x0004)
-#define BD_ENET_RX_OV		((ushort)0x0002)
-#define BD_ENET_RX_CL		((ushort)0x0001)
-#define BD_ENET_RX_BC		((ushort)0x0080)	/* DA is Broadcast */
-#define BD_ENET_RX_MC		((ushort)0x0040)	/* DA is Multicast */
-#define BD_ENET_RX_STATS	((ushort)0x013f)	/* All status bits */
-
-/* Buffer descriptor control/status used by Ethernet transmit.
-*/
-#define BD_ENET_TX_READY	((ushort)0x8000)
-#define BD_ENET_TX_PAD		((ushort)0x4000)
-#define BD_ENET_TX_WRAP		((ushort)0x2000)
-#define BD_ENET_TX_INTR		((ushort)0x1000)
-#define BD_ENET_TX_LAST		((ushort)0x0800)
-#define BD_ENET_TX_TC		((ushort)0x0400)
-#define BD_ENET_TX_DEF		((ushort)0x0200)
-#define BD_ENET_TX_HB		((ushort)0x0100)
-#define BD_ENET_TX_LC		((ushort)0x0080)
-#define BD_ENET_TX_RL		((ushort)0x0040)
-#define BD_ENET_TX_RCMASK	((ushort)0x003c)
-#define BD_ENET_TX_UN		((ushort)0x0002)
-#define BD_ENET_TX_CSL		((ushort)0x0001)
-#define BD_ENET_TX_STATS	((ushort)0x03ff)	/* All status bits */
-
 /* SCC as UART
 */
 typedef struct scc_uart {
@@ -549,8 +488,6 @@ typedef struct scc_trans {
 	uint	st_cmask;	/* Constant mask for CRC */
 } scc_trans_t;
 
-#define BD_SCC_TX_LAST		((ushort)0x0800)
-
 /* IIC parameter RAM.
 */
 typedef struct iic {
@@ -574,8 +511,6 @@ typedef struct iic {
 	char	res2[2];	/* Reserved */
 } iic_t;
 
-#define BD_IIC_START		((ushort)0x0400)
-
 /* SPI parameter RAM.
 */
 typedef struct spi {
diff --git a/include/asm-powerpc/cpm2.h b/include/asm-powerpc/cpm2.h
index f1112c1..b93a53e 100644
--- a/include/asm-powerpc/cpm2.h
+++ b/include/asm-powerpc/cpm2.h
@@ -132,29 +132,6 @@ extern void cpm_setbrg(uint brg, uint rate);
 extern void cpm2_fastbrg(uint brg, uint rate, int div16);
 extern void cpm2_reset(void);
 
-
-/* Buffer descriptors used by many of the CPM protocols.
-*/
-typedef struct cpm_buf_desc {
-	ushort	cbd_sc;		/* Status and Control */
-	ushort	cbd_datlen;	/* Data length in buffer */
-	uint	cbd_bufaddr;	/* Buffer address in host memory */
-} cbd_t;
-
-#define BD_SC_EMPTY	((ushort)0x8000)	/* Receive is empty */
-#define BD_SC_READY	((ushort)0x8000)	/* Transmit is ready */
-#define BD_SC_WRAP	((ushort)0x2000)	/* Last buffer descriptor */
-#define BD_SC_INTRPT	((ushort)0x1000)	/* Interrupt on change */
-#define BD_SC_LAST	((ushort)0x0800)	/* Last buffer in frame */
-#define BD_SC_CM	((ushort)0x0200)	/* Continous mode */
-#define BD_SC_ID	((ushort)0x0100)	/* Rec'd too many idles */
-#define BD_SC_P		((ushort)0x0100)	/* xmt preamble */
-#define BD_SC_BR	((ushort)0x0020)	/* Break received */
-#define BD_SC_FR	((ushort)0x0010)	/* Framing error */
-#define BD_SC_PR	((ushort)0x0008)	/* Parity error */
-#define BD_SC_OV	((ushort)0x0002)	/* Overrun */
-#define BD_SC_CD	((ushort)0x0001)	/* ?? */
-
 /* Function code bits, usually generic to devices.
 */
 #define CPMFCR_GBL	((u_char)0x20)	/* Set memory snooping */
@@ -456,43 +433,6 @@ typedef struct scc_enet {
 #define SCC_PSMR_NIB22	((ushort)0x000a)	/* Start frame search */
 #define SCC_PSMR_FDE	((ushort)0x0001)	/* Full duplex enable */
 
-/* Buffer descriptor control/status used by Ethernet receive.
- * Common to SCC and FCC.
- */
-#define BD_ENET_RX_EMPTY	((ushort)0x8000)
-#define BD_ENET_RX_WRAP		((ushort)0x2000)
-#define BD_ENET_RX_INTR		((ushort)0x1000)
-#define BD_ENET_RX_LAST		((ushort)0x0800)
-#define BD_ENET_RX_FIRST	((ushort)0x0400)
-#define BD_ENET_RX_MISS		((ushort)0x0100)
-#define BD_ENET_RX_BC		((ushort)0x0080)	/* FCC Only */
-#define BD_ENET_RX_MC		((ushort)0x0040)	/* FCC Only */
-#define BD_ENET_RX_LG		((ushort)0x0020)
-#define BD_ENET_RX_NO		((ushort)0x0010)
-#define BD_ENET_RX_SH		((ushort)0x0008)
-#define BD_ENET_RX_CR		((ushort)0x0004)
-#define BD_ENET_RX_OV		((ushort)0x0002)
-#define BD_ENET_RX_CL		((ushort)0x0001)
-#define BD_ENET_RX_STATS	((ushort)0x01ff)	/* All status bits */
-
-/* Buffer descriptor control/status used by Ethernet transmit.
- * Common to SCC and FCC.
- */
-#define BD_ENET_TX_READY	((ushort)0x8000)
-#define BD_ENET_TX_PAD		((ushort)0x4000)
-#define BD_ENET_TX_WRAP		((ushort)0x2000)
-#define BD_ENET_TX_INTR		((ushort)0x1000)
-#define BD_ENET_TX_LAST		((ushort)0x0800)
-#define BD_ENET_TX_TC		((ushort)0x0400)
-#define BD_ENET_TX_DEF		((ushort)0x0200)
-#define BD_ENET_TX_HB		((ushort)0x0100)
-#define BD_ENET_TX_LC		((ushort)0x0080)
-#define BD_ENET_TX_RL		((ushort)0x0040)
-#define BD_ENET_TX_RCMASK	((ushort)0x003c)
-#define BD_ENET_TX_UN		((ushort)0x0002)
-#define BD_ENET_TX_CSL		((ushort)0x0001)
-#define BD_ENET_TX_STATS	((ushort)0x03ff)	/* All status bits */
-
 /* SCC as UART
 */
 typedef struct scc_uart {
@@ -562,8 +502,6 @@ typedef struct scc_trans {
 	uint	st_cmask;	/* Constant mask for CRC */
 } scc_trans_t;
 
-#define BD_SCC_TX_LAST		((ushort)0x0800)
-
 /* How about some FCCs.....
 */
 #define FCC_GFMR_DIAG_NORM	((uint)0x00000000)
@@ -769,8 +707,6 @@ typedef struct spi {
 
 #define SPI_EB		((u_char)0x10)		/* big endian byte order */
 
-#define BD_IIC_START		((ushort)0x0400)
-
 /* IDMA parameter RAM
 */
 typedef struct idma {
-- 
1.5.3.8

