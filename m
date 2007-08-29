Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbXH2Vm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbXH2Vm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 17:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbXH2Vmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 17:42:49 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:47899 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881AbXH2Vmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 17:42:49 -0400
From: Daniel Exner <dex@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Override 80-wire cable detection for Toshiba S1800-814
Date: Wed, 29 Aug 2007 23:41:13 +0200
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_6fe1GGdpei/6Uik"
Message-Id: <200708292341.14212.dex@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;dex@dragonslave.de;1188423769;5ba136d3;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_6fe1GGdpei/6Uik
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi!

Please CC me, as I'm currently not subscribed to this list, thx.

Attached patch will add above mentioned Laptop Model to whitelist for both 
pata_ali and alim15x3, as it is correctly detected as 40-wire connected but 
this cable is short enough to still do transfers higher than UDMA33.
Don't know if this is also true for other S1800 Laptops cause I own only one.

I hope I did this correctly as this is my first Patch Mail to LKML :)
-- 
Greetings
Daniel Exner

--Boundary-00=_6fe1GGdpei/6Uik
Content-Type: text/x-diff;
  charset="utf-8";
  name="patchAli_pata.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="patchAli_pata.patch"

--- linux-2.6.22.old/drivers/ata/pata_ali.c	2007-08-29 23:27:53.000000000 +0200
+++ linux-2.6.22/drivers/ata/pata_ali.c	2007-08-29 23:14:37.000000000 +0200
@@ -48,6 +48,13 @@
 			DMI_MATCH(DMI_BOARD_VERSION, "OmniBook N32N-736"),
 		},
 	},
+	{
+		.ident = "Toshiba Satelite S1800-814",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "S1800-814"),
+		},
+	}, 
 	{ }
 };
 
--- linux-2.6.22.old/drivers/ide/pci/alim15x3.c	2007-08-29 22:17:14.000000000 +0200
+++ linux-2.6.22/drivers/ide/pci/alim15x3.c	2007-08-29 22:56:27.000000000 +0200
@@ -596,6 +596,13 @@
 			DMI_MATCH(DMI_BOARD_VERSION, "OmniBook N32N-736"),
 		},
 	},
+	{
+		.ident = "Toshiba Satellite S1800-814",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "S1800-814"),
+		},
+	},
 	{ }
 };
 

--Boundary-00=_6fe1GGdpei/6Uik--
