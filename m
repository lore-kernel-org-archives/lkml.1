Return-Path: <linux-kernel-owner+w=401wt.eu-S934223AbZIDUV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223AbZIDUV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933942AbZIDUVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:21:55 -0400
Received: from kroah.org ([198.145.64.141]:36143 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933991AbZIDUOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:20 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:52 2009
Message-Id: <20090904200851.940224778@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 13/48] KVM: MMU: Fix setting the accessed bit on non-speculative sptes
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-fix-setting-the-accessed-bit-on-non-speculative-sptes.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@qumranet.com>

(cherry picked from commit 3201b5d9f0f7ef392886cd76dcd2c69186d9d5cd)

The accessed bit was accidentally turned on in a random flag word, rather
than, the spte itself, which was lucky, since it used the non-EPT compatible
PT_ACCESSED_MASK.

Fix by turning the bit on in the spte and changing it to use the portable
accessed mask.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1162,7 +1162,7 @@ static void mmu_set_spte(struct kvm_vcpu
 	 */
 	spte = shadow_base_present_pte | shadow_dirty_mask;
 	if (!speculative)
-		pte_access |= PT_ACCESSED_MASK;
+		spte |= shadow_accessed_mask;
 	if (!dirty)
 		pte_access &= ~ACC_WRITE_MASK;
 	if (pte_access & ACC_EXEC_MASK)


