Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbZDWH5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbZDWH5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757381AbZDWHeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:34:23 -0400
Received: from sous-sol.org ([216.99.217.87]:51051 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757360AbZDWHeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:34:19 -0400
Message-Id: <20090423073023.859801030@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:49 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, chrisw@redhat.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com,
       Amit Shah <amit.shah@redhat.com>, Avi Kivity <avi@redhat.com>,
       Amit Shah <amit.shah@qumranet.com>, Avi Kivity <avi@qumranet.com>
Subject: [patch 089/100] KVM: is_long_mode() should check for EFER.LMA
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=kvm-is_long_mode-should-check-for-efer.lma.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Amit Shah <amit.shah@qumranet.com>

upstream commit: 41d6af119206e98764b4ae6d264d63acefcf851e

is_long_mode currently checks the LongModeEnable bit in
EFER instead of the LongModeActive bit. This is wrong, but
we survived this till now since it wasn't triggered. This
breaks guests that go from long mode to compatibility mode.

This is noticed on a solaris guest and fixes bug #1842160

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kvm/mmu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -54,7 +54,7 @@ static inline int kvm_mmu_reload(struct 
 static inline int is_long_mode(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
-	return vcpu->arch.shadow_efer & EFER_LME;
+	return vcpu->arch.shadow_efer & EFER_LMA;
 #else
 	return 0;
 #endif

