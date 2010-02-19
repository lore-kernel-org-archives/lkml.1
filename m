Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0BSRHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:07:06 -0500
Received: from kroah.org ([198.145.64.141]:57758 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988Ab0BSRBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:04 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:50 2010
Message-Id: <20100219163250.719595978@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [72/93] x86/amd-iommu: Fix deassignment of a device from the pt_domain
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Joerg Roedel <joerg.roedel@amd.com>

commit d3ad9373b7c29b63d5e8460a69453718d200cc3b upstream.

Deassigning a device from the passthrough domain does not
work and breaks device assignment to kvm guests. This patch
fixes the issue.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1230,9 +1230,10 @@ static void __detach_device(struct prote
 
 	/*
 	 * If we run in passthrough mode the device must be assigned to the
-	 * passthrough domain if it is detached from any other domain
+	 * passthrough domain if it is detached from any other domain.
+	 * Make sure we can deassign from the pt_domain itself.
 	 */
-	if (iommu_pass_through) {
+	if (iommu_pass_through && domain != pt_domain) {
 		struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
 		__attach_device(iommu, pt_domain, devid);
 	}


