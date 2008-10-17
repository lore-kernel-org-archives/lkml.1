Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbYJQR5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbYJQR5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbYJQR5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:57:12 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60745 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbYJQR5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:57:11 -0400
Date: Fri, 17 Oct 2008 20:57:08 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
cc: david@rowetel.com, steveu@coppice.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] echo: remove annoying "end of function" markers
Message-ID: <Pine.LNX.4.64.0810172056010.23852@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch removes the very noisy "end of function" markers that are very 
annoying when reading the driver code.

Cc: David Rowe <david@rowetel.com>
Cc: Steve Underwood <steveu@coppice.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/echo/bit_operations.h |   10 ----------
 drivers/staging/echo/echo.c           |    7 -------
 drivers/staging/echo/fir.h            |    9 ---------
 3 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/echo/bit_operations.h b/drivers/staging/echo/bit_operations.h
index 04b55d2..abcd7a2 100644
--- a/drivers/staging/echo/bit_operations.h
+++ b/drivers/staging/echo/bit_operations.h
@@ -45,7 +45,6 @@ static __inline__ int top_bit(unsigned int bits)
              : [bits] "rm" (bits));
     return res;
 }
-/*- End of function --------------------------------------------------------*/
 
 /*! \brief Find the bit position of the lowest set bit in a word
     \param bits The word to be searched
@@ -61,7 +60,6 @@ static __inline__ int bottom_bit(unsigned int bits)
              : [bits] "rm" (bits));
     return res;
 }
-/*- End of function --------------------------------------------------------*/
 #else
 static __inline__ int top_bit(unsigned int bits)
 {
@@ -97,7 +95,6 @@ static __inline__ int top_bit(unsigned int bits)
     }
     return i;
 }
-/*- End of function --------------------------------------------------------*/
 
 static __inline__ int bottom_bit(unsigned int bits)
 {
@@ -133,7 +130,6 @@ static __inline__ int bottom_bit(unsigned int bits)
     }
     return i;
 }
-/*- End of function --------------------------------------------------------*/
 #endif
 
 /*! \brief Bit reverse a byte.
@@ -151,7 +147,6 @@ static __inline__ uint8_t bit_reverse8(uint8_t x)
     return ((x & 0xAA) >> 1) | ((x & 0x55) << 1);
 #endif
 }
-/*- End of function --------------------------------------------------------*/
 
 /*! \brief Bit reverse a 16 bit word.
     \param data The word to be reversed.
@@ -191,7 +186,6 @@ static __inline__ uint32_t least_significant_one32(uint32_t x)
 {
     return (x & (-(int32_t) x));
 }
-/*- End of function --------------------------------------------------------*/
 
 /*! \brief Find the most significant one in a word, and return a word
            with just that bit set.
@@ -206,7 +200,6 @@ static __inline__ uint32_t most_significant_one32(uint32_t x)
     return (x ^ (x >> 1));
 #endif
 }
-/*- End of function --------------------------------------------------------*/
 
 /*! \brief Find the parity of a byte.
     \param x The byte to be checked.
@@ -216,7 +209,6 @@ static __inline__ int parity8(uint8_t x)
     x = (x ^ (x >> 4)) & 0x0F;
     return (0x6996 >> x) & 1;
 }
-/*- End of function --------------------------------------------------------*/
 
 /*! \brief Find the parity of a 16 bit word.
     \param x The word to be checked.
@@ -227,7 +219,6 @@ static __inline__ int parity16(uint16_t x)
     x = (x ^ (x >> 4)) & 0x0F;
     return (0x6996 >> x) & 1;
 }
-/*- End of function --------------------------------------------------------*/
 
 /*! \brief Find the parity of a 32 bit word.
     \param x The word to be checked.
@@ -239,7 +230,6 @@ static __inline__ int parity32(uint32_t x)
     x = (x ^ (x >> 4)) & 0x0F;
     return (0x6996 >> x) & 1;
 }
-/*- End of function --------------------------------------------------------*/
 
 #endif
 /*- End of file ------------------------------------------------------------*/
diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
index 8c0a707..0b997ac 100644
--- a/drivers/staging/echo/echo.c
+++ b/drivers/staging/echo/echo.c
@@ -230,7 +230,6 @@ static __inline__ void lms_adapt_bg(echo_can_state_t *ec, int clean, int shift)
 }
 #endif
 
-/*- End of function --------------------------------------------------------*/
 
 echo_can_state_t *echo_can_create(int len, int adaption_mode)
 {
@@ -287,7 +286,6 @@ error_oom:
     kfree(ec);
     return NULL;
 }
