Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbZKSNgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbZKSNgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbZKSNgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:36:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbZKSNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:09 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 24/35] KVM: remove duplicated task_switch check
Date: Thu, 19 Nov 2009 15:35:00 +0200
Message-Id: <1258637711-11674-25-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Probably introduced by a bad merge.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 58c5cdd..dbddcc2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4530,11 +4530,6 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason)
 	if (reason != TASK_SWITCH_CALL && reason != TASK_SWITCH_GATE)
 		old_tss_sel = 0xffff;
 
-	/* set back link to prev task only if NT bit is set in eflags
-	   note that old_tss_sel is not used afetr this point */
-	if (reason != TASK_SWITCH_CALL && reason != TASK_SWITCH_GATE)
-		old_tss_sel = 0xffff;
-
 	if (nseg_desc.type & 8)
 		ret = kvm_task_switch_32(vcpu, tss_selector, old_tss_sel,
 					 old_tss_base, &nseg_desc);
-- 
1.6.5.2

