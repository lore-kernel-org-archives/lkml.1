Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZBGRYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZBGRYV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbZBGRWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:22:35 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43449 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZBGRWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:22:32 -0500
Date: Sat, 7 Feb 2009 12:12:24 -0500
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com
Subject: [PATCH 2/15] tdfxfb: fix memory leaks in removal path
Message-ID: <20090207121224.1e162373@ephemeral>
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
 drivers/video/tdfxfb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/tdfxfb.c b/drivers/video/tdfxfb.c
index 14bd3f3..ee64771 100644
--- a/drivers/video/tdfxfb.c
+++ b/drivers/video/tdfxfb.c
@@ -1393,6 +1393,7 @@ static void __devexit tdfxfb_remove(struct pci_dev *pdev)
 	release_mem_region(pci_resource_start(pdev, 0),
 			   pci_resource_len(pdev, 0));
 	pci_set_drvdata(pdev, NULL);
+	fb_dealloc_cmap(&info->cmap);
 	framebuffer_release(info);
 }
 
-- 
1.5.6.5

