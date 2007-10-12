Return-Path: <linux-kernel-owner+w=401wt.eu-S1759660AbXJLQnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759660AbXJLQnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759928AbXJLQnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:43:10 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:53573 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759677AbXJLQnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:43:07 -0400
Date: Fri, 12 Oct 2007 11:39:11 -0500
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 3/7] IPMI: documentation fixes
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Reply-to: minyard@acm.org
Message-id: <20071012163911.GC22142@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Corey Minyard <cminyard@mvista.com>

Clean up IPMI documentation to remove references to high-res timers
and add info about the polling thread.  Also fix an doc error for a
parameter.

Not needed for the stable kernel.

Signed-off-by: Corey Minyard <cminyard@mvista.com>

---
Index: linux-2.6.21/Documentation/IPMI.txt
===================================================================
--- linux-2.6.21.orig/Documentation/IPMI.txt
+++ linux-2.6.21/Documentation/IPMI.txt
@@ -441,17 +441,20 @@ ACPI, and if none of those then a KCS de
 0xca2.  If you want to turn this off, set the "trydefaults" option to
 false.
 
-If you have high-res timers compiled into the kernel, the driver will
-use them to provide much better performance.  Note that if you do not
-have high-res timers enabled in the kernel and you don't have
-interrupts enabled, the driver will run VERY slowly.  Don't blame me,
+If your IPMI interface does not support interrupts and is a KCS or
+SMIC interface, the IPMI driver will start a kernel thread for the
+interface to help speed things up.  This is a low-priority kernel
+thread that constantly polls the IPMI driver while an IPMI operation
+is in progress.  The force_kipmid module parameter will all the user to
+force this thread on or off.  If you force it off and don't have
+interrupts, the driver will run VERY slowly.  Don't blame me,
 these interfaces suck.
 
 The driver supports a hot add and remove of interfaces.  This way,
 interfaces can be added or removed after the kernel is up and running.
-This is done using /sys/modules/ipmi_si/hotmod, which is a write-only
-parameter.  You write a string to this interface.  The string has the
-format:
+This is done using /sys/modules/ipmi_si/parameters/hotmod, which is a
+write-only parameter.  You write a string to this interface.  The string
+has the format:
    <op1>[:op2[:op3...]]
 The "op"s are:
    add|remove,kcs|bt|smic,mem|i/o,<address>[,<opt1>[,<opt2>[,...]]]
