Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbYFBUYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbYFBUYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 16:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbYFBUWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 16:22:38 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:17242 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbYFBUWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 16:22:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Tx0slRZGrlj2O4rZKf5S2kVHPlO+NuoxH7n2lx+midoyda11JlWiSPXzuh2PK0f2/05OZgON18Var3c3nfbIUnBp1eyB67xARlJEYxLkV1bAw2rIxRMzH7YV5tcMmY1EUjGhjLih+z2dQjpF5ZeJ2eX3T73UeIVtaU/un0Cvapg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Jun 2008 22:24:04 +0200
Message-Id: <20080602202404.7265.39402.sendpatchset@localhost.localdomain>
In-Reply-To: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
References: <20080602202253.7265.23590.sendpatchset@localhost.localdomain>
Subject: [PATCH 9/9] ide-cs: use struct ide_port_info
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the driver to use struct ide_port_info.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/ide-cs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -150,6 +150,11 @@ static const struct ide_port_ops idecs_p
 	.quirkproc		= ide_undecoded_slave,
 };
 
+static const struct ide_port_info idecs_port_info = {
+	.port_ops		= &idecs_port_ops,
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static ide_hwif_t *idecs_register(unsigned long io, unsigned long ctl,
 				unsigned long irq, struct pcmcia_device *handle)
 {
@@ -184,11 +189,10 @@ static ide_hwif_t *idecs_register(unsign
     i = hwif->index;
 
     ide_init_port_hw(hwif, &hw);
-    hwif->port_ops = &idecs_port_ops;
 
     idx[0] = i;
 
-    ide_device_add(idx, NULL);
+    ide_device_add(idx, &idecs_port_info);
 
     if (hwif->present)
 	return hwif;
