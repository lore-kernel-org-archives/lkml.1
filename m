Return-Path: <linux-kernel-owner+w=401wt.eu-S1758285AbYJVRjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285AbYJVRjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757688AbYJVRdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:33:50 -0400
Received: from kroah.org ([198.145.64.141]:53058 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757678AbYJVRdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:33:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tzafrir Cohen <tzafrir@cohens.org.il>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/42] Staging: echo: Replace echo_can_state_t with struct echo_can_state
Date: Wed, 22 Oct 2008 10:29:00 -0700
Message-Id: <1224696563-5170-19-git-send-email-gregkh@suse.de>
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
 drivers/staging/echo/echo.c  |   20 ++++++++++----------
 drivers/staging/echo/oslec.h |   16 ++++++++--------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
index 0a03eed..a408b62 100644
--- a/drivers/staging/echo/echo.c
+++ b/drivers/staging/echo/echo.c
@@ -128,7 +128,7 @@
 
 
 #ifdef __BLACKFIN_ASM__
-static void __inline__ lms_adapt_bg(echo_can_state_t *ec, int clean, int shift)
+static void __inline__ lms_adapt_bg(struct echo_can_state *ec, int clean, int shift)
 {
     int i, j;
     int offset1;
@@ -200,7 +200,7 @@ static void __inline__ lms_adapt_bg(echo_can_state_t *ec, int clean, int shift)
 */
 
 #else
-static __inline__ void lms_adapt_bg(echo_can_state_t *ec, int clean, int shift)
+static __inline__ void lms_adapt_bg(struct echo_can_state *ec, int clean, int shift)
 {
     int i;
 
@@ -234,9 +234,9 @@ static __inline__ void lms_adapt_bg(echo_can_state_t *ec, int clean, int shift)
 
 /*- End of function --------------------------------------------------------*/
 
-echo_can_state_t *echo_can_create(int len, int adaption_mode)
+struct echo_can_state *echo_can_create(int len, int adaption_mode)
 {
-    echo_can_state_t *ec;
+    struct echo_can_state *ec;
     int i;
     int j;
 
@@ -292,7 +292,7 @@ echo_can_state_t *echo_can_create(int len, int adaption_mode)
 EXPORT_SYMBOL_GPL(echo_can_create);
 /*- End of function --------------------------------------------------------*/
 
-void echo_can_free(echo_can_state_t *ec)
+void echo_can_free(struct echo_can_state *ec)
 {
 	int i;
 
@@ -306,14 +306,14 @@ void echo_can_free(echo_can_state_t *ec)
 EXPORT_SYMBOL_GPL(echo_can_free);
 /*- End of function --------------------------------------------------------*/
 
-void echo_can_adaption_mode(echo_can_state_t *ec, int adaption_mode)
+void echo_can_adaption_mode(struct echo_can_state *ec, int adaption_mode)
 {
     ec->adaption_mode = adaption_mode;
 }
 EXPORT_SYMBOL_GPL(echo_can_adaption_mode);
 /*- End of function --------------------------------------------------------*/
 
-void echo_can_flush(echo_can_state_t *ec)
+void echo_can_flush(struct echo_can_state *ec)
 {
     int i;
 
@@ -340,7 +340,7 @@ void echo_can_flush(echo_can_state_t *ec)
 EXPORT_SYMBOL_GPL(echo_can_flush);
 /*- End of function --------------------------------------------------------*/
 
-void echo_can_snapshot(echo_can_state_t *ec) {
+void echo_can_snapshot(struct echo_can_state *ec) {
     memcpy(ec->snapshot, ec->fir_taps16[0], ec->taps*sizeof(int16_t));
 }
 EXPORT_SYMBOL_GPL(echo_can_snapshot);
@@ -348,7 +348,7 @@ EXPORT_SYMBOL_GPL(echo_can_snapshot);
 
 /* Dual Path Echo Canceller ------------------------------------------------*/
 
-int16_t echo_can_update(echo_can_state_t *ec, int16_t tx, int16_t rx)
+int16_t echo_can_update(struct echo_can_state *ec, int16_t tx, int16_t rx)
 {
     int32_t echo_value;
     int clean_bg;
@@ -613,7 +613,7 @@ EXPORT_SYMBOL_GPL(echo_can_update);
    precision, which noise shapes things, giving very clean DC removal.
 */
 
-int16_t echo_can_hpf_tx(echo_can_state_t *ec, int16_t tx) {
+int16_t echo_can_hpf_tx(struct echo_can_state *ec, int16_t tx) {
     int tmp, tmp1;
 
     if (ec->adaption_mode & ECHO_CAN_USE_TX_HPF) {
diff --git a/drivers/staging/echo/oslec.h b/drivers/staging/echo/oslec.h
index 913fc51..8227013 100644
--- a/drivers/staging/echo/oslec.h
+++ b/drivers/staging/echo/oslec.h
@@ -42,31 +42,31 @@
     G.168 echo canceller descriptor. This defines the working state for a line
     echo canceller.
 */
-typedef struct echo_can_state echo_can_state_t;
+struct echo_can_state;
 
 /*! Create a voice echo canceller context.
     \param len The length of the canceller, in samples.
     \return The new canceller context, or NULL if the canceller could not be created.
 */
-echo_can_state_t *echo_can_create(int len, int adaption_mode);
+struct echo_can_state *echo_can_create(int len, int adaption_mode);
 
 /*! Free a voice echo canceller context.
     \param ec The echo canceller context.
 */
-void echo_can_free(echo_can_state_t *ec);
+void echo_can_free(struct echo_can_state *ec);
 
 /*! Flush (reinitialise) a voice echo canceller context.
     \param ec The echo canceller context.
 */
-void echo_can_flush(echo_can_state_t *ec);
+void echo_can_flush(struct echo_can_state *ec);
 
 /*! Set the adaption mode of a voice echo canceller context.
     \param ec The echo canceller context.
     \param adapt The mode.
 */
-void echo_can_adaption_mode(echo_can_state_t *ec, int adaption_mode);
+void echo_can_adaption_mode(struct echo_can_state *ec, int adaption_mode);
 
-void echo_can_snapshot(echo_can_state_t *ec);
+void echo_can_snapshot(struct echo_can_state *ec);
 
 /*! Process a sample through a voice echo canceller.
     \param ec The echo canceller context.
@@ -74,13 +74,13 @@ void echo_can_snapshot(echo_can_state_t *ec);
     \param rx The received audio sample.
     \return The clean (echo cancelled) received sample.
 */
-int16_t echo_can_update(echo_can_state_t *ec, int16_t tx, int16_t rx);
+int16_t echo_can_update(struct echo_can_state *ec, int16_t tx, int16_t rx);
 
 /*! Process to high pass filter the tx signal.
     \param ec The echo canceller context.
     \param tx The transmitted auio sample.
     \return The HP filtered transmit sample, send this to your D/A.
 */
-int16_t echo_can_hpf_tx(echo_can_state_t *ec, int16_t tx);
+int16_t echo_can_hpf_tx(struct echo_can_state *ec, int16_t tx);
 
 #endif	/* __OSLEC_H */
-- 
1.6.0.2

