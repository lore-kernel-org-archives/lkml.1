Return-Path: <linux-kernel-owner+w=401wt.eu-S932467AbZLDW0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467AbZLDW0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932426AbZLDW0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:26:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54897 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932441AbZLDW0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:26:43 -0500
Message-ID: <4B198D0E.8090601@gmail.com>
Date: Fri, 04 Dec 2009 23:28:30 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: airlied@linux.ie, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 13/31] Constify struct intel_dvo_dev_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct intel_dvo_dev_ops.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/gpu/drm/i915/dvo.h        |   16 ++++++++--------
 drivers/gpu/drm/i915/dvo_ch7017.c |    2 +-
 drivers/gpu/drm/i915/dvo_ch7xxx.c |    2 +-
 drivers/gpu/drm/i915/dvo_ivch.c   |    2 +-
 drivers/gpu/drm/i915/dvo_sil164.c |    2 +-
 drivers/gpu/drm/i915/dvo_tfp410.c |    2 +-
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/dvo.h b/drivers/gpu/drm/i915/dvo.h
index 288fc50..c609205 100644
--- a/drivers/gpu/drm/i915/dvo.h
+++ b/drivers/gpu/drm/i915/dvo.h
@@ -135,23 +135,23 @@ struct intel_dvo_dev_ops {
 	 *
 	 * \return singly-linked list of modes or NULL if no modes found.
 	 */
-	struct drm_display_mode *(*get_modes)(struct intel_dvo_device *dvo);
+	struct drm_display_mode *(* const get_modes)(struct intel_dvo_device *dvo);
 
 	/**
 	 * Clean up driver-specific bits of the output
 	 */
-	void (*destroy) (struct intel_dvo_device *dvo);
+	void (* const destroy) (struct intel_dvo_device *dvo);
 
 	/**
 	 * Debugging hook to dump device registers to log file
 	 */
-	void (*dump_regs)(struct intel_dvo_device *dvo);
+	void (* const dump_regs)(struct intel_dvo_device *dvo);
 };
 
-extern struct intel_dvo_dev_ops sil164_ops;
-extern struct intel_dvo_dev_ops ch7xxx_ops;
-extern struct intel_dvo_dev_ops ivch_ops;
-extern struct intel_dvo_dev_ops tfp410_ops;
-extern struct intel_dvo_dev_ops ch7017_ops;
+extern const struct intel_dvo_dev_ops sil164_ops;
+extern const struct intel_dvo_dev_ops ch7xxx_ops;
+extern const struct intel_dvo_dev_ops ivch_ops;
+extern const struct intel_dvo_dev_ops tfp410_ops;
+extern const struct intel_dvo_dev_ops ch7017_ops;
 
 #endif /* _INTEL_DVO_H */
diff --git a/drivers/gpu/drm/i915/dvo_ch7017.c b/drivers/gpu/drm/i915/dvo_ch7017.c
index 621815b..499d82e 100644
--- a/drivers/gpu/drm/i915/dvo_ch7017.c
+++ b/drivers/gpu/drm/i915/dvo_ch7017.c
@@ -443,7 +443,7 @@ static void ch7017_destroy(struct intel_dvo_device *dvo)
 	}
 }
 
-struct intel_dvo_dev_ops ch7017_ops = {
+const struct intel_dvo_dev_ops ch7017_ops = {
 	.init = ch7017_init,
 	.detect = ch7017_detect,
 	.mode_valid = ch7017_mode_valid,
diff --git a/drivers/gpu/drm/i915/dvo_ch7xxx.c b/drivers/gpu/drm/i915/dvo_ch7xxx.c
index a9b8962..ac769ba 100644
--- a/drivers/gpu/drm/i915/dvo_ch7xxx.c
+++ b/drivers/gpu/drm/i915/dvo_ch7xxx.c
@@ -356,7 +356,7 @@ static void ch7xxx_destroy(struct intel_dvo_device *dvo)
 	}
 }
 
-struct intel_dvo_dev_ops ch7xxx_ops = {
+const struct intel_dvo_dev_ops ch7xxx_ops = {
 	.init = ch7xxx_init,
 	.detect = ch7xxx_detect,
 	.mode_valid = ch7xxx_mode_valid,
diff --git a/drivers/gpu/drm/i915/dvo_ivch.c b/drivers/gpu/drm/i915/dvo_ivch.c
index aa176f9..ed2930c 100644
--- a/drivers/gpu/drm/i915/dvo_ivch.c
+++ b/drivers/gpu/drm/i915/dvo_ivch.c
@@ -430,7 +430,7 @@ static void ivch_destroy(struct intel_dvo_device *dvo)
 	}
 }
 
-struct intel_dvo_dev_ops ivch_ops= {
+const struct intel_dvo_dev_ops ivch_ops= {
 	.init = ivch_init,
 	.dpms = ivch_dpms,
 	.save = ivch_save,
diff --git a/drivers/gpu/drm/i915/dvo_sil164.c b/drivers/gpu/drm/i915/dvo_sil164.c
index e1c1f73..7dbebcf 100644
--- a/drivers/gpu/drm/i915/dvo_sil164.c
+++ b/drivers/gpu/drm/i915/dvo_sil164.c
@@ -290,7 +290,7 @@ static void sil164_destroy(struct intel_dvo_device *dvo)
 	}
 }
 
-struct intel_dvo_dev_ops sil164_ops = {
+const struct intel_dvo_dev_ops sil164_ops = {
 	.init = sil164_init,
 	.detect = sil164_detect,
 	.mode_valid = sil164_mode_valid,
diff --git a/drivers/gpu/drm/i915/dvo_tfp410.c b/drivers/gpu/drm/i915/dvo_tfp410.c
index 9ecc907..5869da0 100644
--- a/drivers/gpu/drm/i915/dvo_tfp410.c
+++ b/drivers/gpu/drm/i915/dvo_tfp410.c
@@ -323,7 +323,7 @@ static void tfp410_destroy(struct intel_dvo_device *dvo)
 	}
 }
 
-struct intel_dvo_dev_ops tfp410_ops = {
+const struct intel_dvo_dev_ops tfp410_ops = {
 	.init = tfp410_init,
 	.detect = tfp410_detect,
 	.mode_valid = tfp410_mode_valid,

