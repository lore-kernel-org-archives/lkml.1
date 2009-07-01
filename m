Return-Path: <linux-kernel-owner+w=401wt.eu-S932187AbZGAAtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbZGAAtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761338AbZGAAeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:15 -0400
Received: from kroah.org ([198.145.64.141]:60063 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761375AbZGAAeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:13 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:14 2009
Message-Id: <20090701002414.000432799@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:22:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 008/108] KVM: Prevent overflow in largepages calculation
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=kvm-prevent-overflow-in-largepages-calculation.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit 09f8ca74ae6c2d78b2c7f6c0751ed0cbe815a3d9 upstream.

If userspace specifies a memory slot that is larger than 8 petabytes, it
could overflow the largepages variable.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 virt/kvm/kvm_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -920,8 +920,7 @@ int __kvm_set_memory_region(struct kvm *
 	int r;
 	gfn_t base_gfn;
 	unsigned long npages, ugfn;
-	int largepages;
-	unsigned long i;
+	unsigned long largepages, i;
 	struct kvm_memory_slot *memslot;
 	struct kvm_memory_slot old, new;
 


