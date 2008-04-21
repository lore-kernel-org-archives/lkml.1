Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbYDUKl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbYDUKl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbYDUKaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:46 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37977
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbYDUKaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:12 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 30/31] KVM: ppc: Kconfig fixes
Date: Mon, 21 Apr 2008 13:29:56 +0300
Message-Id: <1208773797-7829-31-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Don't allow building as a module (asm-offsets dependencies).

Also, automatically select KVM_BOOKE_HOST until we better separate the guest
and host layers.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/powerpc/kvm/Kconfig |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 989ee82..6f73edd 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -15,10 +15,12 @@ menuconfig VIRTUALIZATION
 if VIRTUALIZATION
 
 config KVM
-	tristate "Kernel-based Virtual Machine (KVM) support"
-	depends on EXPERIMENTAL
+	bool "Kernel-based Virtual Machine (KVM) support"
+	depends on 44x && EXPERIMENTAL
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
+	# We can only run on Book E hosts so far
+	select KVM_BOOKE_HOST
 	---help---
 	  Support hosting virtualized guest machines. You will also
 	  need to select one or more of the processor modules below.
@@ -26,13 +28,10 @@ config KVM
 	  This module provides access to the hardware capabilities through
 	  a character device node named /dev/kvm.
 
-	  To compile this as a module, choose M here: the module
-	  will be called kvm.
-
 	  If unsure, say N.
 
 config KVM_BOOKE_HOST
-	tristate "KVM host support for Book E PowerPC processors"
+	bool "KVM host support for Book E PowerPC processors"
 	depends on KVM && 44x
 	---help---
 	  Provides host support for KVM on Book E PowerPC processors. Currently
-- 
1.5.5

