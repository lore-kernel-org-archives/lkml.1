Return-Path: <linux-kernel-owner+w=401wt.eu-S1758444AbYBQM1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444AbYBQM1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbYBQMXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:11 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38352 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342AbYBQMW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:57 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Antonino Daplas <adaplas@gmail.com>,
       Michal Januszewski <spock@gentoo.org>
Subject: [PATCH 18/27] video: fix section mismatch warnings in uvesafb
Date: Sun, 17 Feb 2008 13:22:55 +0100
Message-Id: <1203250984-11285-18-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: vmlinux.o(.text+0x51961b): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:mtrr
WARNING: vmlinux.o(.text+0x519641): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:mtrr
WARNING: vmlinux.o(.text+0x519664): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:pmi_setpal
WARNING: vmlinux.o(.text+0x51966a): Section mismatch in reference from the function param_set_scroll() to the variable .devinit.data:pmi_setpal

The function param_set_scroll() referenced the variable
named ypan several times. modpost reported a bogus
variable name but removing the the __devinitdata
annotation of ypan fixed the above warnings.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Michal Januszewski <spock@gentoo.org>
---
 drivers/video/uvesafb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index be27b9c..2fb5bb8 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -44,7 +44,7 @@ static struct fb_fix_screeninfo uvesafb_fix __devinitdata = {
 
 static int mtrr		__devinitdata = 3; /* enable mtrr by default */
 static int blank	= 1;		   /* enable blanking by default */
-static int ypan		__devinitdata = 1; /* 0: scroll, 1: ypan, 2: ywrap */
+static int ypan		= 1;		   /* 0: scroll, 1: ypan, 2: ywrap */
 static int pmi_setpal	__devinitdata = 1; /* use PMI for palette changes */
 static int nocrtc	__devinitdata; /* ignore CRTC settings */
 static int noedid	__devinitdata; /* don't try DDC transfers */
-- 
1.5.4.rc3.14.g44397

