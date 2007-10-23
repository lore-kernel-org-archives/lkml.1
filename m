Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbXJWEmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbXJWEmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 00:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbXJWEjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 00:39:24 -0400
Received: from rex.snapgear.com ([203.143.235.140]:58893 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752859AbXJWEjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 00:39:22 -0400
Date: Tue, 23 Oct 2007 14:37:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710230437.l9N4bsVf001778@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: improve mii_do_cmd code in FEC driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe De Muyter <phdm@macqel.be>

Improve the readability of mii_do_cmd().

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/drivers/net/fec.c linux-2.6.23-uc0/drivers/net/fec.c
--- linux-2.6.23/drivers/net/fec.c	2007-10-19 10:25:49.000000000 +1000
+++ linux-2.6.23-uc0/drivers/net/fec.c	2007-10-19 10:34:22.000000000 +1000
@@ -770,14 +768,11 @@ mii_queue(struct net_device *dev, int re
 
 static void mii_do_cmd(struct net_device *dev, const phy_cmd_t *c)
 {
-	int k;
-
 	if(!c)
 		return;
 
-	for(k = 0; (c+k)->mii_data != mk_mii_end; k++) {
-		mii_queue(dev, (c+k)->mii_data, (c+k)->funct);
-	}
+	for (; c->mii_data != mk_mii_end; c++)
+		mii_queue(dev, c->mii_data, c->funct);
 }
 
 static void mii_parse_sr(uint mii_reg, struct net_device *dev)
