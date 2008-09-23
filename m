Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYIWNvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYIWNvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYIWNrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52371 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbYIWNrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:21 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Mohammed Gamal <m.gamal005@gmail.com>
Subject: [PATCH 13/40] KVM: VMX: Remove redundant check in handle_rmode_exception
Date: Tue, 23 Sep 2008 16:46:27 +0300
Message-Id: <1222177614-26669-14-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

Since checking for vcpu->arch.rmode.active is already done whenever we
call handle_rmode_exception(), checking it inside the function is redundant.

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e8fed9b..9591ca7 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2224,9 +2224,6 @@ static void kvm_guest_debug_pre(struct kvm_vcpu *vcpu)
 static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 				  int vec, u32 err_code)
 {
-	if (!vcpu->arch.rmode.active)
-		return 0;
-
 	/*
 	 * Instruction with address size override prefix opcode 0x67
 	 * Cause the #SS fault with 0 error code in VM86 mode.
-- 
1.6.0.1

