Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948Ab0AMG7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab0AMG7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 01:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955Ab0AMG7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 01:59:35 -0500
Received: from mail.perches.com ([173.55.12.10]:1084 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996Ab0AMG7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 01:59:18 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 2/3] drivers/isdn/mISDN/dsp_ecdis.h: Remove #define TRUE/FALSE, use bool
Date: Tue, 12 Jan 2010 22:59:14 -0800
Message-Id: <eaa8e362c14cb76129d60b401bd7fa8d94dd742a.1263365754.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1263365754.git.joe@perches.com>
References: <cover.1263365754.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/isdn/mISDN/dsp_ecdis.h |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_ecdis.h b/drivers/isdn/mISDN/dsp_ecdis.h
index 21dbd15..4a927b3 100644
--- a/drivers/isdn/mISDN/dsp_ecdis.h
+++ b/drivers/isdn/mISDN/dsp_ecdis.h
@@ -33,16 +33,12 @@ struct ec_disable_detector_state {
 	struct biquad2_state notch;
 	int notch_level;
 	int channel_level;
-	int tone_present;
+	bool tone_present;
+	bool hit;
 	int tone_cycle_duration;
 	int good_cycles;
-	int hit;
 };
 
-
-#define FALSE 0
-#define TRUE (!FALSE)
-
 static inline void
 echo_can_disable_detector_init(struct ec_disable_detector_state *det)
 {
@@ -58,10 +54,10 @@ echo_can_disable_detector_init(struct ec_disable_detector_state *det)
 
 	det->channel_level = 0;
 	det->notch_level = 0;
-	det->tone_present = FALSE;
+	det->tone_present = false;
+	det->hit = false;
 	det->tone_cycle_duration = 0;
 	det->good_cycles = 0;
-	det->hit = 0;
 }
 /*- End of function --------------------------------------------------------*/
 
@@ -91,16 +87,16 @@ int16_t amp)
 					&& det->tone_cycle_duration <= 475*8) {
 					det->good_cycles++;
 					if (det->good_cycles > 2)
-						det->hit = TRUE;
+						det->hit = true;
 				}
 				det->tone_cycle_duration = 0;
 			}
-			det->tone_present = TRUE;
+			det->tone_present = true;
 		} else
-			det->tone_present = FALSE;
+			det->tone_present = false;
 		det->tone_cycle_duration++;
 	} else {
-		det->tone_present = FALSE;
+		det->tone_present = false;
 		det->tone_cycle_duration = 0;
 		det->good_cycles = 0;
 	}
-- 
1.6.6.rc0.57.gad7a

