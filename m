Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYBSSZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYBSSZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYBSSZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:25:49 -0500
Received: from qb-out-0506.google.com ([72.14.204.231]:9676 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbYBSSZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:25:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=isgDD9i1UjiUzGUufK9NuIqMKQ+TNFp0M3RcmAr8CLcNu+x3TdmJfY2H9gDxjRedlbq5w/dhPJWgjkxhSQHkObif0sK/UF7qs+u6BVAAQHiv7yPRrSXygOmoHyj0s/uH2Pj+93hZd/hwByfzocdFiAWQyF1eK6amj5mG2aDz7oI=
Subject: [PATCH] kvm: sparse fixes for kvm/x86.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 10:25:50 -0800
Message-Id: <1203445550.10464.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In two case statements, use the ever popular 'i' instead of index:
arch/x86/kvm/x86.c:1063:7: warning: symbol 'index' shadows an earlier one
arch/x86/kvm/x86.c:1000:9: originally declared here
arch/x86/kvm/x86.c:1079:7: warning: symbol 'index' shadows an earlier one
arch/x86/kvm/x86.c:1000:9: originally declared here

Missing semicolon.
arch/x86/kvm/x86.c:493:3: warning: returning void-valued expression

Make it static.
arch/x86/kvm/x86.c:1945:24: warning: symbol 'emulate_ops' was not declared. Should it be static?

Drop the return statements.
arch/x86/kvm/x86.c:2878:2: warning: returning void-valued expression
arch/x86/kvm/x86.c:2944:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, I had originally sent this to you, please drop it if you haven't already
done so, I'll get this in through the kvm tree.

 arch/x86/kvm/x86.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5dfc21f..df49ddc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -490,7 +490,7 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 	struct timespec wc_ts;
 
 	if (!wall_clock)
-		return
+		return;
 
 	mutex_lock(&kvm->lock);
 
@@ -1060,32 +1060,32 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	}
 	/* function 4 and 0xb have additional index. */
 	case 4: {
-		int index, cache_type;
+		int i, cache_type;
 
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		/* read more entries until cache_type is zero */
-		for (index = 1; *nent < maxnent; ++index) {
-			cache_type = entry[index - 1].eax & 0x1f;
+		for (i = 1; *nent < maxnent; ++i) {
+			cache_type = entry[i - 1].eax & 0x1f;
 			if (!cache_type)
 				break;
-			do_cpuid_1_ent(&entry[index], function, index);
-			entry[index].flags |=
+			do_cpuid_1_ent(&entry[i], function, i);
+			entry[i].flags |=
 			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 			++*nent;
 		}
 		break;
 	}
 	case 0xb: {
-		int index, level_type;
+		int i, level_type;
 
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		/* read more entries until level_type is zero */
-		for (index = 1; *nent < maxnent; ++index) {
-			level_type = entry[index - 1].ecx & 0xff;
+		for (i = 1; *nent < maxnent; ++i) {
+			level_type = entry[i - 1].ecx & 0xff;
 			if (!level_type)
 				break;
-			do_cpuid_1_ent(&entry[index], function, index);
-			entry[index].flags |=
+			do_cpuid_1_ent(&entry[i], function, i);
+			entry[i].flags |=
 			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 			++*nent;
 		}
@@ -1942,7 +1942,7 @@ void kvm_report_emulation_failure(struct kvm_vcpu *vcpu, const char *context)
 }
 EXPORT_SYMBOL_GPL(kvm_report_emulation_failure);
 
-struct x86_emulate_ops emulate_ops = {
+static struct x86_emulate_ops emulate_ops = {
 	.read_std            = emulator_read_std,
 	.read_emulated       = emulator_read_emulated,
 	.write_emulated      = emulator_write_emulated,
@@ -2875,7 +2875,7 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 static void get_segment(struct kvm_vcpu *vcpu,
 			struct kvm_segment *var, int seg)
 {
-	return kvm_x86_ops->get_segment(vcpu, var, seg);
+	kvm_x86_ops->get_segment(vcpu, var, seg);
 }
 
 void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
@@ -2941,7 +2941,7 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 static void set_segment(struct kvm_vcpu *vcpu,
 			struct kvm_segment *var, int seg)
 {
-	return kvm_x86_ops->set_segment(vcpu, var, seg);
+	kvm_x86_ops->set_segment(vcpu, var, seg);
 }
 
 int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
-- 
1.5.4.2.200.g99e75



