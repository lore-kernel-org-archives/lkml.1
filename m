Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab0BMNoZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 08:44:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:38074 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab0BMNoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:44:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=gOsAiJwgSzCpXJSOxpt2NZy/rTZeug41tC8YOKBpMGI0TF7Z1vY5AfiibwwviHgH09
         oYQINh6DOvH3YlLtex1VJiARE7gONDnfk4La2WYgwwi8k+ra0kOSYTuJFiGRUDCL000J
         k1vLEJYgERCGrsjp5n+i6W4amjOjxg7GkAHew=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Date: Sat, 13 Feb 2010 14:35:59 +0100
Message-Id: <20100213133559.11564.54028.sendpatchset@localhost>
In-Reply-To: <20100213133538.11564.94218.sendpatchset@localhost>
References: <20100213133538.11564.94218.sendpatchset@localhost>
Subject: [PATCH 2/3] pata_pdc202xx_old: fix UDMA mode for PDC2026x chipsets
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_pdc202xx_old: fix UDMA mode for PDC2026x chipsets

PDC2026x chipsets need the same treatment as PDC20246 one.

This is completely untested but will hopefully fix UDMA issues
that people have been reporting against pata_pdc202xx_old for
the last couple of years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_pdc202xx_old.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_pdc202xx_old.c
===================================================================
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -26,7 +26,7 @@
 
 #include "pata_pdc202xx_old.h"
 
-static void pdc20246_exec_command(struct ata_port *ap,
+static void pdc202xx_exec_command(struct ata_port *ap,
 				  const struct ata_taskfile *tf)
 {
 	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
@@ -181,7 +181,7 @@ static struct ata_port_operations pdc202
 	.set_piomode		= pdc202xx_set_piomode,
 	.set_dmamode		= pdc202xx_set_dmamode,
 
-	.sff_exec_command	= pdc20246_exec_command,
+	.sff_exec_command	= pdc202xx_exec_command,
 };
 
 static struct ata_port_operations pdc2026x_port_ops = {
