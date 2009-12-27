Return-Path: <linux-kernel-owner+w=401wt.eu-S1751407AbZL0VTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbZL0VTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZL0VTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:19:17 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48607 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZL0VTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:19:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=GCggLtiiIyEzRNcAnQBJ8G/Qou5rajFKaplF2KKWWE0XA4bvN9caSRMyeEmf1+7Jog
         G93rI9ULOYZjIcnBcmr62YcijqCW6duff7QoMUrb/ABZ+hm+9CF1K3sN+IeHWTnUxlF6
         gx4I7dg37Frf4sb7UYl4AuZ7quPL7aPS1blIw=
Message-ID: <4B37D000.6070009@gmail.com>
Date: Sun, 27 Dec 2009 22:22:08 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Petko Manolov <petkan@users.sourceforge.net>, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] usbnet: test off by one
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With `while (i++ < MII_TIMEOUT)' i reaches MII_TIMEOUT + 1 after the loop
This is probably unlikely a problem in practice.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/usb/rtl8150.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index f14d225..fd19db0 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -270,7 +270,7 @@ static int read_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 * reg)
 		get_registers(dev, PHYCNT, 1, data);
 	} while ((data[0] & PHY_GO) && (i++ < MII_TIMEOUT));
 
-	if (i < MII_TIMEOUT) {
+	if (i <= MII_TIMEOUT) {
 		get_registers(dev, PHYDAT, 2, data);
 		*reg = data[0] | (data[1] << 8);
 		return 0;
@@ -295,7 +295,7 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
 		get_registers(dev, PHYCNT, 1, data);
 	} while ((data[0] & PHY_GO) && (i++ < MII_TIMEOUT));
 
-	if (i < MII_TIMEOUT)
+	if (i <= MII_TIMEOUT)
 		return 0;
 	else
 		return 1;
