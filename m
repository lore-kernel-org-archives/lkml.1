Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935573Ab0CMAci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:32:38 -0500
Received: from kroah.org ([198.145.64.141]:46838 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935399Ab0CMAbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:19 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:09 2010
Message-Id: <20100313002709.080540894@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David J. Choi" <david.choi@micrel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [044/145] drivers/net: ks8851_mll ethernet network driver
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Choi, David <David.Choi@Micrel.Com>

[ Upstream commit aeedba8bd2cf2f6f7b45bc7853754a03bc926797 ]

Hello David Miller,

I fix a bug in ks8851_mll driver, which has existed since 2.6.32-rc6.

>From : David J. Choi <david.choi@micrel.com>

Fix a bug that the data pointers in the interrupt handler are set wrong, which is related with the 5th parameter of request_irq().

Signed-off-by: David J. Choi <david.choi@micrel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ks8851_mll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ks8851_mll.c
+++ b/drivers/net/ks8851_mll.c
@@ -854,8 +854,8 @@ static void ks_update_link_status(struct
 
 static irqreturn_t ks_irq(int irq, void *pw)
 {
-	struct ks_net *ks = pw;
-	struct net_device *netdev = ks->netdev;
+	struct net_device *netdev = pw;
+	struct ks_net *ks = netdev_priv(netdev);
 	u16 status;
 
 	/*this should be the first in IRQ handler */


