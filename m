Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbYDNHua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbYDNHua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759261AbYDNHuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:50:14 -0400
Received: from mail.queued.net ([207.210.101.209]:4873 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303AbYDNHuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:50:12 -0400
Date: Mon, 14 Apr 2008 03:52:13 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, info-linux@geode.amd.com,
       jordan.crouse@amd.com, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 1/3] gxfb/lxfb: use VSA definitions when fetching
 framebuffer size
Message-ID: <20080414035213.1223c84b@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


..Rather than using magic constants.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/geode/display_gx.c |    7 ++++---
 drivers/video/geode/lxfb_ops.c   |    6 +++---
 include/asm-x86/geode.h          |    1 +
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/video/geode/display_gx.c b/drivers/video/geode/display_gx.c
index 3743c87..1e82ecc 100644
--- a/drivers/video/geode/display_gx.c
+++ b/drivers/video/geode/display_gx.c
@@ -17,6 +17,7 @@
 #include <asm/io.h>
 #include <asm/div64.h>
 #include <asm/delay.h>
+#include <asm/geode.h>
 
 #include "gxfb.h"
 
@@ -28,10 +29,10 @@ unsigned int gx_frame_buffer_size(void)
 	/* Virtual register class = 0x02 */
 	/* VG_MEM_SIZE(512Kb units) = 0x00 */
 
-	outw(0xFC53, 0xAC1C);
-	outw(0x0200, 0xAC1C);
+	outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
+	outw(VSA_VR_MEM_SIZE, VSA_VRC_INDEX);
 
-	val = (unsigned int)(inw(0xAC1E)) & 0xFFl;
+	val = (unsigned int)(inw(VSA_VRC_DATA)) & 0xFFl;
 	return (val << 19);
 }
 
diff --git a/drivers/video/geode/lxfb_ops.c b/drivers/video/geode/lxfb_ops.c
index c0413ea..51080db 100644
--- a/drivers/video/geode/lxfb_ops.c
+++ b/drivers/video/geode/lxfb_ops.c
@@ -283,10 +283,10 @@ unsigned int lx_framebuffer_size(void)
 	/* Virtual Register Class    = 0x02                     */
 	/* VG_MEM_SIZE (1MB units)   = 0x00                     */
 
-	outw(0xFC53, 0xAC1C);
-	outw(0x0200, 0xAC1C);
+	outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
+	outw(VSA_VR_MEM_SIZE, VSA_VRC_INDEX);
 
-	val = (unsigned int)(inw(0xAC1E)) & 0xFE;
+	val = (unsigned int)(inw(VSA_VRC_DATA)) & 0xFE;
 	return (val << 20);
 }
 
diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
index 6cded63..6c8a2a0 100644
--- a/include/asm-x86/geode.h
+++ b/include/asm-x86/geode.h
@@ -109,6 +109,7 @@ extern int geode_get_dev_base(unsigned int dev);
 #define VSA_VRC_DATA		0xAC1E
 #define VSA_VR_UNLOCK		0xFC53	/* unlock virtual register */
 #define VSA_VR_SIGNATURE	0x0003
+#define VSA_VR_MEM_SIZE		0x0200
 #define VSA_SIG			0x4132	/* signature is ascii 'VSA2' */
 
 /* GPIO */
-- 
1.5.4.4



-- 
Need a kernel or Debian developer?  Contact me, I'm looking for contracts.
