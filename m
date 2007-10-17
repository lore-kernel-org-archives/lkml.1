Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbXJQOd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbXJQOd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 10:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbXJQOdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 10:33:18 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:48097 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbXJQOdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 10:33:17 -0400
Date: Wed, 17 Oct 2007 15:33:13 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [FB] au1100fb: Fix modpost warnings.
Message-ID: <20071017143313.GA17876@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x170be8): Section mismatch: reference to .init.data:au1100fb_fix (between 'au1100fb_drv_probe' and 'read_null')
WARNING: vmlinux.o(.text+0x170dc4): Section mismatch: reference to .init.data:au1100fb_var (between 'au1100fb_drv_probe' and 'read_null')
WARNING: vmlinux.o(.text+0x170dd0): Section mismatch: reference to .init.data:au1100fb_fix (between 'au1100fb_drv_probe' and 'read_null')
WARNING: vmlinux.o(.text+0x170de0): Section mismatch: reference to .init.data:au1100fb_var (between 'au1100fb_drv_probe' and 'read_null')
WARNING: vmlinux.o(.text+0x170e70): Section mismatch: reference to .init.data:au1100fb_var (between 'au1100fb_drv_probe' and 'read_null')

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/drivers/video/au1100fb.c b/drivers/video/au1100fb.c
index 832e461..62bd444 100644
--- a/drivers/video/au1100fb.c
+++ b/drivers/video/au1100fb.c
@@ -457,7 +457,7 @@ static struct fb_ops au1100fb_ops =
 
 /* AU1100 LCD controller device driver */
 
-int au1100fb_drv_probe(struct device *dev)
+static int __init au1100fb_drv_probe(struct device *dev)
 {
 	struct au1100fb_device *fbdev = NULL;
 	struct resource *regs_res;
