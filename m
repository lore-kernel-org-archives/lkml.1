Return-Path: <linux-kernel-owner+w=401wt.eu-S934144AbZIDUTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144AbZIDUTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934061AbZIDUTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:19:32 -0400
Received: from kroah.org ([198.145.64.141]:36207 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934024AbZIDUOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:53 2009
Message-Id: <20090904200853.830967661@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 24/48] KVM: SVM: Remove port 80 passthrough
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-svm-remove-port-80-passthrough.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@redhat.com>

(cherry picked from commit 99f85a28a78e96d28907fe036e1671a218fee597)

KVM optimizes guest port 80 accesses by passthing them through to the host.
Some AMD machines die on port 80 writes, allowing the guest to hard-lock the
host.

Remove the port passthrough to avoid the problem.

Reported-by: Piotr Jaroszyński <p.jaroszynski@gmail.com>
Tested-by: Piotr Jaroszyński <p.jaroszynski@gmail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/svm.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -429,7 +429,6 @@ static __init int svm_hardware_setup(voi
 
 	iopm_va = page_address(iopm_pages);
 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << IOPM_ALLOC_ORDER));
-	clear_bit(0x80, iopm_va); /* allow direct access to PC debug port */
 	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
 
 	if (boot_cpu_has(X86_FEATURE_NX))


