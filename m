Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZHPJdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZHPJdg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbZHPJcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:32:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45362 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbZHPJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 22/48] KVM: powerpc: fix some init/exit annotations
Date: Sun, 16 Aug 2009 12:29:42 +0300
Message-Id: <1250415008-17175-23-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

Fixes a couple of warnings like this one:

WARNING: arch/powerpc/kvm/kvm-440.o(.text+0x1e8c): Section mismatch in reference from the function kvmppc_44x_exit() to the function .exit.text:kvmppc_booke_exit()
The function kvmppc_44x_exit() references a function in an exit section.
Often the function kvmppc_booke_exit() has valid usage outside the exit section
and the fix is to remove the __exit annotation of kvmppc_booke_exit.

Also add some __init annotations on obvious routines.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/44x.c   |    4 ++--
 arch/powerpc/kvm/booke.c |    2 +-
 arch/powerpc/kvm/e500.c  |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/44x.c b/arch/powerpc/kvm/44x.c
index 0cef809..f4d1b55 100644
--- a/arch/powerpc/kvm/44x.c
+++ b/arch/powerpc/kvm/44x.c
@@ -138,7 +138,7 @@ void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu)
 	kmem_cache_free(kvm_vcpu_cache, vcpu_44x);
 }
 
-static int kvmppc_44x_init(void)
+static int __init kvmppc_44x_init(void)
 {
 	int r;
 
@@ -149,7 +149,7 @@ static int kvmppc_44x_init(void)
 	return kvm_init(NULL, sizeof(struct kvmppc_vcpu_44x), THIS_MODULE);
 }
 
-static void kvmppc_44x_exit(void)
+static void __exit kvmppc_44x_exit(void)
 {
 	kvmppc_booke_exit();
 }
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 642e420..e7bf4d0 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -520,7 +520,7 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	return kvmppc_core_vcpu_translate(vcpu, tr);
 }
 
-int kvmppc_booke_init(void)
+int __init kvmppc_booke_init(void)
 {
 	unsigned long ivor[16];
 	unsigned long max_ivor = 0;
diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index d8067fd..674e796 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -132,7 +132,7 @@ void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu)
 	kmem_cache_free(kvm_vcpu_cache, vcpu_e500);
 }
 
-static int kvmppc_e500_init(void)
+static int __init kvmppc_e500_init(void)
 {
 	int r, i;
 	unsigned long ivor[3];
@@ -160,7 +160,7 @@ static int kvmppc_e500_init(void)
 	return kvm_init(NULL, sizeof(struct kvmppc_vcpu_e500), THIS_MODULE);
 }
 
-static void kvmppc_e500_exit(void)
+static void __init kvmppc_e500_exit(void)
 {
 	kvmppc_booke_exit();
 }
-- 
1.6.3.3

