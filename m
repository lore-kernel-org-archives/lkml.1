Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZKSNhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZKSNhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZKSNgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:36:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbZKSNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:09 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 29/35] KVM: x86: disallow KVM_{SET,GET}_LAPIC without allocated in-kernel lapic
Date: Thu, 19 Nov 2009 15:35:05 +0200
Message-Id: <1258637711-11674-30-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Otherwise kvm might attempt to dereference a NULL pointer.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 97f6f95..cd6fe0a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1893,6 +1893,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 	switch (ioctl) {
 	case KVM_GET_LAPIC: {
+		r = -EINVAL;
+		if (!vcpu->arch.apic)
+			goto out;
 		lapic = kzalloc(sizeof(struct kvm_lapic_state), GFP_KERNEL);
 
 		r = -ENOMEM;
@@ -1908,6 +1911,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_SET_LAPIC: {
+		r = -EINVAL;
+		if (!vcpu->arch.apic)
+			goto out;
 		lapic = kmalloc(sizeof(struct kvm_lapic_state), GFP_KERNEL);
 		r = -ENOMEM;
 		if (!lapic)
-- 
1.6.5.2

