Return-Path: <linux-kernel-owner+w=401wt.eu-S1751989AbZERJpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbZERJpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756777AbZERJZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:25:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38431 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbZERJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 29/43] KVM: make 'lapic_timer_ops' and 'kpit_ops' static
Date: Mon, 18 May 2009 12:22:51 +0300
Message-Id: <1242638585-18470-30-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>

Fix this sparse warnings:
  arch/x86/kvm/lapic.c:916:22: warning: symbol 'lapic_timer_ops' was not declared. Should it be static?
  arch/x86/kvm/i8254.c:268:22: warning: symbol 'kpit_ops' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c |    2 +-
 arch/x86/kvm/lapic.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 4e2e3f2..cf09bb6 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -265,7 +265,7 @@ static bool kpit_is_periodic(struct kvm_timer *ktimer)
 	return ps->is_periodic;
 }
 
-struct kvm_timer_ops kpit_ops = {
+static struct kvm_timer_ops kpit_ops = {
 	.is_periodic = kpit_is_periodic,
 };
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index dd934d2..4d76bb6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -913,7 +913,7 @@ void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu)
 		kvm_apic_local_deliver(apic, APIC_LVT0);
 }
 
-struct kvm_timer_ops lapic_timer_ops = {
+static struct kvm_timer_ops lapic_timer_ops = {
 	.is_periodic = lapic_is_periodic,
 };
 
-- 
1.6.0.6

