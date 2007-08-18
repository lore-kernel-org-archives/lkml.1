Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbXHRJiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbXHRJiv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 05:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbXHRJin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 05:38:43 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:53331 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752268AbXHRJil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 05:38:41 -0400
Message-id: <96215875148836636@wsc.cz>
In-reply-to: <737828602404912540@wsc.cz>
Subject: [PATCH 2/9] cyber2000fb, rename BIT macro
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <rmk@arm.linux.org.uk>
Date: Sat, 18 Aug 2007 11:40:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyber2000fb, rename BIT macro

BIT will be global macro for (1 << x)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit e99a73f0e9d20869736b5cbd106f63fe31d63c85
tree 33d5589b80148507614fb5c203c752a744b999be
parent 8754d87e5b6221e7d34cccef473588d5170b689e
author Jiri Slaby <jirislaby@gmail.com> Sun, 12 Aug 2007 21:42:59 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 12 Aug 2007 21:42:59 +0200

 drivers/video/cyber2000fb.c |   44 ++++++++++++++++++++++---------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/video/cyber2000fb.c b/drivers/video/cyber2000fb.c
index 30ede6e..9e35353 100644
--- a/drivers/video/cyber2000fb.c
+++ b/drivers/video/cyber2000fb.c
@@ -550,7 +550,7 @@ cyber2000fb_decode_crtc(struct par_info *hw, struct cfb_info *cfb,
 {
 	u_int Htotal, Hblankend, Hsyncend;
 	u_int Vtotal, Vdispend, Vblankstart, Vblankend, Vsyncstart, Vsyncend;
-#define BIT(v,b1,m,b2) (((v >> b1) & m) << b2)
+#define ENCODE_BIT(v,b1,m,b2) (((v >> b1) & m) << b2)
 
 	hw->crtc[13] = hw->pitch;
 	hw->crtc[17] = 0xe3;
@@ -570,13 +570,13 @@ cyber2000fb_decode_crtc(struct par_info *hw, struct cfb_info *cfb,
 
 	Hblankend   = (Htotal - 4*8) >> 3;
 
-	hw->crtc[3] = BIT(Hblankend,  0, 0x1f,  0) |
-		      BIT(1,          0, 0x01,  7);
+	hw->crtc[3] = ENCODE_BIT(Hblankend,  0, 0x1f,  0) |
+		      ENCODE_BIT(1,          0, 0x01,  7);
 
 	Hsyncend    = (var->xres + var->right_margin + var->hsync_len) >> 3;
 
-	hw->crtc[5] = BIT(Hsyncend,   0, 0x1f,  0) |
-		      BIT(Hblankend,  5, 0x01,  7);
+	hw->crtc[5] = ENCODE_BIT(Hsyncend,   0, 0x1f,  0) |
+		      ENCODE_BIT(Hblankend,  5, 0x01,  7);
 
 	Vdispend    = var->yres - 1;
 	Vsyncstart  = var->yres + var->lower_margin;
@@ -591,20 +591,20 @@ cyber2000fb_decode_crtc(struct par_info *hw, struct cfb_info *cfb,
 	Vblankend   = Vtotal - 10;
 
 	hw->crtc[6]  = Vtotal;
-	hw->crtc[7]  = BIT(Vtotal,     8, 0x01,  0) |
-			BIT(Vdispend,   8, 0x01,  1) |
-			BIT(Vsyncstart, 8, 0x01,  2) |
-			BIT(Vblankstart,8, 0x01,  3) |
-			BIT(1,          0, 0x01,  4) |
-	        	BIT(Vtotal,     9, 0x01,  5) |
-			BIT(Vdispend,   9, 0x01,  6) |
-			BIT(Vsyncstart, 9, 0x01,  7);
-	hw->crtc[9]  = BIT(0,          0, 0x1f,  0) |
-		        BIT(Vblankstart,9, 0x01,  5) |
-			BIT(1,          0, 0x01,  6);
+	hw->crtc[7]  = ENCODE_BIT(Vtotal,     8, 0x01,  0) |
+			ENCODE_BIT(Vdispend,   8, 0x01,  1) |
+			ENCODE_BIT(Vsyncstart, 8, 0x01,  2) |
+			ENCODE_BIT(Vblankstart,8, 0x01,  3) |
+			ENCODE_BIT(1,          0, 0x01,  4) |
+	        	ENCODE_BIT(Vtotal,     9, 0x01,  5) |
+			ENCODE_BIT(Vdispend,   9, 0x01,  6) |
+			ENCODE_BIT(Vsyncstart, 9, 0x01,  7);
+	hw->crtc[9]  = ENCODE_BIT(0,          0, 0x1f,  0) |
+		        ENCODE_BIT(Vblankstart,9, 0x01,  5) |
+			ENCODE_BIT(1,          0, 0x01,  6);
 	hw->crtc[10] = Vsyncstart;
-	hw->crtc[11] = BIT(Vsyncend,   0, 0x0f,  0) |
-		       BIT(1,          0, 0x01,  7);
+	hw->crtc[11] = ENCODE_BIT(Vsyncend,   0, 0x0f,  0) |
+		       ENCODE_BIT(1,          0, 0x01,  7);
 	hw->crtc[12] = Vdispend;
 	hw->crtc[15] = Vblankstart;
 	hw->crtc[16] = Vblankend;
@@ -616,10 +616,10 @@ cyber2000fb_decode_crtc(struct par_info *hw, struct cfb_info *cfb,
 	 * 4=LINECOMP:10 5-IVIDEO 6=FIXCNT
 	 */
 	hw->crtc_ofl =
-		BIT(Vtotal,     10, 0x01,  0) |
-		BIT(Vdispend,   10, 0x01,  1) |
-		BIT(Vsyncstart, 10, 0x01,  2) |
-		BIT(Vblankstart,10, 0x01,  3) |
+		ENCODE_BIT(Vtotal,     10, 0x01,  0) |
+		ENCODE_BIT(Vdispend,   10, 0x01,  1) |
+		ENCODE_BIT(Vsyncstart, 10, 0x01,  2) |
+		ENCODE_BIT(Vblankstart,10, 0x01,  3) |
 		EXT_CRT_VRTOFL_LINECOMP10;
 
 	/* woody: set the interlaced bit... */
