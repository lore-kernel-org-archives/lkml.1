Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbYJ1Ibj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbYJ1Ibj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 04:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYJ1Ib3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 04:31:29 -0400
Received: from 75-125-101-9.opticaljungle.com ([75.125.101.9]:42453 "EHLO
	mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753123AbYJ1Ib2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 04:31:28 -0400
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2008 04:31:28 EDT
Date: Tue, 28 Oct 2008 09:19:50 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: kernel@wantstofly.org
Cc: rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] ep93xx: fix OHCI DMA mask
Message-ID: <20081028081950.GA2930@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	kernel@wantstofly.org, rmk@arm.linux.org.uk,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ep93xx: Fix OHCI DMA mask

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

--- linux-2.6.27.org/arch/arm/mach-ep93xx/core.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27/arch/arm/mach-ep93xx/core.c	2008-10-28 08:05:53.000000000 +0100
@@ -26,6 +26,7 @@
 #include <linux/serial_core.h>
 #include <linux/device.h>
 #include <linux/mm.h>
+#include <linux/dma-mapping.h>
 #include <linux/time.h>
 #include <linux/timex.h>
 #include <linux/delay.h>
@@ -450,12 +451,13 @@
 	},
 };
 
+
 static struct platform_device ep93xx_ohci_device = {
 	.name		= "ep93xx-ohci",
 	.id		= -1,
 	.dev		= {
-		.dma_mask		= (void *)0xffffffff,
-		.coherent_dma_mask	= 0xffffffff,
+		.dma_mask		= &ep93xx_ohci_device.dev.coherent_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 	.num_resources	= ARRAY_SIZE(ep93xx_ohci_resources),
 	.resource	= ep93xx_ohci_resources,

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

            You can chain me, you can torture me, you can even
          destroy this body, but you will never imprison my mind
                            (Mahatma Gandhi)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
