Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYLAMAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYLAMAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYLAMAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:00:41 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:24097 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYLAMAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:00:40 -0500
X-BigFish: VPS-37(ze80iz1418M1432R98dR1805M179dR936fO873fnzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KB75CQ-03-EQR-01
Date: Mon, 1 Dec 2008 13:00:26 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, weidong.han@intel.com,
       mingo@redhat.com, avi@redhat.com, amit.shah@redhat.com
Subject: Re: [PATCH 3/9] add frontend implementation for the IOMMU API
Message-ID: <20081201120026.GF17719@amd.com>
References: <1227800454-9555-4-git-send-email-joerg.roedel@amd.com> <20081128184041N.fujita.tomonori@lab.ntt.co.jp> <20081128113129.GO1386@amd.com> <20081201173830B.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081201173830B.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 01 Dec 2008 12:00:26.0921 (UTC) FILETIME=[6619B190:01C953AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 05:38:11PM +0900, FUJITA Tomonori wrote:
> On Fri, 28 Nov 2008 12:31:29 +0100
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Fri, Nov 28, 2008 at 06:40:41PM +0900, FUJITA Tomonori wrote:
> > > On Thu, 27 Nov 2008 16:40:48 +0100
> > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > 
> > > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > > ---
> > > >  drivers/base/iommu.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  1 files changed, 94 insertions(+), 0 deletions(-)
> > > >  create mode 100644 drivers/base/iommu.c
> > > > 
> > > > diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
> > > > new file mode 100644
> > > > index 0000000..7250b9c
> > > > --- /dev/null
> > > > +++ b/drivers/base/iommu.c
> > > 
> > > Hmm, why is this at drivers/base/? Anyone except for kvm could use
> > > this? If so, under virt/ is more appropriate?
> > 
> > I don't see a reason why this should be KVM specific. KVM is the only
> > user for now. But it can be used for i.e. UIO too. Or in drivers to
> > speed up devices which have bad performance when they do scather gather
> > IO.
> 
> If there are some except for kvm that could use this, it should be
> fine, I guess.
> 
> Can you add such information (e.g. who could use this) to the patch
> description? It should be in the git log if the patch is merged.

Ok, I will add it.

> > > The majority of the names (include/linux/iommu.h, iommu.c, iommu_ops,
> > > etc) looks too generic? We already have lots of similar things
> > > (e.g. arch/{x86,ia64}/asm/iommu.h, several archs' iommu.c, etc). Such
> > > names are expected to be used by all the IOMMUs.
> > 
> > The API is already useful for more than KVM. I also plan to extend it to
> > support more types of IOMMUs than VT-d and AMD IOMMU in the future. But
> > these changes are more intrusive than this patchset and need more
> > discussion. I prefer to do small steps into this direction.
> 
> Can you be more specific? What IOMMU could use this? For example, how
> GART can use this? I think that people expect the name 'struct
> iommu_ops' to be an abstract for all the IOMMUs (or the majority at
> least). If this works like that, the name is a good choice, I think.

GART can't use exactly this. But with some extensions we can make it
useful for GART and GART-like IOMMUs too. For example we can emulate
domains in GART by partitioning the GART aperture space.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

