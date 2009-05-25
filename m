Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbZEYQPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbZEYQPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 12:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZEYQPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 12:15:44 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:38715 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZEYQPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 12:15:43 -0400
X-Greylist: delayed 1863 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 May 2009 12:15:43 EDT
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jonathan Corbet <corbet@lwn.net>,
       Paul Mackerras <paulus@samba.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [regression] adb trackpad disappears after suspend to ram
Date: Mon, 25 May 2009 17:44:17 +0200
Message-ID: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On my PowerBook6,5 (iBook G4) the trackpad does not show up on the
adb-bus after resuming from suspend to ram. This happens in roughly 50%
of the resume cycles.
Affected kernel versions: v2.6.30_rc1 through _rc7

Here is a diff of the output of lshal before and after the trackpad vanished:

--- lshal-ok.out	2009-05-25 17:00:28.000000000 +0200
+++ lshal-notouchpad.out	2009-05-25 17:04:42.000000000 +0200
@@ -1,5 +1,5 @@
 
-Dumping 81 device(s) from the Global Device List:
+Dumping 80 device(s) from the Global Device List:
 -------------------------------------------------
 udi = '/org/freedesktop/Hal/devices/computer'
   info.addons = {'hald-addon-cpufreq'} (string list)
@@ -95,21 +95,6 @@
   linux.subsystem = 'input'  (string)
   linux.sysfs_path = '/sys/devices/virtual/input/input4/event4'  (string)
 
-udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_2'
-  info.capabilities = {'input', 'input.mouse'} (string list)
-  info.category = 'input'  (string)
-  info.parent = '/org/freedesktop/Hal/devices/computer'  (string)
-  info.product = 'ADB mouse'  (string)
-  info.subsystem = 'input'  (string)
-  info.udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_2'  (string)
-  input.device = '/dev/input/event3'  (string)
-  input.product = 'ADB mouse'  (string)
-  input.x11_driver = 'evdev'  (string)
-  linux.device_file = '/dev/input/event3'  (string)
-  linux.hotplug_type = 2  (0x2)  (int)
-  linux.subsystem = 'input'  (string)
-  linux.sysfs_path = '/sys/devices/virtual/input/input3/event3'  (string)
-
 udi = '/org/freedesktop/Hal/devices/computer_logicaldev_input_1'
   info.addons.singleton = {'hald-addon-input'} (string list)
   info.capabilities = {'input', 'input.keys', 'button'} (string list)
@@ -1820,6 +1805,6 @@
   pci.vendor_id = 4203  (0x106b)  (int)
 
 
-Dumped 81 device(s) from the Global Device List.
+Dumped 80 device(s) from the Global Device List.
 ------------------------------------------------

Please let me know if you need more info.

Regards, 
 Jan Scholz
