Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbXIIRGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbXIIRGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 13:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbXIIRGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 13:06:45 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:59148 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbXIIRGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 13:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LSdcfCid89pPHa6mCPSGqOYHmav7ySptwGXiWnLv39Wo0cxtXXTX5fB+4fxf/BX9cM8+p6gmjmNXD6/S+hYIo1FEVIAUSRse+mFFDyAGhH4fXPIrQSwXVjP986tE8pD51KY3exGLvybw7CL1P5yXxobHwDGvk5zTIzpVp2/s5oE=
Message-ID: <8b67d60709091006h5388483fyaf5dd3f87a078b0f@mail.gmail.com>
Date: Sun, 9 Sep 2007 18:06:41 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: [PATCH 3/3] Maple bus support for the Sega Dreamcast - consequential change to pvr2 driver
Cc: "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the VBLANK interrupt shareable.

This is the third time I have posted this patch. This is required to
allow the Maple bus driver to work (Maple hardware is synced with the
VBLANK interrupt).

Signed off: Adrian McMenamin <adrian@mcmen.demon.co.uk>

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
