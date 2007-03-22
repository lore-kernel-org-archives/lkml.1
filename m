Return-Path: <linux-kernel-owner+w=401wt.eu-S965610AbXCVCwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965610AbXCVCwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 22:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965617AbXCVCwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 22:52:14 -0400
Received: from ozlabs.org ([203.10.76.45]:43639 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965610AbXCVCwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 22:52:14 -0400
Subject: [PATCH] make KVM conform to sucky rdmsr interface
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@muc.de>, Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@osdl.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 13:51:57 +1100
Message-Id: <1174531917.2713.91.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grrr.... Andi refused to take my "rdmsr64" patch which moved to a
function-like interface for MSRs, dismissing it as pointless churn.

paravirt_ops cleanups changed a macro to an inline and spotted this
kvm bug.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 47c6ee74a5c5 drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c	Thu Mar 22 12:57:44 2007 +1100
+++ b/drivers/kvm/vmx.c	Thu Mar 22 13:38:24 2007 +1100
@@ -1127,7 +1127,7 @@ static int vmx_vcpu_setup(struct kvm_vcp
 		u64 data;
 		int j = vcpu->nmsrs;
 
-		if (rdmsr_safe(index, &data_low, &data_high) < 0)
+		if (rdmsr_safe(index, data_low, data_high) < 0)
 			continue;
 		if (wrmsr_safe(index, data_low, data_high) < 0)
 			continue;


