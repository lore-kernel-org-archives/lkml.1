Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbZKYRHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbZKYRHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932400AbZKYRHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:07:10 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57397 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219AbZKYRHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:07:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ih4RWUZTpi7p0PUxl6BM8kBzIhv7UAWJ+xTaGTDAWvsYhob9LKIQLPjjDip2d8jma7
         iQdKUFL+DTLprXN44oNwL+80/kHNo9GbZtL7rTnqRbtfJ23Pp2tVv6QRVa0WOISIvEb5
         DZjfRUztc7NUXXU7qxHzSuAIzzJilKYhTijQo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:06:30 +0100
Message-Id: <20091125170630.5446.62655.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 35/86] pata_it8213: fix UDMA handling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_it8213: fix UDMA handling

Driver should program the cycle timing not the mode number
(doing the latter results in wrong timings being used).

There shouldn't be any problems with it as IDE it8213 host driver
has been doing it this way for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_it8213.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_it8213.c
===================================================================
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -173,10 +173,10 @@ static void it8213_set_dmamode (struct a
 
 		udma_enable |= (1 << devid);
 
-		/* Load the UDMA mode number */
+		/* Load the UDMA cycle time */
 		pci_read_config_word(dev, 0x4A, &udma_timing);
 		udma_timing &= ~(3 << (4 * devid));
-		udma_timing |= (udma & 3) << (4 * devid);
+		udma_timing |= u_speed << (4 * devid);
 		pci_write_config_word(dev, 0x4A, udma_timing);
 
 		/* Load the clock selection */
