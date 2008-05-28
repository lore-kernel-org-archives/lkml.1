Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYE1Vpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYE1Vpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbYE1VnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:43:24 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:49842 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbYE1VnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=HGIn8LsKfkCxuQuHWbsM3DbNZe4GCUNJ/aB+gZ9xdbYt872pUUJ3zWOIbhNvFyeZ+SjNK96wNAPKdea5WV+6VjzgBCW5S9WUaFtpCyPUUFsZoVV2a++PGUBioUY/YVKzm4pSb8pr93tZUqBmk2Uymj2zmGq6s+bXd1EpdjuIKx4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:40:54 +0200
Message-Id: <20080528214054.16327.46227.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/21] ali14xx: convert to use ide_timing_find_mode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig          |    1 +
 drivers/ide/legacy/ali14xx.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -988,6 +988,7 @@ config BLK_DEV_4DRIVES
 
 config BLK_DEV_ALI14XX
 	tristate "ALI M14xx support"
+	select IDE_TIMINGS
 	help
 	  This driver is enabled at runtime using the "ali14xx.probe" kernel
 	  boot parameter.  It enables support for the secondary IDE interface
Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -117,10 +117,11 @@ static void ali14xx_set_pio_mode(ide_dri
 	u8 param1, param2, param3, param4;
 	unsigned long flags;
 	int bus_speed = ide_vlb_clk ? ide_vlb_clk : 50;
+	struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 
 	/* calculate timing, according to PIO mode */
 	time1 = ide_pio_cycle_time(drive, pio);
-	time2 = ide_pio_timings[pio].active_time;
+	time2 = t->active;
 	param3 = param1 = (time2 * bus_speed + 999) / 1000;
 	param4 = param2 = (time1 * bus_speed + 999) / 1000 - param1;
 	if (pio < 3) {
