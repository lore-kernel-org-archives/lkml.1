Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbZHZKaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbZHZKaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbZHZKaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:30:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbZHZKaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:09 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/47] KVM: remove superfluous NULL pointer check in kvm_inject_pit_timer_irqs()
Date: Wed, 26 Aug 2009 13:29:23 +0300
Message-Id: <1251282609-12835-2-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

This takes care of the following entries from Dan's list:

arch/x86/kvm/i8254.c +714 kvm_inject_pit_timer_irqs(6) warning: variable derefenced in initializer 'vcpu'
arch/x86/kvm/i8254.c +714 kvm_inject_pit_timer_irqs(6) warning: variable derefenced before check 'vcpu'

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Cc: Julia Lawall <julia@diku.dk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 472653c..82ad523 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -713,7 +713,7 @@ void kvm_inject_pit_timer_irqs(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_kpit_state *ps;
 
-	if (vcpu && pit) {
+	if (pit) {
 		int inject = 0;
 		ps = &pit->pit_state;
 
-- 
1.6.4.1

