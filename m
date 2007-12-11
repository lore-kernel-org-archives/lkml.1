Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbXLKWWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbXLKWWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbXLKWV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:21:28 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38489 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756026AbXLKWVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:21:25 -0500
Date: Tue, 11 Dec 2007 23:21:26 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Krzysztof Helt <krzysztof.h1@wp.pl>, adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/video/pm3fb.c section fix
Message-ID: <20071211222126.GH14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatches:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x46e456): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e45c): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e49b): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e4a0): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e4bc): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e4c2): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e5c1): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
WARNING: vmlinux.o(.text+0x46e5c7): Section mismatch: reference to .init.data: (between 'pm3fb_size_memory' and 'update_crtc2')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
2d78ede5eebe2900519b7fc43e688b411e4fdedf 
diff --git a/drivers/video/pm3fb.c b/drivers/video/pm3fb.c
index 0706599..5dba8cd 100644
--- a/drivers/video/pm3fb.c
+++ b/drivers/video/pm3fb.c
@@ -1227,7 +1227,7 @@ static struct fb_ops pm3fb_ops = {
 
 /* mmio register are already mapped when this function is called */
 /* the pm3fb_fix.smem_start is also set */
-static unsigned long pm3fb_size_memory(struct pm3_par *par)
+static unsigned long __devinit pm3fb_size_memory(struct pm3_par *par)
 {
 	unsigned long	memsize = 0;
 	unsigned long	tempBypass, i, temp1, temp2;

