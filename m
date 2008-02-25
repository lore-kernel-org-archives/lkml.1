Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbYBYRqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbYBYRqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757183AbYBYRqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:46:05 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:42875 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186AbYBYRqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:46:04 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Grant Grundler <grundler@parisc-linux.org>
Subject: [PATCH] de2104x: remove BUG_ON() when changing media type
Date: Mon, 25 Feb 2008 18:45:46 +0100
User-Agent: KMail/1.9.9
Cc: jgarzik@pobox.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
References: <200801262158.12016.linux@rainbow-software.org> <200802181740.44196.linux@rainbow-software.org> <20080225071505.GC26674@colo.lackof.org>
In-Reply-To: <20080225071505.GC26674@colo.lackof.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1340
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200802251845.51562.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the chip dies (probably because of a bug somewhere in the driver), 
de_stop_rxtx() fails and changing the media type crashes the whole machine. 
Replace BUG_ON() in de_set_media() with a warning.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.24-orig/drivers/net/tulip/de2104x.c	2008-02-25 18:27:34.000000000 +0100
+++ linux-2.6.24-pentium/drivers/net/tulip/de2104x.c	2008-02-25 18:34:56.000000000 +0100
@@ -910,7 +910,8 @@
 	unsigned media = de->media_type;
 	u32 macmode = dr32(MacMode);
 
-	BUG_ON(de_is_running(de));
+	if (de_is_running(de))
+		printk(KERN_WARNING "%s: chip is running while changing media!\n", de->dev->name);
 
 	if (de->de21040)
 		dw32(CSR11, FULL_DUPLEX_MAGIC);


-- 
Ondrej Zary
