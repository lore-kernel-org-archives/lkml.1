Return-Path: <linux-kernel-owner+w=401wt.eu-S933785AbZHWMDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785AbZHWMDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933541AbZHWMDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:03:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933536AbZHWL4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/46] KVM: Always report x2apic as supported feature
Date: Sun, 23 Aug 2009 14:56:17 +0300
Message-Id: <1251028605-31977-19-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

We emulate x2apic in software, so host support is not required.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e3d9040..dfb0e37 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1504,6 +1504,9 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	case 1:
 		entry->edx &= kvm_supported_word0_x86_features;
 		entry->ecx &= kvm_supported_word4_x86_features;
+		/* we support x2apic emulation even if host does not support
+		 * it since we emulate x2apic in software */
+		entry->ecx |= F(X2APIC);
 		break;
 	/* function 2 entries are STATEFUL. That is, repeated cpuid commands
 	 * may return different values. This forces us to get_cpu() before
-- 
1.6.4.1

