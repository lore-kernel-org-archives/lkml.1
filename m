Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbZBGRYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbZBGRYh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZBGRWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:22:35 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43450 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbZBGRWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:22:32 -0500
Date: Sat, 7 Feb 2009 12:12:33 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com
Subject: [PATCH 3/15] tridentfb: fix memory leaks in removal path
Message-ID: <20090207121233.0a93b4db@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We were leaking the cmap memory.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/tridentfb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/tridentfb.c b/drivers/video/tridentfb.c
index 479b2e7..c5369ba 100644
--- a/drivers/video/tridentfb.c
+++ b/drivers/video/tridentfb.c
@@ -1563,6 +1563,7 @@ static void __devexit trident_pci_remove(struct pci_dev *dev)
 	release_mem_region(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len);
 	pci_set_drvdata(dev, NULL);
 	kfree(info->pixmap.addr);
+	fb_dealloc_cmap(&info->cmap);
 	framebuffer_release(info);
 }
 
-- 
1.5.6.5

