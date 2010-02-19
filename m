Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab0BSRST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:18:19 -0500
Received: from kroah.org ([198.145.64.141]:57379 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab0BSRAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:13 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:33 2010
Message-Id: <20100219163233.499006231@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>
Subject: [14/93] drm/i915: Add HP nx9020/SamsungSX20S to ACPI LID quirk list
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit 40f33a92100f4d9b6e85ad642100cfe42d7ff57d upstream.

The HP comaq nx9020/Samsung SX20S laptop always report that the LID status is
closed and we can't use it reliabily for LVDS detection. So add the two boxes
into the quirk list.

http://bugzilla.kernel.org/show_bug.cgi?id=14957
http://bugzilla.kernel.org/show_bug.cgi?id=14554

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_lvds.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -602,6 +602,20 @@ static void intel_lvds_mode_set(struct d
 /* Some lid devices report incorrect lid status, assume they're connected */
 static const struct dmi_system_id bad_lid_status[] = {
 	{
+		.ident = "Compaq nx9020",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_BOARD_NAME, "3084"),
+		},
+	},
+	{
+		.ident = "Samsung SX20S",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Phoenix Technologies LTD"),
+			DMI_MATCH(DMI_BOARD_NAME, "SX20S"),
+		},
+	},
+	{
 		.ident = "Aspire One",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),


