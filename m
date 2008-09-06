Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbYIFRaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbYIFRaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYIFRaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:30:05 -0400
Received: from bu3sch.de ([62.75.166.246]:40367 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbYIFRaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:30:04 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43 G-PHY: Remove mmiowb()
Date: Sat, 6 Sep 2008 19:28:55 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809061928.56550.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It causes compile errors on m68k and it is not needed.
Remove it.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for the next merge window.


Index: wireless-testing/drivers/net/wireless/b43/phy_g.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_g.c	2008-09-06 15:06:56.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_g.c	2008-09-06 19:24:35.000000000 +0200
@@ -383,13 +383,12 @@ static void b43_set_original_gains(struc
 }
 
 /* http://bcm-specs.sipsolutions.net/NRSSILookupTable */
 void b43_nrssi_hw_write(struct b43_wldev *dev, u16 offset, s16 val)
 {
 	b43_phy_write(dev, B43_PHY_NRSSILT_CTRL, offset);
-	mmiowb();
 	b43_phy_write(dev, B43_PHY_NRSSILT_DATA, (u16) val);
 }
 
 /* http://bcm-specs.sipsolutions.net/NRSSILookupTable */
 s16 b43_nrssi_hw_read(struct b43_wldev *dev, u16 offset)
 {
