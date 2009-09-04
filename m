Return-Path: <linux-kernel-owner+w=401wt.eu-S934233AbZIDUWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934233AbZIDUWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933997AbZIDUV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:21:57 -0400
Received: from kroah.org ([198.145.64.141]:36132 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933953AbZIDUOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:51 2009
Message-Id: <20090904200851.493781097@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 10/48] KVM: Dont call get_user_pages(.force = 1)
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-don-t-call-get_user_pages.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@qumranet.com>

(cherry picked from commit d657c7335b97d746aa6123c56504b46c20e37df3)

This is esoteric and only needed to break COW on MAP_SHARED mappings.  Since
KVM no longer does these sorts of mappings, breaking COW on them is no longer
necessary.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -726,7 +726,7 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t 
 		return page_to_pfn(bad_page);
 	}
 
-	npages = get_user_pages(current, current->mm, addr, 1, 1, 1, page,
+	npages = get_user_pages(current, current->mm, addr, 1, 1, 0, page,
 				NULL);
 
 	if (unlikely(npages != 1)) {


