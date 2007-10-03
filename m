Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbXJCSkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbXJCSkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbXJCSkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:40:04 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42180 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbXJCSkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:40:03 -0400
Date: Wed, 3 Oct 2007 14:40:01 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] net driver fixes
Message-ID: <20071003184001.GA28525@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


sky2 is really the only important fix, the others are trivial.


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git upstream-linus

to receive the following updates:

 drivers/net/sky2.c                          |    3 ---
 drivers/net/wireless/bcm43xx/bcm43xx_wx.c   |    2 +-
 net/ieee80211/softmac/ieee80211softmac_wx.c |    2 +-
 3 files changed, 2 insertions(+), 5 deletions(-)

Joe Perches (1):
      bcm43xx: Correct printk with PFX before KERN_

Richard Knutsson (1):
      softmac: Fix compiler-warning

Stephen Hemminger (1):
      sky2: jumbo frame regression fix

diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 162489b..ea117fc 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -2163,9 +2163,6 @@ static struct sk_buff *sky2_receive(struct net_device *dev,
 	sky2->rx_next = (sky2->rx_next + 1) % sky2->rx_pending;
 	prefetch(sky2->rx_ring + sky2->rx_next);
 
-	if (length < ETH_ZLEN || length > sky2->rx_data_size)
-		goto len_error;
-
 	/* This chip has hardware problems that generates bogus status.
 	 * So do only marginal checking and expect higher level protocols
 	 * to handle crap frames.
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_wx.c b/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
index d6d9413..6acfdc4 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_wx.c
@@ -444,7 +444,7 @@ static int bcm43xx_wx_set_xmitpower(struct net_device *net_dev,
 	u16 maxpower;
 
 	if ((data->txpower.flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM) {
-		printk(PFX KERN_ERR "TX power not in dBm.\n");
+		printk(KERN_ERR PFX "TX power not in dBm.\n");
 		return -EOPNOTSUPP;
 	}
 
diff --git a/net/ieee80211/softmac/ieee80211softmac_wx.c b/net/ieee80211/softmac/ieee80211softmac_wx.c
index 442b987..5742dc8 100644
--- a/net/ieee80211/softmac/ieee80211softmac_wx.c
+++ b/net/ieee80211/softmac/ieee80211softmac_wx.c
@@ -114,7 +114,7 @@ check_assoc_again:
 	sm->associnfo.associating = 1;
 	/* queue lower level code to do work (if necessary) */
 	schedule_delayed_work(&sm->associnfo.work, 0);
-out:
+
 	mutex_unlock(&sm->associnfo.mutex);
 
 	return 0;
