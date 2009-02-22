Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZBVMUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZBVMUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 07:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbZBVMTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 07:19:36 -0500
Received: from cathcart.site5.com ([74.54.107.137]:43144 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbZBVMTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 07:19:35 -0500
From: Mike Rapoport <mike@compulab.co.il>
To: dbrownell@users.sourceforge.net
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       dcbw@redhat.com, andrey@cozybit.com,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH RESEND 1/3] SPI: add dma_alignment field to spi_master
Date: Sun, 22 Feb 2009 14:19:16 +0200
Message-Id: <b9186e380ae53df7b4ce65a552b39d34879f3dd6.1234167048.git.mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <cover.1234167048.git.mike@compulab.co.il>
References: <cover.1234167048.git.mike@compulab.co.il>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some SPI controllers have restrictions on DMAable buffers alignemt.
Currently if the buffer supplied by protocol driver is not properly
aligned, the controller silently performs transfer in PIO mode.
Addition of dma_alignment field to spi_master allows protocol drivers to
perform proper alignment.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 include/linux/spi/spi.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 68bb1c5..2cc43fa 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -204,6 +204,7 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
  *	SPI slaves, and are numbered from zero to num_chipselects.
  *	each slave has a chipselect signal, but it's common that not
  *	every chipselect is connected to a slave.
+ * @dma_alignment: SPI controller constraint on DMA buffers alignment.
  * @setup: updates the device mode and clocking records used by a
  *	device's SPI controller; protocol code may call this.  This
  *	must fail if an unrecognized or unsupported mode is requested.
@@ -239,6 +240,11 @@ struct spi_master {
 	 */
 	u16			num_chipselect;
 
+	/* some SPI controllers pose alignment requirements on DMAable
+	 * buffers; let protocol drivers know about these requirements.
+	 */
+	u16			dma_alignment;
+
 	/* setup mode and clock, etc (spi driver may call many times) */
 	int			(*setup)(struct spi_device *spi);
 
-- 
1.5.6.4

