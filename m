Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab0BDRaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:30:25 -0500
Received: from kroah.org ([198.145.64.141]:34801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933292Ab0BDRWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:06 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:12 2010
Message-Id: <20100204171512.113418072@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [42/74] x86/amd-iommu: Fix possible integer overflow
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit d91afd15b041f27d34859c79afa9e172018a86f4 upstream.

The variable i in this function could be increased to over
2**32 which would result in an integer overflow when using
int. Fix it by changing i to unsigned long.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -540,7 +540,7 @@ static void flush_all_devices_for_iommu(
 static void flush_devices_by_domain(struct protection_domain *domain)
 {
 	struct amd_iommu *iommu;
-	int i;
+	unsigned long i;
 
 	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
 		if ((domain == NULL && amd_iommu_pd_table[i] == NULL) ||