-/*- End of function --------------------------------------------------------*/
 
 void echo_can_free(echo_can_state_t *ec)
 {
@@ -300,13 +298,11 @@ void echo_can_free(echo_can_state_t *ec)
 	kfree(ec->snapshot);
 	kfree(ec);
 }
-/*- End of function --------------------------------------------------------*/
 
 void echo_can_adaption_mode(echo_can_state_t *ec, int adaption_mode)
 {
     ec->adaption_mode = adaption_mode;
 }
-/*- End of function --------------------------------------------------------*/
 
 void echo_can_flush(echo_can_state_t *ec)
 {
@@ -332,12 +328,10 @@ void echo_can_flush(echo_can_state_t *ec)
     ec->curr_pos = ec->taps - 1;
     ec->Pstates = 0;
 }
-/*- End of function --------------------------------------------------------*/
 
 void echo_can_snapshot(echo_can_state_t *ec) {
     memcpy(ec->snapshot, ec->fir_taps16[0], ec->taps*sizeof(int16_t));
 }
-/*- End of function --------------------------------------------------------*/
 
 /* Dual Path Echo Canceller ------------------------------------------------*/
 
@@ -583,7 +577,6 @@ int16_t echo_can_update(echo_can_state_t *ec, int16_t tx, int16_t rx)
     return (int16_t) ec->clean_nlp << 1;
 }
 
-/*- End of function --------------------------------------------------------*/
 
 /* This function is seperated from the echo canceller is it is usually called
    as part of the tx process.  See rx HP (DC blocking) filter above, it's
diff --git a/drivers/staging/echo/fir.h b/drivers/staging/echo/fir.h
index b471003..c5dd187 100644
--- a/drivers/staging/echo/fir.h
+++ b/drivers/staging/echo/fir.h
@@ -119,7 +119,6 @@ static __inline__ const int16_t *fir16_create(fir16_state_t *fir,
 #endif
 	return fir->history;
 }
-/*- End of function --------------------------------------------------------*/
 
 static __inline__ void fir16_flush(fir16_state_t *fir)
 {
@@ -129,13 +128,11 @@ static __inline__ void fir16_flush(fir16_state_t *fir)
     memset(fir->history, 0, fir->taps*sizeof(int16_t));
 #endif
 }
-/*- End of function --------------------------------------------------------*/
 
 static __inline__ void fir16_free(fir16_state_t *fir)
 {
 	kfree(fir->history);
 }
-/*- End of function --------------------------------------------------------*/
 
 #ifdef __BLACKFIN_ASM__
 static inline int32_t dot_asm(short *x, short *y, int len)
@@ -165,7 +162,6 @@ static inline int32_t dot_asm(short *x, short *y, int len)
    return dot;
 }
 #endif
-/*- End of function --------------------------------------------------------*/
 
 static __inline__ int16_t fir16(fir16_state_t *fir, int16_t sample)
 {
@@ -260,7 +256,6 @@ static __inline__ int16_t fir16(fir16_state_t *fir, int16_t sample)
     fir->curr_pos--;
     return (int16_t) (y >> 15);
 }
-/*- End of function --------------------------------------------------------*/
 
 static __inline__ const int16_t *fir32_create(fir32_state_t *fir,
                                               const int32_t *coeffs,
@@ -272,19 +267,16 @@ static __inline__ const int16_t *fir32_create(fir32_state_t *fir,
     fir->history = kcalloc(taps, sizeof(int16_t), GFP_KERNEL);
     return fir->history;
 }
-/*- End of function --------------------------------------------------------*/
 
 static __inline__ void fir32_flush(fir32_state_t *fir)
 {
     memset(fir->history, 0, fir->taps*sizeof(int16_t));
 }
-/*- End of function --------------------------------------------------------*/
 
 static __inline__ void fir32_free(fir32_state_t *fir)
 {
     kfree(fir->history);
 }
-/*- End of function --------------------------------------------------------*/
 
 static __inline__ int16_t fir32(fir32_state_t *fir, int16_t sample)
 {
@@ -306,7 +298,6 @@ static __inline__ int16_t fir32(fir32_state_t *fir, int16_t sample)
     fir->curr_pos--;
     return (int16_t) (y >> 15);
 }
-/*- End of function --------------------------------------------------------*/
 
 #endif
 /*- End of file ------------------------------------------------------------*/
-- 
1.5.3.7

