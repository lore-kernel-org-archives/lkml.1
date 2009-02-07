Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZBGRSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZBGRSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbZBGRSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:18:35 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43423 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbZBGRSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:18:35 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Feb 2009 12:18:35 EST
Date: Sat, 7 Feb 2009 12:18:31 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com
Subject: [PATCH 11/15] tgafb: fix cmap memory leak
Message-ID: <20090207121831.11c34988@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - fix cmap leak when register_framebuffer fails

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/tgafb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/video/tgafb.c b/drivers/video/tgafb.c
index 680642c..a86046f 100644
--- a/drivers/video/tgafb.c
+++ b/drivers/video/tgafb.c
@@ -1663,7 +1663,7 @@ tgafb_register(struct device *dev)
 	if (register_framebuffer(info) < 0) {
 		printk(KERN_ERR "tgafb: Could not register framebuffer\n");
 		ret = -EINVAL;
-		goto err1;
+		goto err2;
 	}
 
 	if (tga_bus_pci) {
@@ -1682,6 +1682,8 @@ tgafb_register(struct device *dev)
 
 	return 0;
 
+ err2:
+	fb_dealloc_cmap(&info->cmap);
  err1:
 	if (mem_base)
 		iounmap(mem_base);
-- 
1.5.6.5

