Return-Path: <linux-kernel-owner+w=401wt.eu-S1762291AbXFQKCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762291AbXFQKCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759788AbXFQJpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:50 -0400
Received: from il.qumranet.com ([82.166.9.18]:55204 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759050AbXFQJoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Jan Engelhardt <jengelh@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 28/58] Use menuconfig objects II - KVM/Virt
Date: Sun, 17 Jun 2007 12:44:09 +0300
Message-Id: <1182073480633-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@linux01.gwdg.de>

Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/Kconfig |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index e8e37d8..2f661e5 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -1,8 +1,12 @@
 #
 # KVM configuration
 #
-menu "Virtualization"
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
 	depends on X86
+	default y
+
+if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
@@ -35,4 +39,4 @@ config KVM_AMD
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
 
-endmenu
+endif # VIRTUALIZATION
-- 
1.5.0.6

