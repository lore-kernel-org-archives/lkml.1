Return-Path: <linux-kernel-owner+w=401wt.eu-S934613AbZDCO4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934613AbZDCO4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933807AbZDCOzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:55:23 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41560 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759399AbZDCOzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:55:21 -0400
Date: Fri, 3 Apr 2009 16:55:17 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] fbdev: generated logo sources depend on scripts/pnmtologo
Message-ID: <alpine.LRH.2.00.0904031654410.10182@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>

The generated logo sources are not automatically regenerated if
scripts/pnmtologo.c has changed. Add the missing dependency to fix this.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Tested-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/video/logo/Makefile |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/video/logo/Makefile b/drivers/video/logo/Makefile
index b91251d..3b43781 100644
--- a/drivers/video/logo/Makefile
+++ b/drivers/video/logo/Makefile
@@ -37,22 +37,24 @@ extra-y += $(call logo-cfiles,_clut224,ppm)
 # Gray 256
 extra-y += $(call logo-cfiles,_gray256,pgm)
 
+pnmtologo := scripts/pnmtologo
+
 # Create commands like "pnmtologo -t mono -n logo_mac_mono -o ..."
 quiet_cmd_logo = LOGO    $@
-	cmd_logo = scripts/pnmtologo \
+	cmd_logo = $(pnmtologo) \
 			-t $(patsubst $*_%,%,$(notdir $(basename $<))) \
 			-n $(notdir $(basename $<)) -o $@ $<
 
-$(obj)/%_mono.c: $(src)/%_mono.pbm FORCE
+$(obj)/%_mono.c: $(src)/%_mono.pbm $(pnmtologo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_vga16.c: $(src)/%_vga16.ppm FORCE
+$(obj)/%_vga16.c: $(src)/%_vga16.ppm $(pnmtologo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_clut224.c: $(src)/%_clut224.ppm FORCE
+$(obj)/%_clut224.c: $(src)/%_clut224.ppm $(pnmtologo) FORCE
 	$(call if_changed,logo)
 
-$(obj)/%_gray256.c: $(src)/%_gray256.pgm FORCE
+$(obj)/%_gray256.c: $(src)/%_gray256.pgm $(pnmtologo) FORCE
 	$(call if_changed,logo)
 
 # Files generated that shall be removed upon make clean
-- 
1.6.0.4


With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
