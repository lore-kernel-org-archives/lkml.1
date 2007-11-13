Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbXKMWu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbXKMWu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759507AbXKMWut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:50:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:39836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759542AbXKMWus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:50:48 -0500
Subject: patch xen-fix-register_vcpu_info.patch queued to -stable tree
To: jeremy@goop.org, ak@muc.de, akpm@linux-foundation.org, chrisw@sous-sol.org,
       gregkh@suse.de, jeremy@xensource.com, keir@xensource.com,
       linux-kernel@vger.kernel.org, mark.williamson@cl.cam.ac.uk,
       stable@kernel.org, xen-users@morten.bogeskov.dk
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Tue, 13 Nov 2007 14:50:31 -0800
In-Reply-To: <20071012211148.610399000@goop.org>
Message-Id: <20071113225043.691F014543E5@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: xen: fix incorrect vcpu_register_vcpu_info hypercall argument

to the 2.6.23-stable tree.  Its filename is

     xen-fix-register_vcpu_info.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Fri Oct 12 14:33:49 2007
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Fri, 12 Oct 2007 14:11:40 -0700
Subject: xen: fix incorrect vcpu_register_vcpu_info hypercall argument
To: LKML <linux-kernel@vger.kernel.org>
Cc: xen-devel@lists.xensource.com, virtualization@lists.osdl.org, Mark Williamson <mark.williamson@cl.cam.ac.uk>, Morten Bøgeskov <xen-users@morten.bogeskov.dk>, Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>, Keir Fraser <keir@xensource.com>, Stable Kernel <stable@kernel.org>
Message-ID: <20071012211148.610399000@goop.org>
Content-Disposition: inline; filename=xen-fix-register_vcpu_info.patch

From: Jeremy Fitzhardinge <jeremy@goop.org>

patch e3d2697669abbe26c08dc9b95e2a71c634d096ed in mainline.

The kernel's copy of struct vcpu_register_vcpu_info was out of date,
at best causing the hypercall to fail and the guest kernel to fall
back to the old mechanism, or worse, causing random memory corruption.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Stable Kernel <stable@kernel.org>
Cc: Morten =?utf-8?q?B=C3=B8geskov?= <xen-users@morten.bogeskov.dk>
Cc: Mark Williamson <mark.williamson@cl.cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/xen/enlighten.c    |    2 +-
 include/xen/interface/vcpu.h |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -116,7 +116,7 @@ static void __init xen_vcpu_setup(int cp
 	info.mfn = virt_to_mfn(vcpup);
 	info.offset = offset_in_page(vcpup);
 
-	printk(KERN_DEBUG "trying to map vcpu_info %d at %p, mfn %x, offset %d\n",
+	printk(KERN_DEBUG "trying to map vcpu_info %d at %p, mfn %llx, offset %d\n",
 	       cpu, vcpup, info.mfn, info.offset);
 
 	/* Check to see if the hypervisor will put the vcpu_info
--- a/include/xen/interface/vcpu.h
+++ b/include/xen/interface/vcpu.h
@@ -160,8 +160,9 @@ struct vcpu_set_singleshot_timer {
  */
 #define VCPUOP_register_vcpu_info   10  /* arg == struct vcpu_info */
 struct vcpu_register_vcpu_info {
-    uint32_t mfn;               /* mfn of page to place vcpu_info */
-    uint32_t offset;            /* offset within page */
+    uint64_t mfn;    /* mfn of page to place vcpu_info */
+    uint32_t offset; /* offset within page */
+    uint32_t rsvd;   /* unused */
 };
 
 #endif /* __XEN_PUBLIC_VCPU_H__ */


Patches currently in stable-queue which might be from jeremy@goop.org are

queue-2.6.23/xen-handle-lazy-cr3-on-unpin.patch
queue-2.6.23/xen-multicall-callbacks.patch
queue-2.6.23/xen-fix-register_vcpu_info.patch
queue-2.6.23/xen-xfs-unmap.patch
