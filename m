Return-Path: <linux-kernel-owner+w=401wt.eu-S965320AbXBLTPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965320AbXBLTPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 14:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965323AbXBLTPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 14:15:49 -0500
Received: from mga06.intel.com ([134.134.136.21]:12201 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965320AbXBLTPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 14:15:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,316,1167638400"; 
   d="scan'208"; a="195870267:sNHT1911291676"
Date: Mon, 12 Feb 2007 10:41:23 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: Adam Belay <abelay@novell.com>, Shaohua Li <shaohua.li@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: [PATCH 3/3] Introducing cpuidle: Basic documentation for cpuidle
Message-ID: <20070212104123.C12078@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Documentation for cpuidle infrastructure

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Adam Belay <abelay@novell.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Index: linux-2.6.21-rc-mm/Documentation/cpuidle/core.txt
===================================================================
--- /dev/null
+++ linux-2.6.21-rc-mm/Documentation/cpuidle/core.txt
@@ -0,0 +1,17 @@
+
+		Supporting multiple CPU idle levels in kernel
+
+				cpuidle
+
+General Information:
+
+Various CPUs today support multiple idle levels that are differentiated
+by varying exit latencies and power consumption during idle.
+cpuidle is a generic in-kernel infrastructure that separates
+idle policy (governor) from idle mechanism (driver) and provides a
+standardized infrastructure to support independent development of
+governors and drivers.
+
+cpuidle resides under /drivers/cpuidle.
+
+
Index: linux-2.6.21-rc-mm/Documentation/cpuidle/driver.txt
===================================================================
--- /dev/null
+++ linux-2.6.21-rc-mm/Documentation/cpuidle/driver.txt
@@ -0,0 +1,24 @@
+
+
+		Supporting multiple CPU idle levels in kernel
+
+				cpuidle drivers
+
+
+
+
+cpuidle driver supports capability detection for a particular system. The
+init and exit routines will be called for each online CPU, with a percpu
+cpuidle_driver object and driver should fill in cpuidle_states inside
+cpuidle_driver depending on the CPU capability.
+
+Driver can handle dynamic state changes (like battery<->AC), by calling
+force_redetect interface.
+
+It is possible to have more than one driver registered at the same time and
+user can switch between drivers using /sysfs interface.
+
+Interfaces:
+int cpuidle_register_driver(struct cpuidle_driver *drv);
+void cpuidle_unregister_driver(struct cpuidle_driver *drv);
+int cpuidle_force_redetect(struct cpuidle_device *dev);
Index: linux-2.6.21-rc-mm/Documentation/cpuidle/sysfs.txt
===================================================================
--- /dev/null
+++ linux-2.6.21-rc-mm/Documentation/cpuidle/sysfs.txt
@@ -0,0 +1,27 @@
+
+
+		Supporting multiple CPU idle levels in kernel
+
+				cpuidle sysfs
+
+System global cpuidle information are under
+/sys/devices/system/cpu/cpuidle
+
+The current interfaces in this directory has self-explanatory names:
+* available_drivers
+* available_governors
+* current_driver
+* current_governor
+
+Per logical CPU specific cpuidle information are under
+/sys/devices/system/cpu/cpuX/cpuidle
+for each online cpu X
+
+Under this percpu directory, there is a directory for each idle state supported
+by the driver, which in turn has
+* latency
+* power
+* time
+* usage
+
+
