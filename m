Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYDISjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYDISjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYDISie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:38:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:17813 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbYDISia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=aBKBiosVEfO5hOBZwXwuZHhhg5/+owTwyEmPRAekq0y2STndp3AxYw9vfdRKEGbQZqqySvp4gcPn2trqw8ylxWXpU0eiEPfEFRxIyAUNKL19sbpNJA01520zaQUFzN8Ng0JuXjD2/tCB4u4Jpbt/p1aOi4E+VhRcLXwW1XvBW4Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] siimage: do clocking register posting earlier in setup_mmio_siimage()
Date: Wed, 9 Apr 2008 20:51:01 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804092051.01552.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do clocking register posting earlier in setup_mmio_siimage()
to match code in init_chipset_siimage().

This is a preparation for the next patch which merges PCI and MMIO
code paths together.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/siimage.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -521,7 +521,9 @@ static unsigned int setup_mmio_siimage (
 			writeb(tmpbyte & ~0x20, ioaddr + 0x4A);
 			break;
 	}
-	
+
+	tmpbyte = readb(ioaddr + 0x4A);
+
 	writeb(      0x72, ioaddr + 0xA1);
 	writew(    0x328A, ioaddr + 0xA2);
 	writel(0x62DD62DD, ioaddr + 0xA4);
@@ -540,8 +542,6 @@ static unsigned int setup_mmio_siimage (
 		writel(0x00680000, ioaddr + 0x1C8);
 	}
 
-	tmpbyte = readb(ioaddr + 0x4A);
-
 	proc_reports_siimage(dev, (tmpbyte>>4), name);
 	return 1;
 }
