Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbYLIUh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbYLIUh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbYLIUYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34865 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbYLIUXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:10 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nitin A Kamble <nitin.a.kamble@intel.com>
Subject: [PATCH 07/44] KVM: Fix cpuid leaf 0xb loop termination
Date: Tue,  9 Dec 2008 22:22:22 +0200
Message-Id: <1228854179-23002-8-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin A Kamble <nitin.a.kamble@intel.com>

For cpuid leaf 0xb the bits 8-15 in ECX register define the end of counting
leaf.      The previous code was using bits 0-7 for this purpose, which is
a bug.

Signed-off-by: Nitin A Kamble <nitin.a.kamble@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a4a39c..2889a0f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1276,7 +1276,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		/* read more entries until level_type is zero */
 		for (i = 1; *nent < maxnent; ++i) {
-			level_type = entry[i - 1].ecx & 0xff;
+			level_type = entry[i - 1].ecx & 0xff00;
 			if (!level_type)
 				break;
 			do_cpuid_1_ent(&entry[i], function, i);
-- 
1.6.0.3

