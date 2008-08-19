Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbYHSAil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbYHSAil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYHSAid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:38:33 -0400
Received: from fmailhost06.isp.att.net ([204.127.217.106]:58799 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYHSAid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:38:33 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2008 20:38:33 EDT
X-Originating-IP: [65.12.36.233]
Date: Mon, 18 Aug 2008 19:28:13 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, link@miggy.org,
       ian@jeffray.co.uk, csnook@redhat.com, jie.yang@atheros.com,
       m@fhloston.org
Subject: [PATCH] atl1: disable TSO by default
Message-ID: <20080818192813.0d0dc1fd@osprey.hogchain.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAIVBMVEV2dXOAgYNxSD+aemaal42A
 gIBqYV2UU07Ik5GXfoFMRTdbKiVwAAACbUlEQVQ4jXXTzWvbMBQAcG3EZsmt0Owc3pgNPo1oxNFt
 pQnEN3Wrs3UnkdXq5tOwIdq9Pci3gUqJexo55KC/cs9O/dHBRIiMfpb03rNE4v800jxIQRzsXPEP
 jDwndhNelo9/ngE/SFdKmZQnfOT0YSSlQBKLiJBDH6w9SPwlp5evpduDr9biQqkV8Rh7p4NRNSO1
 4BHhpjLpIK2gWksIgl0LPLCHoBIcX6dp2kGKMYnfGJnjIFungZeuHA6dhSvqLXrA1zJmVKayCu1w
 DKuGAU+WZRRCsLdBFXgLl2Sw3N2ZEJDAn3VwEV9FK12YUGW+yqlIWiD30U5rbSi2efGuhRfxEXRB
 8e+uJE/AL5z78xrqVg6aBHlMTj9V7x/RJOMGHHI11ItVUW+B0JakkGPcUsJNHuY7/ZA04X4xwQ/D
 3I0FGgaT8iFponoJ26F+sNbu51O7l7QHHtNTbxMc5o/W+kw0S31Ub5i+pQBq/hjYPVPbJ/ic/aoC
 pbTQtxlAvvnZgNod89Y4D2sFXpMHZWU1yHb6Ft+g2aTJY84iY2iY4ySGmWdvmxlDprHkCgd1yDRV
 bXVfFQiZjyuyaU5p1pZkTbXBbxRagAyU2rZfcH2tTQ7+FpNQ4Ofb7lxdFzTHDGqAvHdEv0cIezi2
 be+0vzdUqawaDSATHfB7itGiIfrQu2p8UQOOooHTh5lUPn6lva/qQrWwQpCUTv08hGe3dkU9KWmJ
 Z2EGpAeDFc3kN8oMNbNJ/AzMFERUhjmehB7ws6XBTTnfeOXT9T/C9dn4HEshpPWIjDvgi5Px2U0G
 Hl7dzaQHg8U4Xn6oa4g3vVnqLz3ribDLdyFmAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atl1 driver is causing stalled connections and file corruption
whenever TSO is enabled.  Two examples are here:

http://lkml.org/lkml/2008/7/15/325
http://lkml.org/lkml/2008/8/18/543

Disable TSO by default until we can determine the source of the
problem.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
cc: stable@kernel.org
---

Jeff, I've been trying to find the source of this problem in my
spare time for a few weeks now, but haven't been successful.  We
turned on TSO by default in 2.6.26 after fixing a nasty performance
bug in it, but there's apparently another bug lurking.

This patch needs to be also applied to 2.6.26, hence the cc to
stable.

 drivers/net/atlx/atl1.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index e6a7bb7..e23ce77 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -3022,7 +3022,6 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 	netdev->features = NETIF_F_HW_CSUM;
 	netdev->features |= NETIF_F_SG;
 	netdev->features |= (NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX);
-	netdev->features |= NETIF_F_TSO;
 	netdev->features |= NETIF_F_LLTX;
 
 	/*
-- 
1.5.5.1
