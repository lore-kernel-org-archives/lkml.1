Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbZFXLhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbZFXLhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbZFXLgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:36:24 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25455 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192AbZFXLgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:36:23 -0400
From: Imre Deak <imre.deak@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <Tomi.Valkeinen@nokia.com>
Subject: [PATCH 15/20] omapfb: dispc: Enable wake up capability
Date: Wed, 24 Jun 2009 14:33:40 +0300
Message-Id: <b11909c54018be72619164782fcf3d6743d0fddd.1245842329.git.imre.deak@nokia.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cba1956a016f911d20cce07f38a33ebbf6c6186e.1245842329.git.imre.deak@nokia.com>
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
 <1ad64c0995ee88d15ebce74dec4d1da9746367f0.1245842329.git.imre.deak@nokia.com>
 <cba1956a016f911d20cce07f38a33ebbf6c6186e.1245842329.git.imre.deak@nokia.com>
In-Reply-To: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
References: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
X-OriginalArrivalTime: 24 Jun 2009 11:36:14.0888 (UTC) FILETIME=[FB4DCA80:01C9F4BF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jouni Hogander <jouni.hogander@nokia.com>

Without wakeup enable omap doesn't wake up on dispc interrupts. This
causes problems in a case where mpu is in sleep state and dispc
interrupt fires.

Signed-off-by: Jouni Hogander <jouni.hogander@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
 drivers/video/omap/dispc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/omap/dispc.c b/drivers/video/omap/dispc.c
index cc3c817..9adf54e 100644
--- a/drivers/video/omap/dispc.c
+++ b/drivers/video/omap/dispc.c
@@ -1395,10 +1395,10 @@ static int omap_dispc_init(struct omapfb_device *fbdev, int ext_mode,
 		enable_digit_clocks(0);
 	}
 
-	/* Enable smart idle and autoidle */
+	/* Enable smart standby/idle, autoidle and wakeup */
 	l = dispc_read_reg(DISPC_SYSCONFIG);
 	l &= ~((3 << 12) | (3 << 3));
-	l |= (2 << 12) | (2 << 3) | (1 << 0);
+	l |= (2 << 12) | (2 << 3) | (1 << 2) | (1 << 0);
 	dispc_write_reg(DISPC_SYSCONFIG, l);
 	omap_writel(1 << 0, DSS_BASE + DSS_SYSCONFIG);
 
-- 
1.6.3.2

