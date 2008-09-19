Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbYISRes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbYISRes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYISRek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:34:40 -0400
Received: from sh.osrg.net ([192.16.179.4]:56202 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYISRek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:34:40 -0400
Date: Sat, 20 Sep 2008 02:34:15 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
 option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080919172036.GT24392@amd.com>
References: <20080919164541.GS24392@amd.com>
	<20080920020917O.fujita.tomonori@lab.ntt.co.jp>
	<20080919172036.GT24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080920023424H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 19:20:36 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Sat, Sep 20, 2008 at 02:09:21AM +0900, FUJITA Tomonori wrote:
> > On Fri, 19 Sep 2008 18:45:41 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > On Sat, Sep 20, 2008 at 01:23:30AM +0900, FUJITA Tomonori wrote:
> > > > This patch against tip/x86/iommu virtually reverts
> > > > 2842e5bf3115193f05dc9dac20f940e7abf44c1a. But just reverting the
> > > > commit breaks AMD IOMMU so this patch also includes some fixes.
> > >  
> > > NACK.
> > > 
> > > > The above commit adds new two options to x86 IOMMU generic kernel boot
> > > > options, fullflush and nofullflush. But such change that affects all
> > > > the IOMMUs needs more discussion (all IOMMU parties need the chance to
> > > > discuss it):
> > > 
> > > It affects only IOMMUs which use the iommu_fullflush variable. This are
> > > GART, which used it since ages, and AMD IOMMU which was introduced by
> > > the above commit. It absolutly makes sense to have command line parameters
> > > which make sense for more than one or most of the IOMMUs in x86 into
> > > 'iommu='. Ingo agreed with this, see http://lkml.org/lkml/2008/6/30/155
> > > I agree with that too. The commit you are trying to revert here was a
> > > step into this direction.
> > 
> > The point is we can't remove or rename VT-d option for IOTLB batching
> > because we already exported it for users.
> > 
> > I think that once we export a boot option to users, we can't remove or
> > rename it. It's the user interface.
> > 
> > You have a different policy for the kernel boot option? You think we
> > can change or rename it after exporting it?
> 
> No. But we can have the generic option in parallel. There is no reason
> to remove the VT-d specific option.
> 
> > 
> > Yeah, Intel IOMMU need to keep the current option for IOTLB batching
> > but it also support fullflush. But we don't discuss anything with
> > Intel developers. That's what I'm against.
> 
> Thats why my patch does not change VT-d code. So why do you send revert
> patches and not starting this discussion? If Muli and the Intel people
> disagree we can still revert it.

It's not a proper Linux development process for me.

A patch to make such change should be merged with Acked-by from other
developers. Making such change first then saying, "if you don't like
it, revert it" is not nice.


> > > > 'nofullflush' definitely is pointless. 'nofullflush' option doesn't
> > > > change any kernel behavior and it was added just for GART
> > > > compatibility. We should not have such generic meaningless option just
> > > > for GART.
> > > 
> > > So why do you keep it in this patch then?
> > 
> > As I wrote, I think that we can't remove the exported user interfacea
> 
> You keep this option for AMD IOMMU too. If you move it to AMD IOMMU code
> then you can remove nofullflush there.

I'm not sure what you mean. You think that we can't change the
exported option, how can we remove nofullflush option?


> > 
> > Please keep it for AMD option for now. Please send a patch to make it
> > generic to other IOMMU people and give them a chance to discuss on
> > it.
> >
> 
> Ok, I will forward the patch to Intel VT-d maintainers and Muli to
> discuss it. If they disagree we can revert the patch.

Again, it's not a proper process for me.
