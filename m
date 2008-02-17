Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbYBQTkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbYBQTkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYBQTj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:39:58 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:51349 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYBQTj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:39:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kjaZpFXinHnwWj0Rm+BYN/jAOJvGElCny91IXcWJ6dau3liIHAgEx4cC97S2bsj/nQMvsCdOvZlyYZGuoWJVR7JNfKbcB415okL117S3ZWa8I0DA2pq0G9LjbmXwmjKYoSoaYhkJDxKOfeWTougCqjFxGwPHsMPcaKysZsSddis=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/4] ide-disk: add missing printk() KERN_* levels
Date: Sun, 17 Feb 2008 20:52:48 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802172052.48836.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -867,7 +867,7 @@ static void idedisk_setup (ide_drive_t *
 
 	/* Only print cache size when it was specified */
 	if (id->buf_size)
-		printk (" w/%dKiB Cache", id->buf_size/2);
+		printk(KERN_CONT " w/%dKiB Cache", id->buf_size / 2);
 
 	printk(KERN_CONT ", CHS=%d/%d/%d\n",
 			 drive->bios_cyl, drive->bios_head, drive->bios_sect);
@@ -949,7 +949,8 @@ static void ide_device_shutdown(ide_driv
 		return;
 	}
 
-	printk("Shutdown: %s\n", drive->name);
+	printk(KERN_INFO "Shutdown: %s\n", drive->name);
+
 	drive->gendev.bus->suspend(&drive->gendev, PMSG_SUSPEND);
 }
 
