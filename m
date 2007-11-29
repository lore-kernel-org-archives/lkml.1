Return-Path: <linux-kernel-owner+w=401wt.eu-S934223AbXK2Wip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223AbXK2Wip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761184AbXK2Wih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:38:37 -0500
Received: from adelie.canonical.com ([91.189.90.139]:57473 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759713AbXK2Wig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:38:36 -0500
X-Greylist: delayed 2182 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Nov 2007 17:38:36 EST
Subject: [SPARC64] Export symbols for sunvnet and sunvdc to be built modular
From: Ben Collins <ben.collins@ubuntu.com>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 29 Nov 2007 17:02:10 -0500
Message-Id: <1196373730.13800.2.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes this build failure:
    
ERROR: "vio_driver_init" [drivers/net/sunvnet.ko] undefined!
ERROR: "vio_driver_init" [drivers/block/sunvdc.ko] undefined!
ERROR: "ldc_map_sg" [drivers/block/sunvdc.ko] undefined!
    
Signed-off-by: Ben Collins <bcollins@ubuntu.com>

diff --git a/arch/sparc64/kernel/ldc.c b/arch/sparc64/kernel/ldc.c
index cbe6fa2..be80948 100644
--- a/arch/sparc64/kernel/ldc.c
+++ b/arch/sparc64/kernel/ldc.c
@@ -2105,6 +2105,7 @@ int ldc_map_sg(struct ldc_channel *lp,
 
 	return state.nc;
 }
+EXPORT_SYMBOL(ldc_map_sg);
 
 int ldc_map_single(struct ldc_channel *lp,
 		   void *buf, unsigned int len,
diff --git a/arch/sparc64/kernel/viohs.c b/arch/sparc64/kernel/viohs.c
index eeeb5ed..708fa17 100644
--- a/arch/sparc64/kernel/viohs.c
+++ b/arch/sparc64/kernel/viohs.c
@@ -819,3 +819,4 @@ int vio_driver_init(struct vio_driver_state *vio, struct vio_dev *vdev,
 
 	return 0;
 }
+EXPORT_SYMBOL(vio_driver_init);

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/
SwissDisk: http://www.swissdisk.com/

