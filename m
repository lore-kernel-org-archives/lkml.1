Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430Ab0ANVtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab0ANVtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239Ab0ANVtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:49:39 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:60096 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0ANVtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:49:39 -0500
Subject: Driver-Core: disable /sbin/hotplug by default
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 22:49:39 +0100
Message-ID: <1263505779.2074.3.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Driver-Core: disable /sbin/hotplug by default

No recent mainstream system uses the /sbin/hotplug fork-bomb any more.
Disable it by default to reflect how it is used these days.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/base/Kconfig |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

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


