Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0CBU7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 15:59:54 -0500
Received: from adelie.canonical.com ([91.189.90.139]:47922 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab0CBU7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 15:59:53 -0500
From: Surbhi Palande <surbhi.palande@canonical.com>
To: dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie, eric@anholt.net,
       yakui.zhao@intel.com, jbarnes@virtuousgeek.org, airlied@redhat.com,
       zhenyuw@linux.intel.com
Subject: [PATCH] drm/i915: blacklist lid status: Sony VGN-BX196VP, Dell Inspiron 700m
Date: Tue,  2 Mar 2010 22:59:52 +0200
Message-Id: <1267563592-6614-1-git-send-email-surbhi.palande@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BugLink: https://bugs.launchpad.net/bugs/515246

Sony VGN-BX196VP and Dell Inspiron 700m report lid status as closed
when it is open. This leads to a "no connectors reported" error at startup.
Blacklisting them, to always return a connected status for the default
lvds connector.

Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
---
Due to lack of hardware, I have not tested this patch on my own. Further
testing shall be helpful.

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

