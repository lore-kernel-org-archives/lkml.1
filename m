Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbXGAU0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbXGAU0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759116AbXGAUWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:22:55 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:46879 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759401AbXGAUWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:22:54 -0400
Date: Sun, 1 Jul 2007 22:23:20 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc6-mm1: TUNER_TEA5761 kconfig fixes
Message-ID: <20070701202320.GS10869@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm2:
>...
>  git-dvb.patch
>...
>  git trees
>...


The following doesn't make much sense:

drivers/media/video/Kconfig:
...
config TUNER_TEA5761
        tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
...

drivers/media/video/Makefile:
...
ifneq ($(CONFIG_TUNER_TEA5761),)
  tuner-objs += tea5761.o
endif
...

With this setup, TUNER_TEA5761=m is equivalent to TUNER_TEA5761=y.

This patch therefore changes TUNER_TEA5761 to a bool.

The missing dependency on EXPERIMENTAL the prompt text indicates also 
gets added by this patch.

Additionally, the Makefile entry can now be written in a more compact way.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

BTW: tea5761.c is currently completely unused.

 drivers/media/video/Kconfig  |    3 ++-
 drivers/media/video/Makefile |    4 +---
 2 files changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.22-rc6-mm1/drivers/media/video/Kconfig.old	2007-06-30 03:51:13.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/media/video/Kconfig	2007-06-30 03:51:40.000000000 +0200
@@ -490,7 +490,8 @@
 	  If in doubt, say N.
 
 config TUNER_TEA5761
-	tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
+	bool "TEA 5761 radio tuner (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
 	depends on I2C
 	select VIDEO_TUNER
 	help
--- linux-2.6.22-rc6-mm1/drivers/media/video/Makefile.old	2007-06-30 03:52:00.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/media/video/Makefile	2007-06-30 03:53:25.000000000 +0200
@@ -7,9 +7,7 @@
 tuner-objs	:=	tuner-core.o tuner-types.o tuner-simple.o \
 			mt20xx.o tda8290.o tea5767.o tda9887.o
 
-ifneq ($(CONFIG_TUNER_TEA5761),)
-  tuner-objs += tea5761.o
-endif
+tuner-$(CONFIG_TUNER_TEA5761)	+= tea5761.o
 
 msp3400-objs	:=	msp3400-driver.o msp3400-kthreads.o
 
