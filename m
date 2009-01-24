Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbZAXOXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbZAXOXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 09:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbZAXOVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 09:21:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:28108 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbZAXOVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 09:21:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=n0IkDDVOgSVDCxvgSC9+0cC7L1tsT3zqZcVPyikWh9O2yguHEE18qw0hlfPVsrlW2O
         37WHI83vPlWd6Rhl3OFFUEEbLUiKNyNIlm7Y9yIfwI7UnZb4EfsJ/8vNv3eJ396V0BQ3
         4W9JSXz8TH/dKglh9w3ujb9NgmLQTJgjPJXNk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] macide: use struct ide_port_info
Date: Sat, 24 Jan 2009 15:18:30 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090123; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901241518.30926.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] macide: use struct ide_port_info

This fixes hwif->channel and drive->dn assignments.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/macide.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: b/drivers/ide/macide.c
===================================================================
--- a/drivers/ide/macide.c
+++ b/drivers/ide/macide.c
@@ -80,6 +80,10 @@ static void __init macide_setup_ports(hw
 	hw->chipset = ide_generic;
 }
 
+static const struct ide_port_info macide_port_info = {
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static const char *mac_ide_name[] =
 	{ "Quadra", "Powerbook", "Powerbook Baboon" };
 
@@ -122,7 +126,7 @@ static int __init macide_init(void)
 
 	macide_setup_ports(&hw, base, irq, ack_intr);
 
-	return ide_host_add(NULL, hws, NULL);
+	return ide_host_add(&macide_port_info, hws, NULL);
 }
 
 module_init(macide_init);
