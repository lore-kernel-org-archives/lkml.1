Return-Path: <linux-kernel-owner+w=401wt.eu-S1761620AbXGaWUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761620AbXGaWUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbXGaWT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:19:57 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1819 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbXGaWT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:19:56 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 81] drivers/net/wireless/zd1201.c: kmalloc + memset conversion to kzalloc
Date: Wed, 1 Aug 2007 00:19:56 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net, pe1rxq@amsat.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708010019.56944.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/net/wireless/zd1201.c | 47231 -> 47205 (-26 bytes)
 drivers/net/wireless/zd1201.o | 216884 -> 216984 (+100 bytes)

 drivers/net/wireless/zd1201.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/net/wireless/zd1201.c	2007-07-26 13:07:43.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/net/wireless/zd1201.c	2007-07-30 00:29:07.000000000 +0200
@@ -522,7 +522,7 @@ static int zd1201_setconfig(struct zd120
 	zd->rxdatas = 0;
 	zd->rxlen = 0;
 	for (seq=0; len > 0; seq++) {
-		request = kmalloc(16, gfp_mask);
+		request = kzalloc(16, gfp_mask);
 		if (!request)
 			return -ENOMEM;
 		urb = usb_alloc_urb(0, gfp_mask);
@@ -530,7 +530,6 @@ static int zd1201_setconfig(struct zd120
 			kfree(request);
 			return -ENOMEM;
 		}
-		memset(request, 0, 16);
 		reqlen = len>12 ? 12 : len;
 		request[0] = ZD1201_USB_RESREQ;
 		request[1] = seq;
