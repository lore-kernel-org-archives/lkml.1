Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbZKQQDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbZKQQDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:03:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbZKQQDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:03:04 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41271 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754910AbZKQQDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:03:03 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [RESEND PATCH] gpio_addr_flash: Fix warnings
To: linux-kernel@vger.kernel.org, vapier@gentoo.org
Date: Tue, 17 Nov 2009 15:46:49 +0000
Message-ID: <20091117154641.3879.73168.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/mtd/maps/gpio-addr-flash.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/mtd/maps/gpio-addr-flash.c b/drivers/mtd/maps/gpio-addr-flash.c
index 1ad5caf..9760e31 100644
--- a/drivers/mtd/maps/gpio-addr-flash.c
+++ b/drivers/mtd/maps/gpio-addr-flash.c
@@ -208,7 +208,7 @@ static int __devinit gpio_flash_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	state->gpio_count     = gpios->end;
-	state->gpio_addrs     = (void *)gpios->start;
+	state->gpio_addrs     = (void *)(unsigned long)gpios->start;
 	state->gpio_values    = (void *)(state + 1);
 	state->win_size       = memory->end - memory->start + 1;
 	memset(state->gpio_values, 0xff, arr_size);
@@ -220,7 +220,7 @@ static int __devinit gpio_flash_probe(struct platform_device *pdev)
 	state->map.copy_to    = gf_copy_to;
 	state->map.bankwidth  = pdata->width;
 	state->map.size       = state->win_size * (1 << state->gpio_count);
-	state->map.virt       = (void __iomem *)memory->start;
+	state->map.virt       = (void __iomem *)(unsigned long)memory->start;
 	state->map.phys       = NO_XIP;
 	state->map.map_priv_1 = (unsigned long)state;
 

