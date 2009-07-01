Return-Path: <linux-kernel-owner+w=401wt.eu-S1763700AbZGAAuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763700AbZGAAuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760005AbZGAAeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:19 -0400
Received: from kroah.org ([198.145.64.141]:60085 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048AbZGAAeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:16 2009
Message-Id: <20090701002415.739953685@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Izik Eidus <ieidus@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 012/108] KVM: Fix dirty bit tracking for slots with large pages
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=kvm-fix-dirty-bit-tracking-for-slots-with-large-pages.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Izik Eidus <ieidus@redhat.com>

commit e244584fe3a5c20deddeca246548ac86dbc6e1d1 upstream.

When slot is already allocated and being asked to be tracked we need
to break the large pages.

This code flush the mmu when someone ask a slot to start dirty bit
tracking.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 virt/kvm/kvm_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1030,6 +1030,8 @@ int __kvm_set_memory_region(struct kvm *
 		if (!new.dirty_bitmap)
 			goto out_free;
 		memset(new.dirty_bitmap, 0, dirty_bytes);
+		if (old.npages)
+			kvm_arch_flush_shadow(kvm);
 	}
 #endif /* not defined CONFIG_S390 */
 


