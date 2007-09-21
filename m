Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbXIUCFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbXIUCFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 22:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbXIUCFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 22:05:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:26252 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbXIUCFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 22:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Wgc7O0RyCqOMKkL5G+Fjudjj/0ExwAoRNu71bDNza1WyWeTL7uQTuRgP3oIAmCTyR2Opmnk4hdWKF0cI0mBLw1nVMWlmv+D9Hac9/UUKBcHL2aNvJvX/HFp5rBogdBn7MYDNw4LxItR8VrKPs+9QgBApSBzim6mF0t7+B4vViKA=
Date: Thu, 20 Sep 2007 22:04:59 -0400
To: Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] make mv643xx_eth.c build again
Message-ID: <20070921020459.GD31759@nineveh.local>
Mail-Followup-To: Stephen Hemminger <shemminger@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070919235828.GA31759@nineveh.local> <20070919170934.84f44e05.akpm@linux-foundation.org> <f86d6cc00709200721h6e8f7cf8xa2264e9d1f88883b@mail.gmail.com> <f86d6cc00709200912j37a3218boa882a044c0610779@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f86d6cc00709200912j37a3218boa882a044c0610779@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The changeset to "Make NAPI polling independent of struct net_device
objects" forgot to change a function prototype in mv643xx_eth.c, and
also introduced a typo that caused the driver not to build.

Signed-off-by: Joseph Fannin <jfannin@gmail.com>

---

This is build-tested only.

diff -ru linux-2.6.23-rc6-mm1.orig/drivers/net/mv643xx_eth.c linux-2.6.23-rc6-mm1/drivers/net/mv643xx_eth.c
--- linux-2.6.23-rc6-mm1.orig/drivers/net/mv643xx_eth.c	2007-09-20 18:17:41.000000000 -0400
+++ linux-2.6.23-rc6-mm1/drivers/net/mv643xx_eth.c	2007-09-20 18:17:11.000000000 -0400
@@ -65,7 +65,7 @@
 static int mv643xx_eth_change_mtu(struct net_device *, int);
 static void eth_port_init_mac_tables(unsigned int eth_port_num);
 #ifdef MV643XX_NAPI
-static int mv643xx_poll(struct net_device *dev, int budget);
+static int mv643xx_poll(struct napi_struct *napi, int budget);
 #endif
 static int ethernet_phy_get(unsigned int eth_port_num);
 static void ethernet_phy_set(unsigned int eth_port_num, int phy_addr);
@@ -561,7 +561,7 @@
 		/* wait for previous write to complete */
 		mv_read(MV643XX_ETH_INTERRUPT_MASK_REG(port_num));
 
-		netif_rx_schedule(dev, &bp->napi);
+		netif_rx_schedule(dev, &mp->napi);
 	}
 #else
 	if (eth_int_cause & ETH_INT_CAUSE_RX)


--
Joseph Fannin
jfannin@gmail.com

