Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab0BMIHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:07:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab0BMICF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 28/39] KVM: ia64: remove redundant kvm_get_exit_data() NULL tests
Date: Sat, 13 Feb 2010 10:01:48 +0200
Message-Id: <1266048119-14325-29-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

kvm_get_exit_data() cannot return a NULL pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/kvm_fw.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/ia64/kvm/kvm_fw.c b/arch/ia64/kvm/kvm_fw.c
index e4b8231..cb548ee 100644
--- a/arch/ia64/kvm/kvm_fw.c
+++ b/arch/ia64/kvm/kvm_fw.c
@@ -75,7 +75,7 @@ static void set_pal_result(struct kvm_vcpu *vcpu,
 	struct exit_ctl_data *p;
 
 	p = kvm_get_exit_data(vcpu);
-	if (p && p->exit_reason == EXIT_REASON_PAL_CALL) {
+	if (p->exit_reason == EXIT_REASON_PAL_CALL) {
 		p->u.pal_data.ret = result;
 		return ;
 	}
@@ -87,7 +87,7 @@ static void set_sal_result(struct kvm_vcpu *vcpu,
 	struct exit_ctl_data *p;
 
 	p = kvm_get_exit_data(vcpu);
-	if (p && p->exit_reason == EXIT_REASON_SAL_CALL) {
+	if (p->exit_reason == EXIT_REASON_SAL_CALL) {
 		p->u.sal_data.ret = result;
 		return ;
 	}
@@ -322,7 +322,7 @@ static  u64 kvm_get_pal_call_index(struct kvm_vcpu *vcpu)
 	struct exit_ctl_data *p;
 
 	p = kvm_get_exit_data(vcpu);
-	if (p && (p->exit_reason == EXIT_REASON_PAL_CALL))
+	if (p->exit_reason == EXIT_REASON_PAL_CALL)
 		index = p->u.pal_data.gr28;
 
 	return index;
@@ -646,18 +646,16 @@ static void kvm_get_sal_call_data(struct kvm_vcpu *vcpu, u64 *in0, u64 *in1,
 
 	p = kvm_get_exit_data(vcpu);
 
-	if (p) {
-		if (p->exit_reason == EXIT_REASON_SAL_CALL) {
-			*in0 = p->u.sal_data.in0;
-			*in1 = p->u.sal_data.in1;
-			*in2 = p->u.sal_data.in2;
-			*in3 = p->u.sal_data.in3;
-			*in4 = p->u.sal_data.in4;
-			*in5 = p->u.sal_data.in5;
-			*in6 = p->u.sal_data.in6;
-			*in7 = p->u.sal_data.in7;
-			return ;
-		}
+	if (p->exit_reason == EXIT_REASON_SAL_CALL) {
+		*in0 = p->u.sal_data.in0;
+		*in1 = p->u.sal_data.in1;
+		*in2 = p->u.sal_data.in2;
+		*in3 = p->u.sal_data.in3;
+		*in4 = p->u.sal_data.in4;
+		*in5 = p->u.sal_data.in5;
+		*in6 = p->u.sal_data.in6;
+		*in7 = p->u.sal_data.in7;
+		return ;
 	}
 	*in0 = 0;
 }
-- 
1.6.5.3

