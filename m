Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbYJ2W7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbYJ2W7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755720AbYJ2Wqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:46:31 -0400
Received: from kroah.org ([198.145.64.141]:56285 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756482AbYJ2WqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:46:15 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: "vijaykumar@bravegnu.org" <vijaykumar@bravegnu.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 42/49] Staging: poch: Rx control register init
Date: Wed, 29 Oct 2008 15:40:09 -0700
Message-Id: <1225320016-21803-42-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: vijaykumar@bravegnu.org <vijaykumar@bravegnu.org>

Added Rx control register definition. Flush Rx FIFO on init, and set
continuous DMA mode.

Signed-off-by: Vijay Kumar <vijaykumar@bravegnu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/poch/poch.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/poch/poch.c b/drivers/staging/poch/poch.c
index b54760f..0a3eca1 100644
--- a/drivers/staging/poch/poch.c
+++ b/drivers/staging/poch/poch.c
@@ -126,9 +126,11 @@
 #define FPGA_INT_TX_ACQ_DONE		(0x1 << 1)
 #define FPGA_INT_RX_ACQ_DONE		(0x1)
 
-#define FPGA_RX_ADC_CTL_REG		0x214
-#define FPGA_RX_ADC_CTL_CONT_CAP	(0x0)
-#define FPGA_RX_ADC_CTL_SNAP_CAP	(0x1)
+#define FPGA_RX_CTL_REG			0x214
+#define FPGA_RX_CTL_FIFO_FLUSH      	(0x1 << 9)
+#define FPGA_RX_CTL_SYNTH_DATA		(0x1 << 8)
+#define FPGA_RX_CTL_CONT_CAP		(0x0 << 1)
+#define FPGA_RX_CTL_SNAP_CAP		(0x1 << 1)
 
 #define FPGA_RX_ARM_REG			0x21C
 
@@ -819,6 +821,11 @@ static int poch_open(struct inode *inode, struct file *filp)
 		iowrite32(FPGA_TX_CTL_FIFO_FLUSH
 			  | FPGA_TX_CTL_OUTPUT_CARDBUS,
 			  fpga + FPGA_TX_CTL_REG);
+	} else {
+		/* Flush RX FIFO and output data to cardbus. */
+		iowrite32(FPGA_RX_CTL_CONT_CAP
+			  | FPGA_RX_CTL_FIFO_FLUSH,
+			  fpga + FPGA_RX_CTL_REG);
 	}
 
 	atomic_inc(&channel->inited);
-- 
1.6.0.2

