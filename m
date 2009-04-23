Return-Path: <linux-kernel-owner+w=401wt.eu-S1760085AbZDWH4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085AbZDWH4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757216AbZDWHeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:34:17 -0400
Received: from sous-sol.org ([216.99.217.87]:51046 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756669AbZDWHeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:34:15 -0400
Message-Id: <20090423073012.859243905@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:47 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, chrisw@redhat.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com,
       Weidong Han <weidong.han@intel.com>, Avi Kivity <avi@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: [patch 087/100] KVM: fix kvm_vm_ioctl_deassign_device
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=kvm-fix-kvm_vm_ioctl_deassign_device.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Weidong Han <weidong.han@intel.com>

upstream commit: 4a906e49f103c2e544148a209ba1db316510799f

only need to set assigned_dev_id for deassignment, use
match->flags to judge and deassign it.

Acked-by: Mark McLoughlin <markmc@redhat.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -563,7 +563,7 @@ static int kvm_vm_ioctl_deassign_device(
 		goto out;
 	}
 
-	if (assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU)
+	if (match->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU)
 		kvm_deassign_device(kvm, match);
 
 	kvm_free_assigned_device(kvm, match);

