Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbZEQMX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbZEQMX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 08:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbZEQMXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 08:23:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53906 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbZEQMXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 08:23:46 -0400
Date: Sun, 17 May 2009 15:22:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: airlied@linux.ie
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] i915: remove __initdata from intel_no_lvds
Message-ID: <20090517122237.GA10225@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make with CONFIG_DEBUG_SECTION_MISMATCH=y warns about the function
intel_lvds_init() referencing the variable __initdata intel_no_lvds.
Since intel_lvds_init might get called after module has been loaded,
intel_no_lvds shouldn't be marked __initdata.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

This is on top of v2.6.30-rc6. Makes sense?

 drivers/gpu/drm/i915/intel_lvds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 439a865..5ffadf9 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -391,7 +391,7 @@ static int __init intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
 }
 
 /* These systems claim to have LVDS, but really don't */
-static const struct dmi_system_id __initdata intel_no_lvds[] = {
+static const struct dmi_system_id intel_no_lvds[] = {
 	{
 		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Apple Mac Mini (Core series)",
-- 
1.6.3.rc3.1.g830204
