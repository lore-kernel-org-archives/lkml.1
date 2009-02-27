Return-Path: <linux-kernel-owner+w=401wt.eu-S1761155AbZB0KgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761155AbZB0KgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758093AbZB0K2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53584 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 35/37] KVM: x86: Fix typos and whitespace errors
Date: Fri, 27 Feb 2009 12:26:58 +0200
Message-Id: <1235730420-7929-36-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@redhat.com>

Some typos, comments, whitespace errors corrected in the cpuid code

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   33 ++++++++++++++++-----------------
 1 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 19ccde6..141a016 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1067,7 +1067,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof cpuid))
 			goto out;
 		r = kvm_dev_ioctl_get_supported_cpuid(&cpuid,
-			cpuid_arg->entries);
+						      cpuid_arg->entries);
 		if (r)
 			goto out;
 
@@ -1165,8 +1165,8 @@ out:
 }
 
 static int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
-				    struct kvm_cpuid2 *cpuid,
-				    struct kvm_cpuid_entry2 __user *entries)
+				     struct kvm_cpuid2 *cpuid,
+				     struct kvm_cpuid_entry2 __user *entries)
 {
 	int r;
 
@@ -1185,8 +1185,8 @@ out:
 }
 
 static int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
-				    struct kvm_cpuid2 *cpuid,
-				    struct kvm_cpuid_entry2 __user *entries)
+				     struct kvm_cpuid2 *cpuid,
+				     struct kvm_cpuid_entry2 __user *entries)
 {
 	int r;
 
@@ -1195,7 +1195,7 @@ static int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 		goto out;
 	r = -EFAULT;
 	if (copy_to_user(entries, &vcpu->arch.cpuid_entries,
-			   vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
+			 vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
 		goto out;
 	return 0;
 
@@ -1205,12 +1205,12 @@ out:
 }
 
 static void do_cpuid_1_ent(struct kvm_cpuid_entry2 *entry, u32 function,
-			  u32 index)
+			   u32 index)
 {
 	entry->function = function;
 	entry->index = index;
 	cpuid_count(entry->function, entry->index,
-		&entry->eax, &entry->ebx, &entry->ecx, &entry->edx);
+		    &entry->eax, &entry->ebx, &entry->ecx, &entry->edx);
 	entry->flags = 0;
 }
 
@@ -1249,7 +1249,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		bit(X86_FEATURE_LAHF_LM) | bit(X86_FEATURE_CMP_LEGACY) |
 		bit(X86_FEATURE_SVM);
 
-	/* all func 2 cpuid_count() should be called on the same cpu */
+	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
 	do_cpuid_1_ent(entry, function, index);
 	++*nent;
@@ -1323,7 +1323,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 }
 
 static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
-				    struct kvm_cpuid_entry2 __user *entries)
+				     struct kvm_cpuid_entry2 __user *entries)
 {
 	struct kvm_cpuid_entry2 *cpuid_entries;
 	int limit, nent = 0, r = -E2BIG;
@@ -1340,7 +1340,7 @@ static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 	limit = cpuid_entries[0].eax;
 	for (func = 1; func <= limit && nent < cpuid->nent; ++func)
 		do_cpuid_ent(&cpuid_entries[nent], func, 0,
-				&nent, cpuid->nent);
+			     &nent, cpuid->nent);
 	r = -E2BIG;
 	if (nent >= cpuid->nent)
 		goto out_free;
@@ -1349,10 +1349,10 @@ static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 	limit = cpuid_entries[nent - 1].eax;
 	for (func = 0x80000001; func <= limit && nent < cpuid->nent; ++func)
 		do_cpuid_ent(&cpuid_entries[nent], func, 0,
-			       &nent, cpuid->nent);
+			     &nent, cpuid->nent);
 	r = -EFAULT;
 	if (copy_to_user(entries, cpuid_entries,
-			nent * sizeof(struct kvm_cpuid_entry2)))
+			 nent * sizeof(struct kvm_cpuid_entry2)))
 		goto out_free;
 	cpuid->nent = nent;
 	r = 0;
@@ -1496,7 +1496,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof cpuid))
 			goto out;
 		r = kvm_vcpu_ioctl_set_cpuid2(vcpu, &cpuid,
-				cpuid_arg->entries);
+					      cpuid_arg->entries);
 		if (r)
 			goto out;
 		break;
@@ -1509,7 +1509,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof cpuid))
 			goto out;
 		r = kvm_vcpu_ioctl_get_cpuid2(vcpu, &cpuid,
-				cpuid_arg->entries);
+					      cpuid_arg->entries);
 		if (r)
 			goto out;
 		r = -EFAULT;
@@ -2864,7 +2864,7 @@ static int is_matching_cpuid_entry(struct kvm_cpuid_entry2 *e,
 	if ((e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) && e->index != index)
 		return 0;
 	if ((e->flags & KVM_CPUID_FLAG_STATEFUL_FUNC) &&
-		!(e->flags & KVM_CPUID_FLAG_STATE_READ_NEXT))
+	    !(e->flags & KVM_CPUID_FLAG_STATE_READ_NEXT))
 		return 0;
 	return 1;
 }
@@ -2892,7 +2892,6 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 			if (!best || e->function > best->function)
 				best = e;
 	}
-
 	return best;
 }
 
-- 
1.6.0.6

