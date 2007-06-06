Return-Path: <linux-kernel-owner+w=401wt.eu-S935248AbXFFT2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935248AbXFFT2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761375AbXFFT2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:28:17 -0400
Received: from [198.99.130.12] ([198.99.130.12]:57369 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbXFFT2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:28:16 -0400
Date: Wed, 6 Jun 2007 15:19:25 -0400
From: Jeff Dike <jdike@addtoit.com>
To: avi@qumranet.com
Cc: kvm-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       jun.nakajima@intel.com, eddie.dong@intel.com
Subject: [PATCH] KVM - Fix rmode_tss_base declaration
Message-ID: <20070606191925.GA8989@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The long return value of rmode_tss_base is truncated by its declared
return type of int.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 drivers/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: kvm/drivers/kvm/vmx.c
===================================================================
--- kvm.orig/drivers/kvm/vmx.c
+++ kvm/drivers/kvm/vmx.c
@@ -884,7 +884,7 @@ static void enter_pmode(struct kvm_vcpu 
 	vmcs_write32(GUEST_CS_AR_BYTES, 0x9b);
 }
 
-static int rmode_tss_base(struct kvm* kvm)
+static unsigned long rmode_tss_base(struct kvm* kvm)
 {
 	gfn_t base_gfn = kvm->memslots[0].base_gfn + kvm->memslots[0].npages - 3;
 	return base_gfn << PAGE_SHIFT;
