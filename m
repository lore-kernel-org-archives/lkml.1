Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbYJQRzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbYJQRzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756985AbYJQRzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:55:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60745 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbYJQRzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:55:33 -0400
Date: Fri, 17 Oct 2008 20:55:32 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
cc: david@rowetel.com, steveu@coppice.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] echo: remove dead code
Message-ID: <Pine.LNX.4.64.0810172055050.23852@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch removes dead code that is wrapped in #ifndef __KERNEL__.

Cc: David Rowe <david@rowetel.com>
Cc: Steve Underwood <steveu@coppice.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/echo/fir.h |   45 --------------------------------------------
 1 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/echo/fir.h b/drivers/staging/echo/fir.h
index ef87491..42d900d 100644
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
1.5.3.7

