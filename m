Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763Ab0AJOdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab0AJOdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 09:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713Ab0AJOdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 09:33:32 -0500
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:65163 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab0AJOda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 09:33:30 -0500
Message-ID: <4B49E533.8050808@freemail.hu>
Date: Sun, 10 Jan 2010 15:33:23 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>
CC: linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, cocci@diku.dk
Subject: [PATCH] i2c-ali1563: remove sparse warnings
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02a.mail.t-online.hu 32721; Body=6 Fuz1=6
	Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Remove the following sparse warnings (see "make C=1"):
 * drivers/i2c/busses/i2c-ali1563.c:91:3: warning: do-while statement is not a compound statement
 * drivers/i2c/busses/i2c-ali1563.c:161:3: warning: do-while statement is not a compound statement

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux/drivers/i2c/busses/i2c-ali1563.c.orig	2010-01-10 13:40:31.000000000 +0100
+++ linux/drivers/i2c/busses/i2c-ali1563.c	2010-01-10 13:54:16.000000000 +0100
@@ -87,9 +87,9 @@
 	outb_p(inb_p(SMB_HST_CNTL2) | HST_CNTL2_START, SMB_HST_CNTL2);

 	timeout = ALI1563_MAX_TIMEOUT;
-	do
+	do {
 		msleep(1);
-	while (((data = inb_p(SMB_HST_STS)) & HST_STS_BUSY) && --timeout);
+	} while (((data = inb_p(SMB_HST_STS)) & HST_STS_BUSY) && --timeout);

 	dev_dbg(&a->dev, "Transaction (post): STS=%02x, CNTL1=%02x, "
 		"CNTL2=%02x, CMD=%02x, ADD=%02x, DAT0=%02x, DAT1=%02x\n",
@@ -157,9 +157,9 @@
 	outb_p(inb_p(SMB_HST_CNTL2) | HST_CNTL2_START, SMB_HST_CNTL2);

 	timeout = ALI1563_MAX_TIMEOUT;
-	do
+	do {
 		msleep(1);
-	while (!((data = inb_p(SMB_HST_STS)) & HST_STS_DONE) && --timeout);
+	} while (!((data = inb_p(SMB_HST_STS)) & HST_STS_DONE) && --timeout);

 	dev_dbg(&a->dev, "Block (post): STS=%02x, CNTL1=%02x, "
 		"CNTL2=%02x, CMD=%02x, ADD=%02x, DAT0=%02x, DAT1=%02x\n",
