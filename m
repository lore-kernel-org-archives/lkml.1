Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbYFBRkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbYFBRkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758193AbYFBRiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:38:50 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:14483 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758130AbYFBRit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:38:49 -0400
Date: Mon, 2 Jun 2008 21:38:48 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>, Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jochen Friedrich <jochen@scram.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] [POWERPC] fsl_soc: remove mpc83xx_wdt code
Message-ID: <20080602173848.GG30705@polina.dev.rtsoft.ru>
References: <20080602173726.GA24556@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080602173726.GA24556@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mpc83xx_wdt is the OF driver now, so we don't need fsl_soc constructor.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/sysdev/fsl_soc.c |   46 -----------------------------------------
 1 files changed, 0 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index a5ceeef..32a3ac8 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -545,52 +545,6 @@ err:
 arch_initcall(fsl_i2c_of_init);
 #endif
 
-#ifdef CONFIG_PPC_83xx
-static int __init mpc83xx_wdt_init(void)
-{
-	struct resource r;
-	struct device_node *np;
-	struct platform_device *dev;
-	u32 freq = fsl_get_sys_freq();
-	int ret;
-
-	np = of_find_compatible_node(NULL, "watchdog", "mpc83xx_wdt");
-
-	if (!np) {
-		ret = -ENODEV;
-		goto nodev;
-	}
-
-	memset(&r, 0, sizeof(r));
-
-	ret = of_address_to_resource(np, 0, &r);
-	if (ret)
-		goto err;
-
-	dev = platform_device_register_simple("mpc83xx_wdt", 0, &r, 1);
-	if (IS_ERR(dev)) {
-		ret = PTR_ERR(dev);
-		goto err;
-	}
-
-	ret = platform_device_add_data(dev, &freq, sizeof(freq));
-	if (ret)
-		goto unreg;
-
-	of_node_put(np);
-	return 0;
-
-unreg:
-	platform_device_unregister(dev);
-err:
-	of_node_put(np);
-nodev:
-	return ret;
-}
-
-arch_initcall(mpc83xx_wdt_init);
-#endif
-
 static enum fsl_usb2_phy_modes determine_usb_phy(const char *phy_type)
 {
 	if (!phy_type)
-- 
1.5.5.1

