Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbZLNAJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbZLNAJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbZLNAJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:09:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34968 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853AbZLMX6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:12 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, airlied@redhat.com, eric@anholt.net,
       jbarnes@virtuousgeek.org, torvalds@linux-foundation.org
Subject: [PATCH 1/1] Constify struct intel_dvo_dev_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:48 +0100
Message-Id: <83d2e4a3ae9480db89c89b98a31b154ebe3f58e1.1260662998.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662998.git.re.emese@gmail.com>
References: <cover.1260662998.git.re.emese@gmail.com>
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
index 1184c14..e7bf041 100644
--- a/drivers/gpu/drm/i915/dvo_ch7017.c
+++ b/drivers/gpu/drm/i915/dvo_ch7017.c
@@ -444,7 +444,7 @@ static void ch7017_destroy(struct intel_dvo_device *dvo)
 	}
 }
 
-struct intel_dvo_dev_ops ch7017_ops = {
+const struct intel_dvo_dev_ops ch7017_ops = {
 	.init = ch7017_init,
 	.detect = ch7017_detect,
 	.mode_valid = ch7017_mode_valid,
diff --git a/drivers/gpu/drm/i915/dvo_ch7xxx.c b/drivers/gpu/drm/i915/dvo_ch7xxx.c
index d56ff5c..45ebeee 100644
--- a/drivers/gpu/drm/i915/dvo_ch7xxx.c
+++ b/drivers/gpu/drm/i915/dvo_ch7xxx.c
@@ -358,7 +358,7 @@ static void ch7xxx_destroy(struct intel_dvo_device *dvo)
 	}
 }
 
-struct intel_dvo_dev_ops ch7xxx_ops = {
+const struct intel_dvo_dev_ops ch7xxx_ops = {
 	.init = ch7xxx_init,
 	.detect = ch7xxx_detect,
 	.mode_valid = ch7xxx_mode_valid,
diff --git a/drivers/gpu/drm/i915/dvo_ivch.c b/drivers/gpu/drm/i915/dvo_ivch.c
index 24169e5..98762eb 100644
--- a/drivers/gpu/drm/i915/dvo_ivch.c
+++ b/drivers/gpu/drm/i915/dvo_ivch.c
@@ -431,7 +431,7 @@ static void ivch_destroy(struct intel_dvo_device *dvo)
 	}
 }
 
-struct intel_dvo_dev_ops ivch_ops= {
+const struct intel_dvo_dev_ops ivch_ops= {
 	.init = ivch_init,
 	.dpms = ivch_dpms,
 	.save = ivch_save,
diff --git a/drivers/gpu/drm/i915/dvo_sil164.c b/drivers/gpu/drm/i915/dvo_sil164.c
index 0001c13..51617c7 100644
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
index c7c391b..9cfe532 100644
--- a/drivers/gpu/drm/i915/dvo_tfp410.c
+++ b/drivers/gpu/drm/i915/dvo_tfp410.c
@@ -325,7 +325,7 @@ static void tfp410_destroy(struct intel_dvo_device *dvo)
 	}
 }
 
-struct intel_dvo_dev_ops tfp410_ops = {
+const struct intel_dvo_dev_ops tfp410_ops = {
 	.init = tfp410_init,
 	.detect = tfp410_detect,
 	.mode_valid = tfp410_mode_valid,
-- 
1.6.5.3

