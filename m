Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYISNCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYISNCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 09:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbYISNCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 09:02:04 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:58453 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbYISNCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 09:02:02 -0400
Date: Fri, 19 Sep 2008 22:01:35 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080919123426.GN24392@amd.com>
References: <20080919115259.GL24392@amd.com>
	<20080919212327Y.fujita.tomonori@lab.ntt.co.jp>
	<20080919123426.GN24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080919220126C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 14:34:26 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Fri, Sep 19, 2008 at 09:24:18PM +0900, FUJITA Tomonori wrote:
> > On Fri, 19 Sep 2008 13:52:59 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > On Fri, Sep 19, 2008 at 08:47:54PM +0900, FUJITA Tomonori wrote:
> > > > On Fri, 19 Sep 2008 20:23:50 +0900
> > > > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > > 
> > > > And you don't need to add 'fullflush' to the generic place too.
> > > > 
> > > > 'fullflush' will be supported with only GART and AMD IOMMU. So adding
> > > > the description of it to both GART and AMD IOMMU should be fine.
> > > > 
> > > > 'fullflush' has the same meaning for both IOMMUs. That's nice
> > > > consistency, I think.
> > > 
> > > Huh? The whole point of this patch was to have a common option between
> > > IOMMUs to disable lazy IOTLB flushing. This was suggested by _you_ and
> > > the only reason I wrote this patch.
> > 
> > You misunderstand what I meant. I'm sorry if my explanation is not
> > clear.
> > 
> > 
> > > After this patch we can change other IOMMU implementations with lazy
> > > flushing to use that parameter too.
> > 
> > I'm not sure that Calgary wants to support such option. It always uses
> > lazy flushing.
> > 
> > 
> > What I don't like is that there is no consistency about the option
> > name for lazy flushing. It doesn't mean that we move the option to the
> > generic place.
> > 
> > Here's my first reply:
> > 
> > =
> > Would it be nice to have consistency of IOMMU parameters?
> > 
> > VT-d also has the kernel-boot option for this lazy flushing trick
> > though VT-d 'strict' option is more vague than 'unmap_flush'
> > =
> > 
> > What I meant that using the option name 'strict' that VT-d uses for
> > lazy flushing for AMD IOMMU would be better than introducing a new
> > option name, "unmap_flush" for AMD IOMMU though I don't think that
> > 'strict' is the good name.
> > 
> > 
> > Seems 'fullflush' is better than 'strict'. So I think that it's better
> > to use 'fullflush' for AMD IMMU rather introducing a new name,
> > 'unmap_flush'. But again, it doesn't mean that 'fullflush' moves to
> > the generic place.
> 
> Ok, so now we have fullflush, which makes sense for all x86 hardware
> IOMMUs except maybe Calgary (from what I know about Calgary fullflush
> can be implemented there only with a abyssal performance penalty nobody
> is willing to pay). So it makes sense to have the option in the generic
> place.

Not sure. It would make sense but maybe not.

But it's the different topic. Making a generic option that affects all
the IOMMUs is an important issue for everyone. All the parties need to
discuss it and agree.


> But we can surely add a comment that it does not affect Calgary
> to the kernel documentation (and change VT-d to use that parameter too).
> But the AMD IOMMU update chain is not the right place for making big
> changes to other IOMMUs.

Yes, that's the point. We should not have such important change in AMD
IOMMU updates.

So please just make 'fullflush' as AMD IOMMU's option.
