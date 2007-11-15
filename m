Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbXKOGtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbXKOGtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762633AbXKOGnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:43:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57671 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762246AbXKOGnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:43:05 -0500
Date: Wed, 14 Nov 2007 22:41:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 13/16] zd1201: avoid null ptr access of skb->dev
Message-ID: <20071115064106.GM18951@kroah.com>
References: <20071115060353.071060513@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="zd1201-avoid-null-ptr-access-of-skb-dev.patch"
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John W. Linville <linville@tuxdriver.com>

patch 3ba72b25211217de195e3f528dd36132b38a205b in mainline.

skb->dev is not set until eth_type_trans is called...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/zd1201.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -327,8 +327,8 @@ static void zd1201_usbrx(struct urb *urb
 			memcpy(skb_put(skb, 6), &data[datalen-8], 6);
 			memcpy(skb_put(skb, 2), &data[datalen-24], 2);
 			memcpy(skb_put(skb, len), data, len);
-			skb->dev->last_rx = jiffies;
 			skb->protocol = eth_type_trans(skb, zd->dev);
+			skb->dev->last_rx = jiffies;
 			zd->stats.rx_packets++;
 			zd->stats.rx_bytes += skb->len;
 			netif_rx(skb);
@@ -384,8 +384,8 @@ static void zd1201_usbrx(struct urb *urb
 			memcpy(skb_put(skb, 2), &data[6], 2);
 			memcpy(skb_put(skb, len), data+8, len);
 		}
-		skb->dev->last_rx = jiffies;
 		skb->protocol = eth_type_trans(skb, zd->dev);
+		skb->dev->last_rx = jiffies;
 		zd->stats.rx_packets++;
 		zd->stats.rx_bytes += skb->len;
 		netif_rx(skb);

-- 
