Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbXKERTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbXKERTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757853AbXKERIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:08:34 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59558 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757254AbXKERI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:08:29 -0500
Date: Mon, 5 Nov 2007 18:08:05 +0100
From: Adrian Bunk <bunk@kernel.org>
To: adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] video/hpfb.c section fix
Message-ID: <20071105170805.GC12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hpfb_init_one() must be __devinit since it's called by the __devinit 
hpfb_dio_probe().

This patch fixes the following section mismatch:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0xb851a): Section mismatch: reference to .init.text:hpfb_init_one (between 'hpfb_dio_probe' and 'read_null')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
bc14fc19ee08ed77903c69901368dfd3503156ce 
diff --git a/drivers/video/hpfb.c b/drivers/video/hpfb.c
index b18486a..2eb4fb1 100644
--- a/drivers/video/hpfb.c
+++ b/drivers/video/hpfb.c
@@ -207,7 +207,8 @@ static struct fb_ops hpfb_ops = {
 #define HPFB_FBOMSB	0x5d	/* Frame buffer offset		*/
 #define HPFB_FBOLSB	0x5f
 
-static int __init hpfb_init_one(unsigned long phys_base, unsigned long virt_base)
+static int __devinit hpfb_init_one(unsigned long phys_base,
+				   unsigned long virt_base)
 {
 	unsigned long fboff, fb_width, fb_height, fb_start;
 

