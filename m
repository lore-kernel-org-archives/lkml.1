Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbYLRXAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbYLRXAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYLRW7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:59:41 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64087 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbYLRW7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:59:39 -0500
Message-ID: <494ad5d9.0ab6660a.2341.ffff80b7@mx.google.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Thu, 18 Dec 2008 21:22:24 +0100
Subject: [PATCH 3/6] drm/i915: fix sparse warnings: move 'extern' decls to header file
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move 'extern'-decls from "intel_dvo.c" to "dvo.h", as "dvo.h" is
included by and only by files where the symbols are either defined or
used.

Fix this sparse warnings:

  drivers/gpu/drm/i915/dvo_ch7xxx.c:358:26: warning: symbol 'ch7xxx_ops' was not declared. Should it be static?
  drivers/gpu/drm/i915/dvo_ch7017.c:444:26: warning: symbol 'ch7017_ops' was not declared. Should it be static?
  drivers/gpu/drm/i915/dvo_ivch.c:432:26: warning: symbol 'ivch_ops' was not declared. Should it be static?
  drivers/gpu/drm/i915/dvo_tfp410.c:325:26: warning: symbol 'tfp410_ops' was not declared. Should it be static?
  drivers/gpu/drm/i915/dvo_sil164.c:292:26: warning: symbol 'sil164_ops' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/gpu/drm/i915/dvo.h       |    6 ++++++
 drivers/gpu/drm/i915/intel_dvo.c |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/dvo.h b/drivers/gpu/drm/i915/dvo.h
index e80866c..e747ac4 100644
--- a/drivers/gpu/drm/i915/dvo.h
+++ b/drivers/gpu/drm/i915/dvo.h
@@ -148,4 +148,10 @@ struct intel_dvo_dev_ops {
 	void (*dump_regs)(struct intel_dvo_device *dvo);
 };
 
+extern struct intel_dvo_dev_ops sil164_ops;
+extern struct intel_dvo_dev_ops ch7xxx_ops;
+extern struct intel_dvo_dev_ops ivch_ops;
+extern struct intel_dvo_dev_ops tfp410_ops;
+extern struct intel_dvo_dev_ops ch7017_ops;
+
 #endif /* _INTEL_DVO_H */
diff --git a/drivers/gpu/drm/i915/intel_dvo.c b/drivers/gpu/drm/i915/intel_dvo.c
index cc621c8..8b8d6e6 100644
--- a/drivers/gpu/drm/i915/intel_dvo.c
+++ b/drivers/gpu/drm/i915/intel_dvo.c
@@ -37,12 +37,6 @@
 #define CH7xxx_ADDR	0x76
 #define TFP410_ADDR	0x38
 
-extern struct intel_dvo_dev_ops sil164_ops;
-extern struct intel_dvo_dev_ops ch7xxx_ops;
-extern struct intel_dvo_dev_ops ivch_ops;
-extern struct intel_dvo_dev_ops tfp410_ops;
-extern struct intel_dvo_dev_ops ch7017_ops;
-
 static struct intel_dvo_device intel_dvo_devices[] = {
 	{
 		.type = INTEL_DVO_CHIP_TMDS,
-- 
1.5.6.3

