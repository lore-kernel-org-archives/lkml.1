Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033Ab0BZPTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:19:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965015Ab0BZPTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:19:06 -0500
From: Matthew Garrett <mjg@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 05/14] dell-laptop: Fix platform device unregistration
Date: Fri, 26 Feb 2010 10:18:38 -0500
Message-Id: <1267197527-18062-6-git-send-email-mjg@redhat.com>
In-Reply-To: <1267197527-18062-1-git-send-email-mjg@redhat.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dell-laptop currently fails to clean up its platform device correctly.
Make sure that it's unregistered.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/dell-laptop.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 9d7e0be..b4c2190 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -474,6 +474,10 @@ static void __exit dell_exit(void)
 	i8042_remove_filter(dell_laptop_i8042_filter);
 	backlight_device_unregister(dell_backlight_device);
 	dell_cleanup_rfkill();
+	if (platform_device) {
+		platform_device_del(platform_device);
+		platform_driver_unregister(&platform_driver);
+	}
 }
 
 module_init(dell_init);
-- 
1.6.6.1

