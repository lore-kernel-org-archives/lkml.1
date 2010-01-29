Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252Ab0A2QGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab0A2QGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314Ab0A2QGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:06:03 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab0A2QF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:05:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=r8fwMTNlXln1w6fvtswp7Tt3KlA51ahAgr/v3MYeP0WJ1yb7K5Y1IWO1mWjSzCIqbP
         HR21051+s5nBHcL1jcCleaFZMgVHgf8BtDNgTAieryaM4618Zqj1xIdvTinwgvHHfGUw
         UMqnJ3lufT10jOySamc80B0LBYiY3VCvDMDD0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:05:51 +0100
Message-Id: <20100129160551.21495.52656.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 25/68] it8213: always program control bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] it8213: always program control bits

This matches behavior of libata pata_it8213 host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/it8213.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: b/drivers/ide/it8213.c
===================================================================
--- a/drivers/ide/it8213.c
+++ b/drivers/ide/it8213.c
@@ -55,15 +55,13 @@ static void it8213_set_pio_mode(ide_hwif
 	if (is_slave) {
 		master_data |=  0x4000;
 		master_data &= ~0x0070;
-		if (pio > 1)
-			master_data = master_data | (control << 4);
+		master_data = master_data | (control << 4);
 		pci_read_config_byte(dev, slave_port, &slave_data);
 		slave_data = slave_data & 0xf0;
 		slave_data = slave_data | (timings[pio][0] << 2) | timings[pio][1];
 	} else {
 		master_data &= ~0x3307;
-		if (pio > 1)
-			master_data = master_data | control;
+		master_data = master_data | control;
 		master_data = master_data | (timings[pio][0] << 12) | (timings[pio][1] << 8);
 	}
 	pci_write_config_word(dev, master_port, master_data);
