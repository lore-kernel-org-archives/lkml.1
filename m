Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbYGPNnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbYGPNnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 09:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbYGPNne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 09:43:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:42779 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122AbYGPNnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 09:43:33 -0400
Date: Wed, 16 Jul 2008 08:39:12 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: linuxppc-dev@ozlabs.org
cc: davej@redhat.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc/ep8248e: Fix compile problem if !CONFIG_FS_ENET
Message-ID: <Pine.LNX.4.64.0807160838520.14127@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't enable FS_ENET we get build issues:

arch/powerpc/platforms/built-in.o: In function `ep8248e_mdio_probe':
arch/powerpc/platforms/82xx/ep8248e.c:129: undefined reference to `alloc_mdio_bitbang'
arch/powerpc/platforms/82xx/ep8248e.c:143: undefined reference to `mdiobus_register'

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

In my powerpc-next tree.

- k

 arch/powerpc/platforms/82xx/ep8248e.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/82xx/ep8248e.c b/arch/powerpc/platforms/82xx/ep8248e.c
index d5770fd..373e993 100644
--- a/arch/powerpc/platforms/82xx/ep8248e.c
+++ b/arch/powerpc/platforms/82xx/ep8248e.c
@@ -59,6 +59,7 @@ static void __init ep8248e_pic_init(void)
 	of_node_put(np);
 }

+#ifdef CONFIG_FS_ENET_MDIO_FCC
 static void ep8248e_set_mdc(struct mdiobb_ctrl *ctrl, int level)
 {
 	if (level)
@@ -164,6 +165,7 @@ static struct of_platform_driver ep8248e_mdio_driver = {
 	.probe = ep8248e_mdio_probe,
 	.remove = ep8248e_mdio_remove,
 };
+#endif

 struct cpm_pin {
 	int port, pin, flags;
@@ -296,7 +298,9 @@ static  __initdata struct of_device_id of_bus_ids[] = {
 static int __init declare_of_platform_devices(void)
 {
 	of_platform_bus_probe(NULL, of_bus_ids, NULL);
+#ifdef CONFIG_FS_ENET_MDIO_FCC
 	of_register_platform_driver(&ep8248e_mdio_driver);
+#endif

 	return 0;
 }
-- 
1.5.5.1

