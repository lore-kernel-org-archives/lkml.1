Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZEENZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZEENZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbZEENZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:25:01 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54443 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbZEENY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:24:57 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RFC PATCH 3/3] kvm: add pv_cpu_ops.hypercall support to the guest
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com
Date: Tue, 05 May 2009 09:24:48 -0400
Message-ID: <20090505132447.19891.22935.stgit@dev.haskins.net>
In-Reply-To: <20090505132005.19891.78436.stgit@dev.haskins.net>
References: <20090505132005.19891.78436.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/kernel/kvm.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 33019dd..d299ed5 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -50,6 +50,26 @@ static void kvm_io_delay(void)
 {
 }
 
+static long _kvm_hypercall(unsigned long nr,
+			   unsigned long *args,
+			   size_t count)
+{
+	switch (count) {
+	case 0:
+		return kvm_hypercall0(nr);
+	case 1:
+		return kvm_hypercall1(nr, args[0]);
+	case 2:
+		return kvm_hypercall2(nr, args[0], args[1]);
+	case 3:
+		return kvm_hypercall3(nr, args[0], args[1], args[2]);
+	case 4:
+		return kvm_hypercall4(nr, args[0], args[1], args[2], args[3]);
+	default:
+		return -EINVAL;
+	}
+}
+
 static void kvm_mmu_op(void *buffer, unsigned len)
 {
 	int r;
@@ -207,6 +227,8 @@ static void paravirt_ops_setup(void)
 	if (kvm_para_has_feature(KVM_FEATURE_NOP_IO_DELAY))
 		pv_cpu_ops.io_delay = kvm_io_delay;
 
+	pv_cpu_ops.hypercall = _kvm_hypercall;
+
 	if (kvm_para_has_feature(KVM_FEATURE_MMU_OP)) {
 		pv_mmu_ops.set_pte = kvm_set_pte;
 		pv_mmu_ops.set_pte_at = kvm_set_pte_at;

