Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbZLGAP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbZLGAP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934389AbZLGAOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:14:09 -0500
Received: from kroah.org ([198.145.64.141]:34765 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932836AbZLGAOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:01 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:59 2009
Message-Id: <20091207000659.288315232@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Brandon Philips <bphilips@suse.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: [106/119] sky2: set carrier off in probe
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=sky2-set-carrier-off-in-probe.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Brandon Philips <bphilips@suse.de>

commit 33cb7d33a1c36e07839d08a4d1a33bf6a0f70bba upstream.

Before bringing up a sky2 interface up ethtool reports
"Link detected: yes". Do as ixgbe does and netif_carrier_off() on
probe().

Signed-off-by: Brandon Philips <bphilips@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sky2.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -4528,6 +4528,8 @@ static int __devinit sky2_probe(struct p
 		goto err_out_free_netdev;
 	}
 
+	netif_carrier_off(dev);
+
 	netif_napi_add(dev, &hw->napi, sky2_poll, NAPI_WEIGHT);
 
 	err = request_irq(pdev->irq, sky2_intr,


