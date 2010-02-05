Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab0BENmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:42:46 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58368 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932444Ab0BENmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:42:44 -0500
Date: Fri, 5 Feb 2010 14:42:57 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Anatolij Gustschin <agust@denx.de>,
       Alexander Shishkin <virtuoso@slind.org>,
       Valentin Sitdikov <valentin.sitdikov@siemens.com>,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: vamos@i4.informatik.uni-erlangen.de
Subject: [PATCH] obsolete config in kernel source (LWMON5)
Message-ID: <20100205134256.GB7077@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	LWMON5 is a larger chunk from the kategory unreachable and
here for ever. Seems this board was either only available from
external trees or has been removed a long time ago. If you agree it
might be worth removing it.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

----
>From 8334822cc79b4cf0b7f6844ebd952ebb24ee046f Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Fri, 5 Feb 2010 13:49:13 +0100
Subject: [PATCH] Remove conditionalizing on LWMON5

There was some condigionalizing for the LWMON5 boards in kernel
source. However infrastructure for enabling this isn't here so
probably the special case code can go as well.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 drivers/video/mb862xx/mb862xxfb.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/video/mb862xx/mb862xxfb.c b/drivers/video/mb862xx/mb862xxfb.c
index fabb0c5..8280a58 100644
--- a/drivers/video/mb862xx/mb862xxfb.c
+++ b/drivers/video/mb862xx/mb862xxfb.c
@@ -31,15 +31,6 @@
 #define CARMINE_MEM_SIZE	0x8000000
 #define DRV_NAME		"mb862xxfb"
 
-#if defined(CONFIG_LWMON5)
-static struct mb862xx_gc_mode lwmon5_gc_mode = {
-	/* Mode for Sharp LQ104V1DG61 TFT LCD Panel */
-	{ "640x480", 60, 640, 480, 40000, 48, 16, 32, 11, 96, 2, 0, 0, 0 },
-	/* 16 bits/pixel, 32MB, 100MHz, SDRAM memory mode value */
-	16, 0x2000000, GC_CCF_COT_100, 0x414fb7f2
-};
-#endif
-
 #if defined(CONFIG_SOCRATES)
 static struct mb862xx_gc_mode socrates_gc_mode = {
 	/* Mode for Prime View PM070WL4 TFT LCD Panel */
@@ -600,10 +591,6 @@ static int __devinit of_platform_mb862xx_probe(struct of_device *ofdev,
 		goto irqdisp;
 	}
 
-#if defined(CONFIG_LWMON5)
-	par->gc_mode = &lwmon5_gc_mode;
-#endif
-
 #if defined(CONFIG_SOCRATES)
 	par->gc_mode = &socrates_gc_mode;
 #endif
-- 
1.6.3.3





