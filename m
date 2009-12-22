Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbZLVVJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbZLVVJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 16:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZLVVJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 16:09:43 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:58851 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZLVVJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 16:09:41 -0500
Message-ID: <4B312767.4090700@oracle.com>
Date: Tue, 22 Dec 2009 12:09:11 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: akpm <akpm@linux-foundation.org>, jeremy@goop.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: [PATCH] xen: add kconfig menu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B313562.0170:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Currently the xen support drivers are displayed in the main
Device Drivers menu of the config tools instead of in their
own sub-menu, so move them to their own sub-menu, like the
rest of the driver world uses.

This keeps the main Device Drivers menu from becoming messy.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Jeremy Fitzhardinge <jeremy@xensource.com>
---
 drivers/xen/Kconfig |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- lnx-2633-rc1.orig/drivers/xen/Kconfig
+++ lnx-2633-rc1/drivers/xen/Kconfig
@@ -1,6 +1,8 @@
+menu "Xen driver support"
+	depends on XEN
+
 config XEN_BALLOON
 	bool "Xen memory balloon driver"
-	depends on XEN
 	default y
 	help
 	  The balloon driver allows the Xen domain to request more memory from
@@ -20,7 +22,6 @@ config XEN_SCRUB_PAGES
 
 config XEN_DEV_EVTCHN
 	tristate "Xen /dev/xen/evtchn device"
-	depends on XEN
 	default y
 	help
 	  The evtchn driver allows a userspace process to triger event
@@ -30,7 +31,6 @@ config XEN_DEV_EVTCHN
 
 config XENFS
 	tristate "Xen filesystem"
-	depends on XEN
 	default y
 	help
 	  The xen filesystem provides a way for domains to share
@@ -53,11 +53,13 @@ config XEN_COMPAT_XENFS
 
 config XEN_SYS_HYPERVISOR
        bool "Create xen entries under /sys/hypervisor"
-       depends on XEN && SYSFS
+       depends on SYSFS
        select SYS_HYPERVISOR
        default y
        help
          Create entries under /sys/hypervisor describing the Xen
 	 hypervisor environment.  When running native or in another
 	 virtual environment, /sys/hypervisor will still be present,
-	 but will have no xen contents.
\ No newline at end of file
+	 but will have no xen contents.
+
+endmenu
