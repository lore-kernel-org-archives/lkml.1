Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbZFWN3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbZFWN3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZFWN2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:28:55 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:38821 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbZFWN2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:28:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=O0D3926oI7AZroC7bm7wMeSynbSoe6a+w/JzxvcV7+1cv+GEOV+XVlbnMhPVZfwSQi
         xgIVPHLdFH0nGG9Pbi/FOrvGT8dY7e3eIGeCvSLcWO43CU7NBiJ3R0kXGCnPBcvIf8gf
         lbgxrP7pp/szK8PPu+uD5uOfOULzUsKVbtGA0=
MIME-Version: 1.0
From: Aviv Laufer <aviv.laufer@gmail.com>
Date: Tue, 23 Jun 2009 16:28:36 +0300
Message-ID: <87972c700906230628l69a8a08ds4d182128bbd5dbe@mail.gmail.com>
Subject: [PATCH] /drivers/video/backlight/tdo24m - crash on kmalloc
To: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is  a crash in tdo24m module caused by a call to kmalloc with
the second parameter sizeof(flag) instead of flag.

Signed-off-by: Aviv Laufer <aviv.laufer@gmail.com>
---


--- linux-2.6.30/drivers/video/backlight/tdo24m.c.orig	2009-06-23
15:08:02.000000000 +0300
+++ linux-2.6.30/drivers/video/backlight/tdo24m.c	2009-06-23
15:09:05.000000000 +0300
@@ -356,7 +356,7 @@ static int __devinit tdo24m_probe(struct
 	lcd->power = FB_BLANK_POWERDOWN;
 	lcd->mode = MODE_VGA;	/* default to VGA */

-	lcd->buf = kmalloc(TDO24M_SPI_BUFF_SIZE, sizeof(GFP_KERNEL));
+	lcd->buf = kmalloc(TDO24M_SPI_BUFF_SIZE, GFP_KERNEL);
 	if (lcd->buf == NULL) {
 		kfree(lcd);
 		return -ENOMEM;
