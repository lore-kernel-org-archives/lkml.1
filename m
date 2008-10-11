Return-Path: <linux-kernel-owner+w=401wt.eu-S1763730AbYJKGwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763730AbYJKGwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbYJKGjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:39:24 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:40791 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbYJKGhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:09 -0400
Date: Sat, 11 Oct 2008 02:35:49 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 29/85] dock: fix eject request process (2.6.27-rc1 regression)
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
Message-id: <82545394e0690aaef446cb262aa5dac0f9c7156e.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

commit 2a7feab28d3fc060d320eaba192e49dad1079b7e introduces a bug.
My thinkpad actually will send an eject_request and we should follow the
eject process to finish the eject, otherwise system still thinks the bay
is present.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/dock.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 25d2161..78d27ce 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -575,11 +575,6 @@ static int handle_eject_request(struct dock_station *ds, u32 event)
 	 */
 	dock_event(ds, event, UNDOCK_EVENT);
 
-	if (!dock_present(ds)) {
-		complete_undock(ds);
-		return -ENODEV;
-	}
-
 	hotplug_dock_devices(ds, ACPI_NOTIFY_EJECT_REQUEST);
 	undock(ds);
 	eject_dock(ds);
-- 
1.5.5.1

