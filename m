Return-Path: <linux-kernel-owner+w=401wt.eu-S935907AbXLTOc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935907AbXLTOc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933077AbXLTONp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:13:45 -0500
Received: from ns2.suse.de ([195.135.220.15]:56904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933208AbXLTONh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:13:37 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:48 2007
Message-Id: <20071220140948.529829822@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:55 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       John Johansen <jjohansen@suse.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 45/47] Add AppArmor LSM to security/Makefile
Content-Disposition: inline; filename=apparmor-intree.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Johansen <jjohansen@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 security/Kconfig          |    1 +
 security/Makefile         |    1 +
 security/apparmor/Kconfig |   22 ++++++++++++++++++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

--- a/security/Kconfig
+++ b/security/Kconfig
@@ -105,6 +105,7 @@ config SECURITY_ROOTPLUG
 
 source security/selinux/Kconfig
 source security/smack/Kconfig
+source security/apparmor/Kconfig
 
 endmenu
 
--- a/security/Makefile
+++ b/security/Makefile
@@ -16,5 +16,6 @@ obj-$(CONFIG_SECURITY)			+= security.o d
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+= commoncap.o smack/built-in.o
+obj-$(CONFIG_SECURITY_APPARMOR)		+= commoncap.o apparmor/
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
--- a/security/apparmor/Kconfig
+++ b/security/apparmor/Kconfig
@@ -1,9 +1,27 @@
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
+	  'apparmor', which allows AppArmor to be enabled or disabled
+          at boot.  If this option is set to 0 (zero), the AppArmor
+	  kernel parameter will default to 0, disabling AppArmor at
+	  bootup.  If this option is set to 1 (one), the AppArmor
+	  kernel parameter will default to 1, enabling AppArmor at
+	  bootup.
+
+	  If you are unsure how to answer this question, answer 1.

-- 

