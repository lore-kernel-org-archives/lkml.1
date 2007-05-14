Return-Path: <linux-kernel-owner+w=401wt.eu-S1031977AbXENLnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031977AbXENLnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030308AbXENLdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:33:36 -0400
Received: from 213.210.179.104.adsl.nextra.cz ([213.210.179.104]:27940 "EHLO
	duck8.pdx.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965287AbXENLcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:32:43 -0400
Message-Id: <20070514110622.445501044@suse.de>
References: <20070514110607.549397248@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 14 May 2007 04:06:48 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Johansen <jjohansen@suse.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 41/45] Add AppArmor LSM to security/Makefile
Content-Disposition: inline; filename=apparmor-intree.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Johansen <jjohansen@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 security/Kconfig          |    1 +
 security/Makefile         |    1 +
 security/apparmor/Kconfig |    3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

--- a/security/Kconfig
+++ b/security/Kconfig
@@ -94,6 +94,7 @@ config SECURITY_ROOTPLUG
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
@@ -1,6 +1,7 @@
 config SECURITY_APPARMOR
 	tristate "AppArmor support"
-	depends on SECURITY!=n
+	depends on SECURITY
+	select AUDIT
 	help
 	  This enables the AppArmor security module.
 	  Required userspace tools (if they are not included in your

-- 
