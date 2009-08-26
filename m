Return-Path: <linux-kernel-owner+w=401wt.eu-S1752423AbZHZR0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbZHZR0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZHZR0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:26:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:41892 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752378AbZHZR0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:26:16 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/r7IpuLFzrbFG+BsFIPxrGb8IXXYOvYherwK7LLJ
	NJU+kyh88vIHWy
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 1/3] viafb: remove LVDS initialization
Date: Wed, 26 Aug 2009 17:29:11 +0000
Message-Id: <1251307753-5209-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: remove LVDS initialization

At least for VX800 this initialization is not very good as some parts of
the register are written with reserved values. This makes the display go
white in some configurations and not usable until the framebuffer is
removed. It's better to not initialize it as it allows to use a
previously (by BIOS) correctly configured display.
This patch makes some displays work but might cause problems on others.
This is bad but can not be easily avoided. If this causes some
regressions it's probably the best to fix it in the 'active' display
setup code.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 viamode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 464903c..fbc2013 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -313,8 +313,7 @@ struct io_reg CX700_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIACR, CR96, 0xFF, 0x00},
 {VIACR, CR97, 0xFF, 0x00},
 {VIACR, CR99, 0xFF, 0x00},
-{VIACR, CR9B, 0xFF, 0x00},
-{VIACR, CRD2, 0xFF, 0xFF}	/* TMDS/LVDS control register.         */
+{VIACR, CR9B, 0xFF, 0x00}
 };
 
 /* Video Mode Table */
-- 
1.6.3.2

