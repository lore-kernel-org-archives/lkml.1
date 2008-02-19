Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbYBSOjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbYBSOjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYBSOj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:39:27 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:41448 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1751674AbYBSOj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:39:26 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Wed, 20 Feb 2008 01:38:55 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Improve init/Kconfig help descriptions [PATCH 4/9]
Message-ID: <20080219143855.GB27352@tull.net>
References: <20080219140609.GA26619@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219140609.GA26619@tull.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 01:06:09AM +1100, Nick Andrew wrote:
> Here is a series of 9 patches to init/Kconfig intended to improve the
> usefulness and consistency of the help descriptions. The patches are
> against linux-2.6.24.2.
> [...]
> Patch 4
> 	AUDIT
> 	AUDITSYSCALL

Changelog:

Improve usefulness and consistency of kernel configuration help messages.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>

--- a/init/Kconfig	2008-02-20 00:45:07.000000000 +1100
+++ b/init/Kconfig	2008-02-20 00:52:07.000000000 +1100
@@ -231,20 +231,36 @@ config AUDIT
 	bool "Auditing support"
 	depends on NET
 	help
-	  Enable auditing infrastructure that can be used with another
-	  kernel subsystem, such as SELinux (which requires this for
-	  logging of avc messages output).  Does not do system-call
-	  auditing without CONFIG_AUDITSYSCALL.
+	  Enable an auditing infrastructure that can be used with another
+	  kernel subsystem, such as Security-Enhanced Linux (SELinux),
+	  which requires this option for logging of AVC messages output.
+
+	  AVC refers to Access Vector Cache, a subsystem used by SELinux
+	  to improve performance of the security checking by caching
+	  previous access decisions.
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
 	depends on AUDIT && (X86 || PPC || PPC64 || S390 || IA64 || UML || SPARC64)
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
