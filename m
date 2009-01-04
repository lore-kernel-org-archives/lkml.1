Return-Path: <linux-kernel-owner+w=401wt.eu-S1752171AbZADF2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbZADF2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 00:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750698AbZADF2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 00:28:33 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:47433 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696AbZADF2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 00:28:32 -0500
Message-ID: <496048F9.1010601@lwfinger.net>
Date: Sat, 03 Jan 2009 23:28:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Juergen Fischer <fischer@norbit.de>
CC: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] aha152x_cs: Fix regression that keeps driver from using shared
 interrupts
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At some point since 2.6.22, the aha152x_cs driver stopped working and
started erring on load with the following messages:

kernel: pcmcia: request for exclusive IRQ could not be fulfilled.
kernel: pcmcia: the driver needs updating to supported shared IRQ lines.

With the following change, the driver works with shared IRQs.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>		[2.6.28], [2.6.27], [2.6.26]
---

Juergen,

If you are not the correct person to receive this, please pass it on.
I originally sent it to Dominik Brodowski, but heard nothing from him.

Thanks,

Larry
---

Index: wireless-testing/drivers/scsi/pcmcia/aha152x_stub.c
===================================================================
--- wireless-testing.orig/drivers/scsi/pcmcia/aha152x_stub.c
+++ wireless-testing/drivers/scsi/pcmcia/aha152x_stub.c
@@ -114,7 +114,7 @@ static int aha152x_probe(struct pcmcia_d
     link->io.NumPorts1 = 0x20;
     link->io.Attributes1 = IO_DATA_PATH_WIDTH_AUTO;
     link->io.IOAddrLines = 10;
-    link->irq.Attributes = IRQ_TYPE_EXCLUSIVE;
+    link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
     link->irq.IRQInfo1 = IRQ_LEVEL_ID;
     link->conf.Attributes = CONF_ENABLE_IRQ;
     link->conf.IntType = INT_MEMORY_AND_IO;

