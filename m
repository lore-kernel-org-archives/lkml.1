Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbZE0VVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbZE0VVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbZE0VVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:21:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49445 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbZE0VVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:21:44 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: dri-devel@lists.sourceforge.net
Subject: [PATCH] drm: intel: add ignore lvds quirk info for AOpen Mini PC
Date: Wed, 27 May 2009 17:20:39 -0400
User-Agent: KMail/1.11.3 (Linux/2.6.29.3-140.fc11.x86_64; KDE/4.2.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, xorg-devel@lists.x.org,
       Eric Anholt <eric@anholt.net>, Florian Demmer <florian@demmer.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905271720.40776.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a FIXME in the intel LVDS bring-up code, adding the appropriate
blacklist entry for the AOpen Mini PC, courtesy of a dmidecode
dump from Florian Demmer.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
CC: Florian Demmer <florian@demmer.org>

---
 drivers/gpu/drm/i915/intel_lvds.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 439a865..7ac00c3 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -424,8 +424,14 @@ static const struct dmi_system_id __initdata intel_no_lvds[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Studio Hybrid 140g"),
 		},
 	},
-
-	/* FIXME: add a check for the Aopen Mini PC */
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "AOpen Mini PC",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "AOpen"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "i965GMx-IF"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };

-- 
Jarod Wilson
jarod@redhat.com
