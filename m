Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbYLOL3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbYLOL3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 06:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYLOL32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 06:29:28 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:37989 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYLOL31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 06:29:27 -0500
X-BigFish: VPS-37(zba6iz1432R98dR936eQ1805M936fOzzzzz32i6bh34h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBX18U-03-A26-01
Date: Mon, 15 Dec 2008 12:29:18 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Mike Day <ncmike@ncultra.org>, Avi Kivity <avi@redhat.com>,
       mingo@redhat.com, weidong.han@intel.com, torvalds@linux-foundation.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCHSETS #2] KVM device passthrough support with AMD IOMMU
Message-ID: <20081215112918.GD3407@amd.com>
References: <20081209141143.GW12816@amd.com> <493F8D90.40205@redhat.com> <20081210141131.GB12816@amd.com> <1228918928.21454.27.camel@macbook.infradead.org> <20081210142525.GC12816@amd.com> <1228933475.23842.70.camel@macbook.infradead.org> <20081210184240.GH12816@amd.com> <1228934903.23842.75.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <1228934903.23842.75.camel@macbook.infradead.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 15 Dec 2008 11:29:18.0491 (UTC) FILETIME=[5E3666B0:01C95EA8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Dec 10, 2008 at 06:48:23PM +0000, David Woodhouse wrote:
> On Wed, 2008-12-10 at 19:42 +0100, Joerg Roedel wrote:
> > Ok, I add it, thanks. Who is the author, Mike or you?
> 
> Might as well attribute it to Mike; he spotted it.

Ok, here is what I applied, fyi.

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="mike.patch"

commit 8876830866c8c9e4471a578a4e474eeef80e98dd
Author: Mike Day <ncmike@ncultra.org>
Date:   Fri Dec 12 17:16:30 2008 +0100

    intel-iommu: fix bit shift at DOMAIN_FLAG_P2P_MULTIPLE_DEVICES
    
    Signed-off-by: Mike Day <ncmike@ncultra.org>
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 772fb22..f39af75 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -204,7 +204,7 @@ static inline bool dma_pte_present(struct dma_pte *pte)
 }
 
 /* devices under the same p2p bridge are owned in one domain */
-#define DOMAIN_FLAG_P2P_MULTIPLE_DEVICES (1 < 0)
+#define DOMAIN_FLAG_P2P_MULTIPLE_DEVICES (1 << 0)
 
 /* domain represents a virtual machine, more than one devices
  * across iommus may be owned in one domain, e.g. kvm guest.

--1yeeQ81UyVL57Vl7--
