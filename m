Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbYB0XBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbYB0XBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbYB0XBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:01:31 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:47912 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1751006AbYB0XBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:01:30 -0500
X-Spam-Check-By: mail.local.tull.net
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH 2.6.25-rc2 3/9] Kconfig: Improve init/Kconfig help	descriptions - NAMESPACES
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Paul Menage <menage@google.com>,
       Paul Jackson <pj@sgi.com>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Pavel Emelyanov <xemul@openvz.org>
Date: Thu, 28 Feb 2008 10:00:53 +1100
Message-ID: <20080227225949.16087.31336.stgit@marcab.local.tull.net>
In-Reply-To: <20080222-114832-init-kconfig-3@tull.net>
References: <20080222-114832-init-kconfig-3@tull.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the help descriptions of init/Kconfig for clarity, accuracy and consistency.

Kernel config options affected:

  - NAMESPACES
  - UTS_NS
  - IPC_NS
  - USER_NS
  - PID_NS

Add a brief description of what namespaces are and when you would
want to use them.

For the *_NS options, add a tiny bit of detail about what it is,
and ensure each config option has an answer hint: Y for namespaces
"if you will be using a container system", Y for the *_NS options
except for the two labeled EXPERIMENTAL.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---
Try #4


 init/Kconfig |   65 +++++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 50 insertions(+), 15 deletions(-)


diff --git a/init/Kconfig b/init/Kconfig
index cc7a341..0e6a084 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -487,31 +487,62 @@ config NAMESPACES
 	bool "Namespaces support" if EMBEDDED
 	default !EMBEDDED
 	help
-	  Provides the way to make tasks work with different objects using
-	  the same id. For example same IPC id may refer to different objects
-	  or same user id or pid may refer to different tasks when used in
-	  different namespaces.
+	  Select various namespace options.
+
+	  Namespaces allow different kernel objects (such as processes
+	  or sockets) to have the same ID in different namespaces.
+	  Identifiers like process IDs, which historically were globally
+	  unique, will now be unique only within each PID namespace.
+	  Each task can refer only to PIDs within the same namespace
+	  as the task itself.
+
+	  Namespaces are used by container systems (e.g. vservers)
+	  to provide isolation between the containers.
+
+	  This option does not affect any kernel code directly; it merely
+	  allows you to select namespace options below.
+
+	  Answer Y if you will be using a container system, and you
+	  will probably want to enable all the namespace options
+	  below.
 
 config UTS_NS
 	bool "UTS namespace"
 	depends on NAMESPACES
 	help
-	  In this namespace tasks see different info provided with the
-	  uname() system call
+	  Enable support for multiple UTS system attributes.
+
+	  Each UTS namespace provides an individual view of the
+	  information returned by the uname() system call including
+	  hostname, kernel version and domain name.
+
+	  Answer Y if you will be using a container system.
 
 config IPC_NS
 	bool "IPC namespace"
 	depends on NAMESPACES && SYSVIPC
 	help
-	  In this namespace tasks work with IPC ids which correspond to
-	  different IPC objects in different namespaces
+	  Enable support for namespace-specific IPC IDs.
+
+	  IPC IDs will be unique only within each IPC namespace.
+
+	  Answer Y if you will be using a container system.
 
 config USER_NS
 	bool "User namespace (EXPERIMENTAL)"
 	depends on NAMESPACES && EXPERIMENTAL
 	help
-	  This allows containers, i.e. vservers, to use user namespaces
-	  to provide different user info for different servers.
+	  Enable experimental support for user namespaces.
+
+	  This is a function used by container-based virtualisation systems
+	  (e.g. vservers). User namespaces are intended to ensure that
+	  processes with the same uid which are in different containers are
+	  isolated from each other.
+
+	  Currently user namespaces provide separate accounting, while
+	  isolation must be provided using SELinux or a custom security
+	  module.
+
 	  If unsure, say N.
 
 config PID_NS
@@ -519,12 +550,16 @@ config PID_NS
 	default n
 	depends on NAMESPACES && EXPERIMENTAL
 	help
-	  Suport process id namespaces.  This allows having multiple
-	  process with the same pid as long as they are in different
-	  pid namespaces.  This is a building block of containers.
+	  Enable experimental support for hierarchical process id namespaces.
+
+	  This is a function used by container-based virtualisation
+	  systems (e.g. vservers).  Each process will have a distinct
+	  Process ID in each PID namespace which the process is in.
+	  A process can "see" other processes in the same PID namespace
+	  and child PID namespaces, but cannot see processes in parent
+	  PID namespaces.
 
-	  Unless you want to work with an experimental feature
-	  say N here.
+	  If unsure, say N.
 
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"

