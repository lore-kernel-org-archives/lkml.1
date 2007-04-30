Return-Path: <linux-kernel-owner+w=401wt.eu-S1161218AbXD3Lhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161218AbXD3Lhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161260AbXD3Lhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:37:33 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:42505 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161218AbXD3Lhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:37:31 -0400
Date: Mon, 30 Apr 2007 13:35:57 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Avi Kivity <avi@qumranet.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 13/36] Use menuconfig objects II - KVM/Virt
In-Reply-To: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704301335310.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Make a "menuconfig" out of the Kconfig objects "menu, ..., endmenu",
so that the user can disable all the options in that menu at once
instead of having to disable each option separately.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/kvm/Kconfig |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- linux-2.6.21-mm_20070428.orig/drivers/kvm/Kconfig
+++ linux-2.6.21-mm_20070428/drivers/kvm/Kconfig
@@ -1,7 +1,12 @@
 #
 # KVM configuration
 #
-menu "Virtualization"
+
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
+	default y
+
+if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
@@ -34,4 +39,4 @@ config KVM_AMD
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
 
-endmenu
+endif # VIRTUALIZATION
