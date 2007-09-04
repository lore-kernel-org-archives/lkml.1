Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbXIDX13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbXIDX13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 19:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbXIDX1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 19:27:22 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:22595 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbXIDX1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 19:27:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Vd6OcjEa9HommaltyJ79Ntomxret4Y182h6YM26Avxp+ME4tCuaOc8zgTAIAtRHMCQFy+/k0FqSfHeJ4QnxczbahHiLsCsmNe+7IGaMqZuSBOcEAl4V6Y8WTrg2cL+MIXqdJOe0XLAUD84sl8hyY/Of6LPyJFcKMmNA9xHn7fao=
Message-ID: <8b67d60709041627j28b8088co25a3628740f24583@mail.gmail.com>
Date: Wed, 5 Sep 2007 00:27:20 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@gmail.com>
Subject: [PATCH - RESUBMiT] Minor patch to pvr2 driver required for maple bus support on SEGA Dreamcast
Cc: linuxsh-dev@lists.sourceforge.net, "Paul Mundt" <lethal@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The maple bus driver (http://lkml.org/lkml/2007/9/4/165) uses hardware
synchronisation between the maple bus and the VBLANK to poll the maple
bus. This patch makes the interrupt shareable.

By definition the interrupt is for both devices.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

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
