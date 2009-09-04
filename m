Return-Path: <linux-kernel-owner+w=401wt.eu-S934087AbZIDUTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087AbZIDUTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934038AbZIDUOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:30 -0400
Received: from kroah.org ([198.145.64.141]:36182 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934022AbZIDUO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:53 2009
Message-Id: <20090904200853.292609785@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, avi@redhat.com
Subject: [patch 20/48] KVM: MMU: increase per-vcpu rmap cache alloc size
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-increase-per-vcpu-rmap-cache-alloc-size.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit c41ef344de212bd918f7765af21b5008628c03e0)

The page fault path can use two rmap_desc structures, if:

- walk_addr's dirty pte update allocates one rmap_desc.
- mmu_lock is dropped, sptes are zapped resulting in rmap_desc being
  freed.
- fetch->mmu_set_spte allocates another rmap_desc.

Increase to 4 for safety.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -298,7 +298,7 @@ static int mmu_topup_memory_caches(struc
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache(&vcpu->arch.mmu_rmap_desc_cache,
-				   rmap_desc_cache, 1);
+				   rmap_desc_cache, 4);
 	if (r)
 		goto out;
 	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);


