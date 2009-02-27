Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbZB0KlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbZB0KlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758247AbZB0K2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53567 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbZB0K1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:09 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/37] KVM: VMX: don't clobber segment AR if emulating invalid state
Date: Fri, 27 Feb 2009 12:26:36 +0200
Message-Id: <1235730420-7929-14-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ususable bit is important for determining state validity; don't
clobber it.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index be94410..a6598cb 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1649,7 +1649,7 @@ static void vmx_get_segment(struct kvm_vcpu *vcpu,
 	var->limit = vmcs_read32(sf->limit);
 	var->selector = vmcs_read16(sf->selector);
 	ar = vmcs_read32(sf->ar_bytes);
-	if (ar & AR_UNUSABLE_MASK)
+	if ((ar & AR_UNUSABLE_MASK) && !emulate_invalid_guest_state)
 		ar = 0;
 	var->type = ar & 15;
 	var->s = (ar >> 4) & 1;
-- 
1.6.0.6

