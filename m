Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZHMUNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZHMUNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbZHMT7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:22 -0400
Received: from kroah.org ([198.145.64.141]:41671 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbZHMT7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:26 2009
Message-Id: <20090813195126.652068054@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jarod Wilson <jarod@redhat.com>, Florian Demmer <florian@demmer.org>,
       Eric Anholt <eric@anholt.net>
Subject: [patch 14/74] drm/i915: add ignore lvds quirk info for AOpen Mini PC
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=0001-drm-i915-add-ignore-lvds-quirk-info-for-AOpen-Mini-P.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jarod Wilson <jarod@redhat.com>

(cherry picked from commit 70aa96ca2d8d938fc036ef8fd189b0151f4fc3ba)

Fix a FIXME in the intel LVDS bring-up code, adding the appropriate
blacklist entry for the AOpen Mini PC, courtesy of a dmidecode
dump from Florian Demmer.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
CC: Florian Demmer <florian@demmer.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/intel_lvds.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -420,8 +420,14 @@ static const struct dmi_system_id intel_
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


