Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbXJ1AAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbXJ1AAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 20:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXJ1AAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 20:00:32 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:2372 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXJ1AAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 20:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:sender;
        b=bmXH7HfXifN9nEXOZ9nDRS2clKztve88p5Nr6v4aHejcBgr/3yvOv6bid8UMFfwX6Aamninz4UAXHsdZZV5csH7ZOuhhszrKlZeefT/kyUAsDKsrPPjD9aCRLUYkn07HZfGnzA4867YILFqn30r3n+jvrH5Qq9kiWOjLF7kj3lU=
Message-ID: <4723D100.5050209@student.tuwien.ac.at>
Date: Sun, 28 Oct 2007 02:00:00 +0200
From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Subject: USB_SUSPEND needs SUSPEND?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

it seems that there is some dependency missing for CONFIG_USB_SUSPEND.
When I compile a kernel without CONFIG_SUSPEND, USB suspend doesn't work
(or at least doesn't expose its interface to userspace).
/sys/bus/usb/devices/.../power doesn't exist, but it is there when I
enable CONFIG_SUSPEND. So should CONFIG_USB_SUSPEND depend on
CONFIG_SUSPEND (or something selected by CONFIG_SUSPEND)?

diff between the two configs follows, full config and dmesg for both
kernels is available at http://stud4.tuwien.ac.at/~e0626486/usb_suspend/
(though the dmesg diff doesn't seem to be all that interesting).


--- /boot/config-2.6.23.1-nosuspend
+++ /boot/config-2.6.23.1-suspend
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.23.1
-# Sat Oct 27 23:59:11 2007
+# Sat Oct 27 22:45:27 2007
 #
 CONFIG_X86_32=y
 CONFIG_GENERIC_TIME=y
@@ -30,7 +30,7 @@
 CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
-CONFIG_LOCALVERSION="-nosuspend"
+CONFIG_LOCALVERSION="-suspend"
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
@@ -229,11 +229,13 @@
 CONFIG_PM=y
 CONFIG_PM_LEGACY=y
 # CONFIG_PM_DEBUG is not set
+CONFIG_PM_SLEEP=y
 CONFIG_SUSPEND_UP_POSSIBLE=y
-# CONFIG_SUSPEND is not set
+CONFIG_SUSPEND=y
 CONFIG_HIBERNATION_UP_POSSIBLE=y
 # CONFIG_HIBERNATION is not set
 CONFIG_ACPI=y
+CONFIG_ACPI_SLEEP=y
 CONFIG_ACPI_PROCFS=y
 CONFIG_ACPI_PROC_EVENT=y
 CONFIG_ACPI_AC=m
@@ -255,6 +257,7 @@
 CONFIG_X86_PM_TIMER=y
 CONFIG_ACPI_CONTAINER=m
 CONFIG_ACPI_SBS=m
+# CONFIG_APM is not set

 #
 # CPU Frequency scaling


-- 
Oliver
