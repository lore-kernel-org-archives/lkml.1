Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbXJaP3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbXJaP3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759664AbXJaPZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:25:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33618 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759564AbXJaPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:25:03 -0400
Date: Wed, 31 Oct 2007 08:12:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, jeff@garzik.org,
       Peter Korsgaard <jacmet@sunsite.dk>
Subject: [patch 19/26] dm9601: Fix receive MTU
Message-ID: <20071031151205.GT2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm9601-fix-receive-mtu.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Peter Korsgaard <jacmet@sunsite.dk>

patch f662fe5a0b144efadbfc00e8040e603ec318746e in mainline.

dm9601: Fix receive MTU

dm9601 didn't take the ethernet header into account when calculating
RX MTU, causing packets bigger than 1486 to fail.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/dm9601.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -405,7 +405,7 @@ static int dm9601_bind(struct usbnet *de
 	dev->net->ethtool_ops = &dm9601_ethtool_ops;
 	dev->net->hard_header_len += DM_TX_OVERHEAD;
 	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
-	dev->rx_urb_size = dev->net->mtu + DM_RX_OVERHEAD;
+	dev->rx_urb_size = dev->net->mtu + ETH_HLEN + DM_RX_OVERHEAD;
 
 	dev->mii.dev = dev->net;
 	dev->mii.mdio_read = dm9601_mdio_read;

-- 
