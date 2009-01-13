Return-Path: <linux-kernel-owner+w=401wt.eu-S1759046AbZAMBgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbZAMBgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757665AbZAMB3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:29:16 -0500
Received: from kroah.org ([198.145.64.141]:36111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758220AbZAMB3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:29:11 -0500
Date: Mon, 12 Jan 2009 17:27:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>
Subject: [patch 19/21] AMD IOMMU: allocate rlookup_table with __GFP_ZERO
Message-ID: <20090113012731.GT4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="amd-iommu-allocate-rlookup_table-with-__gfp_zero.patch"
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

Upstream commit 83fd5cc6481c6b7fa8b45f8a7e0aa7120213430b

This is pointer list and if we dereference an uninitialized pointer
later this results in a kernel crash at boot. Happens typically after
3-5 hours of rebooting.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu_init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -930,7 +930,8 @@ int __init amd_iommu_init(void)
 		goto free;
 
 	/* IOMMU rlookup table - find the IOMMU for a specific device */
-	amd_iommu_rlookup_table = (void *)__get_free_pages(GFP_KERNEL,
+	amd_iommu_rlookup_table = (void *)__get_free_pages(
+			GFP_KERNEL | __GFP_ZERO,
 			get_order(rlookup_table_size));
 	if (amd_iommu_rlookup_table == NULL)
 		goto free;

