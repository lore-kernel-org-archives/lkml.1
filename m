Return-Path: <linux-kernel-owner+w=401wt.eu-S934063AbZIDUOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063AbZIDUOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934051AbZIDUOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:33 -0400
Received: from kroah.org ([198.145.64.141]:36209 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934034AbZIDUOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:31 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:54 2009
Message-Id: <20090904200853.967007512@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 25/48] KVM: Make EFER reads safe when EFER does not exist
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-make-efer-reads-safe-when-efer-does-not-exist.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@redhat.com>

(cherry picked from commit e286e86e6d2042d67d09244aa0e05ffef75c9d54)

Some processors don't have EFER; don't oops if userspace wants us to
read EFER when we check NX.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -983,9 +983,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *
 
 static int is_efer_nx(void)
 {
-	u64 efer;
+	unsigned long long efer = 0;
 
-	rdmsrl(MSR_EFER, efer);
+	rdmsrl_safe(MSR_EFER, &efer);
 	return efer & EFER_NX;
 }
 


