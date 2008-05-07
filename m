Return-Path: <linux-kernel-owner+w=401wt.eu-S1764171AbYEGRb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764171AbYEGRb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759400AbYEGR3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:29:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:28539 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbYEGR3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=V6W4Anf1DgZDsOtV/tgUbmbapYW4fbpgPae0gAKrJ+2LZC/zx2WRBfZFmZnZ0ZW8lA8b70wh6hklS7zpu4XD5rclDMCZVmXvU5gO1YpTgES8Q/8RPZ6x44VCoRsfE7q/sW09K/ghrb31WE+DPlbH77Lh6LxxPOPP16FHNXFgQME=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/6] ide: fix do_probe() to use SELECT_DRIVE()
Date: Wed, 7 May 2008 19:41:29 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805071941.29674.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix one place in do_probe() which used ->OUTB directly instead
of calling SELECT_DRIVE() (so ->selectproc method is also used).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -478,7 +478,7 @@ static int do_probe (ide_drive_t *drive,
 			printk(KERN_ERR "%s: no response (status = 0x%02x), "
 					"resetting drive\n", drive->name, stat);
 			msleep(50);
-			hwif->OUTB(drive->select.all, io_ports->device_addr);
+			SELECT_DRIVE(drive);
 			msleep(50);
 			hwif->OUTBSYNC(drive, WIN_SRST, io_ports->command_addr);
 			(void)ide_busy_sleep(hwif);
