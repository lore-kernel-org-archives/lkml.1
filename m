Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbZFXLlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbZFXLlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757893AbZFXLgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:36:53 -0400
Received: from smtp.nokia.com ([192.100.105.134]:58216 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987AbZFXLgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:36:51 -0400
From: Imre Deak <imre.deak@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <Tomi.Valkeinen@nokia.com>
Subject: [PATCH 13/20] omapfb: dispc: Various typo fixes
Date: Wed, 24 Jun 2009 14:33:38 +0300
Message-Id: <1ad64c0995ee88d15ebce74dec4d1da9746367f0.1245842329.git.imre.deak@nokia.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <db880b91c36cbd5672f503e249d44411448533bd.1245842329.git.imre.deak@nokia.com>
References: <1245843225-1036-1-git-send-email-imre.deak@nokia.com>
 <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
 <5cf7e298c3b70ad6e07d34034cc901689445e978.1245842329.git.imre.deak@nokia.com>
 <f2b49525146391a3d01b944bf4ebce045cb503d4.1245842329.git.imre.deak@nokia.com>
 <9cecdc5077b72042551eb8e3dc96911e9f4fa3fd.1245842329.git.imre.deak@nokia.com>
 <a3b6ef17cc694c350bc3a585a1697cf57cb0b1c1.1245842329.git.imre.deak@nokia.com>
 <0e2b7b0555c657a8eab00df0091b9828fb292f4c.1245842329.git.imre.deak@nokia.com>
 <af3d1e0dff22f0bb72f6ccee57dfa9a1e5f31abb.1245842329.git.imre.deak@nokia.com>
 <6881ca5b34fcf36c3f39b13de85857dcc20f568d.1245842329.git.imre.deak@nokia.com>
 <726d4af0547b42ec8a9af7c6f0079cf9b7fadf5c.1245842329.git.imre.deak@nokia.com>
 <742d96c9c8d6826eddd49a913b6adaa8f176edbe.1245842329.git.imre.deak@nokia.com>
 <279625bb9ea911185e017cdf8d18a46f263fbb5c.1245842329.git.imre.deak@nokia.com>
 <db880b91c36cbd5672f503e249d44411448533bd.1245842329.git.imre.deak@nokia.com>
In-Reply-To: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
References: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
X-OriginalArrivalTime: 24 Jun 2009 11:36:11.0382 (UTC) FILETIME=[F936D160:01C9F4BF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- value and register offset was swapped in a dispc write
- DISPC_CONTROL register was used instead of DISPC_SYSCONFIG
- FIFO size bit field had incorrect length for OMAP3

Fixed-by: arun <arunedarath@mistralsolutions.com>
Fixed-by: Kalle Jokiniemi <ext-kalle.jokiniemi@nokia.com>
Fixed-by: Andrzej Zaborowski <balrog@zabor.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
 drivers/video/omap/dispc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/omap/dispc.c b/drivers/video/omap/dispc.c
index 148cbcc..2db8fbb 100644
--- a/drivers/video/omap/dispc.c
+++ b/drivers/video/omap/dispc.c
@@ -286,7 +286,7 @@ static void setup_plane_fifo(int plane, int ext_mode)
 	BUG_ON(plane > 2);
 
 	l = dispc_read_reg(fsz_reg[plane]);
-	l &= FLD_MASK(0, 9);
+	l &= FLD_MASK(0, 11);
 	if (ext_mode) {
 		low = l * 3 / 4;
 		high = l;
@@ -294,7 +294,7 @@ static void setup_plane_fifo(int plane, int ext_mode)
 		low = l / 4;
 		high = l * 3 / 4;
 	}
-	MOD_REG_FLD(ftrs_reg[plane], FLD_MASK(16, 9) | FLD_MASK(0, 9),
+	MOD_REG_FLD(ftrs_reg[plane], FLD_MASK(16, 12) | FLD_MASK(0, 12),
 			(high << 16) | low);
 }
 
@@ -1397,7 +1397,7 @@ static int omap_dispc_init(struct omapfb_device *fbdev, int ext_mode,
 	}
 
 	/* Enable smart idle and autoidle */
-	l = dispc_read_reg(DISPC_CONTROL);
+	l = dispc_read_reg(DISPC_SYSCONFIG);
 	l &= ~((3 << 12) | (3 << 3));
 	l |= (2 << 12) | (2 << 3) | (1 << 0);
 	dispc_write_reg(DISPC_SYSCONFIG, l);
@@ -1409,7 +1409,7 @@ static int omap_dispc_init(struct omapfb_device *fbdev, int ext_mode,
 	dispc_write_reg(DISPC_CONFIG, l);
 
 	l = dispc_read_reg(DISPC_IRQSTATUS);
-	dispc_write_reg(l, DISPC_IRQSTATUS);
+	dispc_write_reg(DISPC_IRQSTATUS, l);
 
 	/* Enable those that we handle always */
 	omap_dispc_enable_irqs(DISPC_IRQ_FRAMEMASK);
-- 
1.6.3.2

