Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbYLIUZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbYLIUZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbYLIUXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34846 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696AbYLIUXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:07 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 10/44] KVM: ppc: fix Kconfig constraints
Date: Tue,  9 Dec 2008 22:22:25 +0200
Message-Id: <1228854179-23002-11-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Make sure that CONFIG_KVM cannot be selected without processor support
(currently, 440 is the only processor implementation available).

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/Kconfig |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 37e9b3c..e4ab1c7 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -15,25 +15,23 @@ menuconfig VIRTUALIZATION
 if VIRTUALIZATION
 
 config KVM
-	bool "Kernel-based Virtual Machine (KVM) support"
-	depends on EXPERIMENTAL
+	bool
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
+
+config KVM_440
+	bool "KVM support for PowerPC 440 processors"
+	depends on EXPERIMENTAL && 44x
+	select KVM
 	---help---
-	  Support hosting virtualized guest machines. You will also
-	  need to select one or more of the processor modules below.
+	  Support running unmodified 440 guest kernels in virtual machines on
+	  440 host processors.
 
 	  This module provides access to the hardware capabilities through
 	  a character device node named /dev/kvm.
 
 	  If unsure, say N.
 
-config KVM_440
-	bool "KVM support for PowerPC 440 processors"
-	depends on KVM && 44x
-	---help---
-	  KVM can run unmodified 440 guest kernels on 440 host processors.
-
 config KVM_TRACE
 	bool "KVM trace support"
 	depends on KVM && MARKERS && SYSFS
-- 
1.6.0.3

