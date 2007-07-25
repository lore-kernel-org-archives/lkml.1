Return-Path: <linux-kernel-owner+w=401wt.eu-S1763058AbXGYNiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763058AbXGYNiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760632AbXGYNh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:37:57 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60723 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275AbXGYNh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:37:56 -0400
Message-ID: <46A75230.4090400@fr.ibm.com>
Date: Wed, 25 Jul 2007 15:37:52 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] fix order of container subsystems in init/Kconfig
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

some cosmetic changes to init/Kconfig to make the subsystem list
under containers look nicer when CONFIG_CONTAINERS=y.

also changed the 'select' to 'depends on' for the namespace 
subsystem.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
---
 init/Kconfig |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: 2.6.23-rc1-mm1/init/Kconfig
===================================================================
--- 2.6.23-rc1-mm1.orig/init/Kconfig
+++ 2.6.23-rc1-mm1/init/Kconfig
@@ -310,6 +310,22 @@ config CONTAINER_DEBUG
 
 	  Say N if unsure
 
+config CONTAINER_NS
+        bool "Namespace container subsystem"
+        depends on CONTAINERS
+        help
+          Provides a simple namespace container subsystem to
+          provide hierarchical naming of sets of namespaces,
+          for instance virtual servers and checkpoint/restart
+          jobs.
+
+config CONTAINER_CPUACCT
+	bool "Simple CPU accounting container subsystem"
+	depends on CONTAINERS
+	help
+	  Provides a simple Resource Controller for monitoring the
+	  total CPU consumed by the tasks in a container
+
 config CPUSETS
 	bool "Cpuset support"
 	depends on SMP && CONTAINERS
@@ -341,27 +357,11 @@ config SYSFS_DEPRECATED
 	  If you are using a distro that was released in 2006 or later,
 	  it should be safe to say N here.
 
-config CONTAINER_NS
-        bool "Namespace container subsystem"
-        select CONTAINERS
-        help
-          Provides a simple namespace container subsystem to
-          provide hierarchical naming of sets of namespaces,
-          for instance virtual servers and checkpoint/restart
-          jobs.
-
 config PROC_PID_CPUSET
 	bool "Include legacy /proc/<pid>/cpuset file"
 	depends on CPUSETS
 	default y
 
-config CONTAINER_CPUACCT
-	bool "Simple CPU accounting container subsystem"
-	depends on CONTAINERS
-	help
-	  Provides a simple Resource Controller for monitoring the
-	  total CPU consumed by the tasks in a container
-
 config RELAY
 	bool "Kernel->user space relay support (formerly relayfs)"
 	help
