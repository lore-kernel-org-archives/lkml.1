Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbYLAOHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbYLAOHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYLAOHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:07:33 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:58696 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbYLAOHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:07:32 -0500
X-BigFish: VPS-33(ze80iz1418M1432R98dR1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KB7B7X-03-K5U-01
Date: Mon, 1 Dec 2008 15:07:11 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       weidong.han@intel.com, mingo@redhat.com, avi@redhat.com,
       amit.shah@redhat.com
Subject: Re: [PATCH 3/9] add frontend implementation for the IOMMU API
Message-ID: <20081201140711.GA12816@amd.com>
References: <1227800454-9555-4-git-send-email-joerg.roedel@amd.com> <20081128184041N.fujita.tomonori@lab.ntt.co.jp> <20081128113129.GO1386@amd.com> <20081201173830B.fujita.tomonori@lab.ntt.co.jp> <20081201120026.GF17719@amd.com> <20081201130209.GA21615@il
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081201130209.GA21615@il.ibm.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 01 Dec 2008 14:07:12.0173 (UTC) FILETIME=[1B2F0DD0:01C953BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 03:02:09PM +0200, Muli Ben-Yehuda wrote:
> On Mon, Dec 01, 2008 at 01:00:26PM +0100, Joerg Roedel wrote:
> 
> > > > > The majority of the names (include/linux/iommu.h, iommu.c,
> > > > > iommu_ops, etc) looks too generic? We already have lots of
> > > > > similar things (e.g. arch/{x86,ia64}/asm/iommu.h, several
> > > > > archs' iommu.c, etc). Such names are expected to be used by
> > > > > all the IOMMUs.
> > > > 
> > > > The API is already useful for more than KVM. I also plan to
> > > > extend it to support more types of IOMMUs than VT-d and AMD
> > > > IOMMU in the future. But these changes are more intrusive than
> > > > this patchset and need more discussion. I prefer to do small
> > > > steps into this direction.
> > > 
> > > Can you be more specific? What IOMMU could use this? For example,
> > > how GART can use this? I think that people expect the name 'struct
> > > iommu_ops' to be an abstract for all the IOMMUs (or the majority
> > > at least). If this works like that, the name is a good choice, I
> > > think.
> > 
> > GART can't use exactly this. But with some extensions we can make it
> > useful for GART and GART-like IOMMUs too. For example we can emulate
> > domains in GART by partitioning the GART aperture space.
> 
> That would only work with a pvdma API, since GART doesn't support
> multiple address spaces, and you don't get the isolation properties of
> a real IOMMU, so... why would you want to do that?

Yes, this can not be used for not-pv device passthrough. But I think it
can speed up the pvdma case. Beside that I can be used for UIO and
devices which perform bad with sg.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

