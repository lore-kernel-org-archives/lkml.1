Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZFJDgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZFJDgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbZFJDdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:33:51 -0400
Received: from kroah.org ([198.145.64.141]:56698 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880AbZFJDdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:33:50 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:42 2009
Message-Id: <20090610002342.430456505@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 12/60] vlan/macvlan: fix NULL pointer dereferences in ethtool handlers
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=vlan-macvlan-fix-null-pointer-dereferences-in-ethtool-handlers.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[ Upstream commit 7816a0a862d851d0b05710e7d94bfe390f3180e2 ]

Check whether the underlying device provides a set of ethtool ops before
checking for individual handlers to avoid NULL pointer dereferences.

Reported-by: Art van Breemen <ard@telegraafnet.nl>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/macvlan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -328,7 +328,8 @@ static u32 macvlan_ethtool_get_rx_csum(s
 	const struct macvlan_dev *vlan = netdev_priv(dev);
 	struct net_device *lowerdev = vlan->lowerdev;
 
-	if (lowerdev->ethtool_ops->get_rx_csum == NULL)
+	if (lowerdev->ethtool_ops == NULL ||
+	    lowerdev->ethtool_ops->get_rx_csum == NULL)
 		return 0;
 	return lowerdev->ethtool_ops->get_rx_csum(lowerdev);
 }


