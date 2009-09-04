Return-Path: <linux-kernel-owner+w=401wt.eu-S934155AbZIDUSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155AbZIDUSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934049AbZIDUSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:18:31 -0400
Received: from kroah.org ([198.145.64.141]:36233 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934065AbZIDUOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:35 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:54 2009
Message-Id: <20090904200854.746551563@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Izik Eidus <ieidus@redhat.com>, avi@redhat.com
Subject: [patch 30/48] KVM: Fix dirty bit tracking for slots with large pages
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-fix-dirty-bit-tracking-for-slots-with-large-pages.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Izik Eidus <ieidus@redhat.com>

(cherry picked from commit e244584fe3a5c20deddeca246548ac86dbc6e1d1)

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
@@ -550,6 +550,8 @@ int __kvm_set_memory_region(struct kvm *
 		if (!new.dirty_bitmap)
 			goto out_free;
 		memset(new.dirty_bitmap, 0, dirty_bytes);
+		if (old.npages)
+			kvm_arch_flush_shadow(kvm);
 	}
 #endif /* not defined CONFIG_S390 */
 


