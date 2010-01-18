Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497Ab0ARRQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0ARRQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387Ab0ARRQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:16:21 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63659 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab0ARRQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:16:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=l4dZKC4mJqfOMYFCJmQHvGr1ITSo7smY9+fpkcP7xAnGzArzXEQbqUMsqHSTLjxYsy
         bMylwH9UlbY6AUyBEmrLYkGHWU6iTbT92dx/21gxLaDVgMppgQd7bQP7tltJfBSDA4Hp
         bcJVHV0xkg0GBCKKJ7n3qrYcUzeG80XSKbERU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:14:55 +0100
Message-Id: <20100118171455.14623.81852.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 08/64] pata_cmd64x: fix PIO setup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cmd64x: fix PIO setup

Fix incorrect handling of recovery clocks value == 16 resulting
in overclocked recovery timings & potentially underclocked active
timings.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cmd64x.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_cmd64x.c
===================================================================
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -2,7 +2,7 @@
  * pata_cmd64x.c 	- CMD64x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
- *			  (C) 2009 Bartlomiej Zolnierkiewicz
+ *			  (C) 2009-2010 Bartlomiej Zolnierkiewicz
  *
  * Based upon
  * linux/drivers/ide/pci/cmd64x.c		Version 1.30	Sept 10, 2002
@@ -182,7 +182,9 @@ static void cmd64x_set_timing(struct ata
 	/* Now convert the clocks into values we can actually stuff into
 	   the chip */
 
-	if (t.recover > 1)
+	if (t.recover == 16)
+		t.recover = 0;
+	else if (t.recover > 1)
 		t.recover--;
 	else
 		t.recover = 15;
