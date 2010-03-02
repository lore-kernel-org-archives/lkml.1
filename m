Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab0CBUSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 15:18:16 -0500
Received: from adelie.canonical.com ([91.189.90.139]:52402 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab0CBUSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 15:18:00 -0500
From: Surbhi Palande <surbhi.palande@canonical.com>
To: dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie, eric@anholt.net,
       yakui.zhao@intel.com, jbarnes@virtuousgeek.org, airlied@redhat.com,
       zhenyuw@linux.intel.com
Subject: This patch fixes the "no connectors reported" bug on Sony VGN-BX196VP and
Date: Tue,  2 Mar 2010 22:17:57 +0200
Message-Id: <1267561077-6292-1-git-send-email-surbhi.palande@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks !

Regards,
Surbhi.

>From 47edbf7437388b23562f12888c36af6b59f56eec Mon Sep 17 00:00:00 2001
From: Surbhi Palande <surbhi.palande@canonical.com>
Date: Mon, 22 Feb 2010 22:39:28 +0200
Subject: [PATCH] drm/i915: blacklist lid status: Sony VGN-BX196VP, Dell Inspiron 700m

BugLink: https://bugs.launchpad.net/bugs/515246

Sony VGN-BX196VP and Dell Inspiron 700m report lid status as closed
when it is open. This leads to a "no connectors reported" error at startup.
Blacklisting them, to always return a connected status for the default
lvds connector.

Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index c2e8a45..b94a5e5 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -643,6 +643,20 @@ static const struct dmi_system_id bad_lid_status[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "M5x0N"),
 		},
 	},
+	{
+		.ident = "Sony VGN-BX196VP",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "VGN-BX196VP"),
+		},
+	},
+	{
+		.ident = "Dell Inspiron 700m",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_MATCH(DMI_BOARD_NAME, "Inspiron 700m"),
+		},
+	},
 	{ }
 };
 
-- 
1.6.3.3

