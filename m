Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbYFIWYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbYFIWYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758993AbYFIWXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:23:19 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47015 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbYFIWXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:23:17 -0400
Date: Tue, 10 Jun 2008 01:22:22 +0300
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, adaplas@gmail.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] export c2p
Message-ID: <20080609222222.GF1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  Building modules, stage 2.
  MODPOST 1203 modules
ERROR: "c2p" [drivers/video/amifb.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
771aaffb33351e9243dd1ff47150f2bb0a32d8f2 diff --git a/drivers/video/c2p.c b/drivers/video/c2p.c
index 03ceb1a..376bc07 100644
--- a/drivers/video/c2p.c
+++ b/drivers/video/c2p.c
@@ -227,5 +227,6 @@ void c2p(u8 *dst, const u8 *src, u32 dx, u32 dy, u32 width, u32 height,
 	dst += dst_nextline;
     }
 }
+EXPORT_SYMBOL_GPL(c2p);
 
 MODULE_LICENSE("GPL");

