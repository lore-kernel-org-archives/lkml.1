Return-Path: <linux-kernel-owner+w=401wt.eu-S1764585AbXINFTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764585AbXINFTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 01:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbXINFTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 01:19:30 -0400
Received: from ozlabs.org ([203.10.76.45]:48546 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbXINFT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 01:19:29 -0400
Subject: [PATCH 2/3] Consolidate host virtualization support under
	Virtualization menu
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Anthony Liguori <aliguori@us.ibm.com>
In-Reply-To: <1189747054.7262.34.camel@localhost.localdomain>
References: <1189747054.7262.34.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 15:18:44 +1000
Message-Id: <1189747124.7262.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We turn "Virtualization" into a menu, not a config option, since it's
actually only used as a menu.  Then we move lguest under that menu.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r c2893801de2a drivers/Kconfig
--- a/drivers/Kconfig	Fri Sep 14 13:24:46 2007 +1000
+++ b/drivers/Kconfig	Fri Sep 14 13:24:49 2007 +1000
@@ -87,6 +87,4 @@ source "drivers/kvm/Kconfig"
 source "drivers/kvm/Kconfig"
 
 source "drivers/uio/Kconfig"
-
-source "drivers/lguest/Kconfig"
 endmenu
diff -r c2893801de2a drivers/kvm/Kconfig
--- a/drivers/kvm/Kconfig	Fri Sep 14 13:24:46 2007 +1000
+++ b/drivers/kvm/Kconfig	Fri Sep 14 13:32:22 2007 +1000
@@ -1,21 +1,12 @@
 #
 # KVM configuration
 #
-menuconfig VIRTUALIZATION
-	bool "Virtualization"
+menu "Virtualization"
 	depends on X86
-	default y
-	---help---
-	  Say Y here to get to see options for virtualization guest drivers.
-	  This option alone does not add any kernel code.
-
-	  If you say N, all options in this submenu will be skipped and disabled.
-
-if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
-	depends on X86 && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	select ANON_INODES
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
@@ -45,4 +36,8 @@ config KVM_AMD
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
 
-endif # VIRTUALIZATION
+# OK, it's a little counter-intuitive to do this, but it puts it neatly under
+# the virtualization menu.
+source drivers/lguest/Kconfig
+
+endmenu


