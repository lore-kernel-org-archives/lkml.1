Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934836Ab0CMBdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:33:46 -0500
Received: from kroah.org ([198.145.64.141]:60594 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934830Ab0CMATn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:43 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:06 2010
Message-Id: <20100313001506.668096005@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: [patch 017/123] drm/i915: give up on 8xx lid status
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 7b9c5abee98c54f85bcc04bd4d7ec8d5094c73f4 upstream.

These old machines more often than not lie about their lid state.  So
don't use it to detect LVDS presence, but leave the event handler to
deal with lid open/close, when we might need to reset the mode.

Fixes kernel bug #15248

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_lvds.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -655,8 +655,15 @@ static const struct dmi_system_id bad_li
  */
 static enum drm_connector_status intel_lvds_detect(struct drm_connector *connector)
 {
+	struct drm_device *dev = connector->dev;
 	enum drm_connector_status status = connector_status_connected;
 
+	/* ACPI lid methods were generally unreliable in this generation, so
+	 * don't even bother.
+	 */
+	if (IS_I8XX(dev))
+		return connector_status_connected;
+
 	if (!dmi_check_system(bad_lid_status) && !acpi_lid_open())
 		status = connector_status_disconnected;
 


