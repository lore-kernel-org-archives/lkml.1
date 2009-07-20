Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbZGTUKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbZGTUKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbZGTUKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:10:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:36223 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbZGTUJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:09:58 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Sarah Sharp <sarah.a.sharp@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 10/10] ehci-dbgp,documentation: Documentation updates for ehci-dbgp
Date: Mon, 20 Jul 2009 15:06:32 -0500
Message-Id: <1248120392-8372-11-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.3.523.g304d0
In-Reply-To: <1248120392-8372-10-git-send-email-jason.wessel@windriver.com>
References: <1248120392-8372-1-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-2-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-3-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-4-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-5-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-6-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-7-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-8-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-9-git-send-email-jason.wessel@windriver.com>
 <1248120392-8372-10-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 20 Jul 2009 20:07:05.0879 (UTC) FILETIME=[A7755A70:01CA0975]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing information about requirements of using the EHCI usb debug
controller as well as to mention you can use a debug controller other
than the first one in the system.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |    2 +-
 Documentation/x86/earlyprintk.txt   |   39 +++++++++++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index dd1a6d4..e709fc0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -670,7 +670,7 @@ and is between 256 and 4096 characters. It is defined in the file
 	earlyprintk=	[X86,SH,BLACKFIN]
 			earlyprintk=vga
 			earlyprintk=serial[,ttySn[,baudrate]]
-			earlyprintk=dbgp
+			earlyprintk=dbgp[debugController#]
 
 			Append ",keep" to not disable it when the real console
 			takes over.
diff --git a/Documentation/x86/earlyprintk.txt b/Documentation/x86/earlyprintk.txt
index 607b1a0..f19802c 100644
--- a/Documentation/x86/earlyprintk.txt
+++ b/Documentation/x86/earlyprintk.txt
@@ -7,7 +7,7 @@ and two USB cables, connected like this:
 
   [host/target] <-------> [USB debug key] <-------> [client/console]
 
-1. There are three specific hardware requirements:
+1. There are a number of specific hardware requirements:
 
  a.) Host/target system needs to have USB debug port capability.
 
@@ -42,7 +42,35 @@ and two USB cables, connected like this:
      This is a small blue plastic connector with two USB connections,
      it draws power from its USB connections.
 
- c.) Thirdly, you need a second client/console system with a regular USB port.
+ c.) You need a second client/console system with a high speed USB 2.0
+     port.
+
+ d.) The Netchip device must be plugged directly into the physical
+     debug port on the "host/target" system.  You cannot use a USB hub in
+     between the physical debug port and the "host/target" system.
+
+     The EHCI debug controller is bound to a specific physical USB
+     port and the Netchip device will only work as an early printk
+     device in this port.  The EHCI host controllers are electrically
+     wired such that the EHCI debug controller is hooked up to the
+     first physical and there is no way to change this via software.
+     You can find the physical port through experimentation by trying
+     each physical port on the system and rebooting.  Or you can try
+     and use lsusb or look at the kernel info messages emitted by the
+     usb stack when you plug a usb device into various ports on the
+     "host/target" system.
+
+     Some hardware vendors do not expose the usb debug port with a
+     physical connector and if you find such a device send a complaint
+     to the hardware vendor, because there is no reason not to wire
+     this port into one of the physically accessible ports.
+
+ e.) It is also important to note, that many versions of the Netchip
+     device require the "client/console" system to be plugged into the
+     right and side of the device (with the product logo facing up and
+     readable left to right).  The reason being is that the 5 volt
+     power supply is taken from only one side of the device and it
+     must be the side that does not get rebooted.
 
 2. Software requirements:
 
@@ -56,6 +84,13 @@ and two USB cables, connected like this:
     (If you are using Grub, append it to the 'kernel' line in
      /etc/grub.conf)
 
+    On systems with more than one EHCI debug controller you must
+    specify the correct EHCI debug controller number.  The ordering
+    comes from the PCI bus enumeration of the EHCI controllers.  The
+    default with no number argument is "0" the first EHCI debug
+    controller.  To use the second EHCI debug controller, you would
+    use the command line: "earlyprintk=dbgp1"
+
     NOTE: normally earlyprintk console gets turned off once the
     regular console is alive - use "earlyprintk=dbgp,keep" to keep
     this channel open beyond early bootup. This can be useful for
-- 
1.6.0.3.523.g304d0

