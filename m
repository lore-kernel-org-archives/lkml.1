Return-Path: <linux-kernel-owner+w=401wt.eu-S1765369AbXJZHOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765369AbXJZHOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761525AbXJZG7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:59:31 -0400
Received: from ns2.suse.de ([195.135.220.15]:37041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761373AbXJZG7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:59:24 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:52 2007
Message-Id: <20071026064052.817294148@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:41:06 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       John Johansen <jjohansen@suse.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 42/45] Add AppArmor LSM to security/Makefile
Content-Disposition: inline; filename=apparmor-intree.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Johansen <jjohansen@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 security/Kconfig          |    1 +
 security/Makefile         |    1 +
 security/apparmor/Kconfig |   21 +++++++++++++++++++--
 3 files changed, 21 insertions(+), 2 deletions(-)

--- a/security/Kconfig
+++ b/security/Kconfig
@@ -104,6 +104,7 @@ config SECURITY_ROOTPLUG
 	  If you are unsure how to answer this question, answer N.
 
 source security/selinux/Kconfig
+source security/apparmor/Kconfig
 
 endmenu
 
--- a/security/Makefile
+++ b/security/Makefile
@@ -14,5 +14,6 @@ endif
 obj-$(CONFIG_SECURITY)			+= security.o dummy.o inode.o
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
+obj-$(CONFIG_SECURITY_APPARMOR)		+= commoncap.o apparmor/
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
--- a/security/apparmor/Kconfig
+++ b/security/apparmor/Kconfig
@@ -1,9 +1,26 @@
 config SECURITY_APPARMOR
-	tristate "AppArmor support"
-	depends on SECURITY!=n
+	bool "AppArmor support"
+	depends on SECURITY
+	select AUDIT
 	help
 	  This enables the AppArmor security module.
 	  Required userspace tools (if they are not included in your
 	  distribution) and further information may be found at
 	  <http://forge.novell.com/modules/xfmod/project/?apparmor>
+
 	  If you are unsure how to answer this question, answer N.
+
+config SECURITY_APPARMOR_BOOTPARAM_VALUE
+	int "AppArmor boot parameter default value"
+	depends on SECURITY_APPARMOR
+	range 0 1
+	default 1
+	help
+	  This option sets the default value for the kernel parameter
+	  'apparmor', which controls whether AppArmor is enabled at
+          boot.  If this option is set to 0 (zero), AppArmor will
+          be disabled by default, requiring the kernel parameter
+          be set to 1 (one) to enable it.  If this option is
+          set to 1 (one), AppArmor will be enabled by default.
+
+	  If you are unsure how to answer this question, answer 1.

-- 

