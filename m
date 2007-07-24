Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbXGXEBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbXGXEBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 00:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbXGXEBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 00:01:44 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:22463 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbXGXEBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 00:01:43 -0400
Date: Mon, 23 Jul 2007 21:05:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh <greg@kroah.com>
Subject: [PATCH] Doc/sysfs-rules typos
Message-Id: <20070723210502.df1d64bc.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix typos only (spelling, grammar, duplicate words, etc.).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/sysfs-rules.txt |   72 ++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 37 deletions(-)

--- linux-2.6.23-rc1.orig/Documentation/sysfs-rules.txt
+++ linux-2.6.23-rc1/Documentation/sysfs-rules.txt
@@ -1,19 +1,18 @@
 Rules on how to access information in the Linux kernel sysfs
 
-The kernel exported sysfs exports internal kernel implementation-details
+The kernel-exported sysfs exports internal kernel implementation details
 and depends on internal kernel structures and layout. It is agreed upon
 by the kernel developers that the Linux kernel does not provide a stable
 internal API. As sysfs is a direct export of kernel internal
-structures, the sysfs interface can not provide a stable interface eighter,
+structures, the sysfs interface cannot provide a stable interface either;
 it may always change along with internal kernel changes.
 
 To minimize the risk of breaking users of sysfs, which are in most cases
 low-level userspace applications, with a new kernel release, the users
-of sysfs must follow some rules to use an as abstract-as-possible way to
+of sysfs must follow some rules to use an as-abstract-as-possible way to
 access this filesystem. The current udev and HAL programs already
 implement this and users are encouraged to plug, if possible, into the
-abstractions these programs provide instead of accessing sysfs
-directly.
+abstractions these programs provide instead of accessing sysfs directly.
 
 But if you really do want or need to access sysfs directly, please follow
 the following rules and then your programs should work with future
@@ -25,22 +24,22 @@ versions of the sysfs interface.
   implementation details in its own API. Therefore it is not better than
   reading directories and opening the files yourself.
   Also, it is not actively maintained, in the sense of reflecting the
-  current kernel-development. The goal of providing a stable interface
-  to sysfs has failed, it causes more problems, than it solves. It
+  current kernel development. The goal of providing a stable interface
+  to sysfs has failed; it causes more problems than it solves. It
   violates many of the rules in this document.
 
 - sysfs is always at /sys
   Parsing /proc/mounts is a waste of time. Other mount points are a
   system configuration bug you should not try to solve. For test cases,
   possibly support a SYSFS_PATH environment variable to overwrite the
-  applications behavior, but never try to search for sysfs. Never try
+  application's behavior, but never try to search for sysfs. Never try
   to mount it, if you are not an early boot script.
 
 - devices are only "devices"
   There is no such thing like class-, bus-, physical devices,
   interfaces, and such that you can rely on in userspace. Everything is
   just simply a "device". Class-, bus-, physical, ... types are just
-  kernel implementation details, which should not be expected by
+  kernel implementation details which should not be expected by
   applications that look for devices in sysfs.
 
   The properties of a device are:
@@ -48,11 +47,11 @@ versions of the sysfs interface.
       - identical to the DEVPATH value in the event sent from the kernel
         at device creation and removal
       - the unique key to the device at that point in time
-      - the kernels path to the device-directory without the leading
+      - the kernel's path to the device directory without the leading
         /sys, and always starting with with a slash
       - all elements of a devpath must be real directories. Symlinks
         pointing to /sys/devices must always be resolved to their real
-        target, and the target path must be used to access the device.
+        target and the target path must be used to access the device.
         That way the devpath to the device matches the devpath of the
         kernel used at event time.
       - using or exposing symlink values as elements in a devpath string
@@ -73,17 +72,17 @@ versions of the sysfs interface.
         link
       - it is retrieved by reading the "driver"-link and using only the
         last element of the target path
-      - devices which do not have "driver"-link, just do not have a
-        driver; copying the driver value in a child device context, is a
+      - devices which do not have "driver"-link just do not have a
+        driver; copying the driver value in a child device context is a
         bug in the application
 
     o attributes
-      - the files in the device directory or files below a subdirectories
+      - the files in the device directory or files below subdirectories
         of the same device directory
       - accessing attributes reached by a symlink pointing to another device,
         like the "device"-link, is a bug in the application
 
