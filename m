Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbZLDSo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbZLDSo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbZLDSoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:44:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:54111 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755778AbZLDSoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:44:20 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19XYA94cRlXmB2Bx1Y2WuLCBEoT+Smux53Ldt5d1f
	SgMpCXnrpomesK
Date: Fri, 4 Dec 2009 19:44:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org
Subject: [PATCH 1/5] sh: DMA driver has to specify its alignment requirements
In-Reply-To: <Pine.LNX.4.64.0912041936541.3981@axis700.grange>
Message-ID: <Pine.LNX.4.64.0912041940110.3981@axis700.grange>
References: <Pine.LNX.4.64.0912041936541.3981@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SH DMA driver by default uses 32-byte transfers, in this mode buffers and
sizes have to be 32-byte aligned. Specifying this requirement also fixes Oopses
with dmatest.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/dma/shdma.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index b3b065c..f5fae12 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -677,6 +677,8 @@ static int __init sh_dmae_probe(struct platform_device *pdev)
 	shdev->common.device_is_tx_complete = sh_dmae_is_complete;
 	shdev->common.device_issue_pending = sh_dmae_memcpy_issue_pending;
 	shdev->common.dev = &pdev->dev;
+	/* Default transfer size of 32 bytes requires 32-byte alignment */
+	shdev->common.copy_align = 5;
 
 #if defined(CONFIG_CPU_SH4)
 	/* Non Mix IRQ mode SH7722/SH7730 etc... */
-- 
1.6.2.4

