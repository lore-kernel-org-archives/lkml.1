Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbZAFWPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbZAFWPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZAFWN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:26 -0500
Received: from kroah.org ([198.145.64.141]:51177 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751705AbZAFWNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:22 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/60] sysfs: clarify SYSFS_DEPRECATED help text
Date: Tue,  6 Jan 2009 14:11:25 -0800
Message-Id: <1231279939-32728-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This should make the help text of SYSFS_DEPRECATED more clear, that this
is _not_ about (what some people think it is) suppressing a few symlinks
and variables, but a different sysfs _layout_ with new features.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 init/Kconfig |   44 +++++++++++++++++++++++++++-----------------
 1 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 52847ee..d9d3dba 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -423,27 +423,37 @@ config SYSFS_DEPRECATED
 	bool
 
 config SYSFS_DEPRECATED_V2
-	bool "Create deprecated sysfs files"
+	bool "Create deprecated sysfs layout for older userspace tools"
 	depends on SYSFS
 	default y
 	select SYSFS_DEPRECATED
 	help
-	  This option creates deprecated symlinks such as the
-	  "device"-link, the <subsystem>:<name>-link, and the
-	  "bus"-link. It may also add deprecated key in the
-	  uevent environment.
-	  None of these features or values should be used today, as
-	  they export driver core implementation details to userspace
-	  or export properties which can't be kept stable across kernel
-	  releases.
-
-	  If enabled, this option will also move any device structures
-	  that belong to a class, back into the /sys/class hierarchy, in
-	  order to support older versions of udev and some userspace
-	  programs.
-
-	  If you are using a distro with the most recent userspace
-	  packages, it should be safe to say N here.
+	  This option switches the layout of sysfs to the deprecated
+	  version.
+
+	  The current sysfs layout features a unified device tree at
+	  /sys/devices/, which is able to express a hierarchy between
+	  class devices. If the deprecated option is set to Y, the
+	  unified device tree is split into a bus device tree at
+	  /sys/devices/ and several individual class device trees at
+	  /sys/class/. The class and bus devices will be connected by
+	  "<subsystem>:<name>" and the "device" links. The "block"
+	  class devices, will not show up in /sys/class/block/. Some
+	  subsystems will suppress the creation of some devices which
+	  depend on the unified device tree.
+
+	  This option is not a pure compatibility option that can
+	  be safely enabled on newer distributions. It will change the
+	  layout of sysfs to the non-extensible deprecated version,
+	  and disable some features, which can not be exported without
+	  confusing older userspace tools. Since 2007/2008 all major
+	  distributions do not enable this option, and ship no tools which
+	  depend on the deprecated layout or this option.
+
+	  If you are using a new kernel on an older distribution, or use
+	  older userspace tools, you might need to say Y here. Do not say Y,
+	  if the original kernel, that came with your distribution, has
+	  this option set to N.
 
 config PROC_PID_CPUSET
 	bool "Include legacy /proc/<pid>/cpuset file"
-- 
1.6.0.4

