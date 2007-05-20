Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbXETTYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbXETTYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 15:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbXETTY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 15:24:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44283 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbXETTY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 15:24:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] i386, x86-64: show that CONFIG_HOTPLUG_CPU is required for suspend on SMP
Date: Sun, 20 May 2007 21:29:26 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705202129.27170.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

It's not sufficiently documented that CONFIG_HOTPLUG_CPU is required for
suspend/hibernation on SMP.

Point out the non-obvious.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/i386/Kconfig   |    2 +-
 arch/x86_64/Kconfig |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc2/arch/i386/Kconfig
===================================================================
--- linux-2.6.22-rc2.orig/arch/i386/Kconfig
+++ linux-2.6.22-rc2/arch/i386/Kconfig
@@ -891,7 +891,7 @@ config PHYSICAL_ALIGN
 	  Don't change this unless you know what you are doing.
 
 config HOTPLUG_CPU
-	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
+	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
 	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
 	---help---
 	  Say Y here to experiment with turning CPUs off and on, and to
Index: linux-2.6.22-rc2/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.22-rc2.orig/arch/x86_64/Kconfig
+++ linux-2.6.22-rc2/arch/x86_64/Kconfig
@@ -428,12 +428,15 @@ config NR_CPUS
 	  memory in the static kernel configuration.
 
 config HOTPLUG_CPU
-	bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
+	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
 	depends on SMP && HOTPLUG && EXPERIMENTAL
 	help
 		Say Y here to experiment with turning CPUs off and on.  CPUs
 		can be controlled through /sys/devices/system/cpu/cpu#.
-		Say N if you want to disable CPU hotplug.
+		This is also required for suspend/hibernation on SMP systems.
+
+		Say N if you want to disable CPU hotplug and don't need to
+		suspend.
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
