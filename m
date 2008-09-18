Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbYIRKN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbYIRKN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 06:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYIRKNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 06:13:51 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:62573 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYIRKNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 06:13:50 -0400
X-BigFish: VPS-39(zz1418M1432R98dR1805M179dR936fQ873fnzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K7DZ2R-03-DGF-01
Date: Thu, 18 Sep 2008 12:13:38 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: joro@8bytes.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/23] AMD IOMMU: implement lazy IO/TLB flushing
Message-ID: <20080918101338.GC24392@amd.com>
References: <1221670377-19295-4-git-send-email-joerg.roedel@amd.com> <20080918041104K.fujita.tomonori@lab.ntt.co.jp> <20080917192827.GA18515@8bytes.org> <20080918102931Z.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080918102931Z.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 18 Sep 2008 10:13:38.0155 (UTC) FILETIME=[379C1BB0:01C91977]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 10:29:24AM +0900, FUJITA Tomonori wrote:
> On Wed, 17 Sep 2008 21:28:27 +0200
> Joerg Roedel <joro@8bytes.org> wrote:
> 
> > On Thu, Sep 18, 2008 at 04:20:18AM +0900, FUJITA Tomonori wrote:
> > > On Wed, 17 Sep 2008 18:52:37 +0200
> > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > 
> > > > The IO/TLB flushing on every unmaping operation is the most expensive
> > > > part there and not strictly necessary. It is sufficient to do the flush
> > > > before any entries are reused. This is patch implements lazy IO/TLB
> > > > flushing which does exactly this.
> > > > 
> > > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > > ---
> > > >  Documentation/kernel-parameters.txt |    5 +++++
> > > >  arch/x86/kernel/amd_iommu.c         |   26 ++++++++++++++++++++++----
> > > >  arch/x86/kernel/amd_iommu_init.c    |   10 +++++++++-
> > > >  include/asm-x86/amd_iommu_types.h   |    9 +++++++++
> > > >  4 files changed, 45 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > > > index c2e00ee..5f0aefe 100644
> > > > --- a/Documentation/kernel-parameters.txt
> > > > +++ b/Documentation/kernel-parameters.txt
> > > > @@ -284,6 +284,11 @@ and is between 256 and 4096 characters. It is defined in the file
> > > >  			isolate - enable device isolation (each device, as far
> > > >  			          as possible, will get its own protection
> > > >  			          domain)
> > > > +			unmap_flush - enable flushing of IO/TLB entries when
> > > > +			              they are unmapped. Otherwise they are
> > > > +				      flushed before they will be reused, which
> > > > +				      is a lot of faster
> > > > +
> > > 
> > > Would it be nice to have consistency of IOMMU parameters?
> > 
> > True. We should merge common parameters across IOMMUs into the
> > iommu= parameter some time in the future, I think. It would also be the
> > place for the IOMMU size parameter.
> 
> Hmm, now is better than the future? I think that now you can add
> something like 'disable_batching_flush' as a common parameter and
> change AMD IOMMU to use it.

Ok, I introduce a parameter called '[no]fullflush' like the GART already uses.
We can remove this parameter from gart_parse_options() later then.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

