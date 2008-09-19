Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbYISLyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbYISLyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 07:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbYISLyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 07:54:12 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:26587 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbYISLyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 07:54:11 -0400
X-BigFish: VPS-50(z21eW5edJz1432R98dR936eQ1805M936fQ873fnzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K7FYE2-03-FOO-01
Date: Fri, 19 Sep 2008 13:52:59 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28
Message-ID: <20080919115259.GL24392@amd.com>
References: <20080919195042S.fujita.tomonori@lab.ntt.co.jp> <20080919110240.GJ24392@amd.com> <20080919202344V.fujita.tomonori@lab.ntt.co.jp> <20080919204738G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080919204738G.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Sep 2008 11:52:59.0880 (UTC) FILETIME=[437CE680:01C91A4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 08:47:54PM +0900, FUJITA Tomonori wrote:
> On Fri, 19 Sep 2008 20:23:50 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Fri, 19 Sep 2008 13:02:40 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > On Fri, Sep 19, 2008 at 07:51:11PM +0900, FUJITA Tomonori wrote:
> > > > On Fri, 19 Sep 2008 12:39:23 +0200
> > > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > > 
> > > > > On Fri, Sep 19, 2008 at 07:28:13PM +0900, FUJITA Tomonori wrote:
> > > > > > On Fri, 19 Sep 2008 12:07:11 +0200
> > > > > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > > > > 
> > > > > > > Hi Ingo,
> > > > > > > 
> > > > > > > please pull the updates for the AMD IOMMU driver for the 2.6.28 merge
> > > > > > > window. Most of the patches had been sent to LKML for review and got
> > > > > > > comments. One patch touches the GART driver and was added after an
> > > > > > > objection with a patch previously in this series. Please pull.
> > > > > > > 
> > > > > > > The following changes since commit 74546a8cd9a4e2c26a15a534f0be2f9cc08ae675:
> > > > > > >   Ingo Molnar (1):
> > > > > > >         Revert "fix warning in: "x86: HPET_MSI Initialise per-cpu HPET timers""
> > > > > > > 
> > > > > > > are available in the git repository at:
> > > > > > > 
> > > > > > >   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-updates-2.6.28
> > > > > > > 
> > > > > > > FUJITA Tomonori (1):
> > > > > > >       AMD IOMMU: avoid unnecessary low zone allocation in alloc_coherent
> > > > > > > 
> > > > > > > Joerg Roedel (24):
> > > > > > >       AMD IOMMU: check for invalid device pointers
> > > > > > >       AMD IOMMU: move TLB flushing to the map/unmap helper functions
> > > > > > >       x86: move GART TLB flushing options to generic code
> > > > > > 
> > > > > > As I wrote, I don't think that this GART patch is the right approach.
> > > > > 
> > > > > I don't thinks its clean to leave nofullflush in GART code and move
> > > > > fullflush to generic code only.
> > > > 
> > > > It's not clean for GART but clean for other IOMMUs.
> > > 
> > > So its unclean anyway. It doesn't matter if for GART or for AMD IOMMU.
> > > 
> > > > > If we move something then both. But feel
> > > > > free to submit a patch that removes the nofullflush option. I would not
> > > > > disagree with that.
> > > > 
> > > > I'm not sure we can remove an option that we added. If we can, please
> > > > remove it now. There is no point to make the meaningless option
> > > > generic.
> > > 
> > > I don't added this option. I just moved it to generic code from the
> > 
> > You added it to the generic place. Moving it to the generic place
> > means adding it to the generic place.
> > 
> > There is no difference in the end. Now 'nofullflush' is listed as the
> > generic place.
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index c2e00ee..569527e 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -888,6 +888,10 @@ and is between 256 and 4096 characters. It is defined in the file
> >  		nomerge
> >  		forcesac
> >  		soft
> > +		fullflush
> > +			Flush IO/TLB at every deallocation
> > +		nofullflush
> > +			Flush IO/TLB only when addresses are reused (default)
> 
> And you don't need to add 'fullflush' to the generic place too.
> 
> 'fullflush' will be supported with only GART and AMD IOMMU. So adding
> the description of it to both GART and AMD IOMMU should be fine.
> 
> 'fullflush' has the same meaning for both IOMMUs. That's nice
> consistency, I think.

Huh? The whole point of this patch was to have a common option between
IOMMUs to disable lazy IOTLB flushing. This was suggested by _you_ and
the only reason I wrote this patch.
After this patch we can change other IOMMU implementations with lazy
flushing to use that parameter too.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

