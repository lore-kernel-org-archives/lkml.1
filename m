Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253Ab0AZXri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab0AZXri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174Ab0AZXr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:47:28 -0500
Received: from kroah.org ([198.145.64.141]:35542 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab0AZXoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:22 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:32 2010
Message-Id: <20100126233932.746221280@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [90/98] KVM: x86: Fix host_mapping_level()
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sheng Yang <sheng@linux.intel.com>

commit 82b7005f0e72d8d1a8226e4c192cbb0850d10b3f upstream.

When found a error hva, should not return PAGE_SIZE but the level...

Also clean up the coding style of the following loop.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/mmu.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -477,7 +477,7 @@ static int host_mapping_level(struct kvm
 
 	addr = gfn_to_hva(kvm, gfn);
 	if (kvm_is_error_hva(addr))
-		return page_size;
+		return PT_PAGE_TABLE_LEVEL;
 
 	down_read(&current->mm->mmap_sem);
 	vma = find_vma(current->mm, addr);
@@ -515,11 +515,9 @@ static int mapping_level(struct kvm_vcpu
 	if (host_level == PT_PAGE_TABLE_LEVEL)
 		return host_level;
 
-	for (level = PT_DIRECTORY_LEVEL; level <= host_level; ++level) {
-
+	for (level = PT_DIRECTORY_LEVEL; level <= host_level; ++level)
 		if (has_wrprotected_page(vcpu->kvm, large_gfn, level))
 			break;
-	}
 
 	return level - 1;
 }


