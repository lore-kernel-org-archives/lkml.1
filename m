Return-Path: <linux-kernel-owner+w=401wt.eu-S1760144AbXHaOsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144AbXHaOsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbXHaOsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:48:10 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:58802 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754187AbXHaOsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:48:09 -0400
From: Daniel Exner <dex@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Override 80-wire cable detection for Toshiba S1800-814 (resend)
Date: Fri, 31 Aug 2007 16:46:18 +0200
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200708292341.14212.dex@dragonslave.de> <20070829225921.6ffd5f98@the-village.bc.nu>
In-Reply-To: <20070829225921.6ffd5f98@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_6mC2GQrmSyFnKne"
Message-Id: <200708311646.18494.dex@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;dex@dragonslave.de;1188571689;32a68068;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_6mC2GQrmSyFnKne
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi!

Please CC me, as I'm currently not subscribed to this list, thx.

Another try :)


-- 
Greetings
Daniel Exner

--Boundary-00=_6mC2GQrmSyFnKne
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="patchAli_pata.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="patchAli_pata.patch"

Add Toshiba S1800-814 to whitelist for both 
pata_ali and alim15x3, as it is correctly detected as 40-wire connected but 
this cable is short enough to still use transfer modes higher than UDMA33.

Signed-off-by: Daniel Exner <dex@dragonslave.de>

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
 

--Boundary-00=_6mC2GQrmSyFnKne--
