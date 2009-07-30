Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbZG3UXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbZG3UXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZG3UXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:23:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:57740 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752703AbZG3UXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:23:14 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19rY9E8hPtrF3SxBCiJbyLpPyf+sGnBeUokkw4ef4
	y+quD9ViJGUEEh
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       HaraldWelte@viatech.com
Cc: linux-kernel@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/2] viafb: remove temporary start address setting
Date: Thu, 30 Jul 2009 20:25:22 +0000
Message-Id: <1248985522-4316-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1248985522-4316-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1248985522-4316-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: remove temporary start address setting

Currently the start address is set to an initial value every time viafb_setmode
is called. This is not done consistently along graphic cores and not even the
whole address but often only parts of it. On top of that it seems useless as
the real/final address will be set by viafb_set_start_addr a few lines later.
Remove this superfluous initalization to shrink register initalization and as a
start to decouple primary and secondary display.
Code cleanup, no notable runtime change expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 viamode.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index e799b2d..7abd65d 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -100,12 +100,8 @@ struct io_reg CN400_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIACR, CR0F, 0xFF, 0x00},	/* Cursor Localtion Low                */
 {VIACR, CR32, 0xFF, 0x00},
 {VIACR, CR33, 0xFF, 0x00},
-{VIACR, CR34, 0xFF, 0x00},
 {VIACR, CR35, 0xFF, 0x00},
 {VIACR, CR36, 0x08, 0x00},
-{VIACR, CR62, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CR63, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CR64, 0xFF, 0x00},	/* Secondary Display Starting Address  */
 {VIACR, CR69, 0xFF, 0x00},
 {VIACR, CR6A, 0xFF, 0x40},
 {VIACR, CR6B, 0xFF, 0x00},
@@ -159,16 +155,12 @@ struct io_reg CN700_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIASR, CR30, 0xFF, 0x04},
 {VIACR, CR32, 0xFF, 0x00},
 {VIACR, CR33, 0x7F, 0x00},
-{VIACR, CR34, 0xFF, 0x00},
 {VIACR, CR35, 0xFF, 0x00},
 {VIACR, CR36, 0xFF, 0x31},
 {VIACR, CR41, 0xFF, 0x80},
 {VIACR, CR42, 0xFF, 0x00},
 {VIACR, CR55, 0x80, 0x00},
 {VIACR, CR5D, 0x80, 0x00},	/*Horizontal Retrace Start bit[11] should be 0*/
-{VIACR, CR62, 0xFF, 0x00},	/* Secondary Display Starting Address */
-{VIACR, CR63, 0xFF, 0x00},	/* Secondary Display Starting Address */
-{VIACR, CR64, 0xFF, 0x00},	/* Secondary Display Starting Address */
 {VIACR, CR68, 0xFF, 0x67},	/* Default FIFO For IGA2 */
 {VIACR, CR69, 0xFF, 0x00},
 {VIACR, CR6A, 0xFD, 0x40},
@@ -233,9 +225,6 @@ struct io_reg KM400_ModeXregs[] = {
 	{VIACR, CR55, 0x80, 0x00},
 	{VIACR, CR5D, 0x80, 0x00},
 	{VIACR, CR36, 0xFF, 0x01},	/* Power Mangement 3                  */
-	{VIACR, CR62, 0xFF, 0x00},	/* Secondary Display Starting Address */
-	{VIACR, CR63, 0xFF, 0x00},	/* Secondary Display Starting Address */
-	{VIACR, CR64, 0xFF, 0x00},	/* Secondary Display Starting Address */
 	{VIACR, CR68, 0xFF, 0x67},	/* Default FIFO For IGA2              */
 	{VIACR, CR6A, 0x20, 0x20},	/* Extended FIFO On                   */
 	{VIACR, CR7A, 0xFF, 0x01},	/* LCD Scaling Parameter 1            */
@@ -285,14 +274,9 @@ struct io_reg CX700_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
 {VIACR, CR0F, 0xFF, 0x00},	/* Cursor Localtion Low                */
 {VIACR, CR32, 0xFF, 0x00},
 {VIACR, CR33, 0xFF, 0x00},
-{VIACR, CR34, 0xFF, 0x00},
 {VIACR, CR35, 0xFF, 0x00},
 {VIACR, CR36, 0x08, 0x00},
 {VIACR, CR47, 0xC8, 0x00},	/* Clear VCK Plus. */
-{VIACR, CR62, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CR63, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CR64, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CRA3, 0xFF, 0x00},	/* Secondary Display Starting Address  */
 {VIACR, CR69, 0xFF, 0x00},
 {VIACR, CR6A, 0xFF, 0x40},
 {VIACR, CR6B, 0xFF, 0x00},
@@ -340,7 +324,6 @@ struct io_reg CLE266_ModeXregs[] = { {VIASR, SR1E, 0xF0, 0x00},
 {VIASR, SR1A, 0xFB, 0x08},
 
 {VIACR, CR32, 0xFF, 0x00},
-{VIACR, CR34, 0xFF, 0x00},
 {VIACR, CR35, 0xFF, 0x00},
 {VIACR, CR36, 0x08, 0x00},
 {VIACR, CR6A, 0xFF, 0x80},
-- 
1.6.3.2

