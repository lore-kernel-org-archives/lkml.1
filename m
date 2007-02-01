Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbXBAPgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbXBAPgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbXBAPgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:36:42 -0500
Received: from styx.suse.cz ([82.119.242.94]:34380 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751796AbXBAPg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:36:26 -0500
Date: Thu, 1 Feb 2007 16:36:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 8/10] NET-3c59x: turn local_save_flags() + local_irq_disable()
 into local_irq_save()
In-Reply-To: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0702011617170.13648@jikos.suse.cz>
References: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

NET-3c59x: turn local_save_flags() + local_irq_disable() into local_irq_save()

drivers/net/3c59x.c::poll_vortex() contains local_irq_disable()
after local_save_flags(). Turn it into local_irq_save().

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---

 drivers/net/3c59x.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/3c59x.c b/drivers/net/3c59x.c
index 80bdcf8..716a472 100644
--- a/drivers/net/3c59x.c
+++ b/drivers/net/3c59x.c
@@ -792,8 +792,7 @@ static void poll_vortex(struct net_device *dev)
 {
 	struct vortex_private *vp = netdev_priv(dev);
 	unsigned long flags;
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	(vp->full_bus_master_rx ? boomerang_interrupt:vortex_interrupt)(dev->irq,dev);
 	local_irq_restore(flags);
 }
