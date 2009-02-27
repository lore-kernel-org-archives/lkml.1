Return-Path: <linux-kernel-owner+w=401wt.eu-S1762078AbZB0Kj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762078AbZB0Kj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbZB0K2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53574 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409AbZB0K1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:10 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 27/37] KVM: ia64: expose registers in struct kvm_regs
Date: Fri, 27 Feb 2009 12:26:50 +0200
Message-Id: <1235730420-7929-28-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jes Sorensen <jes@sgi.com>

Provide register layout for struct kvm_regs exposed to userland.

Signed-off-by: Jes Sorensen <jes@sgi.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm.h |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/kvm.h b/arch/ia64/include/asm/kvm.h
index b514578..0ee5bd7 100644
--- a/arch/ia64/include/asm/kvm.h
+++ b/arch/ia64/include/asm/kvm.h
@@ -166,7 +166,40 @@ struct saved_vpd {
 	unsigned long  vcpuid[5];
 	unsigned long  vpsr;
 	unsigned long  vpr;
-	unsigned long  vcr[128];
+	union {
+		unsigned long  vcr[128];
+		struct {
+			unsigned long dcr;
+			unsigned long itm;
+			unsigned long iva;
+			unsigned long rsv1[5];
+			unsigned long pta;
+			unsigned long rsv2[7];
+			unsigned long ipsr;
+			unsigned long isr;
+			unsigned long rsv3;
+			unsigned long iip;
+			unsigned long ifa;
+			unsigned long itir;
+			unsigned long iipa;
+			unsigned long ifs;
+			unsigned long iim;
+			unsigned long iha;
+			unsigned long rsv4[38];
+			unsigned long lid;
+			unsigned long ivr;
+			unsigned long tpr;
+			unsigned long eoi;
+			unsigned long irr[4];
+			unsigned long itv;
+			unsigned long pmv;
+			unsigned long cmcv;
+			unsigned long rsv5[5];
+			unsigned long lrr0;
+			unsigned long lrr1;
+			unsigned long rsv6[46];
+		};
+	};
 };
 
 struct kvm_regs {
-- 
1.6.0.6

