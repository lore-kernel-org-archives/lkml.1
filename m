Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0CBX4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:56:25 -0500
Received: from kroah.org ([198.145.64.141]:38541 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab0CBX3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:22 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/62] Driver-Core: disable /sbin/hotplug by default
Date: Tue,  2 Mar 2010 15:28:19 -0800
Message-Id: <1267572541-410-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

No recent mainstream system uses the /sbin/hotplug fork-bomb any more.
Disable it by default to reflect how it is used these days.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/Kconfig |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 8497ce9..338f0bf 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -3,10 +3,18 @@ menu "Generic Driver Options"
 config UEVENT_HELPER_PATH
 	string "path to uevent helper"
 	depends on HOTPLUG
-	default "/sbin/hotplug"
+	default ""
 	help
 	  Path to uevent helper program forked by the kernel for
 	  every uevent.
+	  Before the switch to the netlink-based uevent source, this was
+	  used to hook hotplug scripts into kernel device events. It
+	  usually pointed to a shell script at /sbin/hotplug.
+	  This should not be used today, because usual systems create
+	  many events at bootup or device discovery in a very short time
+	  frame. One forked process per event can create so many processes
+	  that it creates a high system load, or on smaller systems
+	  it is known to create out-of-memory situations during bootup.
 
 config DEVTMPFS
 	bool "Maintain a devtmpfs filesystem to mount at /dev"
-- 
1.7.0.1

