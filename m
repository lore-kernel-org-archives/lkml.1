Return-Path: <linux-kernel-owner+w=401wt.eu-S1764463AbYFFGTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764463AbYFFGTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764535AbYFFGRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:17:47 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59299 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYFFGRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:17:46 -0400
Message-Id: <20080606060958.873465466@bull.net>
References: <20080606060955.317871352@bull.net>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 08:10:01 +0200
From: <Solofo.Ramangalahy@bull.net>
To: <linux-kernel@vger.kernel.org>
Cc: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
Subject: [RFC -mm 6/6] sysv ipc: documentation for msgmnb scaling wrt. cpus
Content-Disposition: inline;
 filename=ipc-documentation-scale-msgmnb-with-the-number-of-cpus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

Add documentation to explain how to disable and reenable the
computation mechanism.

Signed-off-by: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>

---

 Documentation/sysctl/kernel.txt |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

Index: b/Documentation/sysctl/kernel.txt
===================================================================
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -179,6 +179,33 @@ kernel stack.
 
 ==============================================================
 
+msgmnb
+
+Maximum size in bytes, not in message count, of a single SystemV IPC
+message queue (b stands for bytes).
+
+This value is dynamic and depends on the online cpu count of the
+machine (taking cpu hotplug into account).
+
+Computed values are between MSGMNB and MSGMNB*MSG_CPU_SCALE #define
+constants (currently [16384,65536]).
+
+The exact value is automatically (re)computed, but:
+. If the value is positioned from user space (via procfs or sysctl()),
+  to a positive value then the automatic recomputation is
+  disabled. This leaves control to user space. E.g.
+
+  # echo 16384 > /proc/sys/kernel/msgmnb
+
+. If the value is positioned from user space to a negative value, then
+  the computation is reenabled. E.g.
+
+  # echo -1 > /proc/sys/kernel/msgmnb
+
+See recompute_msgmnb() function in ipc/ directory for details.
+
+==============================================================
+
 osrelease, ostype & version:
 
 # cat osrelease

-- 
Solofo Ramangalahy
Bull SA.
