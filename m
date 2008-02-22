Return-Path: <linux-kernel-owner+w=401wt.eu-S936447AbYBVAxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936447AbYBVAxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935921AbYBVAxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:53:19 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:60973 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S935790AbYBVAxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:53:14 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Fri, 22 Feb 2008 11:52:44 +1100
Message-ID: <20080222-114832-init-kconfig-4@tull.net>
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Serge Hallyn <serue@us.ibm.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: [PATCH 2.6.25-rc2 4/9] Kconfig: Improve init/Kconfig help descriptions - AUDIT
References: <20080219140609.GA26619@tull.net>
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the help descriptions for clarity, accuracy and consistency.

Kernel config options affected:

  - AUDIT
  - AUDITSYSCALL

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---
Try #3.

--- a/init/Kconfig	2008-02-20 09:34:48.000000000 +1100
+++ b/init/Kconfig	2008-02-21 09:15:18.000000000 +1100
@@ -218,20 +218,37 @@ config AUDIT
 	bool "Auditing support"
 	depends on NET
 	help
-	  Enable auditing infrastructure that can be used with another
-	  kernel subsystem, such as SELinux (which requires this for
-	  logging of avc messages output).  Does not do system-call
-	  auditing without CONFIG_AUDITSYSCALL.
+	  Enable an auditing infrastructure that can be used with another
+	  kernel subsystem, such as Security-Enhanced Linux (SELinux),
+	  which requires this option for logging of security related
+	  messages.
+
+	  With this option, the kernel can use netlink to pass audit
+	  messages to an audit daemon process. Otherwise, audit messages
+	  are logged to syslog.
+
+	  See <http://www.nsa.gov/selinux/> for more information
+	  on Security-Enhanced Linux.
+
+	  CONFIG_AUDITSYSCALL (see below) is also required for
+	  system-call auditing.
+
+	  If unsure, say N.
 
 config AUDITSYSCALL
 	bool "Enable system-call auditing support"
 	depends on AUDIT && (X86 || PPC || PPC64 || S390 || IA64 || UML || SPARC64|| SUPERH)
 	default y if SECURITY_SELINUX
 	help
-	  Enable low-overhead system-call auditing infrastructure that
+	  Enable a low-overhead system-call auditing infrastructure that
 	  can be used independently or with another kernel subsystem,
-	  such as SELinux.  To use audit's filesystem watch feature, please
-	  ensure that INOTIFY is configured.
+	  such as SELinux.
+
+	  To use audit's filesystem watch feature, please ensure
+	  that CONFIG_INOTIFY is enabled. See the 'File systems'
+	  menu for Inotify file change notification support.
+
+	  If unsure, say N.
 
 config AUDIT_TREE
 	def_bool y
