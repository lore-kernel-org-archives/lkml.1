Return-Path: <linux-kernel-owner+w=401wt.eu-S1752305AbYFZNbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbYFZNbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYFZNb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:31:29 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:59310 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbYFZNb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:31:28 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2008 09:31:28 EDT
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dan Williams <dan.j.williams@intel.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       kernel@avr32linux.org, shannon.nelson@intel.com,
       David Brownell <david-b@pacbell.net>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Adrian Bunk <bunk@stusta.de>
Subject: [PATCH v4 4/6] dmaengine: Make DMA Engine menu visible for AVR32 users
Date: Thu, 26 Jun 2008 15:23:21 +0200
Message-Id: <1214486603-23655-5-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214486603-23655-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1214486603-23655-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1214486603-23655-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1214486603-23655-4-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 26 Jun 2008 13:23:06.0822 (UTC) FILETIME=[C52A0660:01C8D78F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the DMA Engine menu visible on AVR32 by adding AVR32 to the
(growing) list of architectures DMADEVICES depends on. Though I'd prefer
to remove that whole "depends" line entirely...

The DMADEVICES menu used to be available for all architectures, but at
some point, we started building a huge dependency list with all the
architectures that might have support for this kind of hardware.

According to Dan Williams:

> Adrian had concerns about users enabling NET_DMA when the hardware
> capability is relatively rare.

which seems very strange as long as (PCI && X86) is enough to enable
this menu. In other words, the vast majority of users will see the menu
even though the hardware is rare.

Also, all DMA clients depend on DMA_ENGINE being set. This symbol is
selected by each DMA Engine driver, so users can't select a DMA client
without selecting a specific DMA Engine driver first.

So, while this patch solves my immediate problem of making DMA Engines
available on AVR32, I'd much rather remove the whole arch dependency
list because I think it's bogus. Comments?

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Adrian Bunk <bunk@stusta.de>
---
 drivers/dma/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 18f6ef3..2ac09be 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig DMADEVICES
 	bool "DMA Engine support"
-	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX || PPC
+	depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX || PPC || AVR32
 	depends on !HIGHMEM64G
 	help
 	  DMA engines can do asynchronous data transfers without
-- 
1.5.5.4

