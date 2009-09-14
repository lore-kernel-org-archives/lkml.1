Return-Path: <linux-kernel-owner+w=401wt.eu-S933645AbZINUJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbZINUJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933216AbZINUI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54110 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933589AbZINUIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Stefan Pledl <stefan.pledl@mesutronic.de>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 42/72] Blackfin: bf548-ezkit: fix incorrect LCD size parameters
Date: Mon, 14 Sep 2009 16:07:46 -0400
Message-Id: <1252958896-25150-43-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Pledl <stefan.pledl@mesutronic.de>

I think we have to use the physical dimensions [mm] of the display for
.width and .heigth in struct bfin_bf54xfb_mach_info bf54x_lq043_data which
are copied to fbinfo->var.height/.width in bf54x-lq043fb.c.

linux/fb.h describes this values as 'height/weight of picture in mm'

Otherwise QT calcs the wrong dpi value and the displayed fonts are very
small.

Signed-off-by: Stefan Pledl <stefan.pledl@mesutronic.de>
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf548/boards/ezkit.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index aa82836..3c06010 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -99,8 +99,8 @@ static struct platform_device bfin_isp1760_device = {
 #include <mach/bf54x-lq043.h>
 
 static struct bfin_bf54xfb_mach_info bf54x_lq043_data = {
-	.width =	480,
-	.height =	272,
+	.width =	95,
+	.height =	54,
 	.xres =		{480, 480, 480},
 	.yres =		{272, 272, 272},
 	.bpp =		{24, 24, 24},
-- 
1.6.4.2

