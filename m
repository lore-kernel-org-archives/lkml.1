Return-Path: <linux-kernel-owner+w=401wt.eu-S1751418AbXCEBrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbXCEBrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbXCEBrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:47:16 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49893 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751418AbXCEBrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:47:16 -0500
Date: Mon, 5 Mar 2007 02:47:16 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: [-mm patch] saa7134: fix MODULES=n compilation
Message-ID: <20070305014716.GL3441@stusta.de>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 03:00:26AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm2:
>...
>  git-dvb.patch
>...
>  git trees
>...

This patch fixes the following compile error with CONFIG_MODULES=n:

<--  snip  -->

...
  CC      drivers/media/video/saa7134/saa7134-core.o
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/media/video/saa7134/saa7134-core.c:979:24: error: macro "request_submodules" passed 1 arguments, but takes just 0
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/media/video/saa7134/saa7134-core.c: In function 'saa7134_initdev':
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/media/video/saa7134/saa7134-core.c:979: error: 'request_submodules' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/media/video/saa7134/saa7134-core.c:979: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/linux-2.6.21-rc2-mm1/drivers/media/video/saa7134/saa7134-core.c:979: error: for each function it appears in.)
make[5]: *** [drivers/media/video/saa7134/saa7134-core.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc2-mm1/drivers/media/video/saa7134/saa7134-core.c.old	2007-03-04 14:29:52.000000000 +0100
+++ linux-2.6.21-rc2-mm1/drivers/media/video/saa7134/saa7134-core.c	2007-03-04 14:30:15.000000000 +0100
@@ -203,7 +203,7 @@
 }
 
 #else
-#define request_submodules()
+#define request_submodules(dev)
 #endif /* CONFIG_MODULES */
 
 /* ------------------------------------------------------------------ */