-  Everything else is just a kernel driver-core implementation detail,
+  Everything else is just a kernel driver-core implementation detail
   that should not be assumed to be stable across kernel releases.
 
 - Properties of parent devices never belong into a child device.
@@ -91,25 +90,25 @@ versions of the sysfs interface.
   context properties. If the device 'eth0' or 'sda' does not have a
   "driver"-link, then this device does not have a driver. Its value is empty.
   Never copy any property of the parent-device into a child-device. Parent
-  device-properties may change dynamically without any notice to the
+  device properties may change dynamically without any notice to the
   child device.
 
-- Hierarchy in a single device-tree
+- Hierarchy in a single device tree
   There is only one valid place in sysfs where hierarchy can be examined
   and this is below: /sys/devices.
-  It is planned, that all device directories will end up in the tree
+  It is planned that all device directories will end up in the tree
   below this directory.
 
 - Classification by subsystem
   There are currently three places for classification of devices:
   /sys/block, /sys/class and /sys/bus. It is planned that these will
-  not contain any device-directories themselves, but only flat lists of
+  not contain any device directories themselves, but only flat lists of
   symlinks pointing to the unified /sys/devices tree.
   All three places have completely different rules on how to access
   device information. It is planned to merge all three
-  classification-directories into one place at /sys/subsystem,
-  following the layout of the bus-directories. All buses and
-  classes, including the converted block-subsystem, will show up
+  classification directories into one place at /sys/subsystem,
+  following the layout of the bus directories. All buses and
+  classes, including the converted block subsystem, will show up
   there.
   The devices belonging to a subsystem will create a symlink in the
   "devices" directory at /sys/subsystem/<name>/devices.
@@ -121,38 +120,38 @@ versions of the sysfs interface.
   subsystem name.
 
   Assuming /sys/class/<subsystem> and /sys/bus/<subsystem>, or
-  /sys/block and /sys/class/block are not interchangeable, is a bug in
+  /sys/block and /sys/class/block are not interchangeable is a bug in
   the application.
 
 - Block
-  The converted block-subsystem at /sys/class/block, or
+  The converted block subsystem at /sys/class/block or
   /sys/subsystem/block will contain the links for disks and partitions
-  at the same level, never in a hierarchy. Assuming the block-subsytem to
-  contain only disks and not partition-devices in the same flat list is
+  at the same level, never in a hierarchy. Assuming the block subsytem to
+  contain only disks and not partition devices in the same flat list is
   a bug in the application.
 
 - "device"-link and <subsystem>:<kernel name>-links
   Never depend on the "device"-link. The "device"-link is a workaround
-  for the old layout, where class-devices are not created in
-  /sys/devices/ like the bus-devices. If the link-resolving of a
-  device-directory does not end in /sys/devices/, you can use the
+  for the old layout, where class devices are not created in
+  /sys/devices/ like the bus devices. If the link-resolving of a
+  device directory does not end in /sys/devices/, you can use the
   "device"-link to find the parent devices in /sys/devices/. That is the
-  single valid use of the "device"-link, it must never appear in any
+  single valid use of the "device"-link; it must never appear in any
   path as an element. Assuming the existence of the "device"-link for
   a device in /sys/devices/ is a bug in the application.
   Accessing /sys/class/net/eth0/device is a bug in the application.
 
   Never depend on the class-specific links back to the /sys/class
   directory.  These links are also a workaround for the design mistake
-  that class-devices are not created in /sys/devices. If a device
+  that class devices are not created in /sys/devices. If a device
   directory does not contain directories for child devices, these links
   may be used to find the child devices in /sys/class. That is the single
-  valid use of these links, they must never appear in any path as an
+  valid use of these links; they must never appear in any path as an
   element. Assuming the existence of these links for devices which are
-  real child device directories in the /sys/devices tree, is a bug in
+  real child device directories in the /sys/devices tree is a bug in
   the application.
 
-  It is planned to remove all these links when when all class-device
+  It is planned to remove all these links when all class device
   directories live in /sys/devices.
 
 - Position of devices along device chain can change.
@@ -161,6 +160,5 @@ versions of the sysfs interface.
   the chain. You must always request the parent device you are looking for
   by its subsystem value. You need to walk up the chain until you find
   the device that matches the expected subsystem. Depending on a specific
-  position of a parent device, or exposing relative paths, using "../" to
-  access the chain of parents, is a bug in the application.
-
+  position of a parent device or exposing relative paths using "../" to
+  access the chain of parents is a bug in the application.
