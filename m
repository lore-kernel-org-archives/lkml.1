Return-Path: <linux-kernel-owner+w=401wt.eu-S934238AbZIDUWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238AbZIDUWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933983AbZIDUOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:17 -0400
Received: from kroah.org ([198.145.64.141]:36112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933953AbZIDUON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:13 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:50 2009
Message-Id: <20090904200850.849943398@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 06/48] KVM: VMX: Change cs reset state to be a data segment
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-vmx-change-cs-reset-state-to-be-a-data-segment.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@qumranet.com>

(cherry picked from commit 5706be0dafd6f42852f85fbae292301dcad4ccec)

Real mode cs is a data segment, not a code segment.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/vmx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2036,6 +2036,7 @@ static int vmx_vcpu_reset(struct kvm_vcp
 
 	fx_init(&vmx->vcpu);
 
+	seg_setup(VCPU_SREG_CS);
 	/*
 	 * GUEST_CS_BASE should really be 0xffff0000, but VT vm86 mode
 	 * insists on having GUEST_CS_BASE == GUEST_CS_SELECTOR << 4.  Sigh.
@@ -2047,8 +2048,6 @@ static int vmx_vcpu_reset(struct kvm_vcp
 		vmcs_write16(GUEST_CS_SELECTOR, vmx->vcpu.arch.sipi_vector << 8);
 		vmcs_writel(GUEST_CS_BASE, vmx->vcpu.arch.sipi_vector << 12);
 	}
-	vmcs_write32(GUEST_CS_LIMIT, 0xffff);
-	vmcs_write32(GUEST_CS_AR_BYTES, 0x9b);
 
 	seg_setup(VCPU_SREG_DS);
 	seg_setup(VCPU_SREG_ES);


