Return-Path: <linux-kernel-owner+w=401wt.eu-S932141AbZD2WiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbZD2WiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760267AbZD2WVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:48 -0400
Received: from kroah.org ([198.145.64.141]:40500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758928AbZD2WVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:29 2009
Message-Id: <20090429220929.451364200@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Francois Romieu <romieu@fr.zoreil.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 43/58] r8169: use hardware auto-padding.
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=r8169-use-hardware-auto-padding.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

Upstream as 97d477a914b146e7e6722ded21afa79886ae8ccd (post 2.6.28).

It shortens the code and fixes the current pci_unmap leak with
padded skb reported by Dave Jones.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2549,13 +2549,6 @@ static int rtl8169_start_xmit(struct sk_
 		opts1 |= FirstFrag;
 	} else {
 		len = skb->len;
-
-		if (unlikely(len < ETH_ZLEN)) {
-			if (skb_padto(skb, ETH_ZLEN))
-				goto err_update_stats;
-			len = ETH_ZLEN;
-		}
-
 		opts1 |= FirstFrag | LastFrag;
 		tp->tx_skb[entry].skb = skb;
 	}
@@ -2593,7 +2586,6 @@ out:
 err_stop:
 	netif_stop_queue(dev);
 	ret = NETDEV_TX_BUSY;
-err_update_stats:
 	dev->stats.tx_dropped++;
 	goto out;
 }


