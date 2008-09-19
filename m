Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYISRJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYISRJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbYISRJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:09:48 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:54482 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbYISRJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:09:48 -0400
Date: Sat, 20 Sep 2008 02:09:21 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
 option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080919164541.GS24392@amd.com>
References: <20080920012322R.fujita.tomonori@lab.ntt.co.jp>
	<20080919164541.GS24392@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080920020917O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 18:45:41 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Sat, Sep 20, 2008 at 01:23:30AM +0900, FUJITA Tomonori wrote:
> > This patch against tip/x86/iommu virtually reverts
> > 2842e5bf3115193f05dc9dac20f940e7abf44c1a. But just reverting the
> > commit breaks AMD IOMMU so this patch also includes some fixes.
>  
> NACK.
> 
> > The above commit adds new two options to x86 IOMMU generic kernel boot
> > options, fullflush and nofullflush. But such change that affects all
> > the IOMMUs needs more discussion (all IOMMU parties need the chance to
> > discuss it):
> 
> It affects only IOMMUs which use the iommu_fullflush variable. This are
> GART, which used it since ages, and AMD IOMMU which was introduced by
> the above commit. It absolutly makes sense to have command line parameters
> which make sense for more than one or most of the IOMMUs in x86 into
> 'iommu='. Ingo agreed with this, see http://lkml.org/lkml/2008/6/30/155
> I agree with that too. The commit you are trying to revert here was a
> step into this direction.

The point is we can't remove or rename VT-d option for IOTLB batching
because we already exported it for users.

I think that once we export a boot option to users, we can't remove or
rename it. It's the user interface.

You have a different policy for the kernel boot option? You think we
can change or rename it after exporting it?


> > http://lkml.org/lkml/2008/9/19/106
> > 
> > For me, adding these boot parameters doesn't make sense.
> 
> May be true for nofullflush. For fullflush it makes sense to have it in
> the generic code since all x86 hardware IOMMUs except Calgary can make
> use of it. 
> 
> > All the hardware IOMMUs could use 'fullflush' for lazy IOTLB flushing
> > but Calgary doesn't support it. Intel VT-d has the different option
> > for it (and we can't rename it). So it might be useful for only GART
> > and AMD IOMMU.
> 
> We can keep the current Intel option and have iommu=fullflush in
> parallel. It could also affect Intel IOMMU.

Yeah, Intel IOMMU need to keep the current option for IOTLB batching
but it also support fullflush. But we don't discuss anything with
Intel developers. That's what I'm against.


> > 'nofullflush' definitely is pointless. 'nofullflush' option doesn't
> > change any kernel behavior and it was added just for GART
> > compatibility. We should not have such generic meaningless option just
> > for GART.
> 
> So why do you keep it in this patch then?

As I wrote, I think that we can't remove the exported user interface.


> > This patch removes the fullflush and nofullflush from the generic
> > kernel boot options and adds 'fullflush' support for AMD IOMMU.
> 
> I disagree. Keep it in the generic code.

We would have it in the generic code but the point is that you change
the generic code without any discussion with other IOMMU people,
Calgary and Intel developers.

After discussion, if we agree on having it in the generic code, it's
fine by me. But again, you changed the generic code without any
discussion with other IOMMU people. It's a wrong development process.

Please keep it for AMD option for now. Please send a patch to make it
generic to other IOMMU people and give them a chance to discuss on
it.
