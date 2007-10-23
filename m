Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbXJWWiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbXJWWiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbXJWWgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:36:45 -0400
Received: from havoc.gtf.org ([69.61.125.42]:44184 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbXJWWgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:36:44 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, avi@qumranet.com
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
Subject: [PATCH 6/12] KVM: work around SMP requirement
Message-Id: <20071023223640.EADF31F81AC@havoc.gtf.org>
Date: Tue, 23 Oct 2007 18:36:40 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KVM is currently completely broken for the !CONFIG_SMP case.

drivers/kvm/kvm_main.c: In function ‘kvm_flush_remote_tlbs’:
drivers/kvm/kvm_main.c:220: error: implicit declaration of function ‘smp_call_function_mask’

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
I hope the KVM maintainer can come up with a better solution...

diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 8749fa4..e35fbc6 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -16,7 +16,7 @@ if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
-	depends on X86 && EXPERIMENTAL
+	depends on X86 && EXPERIMENTAL && SMP
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	---help---
