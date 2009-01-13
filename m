Return-Path: <linux-kernel-owner+w=401wt.eu-S1760193AbZAMBgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbZAMBgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758249AbZAMB3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:29:17 -0500
Received: from kroah.org ([198.145.64.141]:36125 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757403AbZAMB3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:29:12 -0500
Date: Mon, 12 Jan 2009 17:27:34 -0800
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
Subject: [patch 20/21] AMD IOMMU: initialize phys_addr correctly in
	iommu_page_map
Message-ID: <20090113012734.GU4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="amd-iommu-initialize-phys_addr-correctly-in-iommu_page_map.patch"
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

Upstream commit bb9d4ff80bc032d7961815c2ff5eaf458ae3adff

Due to this bug mappings for devices requested by the ACPI table are
incorrect.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -235,7 +235,7 @@ static int iommu_map(struct protection_d
 	u64 __pte, *pte, *page;
 
 	bus_addr  = PAGE_ALIGN(bus_addr);
-	phys_addr = PAGE_ALIGN(bus_addr);
+	phys_addr = PAGE_ALIGN(phys_addr);
 
 	/* only support 512GB address spaces for now */
 	if (bus_addr > IOMMU_MAP_SIZE_L3 || !(prot & IOMMU_PROT_MASK))

