Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbYISLsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbYISLsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 07:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYISLsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 07:48:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:41991 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbYISLsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 07:48:16 -0400
Date: Fri, 19 Sep 2008 20:47:54 +0900
To: fujita.tomonori@lab.ntt.co.jp
Cc: joerg.roedel@amd.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080919202344V.fujita.tomonori@lab.ntt.co.jp>
References: <20080919195042S.fujita.tomonori@lab.ntt.co.jp>
	<20080919110240.GJ24392@amd.com>
	<20080919202344V.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080919204738G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 20:23:50 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Fri, 19 Sep 2008 13:02:40 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Fri, Sep 19, 2008 at 07:51:11PM +0900, FUJITA Tomonori wrote:
> > > On Fri, 19 Sep 2008 12:39:23 +0200
> > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > 
> > > > On Fri, Sep 19, 2008 at 07:28:13PM +0900, FUJITA Tomonori wrote:
> > > > > On Fri, 19 Sep 2008 12:07:11 +0200
> > > > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > > > 
> > > > > > Hi Ingo,
> > > > > > 
> > > > > > please pull the updates for the AMD IOMMU driver for the 2.6.28 merge
> > > > > > window. Most of the patches had been sent to LKML for review and got
> > > > > > comments. One patch touches the GART driver and was added after an
> > > > > > objection with a patch previously in this series. Please pull.
> > > > > > 
> > > > > > The following changes since commit 74546a8cd9a4e2c26a15a534f0be2f9cc08ae675:
> > > > > >   Ingo Molnar (1):
> > > > > >         Revert "fix warning in: "x86: HPET_MSI Initialise per-cpu HPET timers""
> > > > > > 
> > > > > > are available in the git repository at:
> > > > > > 
> > > > > >   git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-updates-2.6.28
> > > > > > 
> > > > > > FUJITA Tomonori (1):
> > > > > >       AMD IOMMU: avoid unnecessary low zone allocation in alloc_coherent
> > > > > > 
> > > > > > Joerg Roedel (24):
> > > > > >       AMD IOMMU: check for invalid device pointers
> > > > > >       AMD IOMMU: move TLB flushing to the map/unmap helper functions
> > > > > >       x86: move GART TLB flushing options to generic code
> > > > > 
> > > > > As I wrote, I don't think that this GART patch is the right approach.
> > > > 
> > > > I don't thinks its clean to leave nofullflush in GART code and move
> > > > fullflush to generic code only.
> > > 
> > > It's not clean for GART but clean for other IOMMUs.
> > 
> > So its unclean anyway. It doesn't matter if for GART or for AMD IOMMU.
> > 
> > > > If we move something then both. But feel
> > > > free to submit a patch that removes the nofullflush option. I would not
> > > > disagree with that.
> > > 
> > > I'm not sure we can remove an option that we added. If we can, please
> > > remove it now. There is no point to make the meaningless option
> > > generic.
> > 
> > I don't added this option. I just moved it to generic code from the
> 
> You added it to the generic place. Moving it to the generic place
> means adding it to the generic place.
> 
> There is no difference in the end. Now 'nofullflush' is listed as the
> generic place.
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index c2e00ee..569527e 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -888,6 +888,10 @@ and is between 256 and 4096 characters. It is defined in the file
>  		nomerge
>  		forcesac
>  		soft
> +		fullflush
> +			Flush IO/TLB at every deallocation
> +		nofullflush
> +			Flush IO/TLB only when addresses are reused (default)

And you don't need to add 'fullflush' to the generic place too.

'fullflush' will be supported with only GART and AMD IOMMU. So adding
the description of it to both GART and AMD IOMMU should be fine.

'fullflush' has the same meaning for both IOMMUs. That's nice
consistency, I think.


