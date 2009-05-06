Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbZEFV5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbZEFV5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761417AbZEFVy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:28 -0400
Received: from kroah.org ([198.145.64.141]:56961 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761395AbZEFVyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:25 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:56 2009
Message-Id: <20090506214756.428397771@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Chris Wright <chrisw@redhat.com>
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
       alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
       Avi Kivity <avi@redhat.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 09/58] KVM: MMU: disable global page optimization
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-disable-global-page-optimization.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

upstream commit: bf47a760f66add7870fba33ab50f58b550d6bbd1

Complexity to fix it not worthwhile the gains, as discussed
in http://article.gmane.org/gmane.comp.emulators.kvm.devel/28649.
    
Cc: stable@kernel.org
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
[mtosatti: backport to 2.6.29]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 arch/x86/kvm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -797,7 +797,7 @@ static struct kvm_mmu_page *kvm_mmu_allo
 	ASSERT(is_empty_shadow_page(sp->spt));
 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	sp->multimapped = 0;
-	sp->global = 1;
+	sp->global = 0;
 	sp->parent_pte = parent_pte;
 	--vcpu->kvm->arch.n_free_mmu_pages;
 	return sp;


