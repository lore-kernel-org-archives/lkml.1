Return-Path: <linux-kernel-owner+w=401wt.eu-S934173AbZIDUVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934173AbZIDUVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933998AbZIDUOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:21 -0400
Received: from kroah.org ([198.145.64.141]:36130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933942AbZIDUOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:51 2009
Message-Id: <20090904200851.340681047@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 09/48] KVM: Allocate guest memory as MAP_PRIVATE, not MAP_SHARED
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-allocate-guest-memory-as-map_private-not-map_shared.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@qumranet.com>

(cherry picked from commit acee3c04e8208c17aad1baff99baa68d71640a19)

There is no reason to share internal memory slots with fork()ed instances.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4003,7 +4003,7 @@ int kvm_arch_set_memory_region(struct kv
 			userspace_addr = do_mmap(NULL, 0,
 						 npages * PAGE_SIZE,
 						 PROT_READ | PROT_WRITE,
-						 MAP_SHARED | MAP_ANONYMOUS,
+						 MAP_PRIVATE | MAP_ANONYMOUS,
 						 0);
 			up_write(&current->mm->mmap_sem);
 


