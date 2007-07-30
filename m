Return-Path: <linux-kernel-owner+w=401wt.eu-S965786AbXG3A5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965786AbXG3A5Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 20:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765816AbXG3A5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 20:57:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764828AbXG3A5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 20:57:18 -0400
Date: Sun, 29 Jul 2007 20:56:46 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200707300056.l6U0ukUe021931@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] CPU online file permission
Cc: akpm@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a reason why the "online" file in the subdirectories for the CPUs
in /sys/devices/system isn't world-readable?  I cannot imagine it to be
security relevant especially now that a getcpu() syscall can be used to
determine what CPUa  thread runs on.

The file is useful to correctly implement the sysconf() function to return
the number of online CPUs.  In the presence of hotplug we currently cannot
provide this information.  The patch below should to it.


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

--- drivers/base/cpu.c	2007-02-20 12:01:31.000000000 -0800
+++ drivers/base/cpu.c-new	2007-07-29 17:52:58.000000000 -0700
@@ -53,7 +53,7 @@
 		ret = count;
 	return ret;
 }
-static SYSDEV_ATTR(online, 0600, show_online, store_online);
+static SYSDEV_ATTR(online, 0644, show_online, store_online);
 
 static void __devinit register_cpu_control(struct cpu *cpu)
 {
