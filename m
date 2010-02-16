Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab0BPKi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:38:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 35/38] KVM: VMX: Remove redundant test in vmx_set_efer()
Date: Tue, 16 Feb 2010 12:35:33 +0200
Message-Id: <1266316536-28936-36-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

msr was tested above, so the second test is not needed.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression *x;
expression e;
identifier l;
@@

if (x == NULL || ...) {
    ... when forall
    return ...; }
... when != goto l;
    when != x = e
    when != &x
*x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 82fb810..b400be0 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1602,8 +1602,6 @@ static void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	 */
 	vmx_load_host_state(to_vmx(vcpu));
 	vcpu->arch.efer = efer;
-	if (!msr)
-		return;
 	if (efer & EFER_LMA) {
 		vmcs_write32(VM_ENTRY_CONTROLS,
 			     vmcs_read32(VM_ENTRY_CONTROLS) |
-- 
1.6.5.3

