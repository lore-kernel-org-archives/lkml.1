Return-Path: <linux-kernel-owner+w=401wt.eu-S934697AbZIEA2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934697AbZIEA2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934642AbZIEAVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:13 -0400
Received: from kroah.org ([198.145.64.141]:42149 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934610AbZIEAUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:51 2009
Message-Id: <20090905001451.752437785@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 28/71] KVM: Fix cpuid feature misreporting
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=kvm-fix-cpuid-feature-misreporting.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@redhat.com>

(cherry picked from commit 8d753f369bd28fff1706ffe9fb9fea4fd88cf85b)

MTRR, PAT, MCE, and MCA are all supported (to some extent) but not reported.
Vista requires these features, so if userspace relies on kernel cpuid
reporting, it loses support for Vista.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1256,9 +1256,12 @@ static void do_cpuid_ent(struct kvm_cpui
 		bit(X86_FEATURE_VME) | bit(X86_FEATURE_DE) |
 		bit(X86_FEATURE_PSE) | bit(X86_FEATURE_TSC) |
 		bit(X86_FEATURE_MSR) | bit(X86_FEATURE_PAE) |
+		bit(X86_FEATURE_MCE) |
 		bit(X86_FEATURE_CX8) | bit(X86_FEATURE_APIC) |
-		bit(X86_FEATURE_SEP) | bit(X86_FEATURE_PGE) |
-		bit(X86_FEATURE_CMOV) | bit(X86_FEATURE_PSE36) |
+		bit(X86_FEATURE_SEP) | bit(X86_FEATURE_MTRR) |
+		bit(X86_FEATURE_PGE) | bit(X86_FEATURE_MCA) |
+		bit(X86_FEATURE_CMOV) | bit(X86_FEATURE_PAT) |
+		bit(X86_FEATURE_PSE36) |
 		bit(X86_FEATURE_CLFLSH) | bit(X86_FEATURE_MMX) |
 		bit(X86_FEATURE_FXSR) | bit(X86_FEATURE_XMM) |
 		bit(X86_FEATURE_XMM2) | bit(X86_FEATURE_SELFSNOOP);


