Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYK1LcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYK1LcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 06:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbYK1LcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 06:32:03 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:2675 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYK1LcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 06:32:00 -0500
X-BigFish: VPS-32(ze80iz1432R98dR1805M179dR936fO873fnzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KB1K0Y-03-E69-01
Date: Fri, 28 Nov 2008 12:31:29 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, weidong.han@intel.com,
       mingo@redhat.com, avi@redhat.com, amit.shah@redhat.com
Subject: Re: [PATCH 3/9] add frontend implementation for the IOMMU API
Message-ID: <20081128113129.GO1386@amd.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com> <1227800454-9555-4-git-send-email-joerg.roedel@amd.com> <20081128184041N.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081128184041N.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 28 Nov 2008 11:31:29.0332 (UTC) FILETIME=[DB2D6740:01C9514C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2008 at 06:40:41PM +0900, FUJITA Tomonori wrote:
> On Thu, 27 Nov 2008 16:40:48 +0100
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  drivers/base/iommu.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 94 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/base/iommu.c
> > 
> > diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
> > new file mode 100644
> > index 0000000..7250b9c
> > --- /dev/null
> > +++ b/drivers/base/iommu.c
> 
> Hmm, why is this at drivers/base/? Anyone except for kvm could use
> this? If so, under virt/ is more appropriate?

I don't see a reason why this should be KVM specific. KVM is the only
user for now. But it can be used for i.e. UIO too. Or in drivers to
speed up devices which have bad performance when they do scather gather
IO.

> The majority of the names (include/linux/iommu.h, iommu.c, iommu_ops,
> etc) looks too generic? We already have lots of similar things
> (e.g. arch/{x86,ia64}/asm/iommu.h, several archs' iommu.c, etc). Such
> names are expected to be used by all the IOMMUs.

The API is already useful for more than KVM. I also plan to extend it to
support more types of IOMMUs than VT-d and AMD IOMMU in the future. But
these changes are more intrusive than this patchset and need more
discussion. I prefer to do small steps into this direction.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

