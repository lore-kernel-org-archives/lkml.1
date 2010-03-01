Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab0CAPQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:16:46 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60576 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0CAPOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:15 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 25/26] w35und: Rename fixed typedef to fixp32_t
Date: Mon,  1 Mar 2010 17:04:27 +0200
Message-Id: <1267455868-4533-25-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'fixed' typedef is the one and only typedef that actually makes
sense. Lets rename the thing to 'fixp32_t' to follow the naming
convention set by generic kernel types such as 'atomic_t' and the
existing in-kernel fixed-point implementation in
drivers/input/fixp-arith.h (which is unfortunately only 16 bits and thus
can't be used here).

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/phy_calibration.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index 8c56962..381d8e9 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -26,9 +26,9 @@
 #define DEG2RAD(X)      0.017453 * (X)
 
 /****************** LOCAL TYPE DEFINITION SECTION ***************************/
-typedef s32         fixed; /* 16.16 fixed-point */
+typedef s32         fixp32_t;	/* 16.16 fixed-point */
 
-static const fixed Angles[]=
+static const fixp32_t Angles[]=
 {
     FIXED(DEG2RAD(45.0)),    FIXED(DEG2RAD(26.565)),  FIXED(DEG2RAD(14.0362)),
     FIXED(DEG2RAD(7.12502)), FIXED(DEG2RAD(3.57633)), FIXED(DEG2RAD(1.78991)),
@@ -300,7 +300,7 @@ u32 _sqrt(u32 sqsum)
 /****************************************************************************/
 void _sin_cos(s32 angle, s32 *sin, s32 *cos)
 {
-    fixed       X, Y, TargetAngle, CurrAngle;
+    fixp32_t X, Y, TargetAngle, CurrAngle;
     unsigned    Step;
 
     X=FIXED(AG_CONST);      // AG_CONST * cos(0)
@@ -310,7 +310,7 @@ void _sin_cos(s32 angle, s32 *sin, s32 *cos)
 
     for (Step=0; Step < 12; Step++)
     {
-        fixed NewX;
+        fixp32_t NewX;
 
         if(TargetAngle > CurrAngle)
         {
-- 
1.6.3.3

