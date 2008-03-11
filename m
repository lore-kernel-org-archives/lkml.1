Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbYCKVNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbYCKVNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbYCKVMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:12:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:36164 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977AbYCKVL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:11:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=COrc18vmqwLXWVvsrTVAbubc7ABDhBw04ND91+O9xTyaMpB4YIm0qExKaPmncedA7gv3kVai2QPPalypBV2TULBJXodQY0djVxlGFeFccdbt7L6tcicyFE3H3i8AZfkhDbwKZtFq9Im5h/4rXlaO2buaF+p+15Wm0qBveTw/Rpg=
Subject: [PATCH 2/6] video: use clamp() macro from kernel.h to replace
	local defintions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 14:11:55 -0700
Message-Id: <1205269915.22317.34.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clamps a value to be within a given range with strict typechecking.

Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/video/bt8xx/bttvp.h    |    2 --
 drivers/media/video/usbvideo/vicam.c |    6 ------
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index 1305d31..b38e3a0 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -82,8 +82,6 @@
 /* Limits scaled width, which must be a multiple of 4. */
 #define MAX_HACTIVE (0x3FF & -4)
 
-#define clamp(x, low, high) min (max (low, x), high)
-
 #define BTTV_NORMS    (\
 		V4L2_STD_PAL    | V4L2_STD_PAL_N | \
 		V4L2_STD_PAL_Nc | V4L2_STD_SECAM | \
diff --git a/drivers/media/video/usbvideo/vicam.c b/drivers/media/video/usbvideo/vicam.c
index da1ba02..938a60d 100644
--- a/drivers/media/video/usbvideo/vicam.c
+++ b/drivers/media/video/usbvideo/vicam.c
@@ -70,12 +70,6 @@
 
 #define VICAM_HEADER_SIZE       64
 
-#define clamp( x, l, h )        max_t( __typeof__( x ),         \
-				       ( l ),                   \
-				       min_t( __typeof__( x ),  \
-					      ( h ),            \
-					      ( x ) ) )
-
 /* Not sure what all the bytes in these char
  * arrays do, but they're necessary to make
  * the camera work.
-- 
1.5.4.4.592.g32d4c


