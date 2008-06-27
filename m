Return-Path: <linux-kernel-owner+w=401wt.eu-S1762572AbYF0Tew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762572AbYF0Tew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 15:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761720AbYF0Tef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 15:34:35 -0400
Received: from curtis.curtisfong.org ([66.43.110.51]:57358 "EHLO
	curtis.curtisfong.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023AbYF0Tee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 15:34:34 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jun 2008 15:34:34 EDT
Date: Fri, 27 Jun 2008 12:26:51 -0700
From: Nye Liu <nyet@nyet.org>
To: linux-kernel@vger.kernel.org
Cc: pantelis.antoniou@gmail.com, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org
Subject: [PATCH] FS_ENET: Don't attempt to set mii_speed when fec_inf is
	null
Message-ID: <20080627192651.GA28291@curtisfong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nye Liu <nyet@mrv.com>

When using CONFIG_FIXED_PHY, fec_inf (fep->phydev->bus->priv) is NULL in
fs_enet/mac-fec.c restart(). Dereferencing fec_inf when trying to set the
mii_speed causes a kernel oops.

Signed-off-by: Nye Liu <nyet@mrv.com>

---

diff --git a/drivers/net/fs_enet/mac-fec.c b/drivers/net/fs_enet/mac-fec.c
index 8a311d1..350bc73 100644
--- a/drivers/net/fs_enet/mac-fec.c
+++ b/drivers/net/fs_enet/mac-fec.c
@@ -328,7 +328,8 @@ static void restart(struct net_device *dev)
        /*
         * Set MII speed.
         */
-       FW(fecp, mii_speed, fec_inf->mii_speed);
+       if (fec_inf)
+           FW(fecp, mii_speed, fec_inf->mii_speed);
 
        /*
         * Clear any outstanding interrupt.

