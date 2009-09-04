Return-Path: <linux-kernel-owner+w=401wt.eu-S934219AbZIDUUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934219AbZIDUUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934008AbZIDUOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:24 -0400
Received: from kroah.org ([198.145.64.141]:36140 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933990AbZIDUOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:51 2009
Message-Id: <20090904200851.795978998@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 12/48] KVM: MMU: Flush tlbs after clearing write permission when accessing dirty log
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-mmu-flush-tlbs-after-clearing-write-permission-when-accessing-dirty-log.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@qumranet.com>

(cherry picked from commit 171d595d3b3254b9a952af8d1f6965d2e85dcbaa)

Otherwise, the cpu may allow writes to the tracked pages, and we lose
some display bits or fail to migrate correctly.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2069,6 +2069,7 @@ void kvm_mmu_slot_remove_write_access(st
 			if (pt[i] & PT_WRITABLE_MASK)
 				pt[i] &= ~PT_WRITABLE_MASK;
 	}
+	kvm_flush_remote_tlbs(kvm);
 	spin_unlock(&kvm->mmu_lock);
 }
 


