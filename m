Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbYCETDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbYCETDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 14:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbYCETDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 14:03:08 -0500
Received: from havoc.gtf.org ([69.61.125.42]:34613 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbYCETDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 14:03:07 -0500
Date: Wed, 5 Mar 2008 14:03:04 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mvsas: fill in error info record bits
Message-ID: <20080305190304.GA13286@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This describes the first dword of struct mvs_err_info, two-dword error
information record that is returned when RXQ_ERR bit is asserted.

These bits are necessary for proper error handling.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index d4a6ac3..ec4dda0 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -511,7 +511,35 @@ enum status_buffer {
 };
 
 enum error_info_rec {
-	CMD_ISS_STPD	=  (1U << 31),	/* Cmd Issue Stopped */
+	CMD_ISS_STPD	= (1U << 31),	/* Cmd Issue Stopped */
+	CMD_PI_ERR	= (1U << 30),	/* Protection info error.  see flags2 */
+	RSP_OVER	= (1U << 29),	/* rsp buffer overflow */
+	RETRY_LIM	= (1U << 28),	/* FIS/frame retry limit exceeded */
+	UNK_FIS		= (1U << 27),	/* unknown FIS */
+	DMA_TERM	= (1U << 26),	/* DMA terminate primitive rx'd */
+	SYNC_ERR	= (1U << 25),	/* SYNC rx'd during frame xmit */
+	TFILE_ERR	= (1U << 24),	/* SATA taskfile Error bit set */
+	R_ERR		= (1U << 23),	/* SATA returned R_ERR prim */
+	RD_OFS		= (1U << 20),	/* Read DATA frame invalid offset *?
+	XFER_RDY_OFS	= (1U << 19),	/* XFER_RDY offset error */
+	UNEXP_XFER_RDY	= (1U << 18),	/* unexpected XFER_RDY error */
+	DATA_OVER_UNDER	= (1U << 16),	/* data overflow/underflow */
+	INTERLOCK	= (1U << 15),	/* interlock error */
+	NAK		= (1U << 14),	/* NAK rx'd */
+	ACK_NAK_TO	= (1U << 13),	/* ACK/NAK timeout */
+	CXN_CLOSED	= (1U << 12),	/* cxn closed w/out ack/nak */
+	OPEN_TO		= (1U << 11),	/* I_T nexus lost, open cxn timeout */
+	PATH_BLOCKED	= (1U << 10),	/* I_T nexus lost, pathway blocked */
+	NO_DEST		= (1U << 9),	/* I_T nexus lost, no destination */
+	STP_RES_BSY	= (1U << 8),	/* STP resources busy */
+	BREAK		= (1U << 7),	/* break received */
+	BAD_DEST	= (1U << 6),	/* bad destination */
+	BAD_PROTO	= (1U << 5),	/* protocol not supported */
+	BAD_RATE	= (1U << 4),	/* cxn rate not supported */
+	WRONG_DEST	= (1U << 3),	/* wrong destination error */
+	CREDIT_TO	= (1U << 2),	/* credit timeout */
+	WDOG_TO		= (1U << 1),	/* watchdog timeout */
+	BUF_PAR		= (1U << 0),	/* buffer parity error */
 };
 
 struct mvs_chip_info {
