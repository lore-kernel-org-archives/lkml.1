Return-Path: <linux-kernel-owner+w=401wt.eu-S1762385AbYEHUuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762385AbYEHUuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759761AbYEHUuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:50:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:52623 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984AbYEHUuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:50:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=g3LKV0w217jwiRswIYkUocC59M7Ur748SCTaIpK0rc00tbhUV+kiPTzdFxANNgWkMwm8DOf6l0IyohjxVrFgln/7htamZpe7OraOTTtocu8PvKVfFSFoFlNPv+AP/bq9n+92+uzkGAf7mcPi8422EJnvr+A1UhO0LZCDrHq4j0c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/5] alim15x3: trivial cleanup for ali_set_pio_mode()
Date: Thu, 8 May 2008 23:03:30 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805082303.30236.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove commented out code and stale comment.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/alim15x3.c |   15 ---------------
 1 file changed, 15 deletions(-)

Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -76,11 +76,6 @@ static void ali_set_pio_mode(ide_drive_t
 		a_clc = 0;
 	c_time = ide_pio_timings[pio].cycle_time;
 
-#if 0
-	if ((r_clc = ((c_time - s_time - a_time) * bus_speed + 999) / 1000) >= 16)
-		r_clc = 0;
-#endif
-
 	if (!(r_clc = (c_time * bus_speed + 999) / 1000 - a_clc - s_clc)) {
 		r_clc = 1;
 	} else {
@@ -110,16 +105,6 @@ static void ali_set_pio_mode(ide_drive_t
 	pci_write_config_byte(dev, port, s_clc);
 	pci_write_config_byte(dev, port+drive->select.b.unit+2, (a_clc << 4) | r_clc);
 	local_irq_restore(flags);
-
-	/*
-	 * setup   active  rec
-	 * { 70,   165,    365 },   PIO Mode 0
-	 * { 50,   125,    208 },   PIO Mode 1
-	 * { 30,   100,    110 },   PIO Mode 2
-	 * { 30,   80,     70  },   PIO Mode 3 with IORDY
-	 * { 25,   70,     25  },   PIO Mode 4 with IORDY  ns
-	 * { 20,   50,     30  }    PIO Mode 5 with IORDY (nonstandard)
-	 */
 }
 
 /**
