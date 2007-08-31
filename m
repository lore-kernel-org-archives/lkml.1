Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbXHaUGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbXHaUGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbXHaUGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:06:12 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:53503 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXHaUGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SZ3vJIXHgS601d1oeafUrUrYa3gPgl5s4lsg3WmeGZyZ8e7Y10l0aeEewErbbtkKWlAXfBc30webfmzY+/BWPACGNn0QpXS1o1IhazC9rN7DLacRUBItUr1EkpyqHYNeH/Eb9hG57IkbtIBBu7OCUJsMzC3xOGwrWwhEKB7TGqE=
Message-ID: <8b67d60708311306v344e8f00w36dc244fc39df39f@mail.gmail.com>
Date: Fri, 31 Aug 2007 21:06:10 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net,
       "Paul Mundt" <lethal@linux-sh.org>
Subject: Fwd: [PATCH] Patch pvr2 driver to allow development of maple bus driver
In-Reply-To: <8b67d60708311300k3ea67eadod531752cca253bbc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8b67d60708311300k3ea67eadod531752cca253bbc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies, sent this Bcc by mistake the first time

---------- Forwarded message ----------
From: Adrian McMenamin <lkmladrian@gmail.com>
Date: 31 Aug 2007 21:00
Subject: [PATCH] Patch pvr2 driver to allow development of maple bus driver
To: "Antonino A. Daplas" <adaplas@gmail.com>


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
        pvr2_fix.mmio_start     = 0xa05f8000;   /* registers start here */
        pvr2_fix.mmio_len       = 0x2000;

-       if (request_irq(HW_EVENT_VSYNC, pvr2fb_interrupt, 0,
+       if (request_irq(HW_EVENT_VSYNC, pvr2fb_interrupt, IRQF_SHARED,
                        "pvr2 VBL handler", fb_info)) {
                return -EBUSY;
        }
