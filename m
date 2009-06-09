Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZFIBhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZFIBhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 21:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZFIBhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 21:37:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:13848 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbZFIBhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 21:37:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,328,1241420400"; 
   d="scan'208";a="464611023"
Subject: [PATCH] KVM: MCE: Fix compiling without CONFIG_X86_MCE
From: Huang Ying <ying.huang@intel.com>
To: "avi@redhat.com" <avi@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Marcelo Tosatti <mtosatti@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 09:37:24 +0800
Message-Id: <1244511444.8361.605.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enclose do_machine_check with #ifdef CONFIG_X86_MCE.

Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kvm/vmx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2623,12 +2623,14 @@ static int handle_rmode_exception(struct
  */
 static void kvm_machine_check(void)
 {
+#ifdef CONFIG_X86_MCE
 	struct pt_regs regs = {
 		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
 		.flags = X86_EFLAGS_IF,
 	};
 
 	do_machine_check(&regs, 0);
+#endif
 }
 
 static int handle_machine_check(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)


