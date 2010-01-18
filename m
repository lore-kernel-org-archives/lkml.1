Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561Ab0ARRXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab0ARRXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515Ab0ARRXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:23:42 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51627 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab0ARRXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:23:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=uZLQXf1J6vLHaU+m4bAv6jCv5vI8pZpqH3Os+6uqiRBd2M7YTN6D1mGy1+/VKFKAd0
         IyCX8Vzq7lVvtiGT5gE+uewhRHfkrf8eqUxtV11PhTjsyxksC/8Bhn7UEw5MifccMkBO
         qM0XzcI0JxfwI1rds/mytjdr/YcDK6pRlbwoc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:22:23 +0100
Message-Id: <20100118172223.14623.60339.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 62/64] tx493xide: use ->pio_mode value to determine pair device speed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] tx493xide: use ->pio_mode value to determine pair device speed

Use the current PIO mode value instead of the physical maximum one
of the pair device on the port to determine PIO commmand timings used
for both devices on the port.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/tx4938ide.c |    2 +-
 drivers/ide/tx4939ide.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/tx4938ide.c
===================================================================
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -64,7 +64,7 @@ static void tx4938ide_set_pio_mode(ide_h
 
 	pair = ide_get_pair_dev(drive);
 	if (pair)
-		safe = min(safe, ide_get_best_pio_mode(pair, 255, 5));
+		safe = min(safe, pair->pio_mode - XFER_PIO_0);
 	tx4938ide_tune_ebusc(pdata->ebus_ch, pdata->gbus_clock, safe);
 }
 
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -114,7 +114,7 @@ static void tx4939ide_set_pio_mode(ide_h
 
 	pair = ide_get_pair_dev(drive);
 	if (pair)
-		safe = min(safe, ide_get_best_pio_mode(pair, 255, 4));
+		safe = min(safe, pair->pio_mode - XFER_PIO_0);
 	/*
 	 * Update Command Transfer Mode for master/slave and Data
 	 * Transfer Mode for this drive.
