Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbZAXOW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbZAXOW7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 09:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbZAXOVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 09:21:30 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:62674 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbZAXOVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 09:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=GVIt7uL/AAPwIGGkzQO8cE7Qy3QRSye7CC5OOHpxvTtZzE2jUNqlD+XriuI8+TMxi8
         Hh66jvDW0jCHgE9o64zk8vyNdcm1TkeMFmhdZ+OXSaTkHtO0zy+hMwtkjRQdNwY3vzmR
         YVvtfIdbLb6UlKtXGL0p6hCS7xpZkCXWTZ7Oo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] buddha: use struct ide_port_info
Date: Sat, 24 Jan 2009 15:17:50 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090123; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901241517.50780.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] buddha: use struct ide_port_info

This fixes hwif->channel and drive->dn assignments.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/buddha.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: b/drivers/ide/buddha.c
===================================================================
--- a/drivers/ide/buddha.c
+++ b/drivers/ide/buddha.c
@@ -143,6 +143,10 @@ static void __init buddha_setup_ports(hw
 	hw->chipset = ide_generic;
 }
 
+static const struct ide_port_info buddha_port_info = {
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
     /*
      *  Probe for a Buddha or Catweasel IDE interface
      */
@@ -224,7 +228,7 @@ fail_base2:
 			hws[i] = &hw[i];
 		}
 
-		ide_host_add(NULL, hws, NULL);
+		ide_host_add(&buddha_port_info, hws, NULL);
 	}
 
 	return 0;
