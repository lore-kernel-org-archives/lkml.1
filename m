Return-Path: <linux-kernel-owner+w=401wt.eu-S1759708AbXHaUAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708AbXHaUAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbXHaUAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:00:21 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:47016 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbXHaUAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=WKbcXx4gxYZpseYCIeCkcXTnJMf1483IM3Y4LLN5cwSB1ux637yL0fAclO/muUOXkFOUQkCPAaOseylOtGAeZVPe3DJ1KTxZr7J/AJI/m4+8scy1JtYjWwDgD9TFlCsXsoJRrjV4fe7vidW9ByfUvQJH0NMBzAqd7sCMOa5MCqE=
Message-ID: <8b67d60708311300k3ea67eadod531752cca253bbc@mail.gmail.com>
Date: Fri, 31 Aug 2007 21:00:19 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: [PATCH] Patch pvr2 driver to allow development of maple bus driver
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the PVR2 VBLANK interrupt on the SEGA Dreamcast
shareable - a small but necessary change to enable ongoing efforts to
develop a driver for the maple bus on the Dreamcast. (Maple is Sega's
proprietary serial interface for the Dreamcast and can be set to
synchronise dma transfers to the VBLANK).

This has no impact on the performance of the PVR2.

Signed-off by Adrian McMenamin <adrian@mcmen.demon.co.uk>

diff --git a/drivers/video/pvr2fb.c b/drivers/video/pvr2fb.c
index 7d6c298..13de07f 100644
--- a/drivers/video/pvr2fb.c
+++ b/drivers/video/pvr2fb.c
@@ -890,7 +890,7 @@ static int __init pvr2fb_dc_init(void)
 	pvr2_fix.mmio_start	= 0xa05f8000;	/* registers start here */
 	pvr2_fix.mmio_len	= 0x2000;

-	if (request_irq(HW_EVENT_VSYNC, pvr2fb_interrupt, 0,
+	if (request_irq(HW_EVENT_VSYNC, pvr2fb_interrupt, IRQF_SHARED,
 	                "pvr2 VBL handler", fb_info)) {
 		return -EBUSY;
 	}
