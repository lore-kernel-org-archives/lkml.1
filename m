Return-Path: <linux-kernel-owner+w=401wt.eu-S1759104AbYJVRlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104AbYJVRlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757641AbYJVReS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:34:18 -0400
Received: from kroah.org ([198.145.64.141]:53073 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757583AbYJVReQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:34:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, David Rowe <david@rowetel.com>,
       Steve Underwood <steveu@coppice.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/42] Staging: echo: remove dead code
Date: Wed, 22 Oct 2008 10:29:04 -0700
Message-Id: <1224696563-5170-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch removes dead code that is wrapped in #ifndef __KERNEL__.

Cc: David Rowe <david@rowetel.com>
Cc: Steve Underwood <steveu@coppice.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/echo/fir.h |   45 --------------------------------------------
 1 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/echo/fir.h b/drivers/staging/echo/fir.h
index c29e1e2..19c20cd 100644
--- a/drivers/staging/echo/fir.h
+++ b/drivers/staging/echo/fir.h
@@ -312,51 +312,6 @@ static __inline__ int16_t fir32(fir32_state_t *fir, int16_t sample)
 }
 /*- End of function --------------------------------------------------------*/
 
-#ifndef __KERNEL__
-static __inline__ const float *fir_float_create(fir_float_state_t *fir,
-                                                const float *coeffs,
-    	    	    	                        int taps)
-{
-    fir->taps = taps;
-    fir->curr_pos = taps - 1;
-    fir->coeffs = coeffs;
-    fir->history = (float *) malloc(taps*sizeof(float));
-    if (fir->history)
-        memset(fir->history, '\0', taps*sizeof(float));
-    return fir->history;
-}
-/*- End of function --------------------------------------------------------*/
-
-static __inline__ void fir_float_free(fir_float_state_t *fir)
-{
-    free(fir->history);
-}
-/*- End of function --------------------------------------------------------*/
-
-static __inline__ int16_t fir_float(fir_float_state_t *fir, int16_t sample)
-{
-    int i;
-    float y;
-    int offset1;
-    int offset2;
-
-    fir->history[fir->curr_pos] = sample;
-
-    offset2 = fir->curr_pos;
-    offset1 = fir->taps - offset2;
-    y = 0;
-    for (i = fir->taps - 1;  i >= offset1;  i--)
-        y += fir->coeffs[i]*fir->history[i - offset1];
-    for (  ;  i >= 0;  i--)
-        y += fir->coeffs[i]*fir->history[i + offset2];
-    if (fir->curr_pos <= 0)
-    	fir->curr_pos = fir->taps;
-    fir->curr_pos--;
-    return  (int16_t) y;
-}
-/*- End of function --------------------------------------------------------*/
-#endif
-
 #ifdef __cplusplus
 }
 #endif
-- 
1.6.0.2

