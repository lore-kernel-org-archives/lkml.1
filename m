Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbYJVRkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbYJVRkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757519AbYJVReG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:34:06 -0400
Received: from kroah.org ([198.145.64.141]:53065 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757518AbYJVReE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:34:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tzafrir Cohen <tzafrir@cohens.org.il>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 21/42] Staging: echo: Replace __BLACKFIN__ASM__ with __bfin__
Date: Wed, 22 Oct 2008 10:29:02 -0700
Message-Id: <1224696563-5170-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tzafrir Cohen <tzafrir@cohens.org.il>

Signed-off-by: Tzafrir Cohen <tzafrir@cohens.org.il>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/echo/echo.c |    2 +-
 drivers/staging/echo/fir.h  |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
index 13792ef..140f3f0 100644
--- a/drivers/staging/echo/echo.c
+++ b/drivers/staging/echo/echo.c
@@ -127,7 +127,7 @@
 /* adapting coeffs using the traditional stochastic descent (N)LMS algorithm */
 
 
-#ifdef __BLACKFIN_ASM__
+#ifdef __bfin__
 static void __inline__ lms_adapt_bg(struct oslec_state *ec, int clean, int shift)
 {
     int i, j;
diff --git a/drivers/staging/echo/fir.h b/drivers/staging/echo/fir.h
index e1bfc49..277d20e 100644
--- a/drivers/staging/echo/fir.h
+++ b/drivers/staging/echo/fir.h
@@ -116,7 +116,7 @@ static __inline__ const int16_t *fir16_create(fir16_state_t *fir,
 	fir->taps = taps;
 	fir->curr_pos = taps - 1;
 	fir->coeffs = coeffs;
-#if defined(USE_MMX)  ||  defined(USE_SSE2) || defined(__BLACKFIN_ASM__)
+#if defined(USE_MMX)  ||  defined(USE_SSE2) || defined(__bfin__)
 	if ((fir->history = malloc(2*taps*sizeof(int16_t))))
 		memset(fir->history, 0, 2*taps*sizeof(int16_t));
 #else
@@ -129,7 +129,7 @@ static __inline__ const int16_t *fir16_create(fir16_state_t *fir,
 
 static __inline__ void fir16_flush(fir16_state_t *fir)
 {
-#if defined(USE_MMX)  ||  defined(USE_SSE2) || defined(__BLACKFIN_ASM__)
+#if defined(USE_MMX)  ||  defined(USE_SSE2) || defined(__bfin__)
     memset(fir->history, 0, 2*fir->taps*sizeof(int16_t));
 #else
     memset(fir->history, 0, fir->taps*sizeof(int16_t));
@@ -143,7 +143,7 @@ static __inline__ void fir16_free(fir16_state_t *fir)
 }
 /*- End of function --------------------------------------------------------*/
 
-#ifdef __BLACKFIN_ASM__
+#ifdef __bfin__
 static inline int32_t dot_asm(short *x, short *y, int len)
 {
    int dot;
@@ -242,7 +242,7 @@ static __inline__ int16_t fir16(fir16_state_t *fir, int16_t sample)
     psrldq_i2r(4, xmm0);
     paddd_r2r(xmm0, xmm4);
     movd_r2m(xmm4, y);
-#elif defined(__BLACKFIN_ASM__)
+#elif defined(__bfin__)
     fir->history[fir->curr_pos] = sample;
     fir->history[fir->curr_pos + fir->taps] = sample;
     y = dot_asm((int16_t*)fir->coeffs, &fir->history[fir->curr_pos], fir->taps);
-- 
1.6.0.2

