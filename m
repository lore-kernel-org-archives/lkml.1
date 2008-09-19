Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbYISV4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbYISV4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 17:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYISV4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 17:56:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:45085 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYISV4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:56:42 -0400
Date: Sat, 20 Sep 2008 06:56:21 +0900
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic
 option
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080919201909.GC10692@amd.com>
References: <20080919195216.GB10692@amd.com>
	<20080920050229Z.fujita.tomonori@lab.ntt.co.jp>
	<20080919201909.GC10692@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080920065630N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 22:19:09 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Sat, Sep 20, 2008 at 05:02:16AM +0900, FUJITA Tomonori wrote:
> > On Fri, 19 Sep 2008 21:52:16 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > On Sat, Sep 20, 2008 at 03:48:11AM +0900, FUJITA Tomonori wrote:
> > > > On Fri, 19 Sep 2008 20:01:18 +0200
> > > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > > 
> > > > > On Sat, Sep 20, 2008 at 02:40:35AM +0900, FUJITA Tomonori wrote:
> > > > > > On Fri, 19 Sep 2008 19:30:04 +0200
> > > > > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > > > > 
> > > > > > > On Sat, Sep 20, 2008 at 02:09:21AM +0900, FUJITA Tomonori wrote:
> > > > > > > > 
> > > > > > > > Please keep it for AMD option for now. Please send a patch to make it
> > > > > > > > generic to other IOMMU people and give them a chance to discuss on
> > > > > > > > it.
> > > > > > > >
> > > > > > > 
> > > > > > > Btw, you already agreed with a generic iommu= parameter for lazy IO/TLB
> > > > > > > flushing"
> > > > > > > 
> > > > > > > 
> > > > > > >  > True. We should merge common parameters across IOMMUs into the
> > > > > > >  > iommu= parameter some time in the future, I think. It would also be the
> > > > > > >  > place for the IOMMU size parameter.
> > > > > > > 
> > > > > > >  Hmm, now is better than the future? I think that now you can add
> > > > > > >  something like 'disable_batching_flush' as a common parameter and
> > > > > > >  change AMD IOMMU to use it.
> > > > > > > 
> > > > > > > in http://lkml.org/lkml/2008/9/17/376
> > > > > > > 
> > > > > > > And since we already have a iommu=fullflush parameter it makes sense of
> > > > > > > make it generic.
> > > > > > 
> > > > > > I'm not against fullflush but we need to discuss it with other people
> > > > > > before making the change.
> > > > > 
> > > > > Weird. Just 2 hours ago you wrote:
> > > > > 
> > > > > |http://lkml.org/lkml/2008/9/19/106
> > > > > |
> > > > > |For me, adding these boot parameters doesn't make sense.
> > > > 
> > > > See:
> > > > 
> > > > http://lkml.org/lkml/2008/9/19/221
> > > 
> > > Removing nofullflush and moving fullflush to the generic code are two
> > > different questions. You talk about the first and I talk about the
> > > second here. We should make sure we talk about the same things
> > > when we flame each other ;)
> > 
> > And the root cause is that your patch does the two different things.
> > 
> > So please revert the changes. I've already send a patch to do
> > that. Please do these things in the proper way. If you think that you
> > are free to remove nofullflush from GART, send a patch to do that. If
> > you think that fullflush should be generic, send a patch to do it with
> > CC'ed to IOMMU people.
> 
> I don't think that there is a reason to revert the patch until

Because you did things int the wrong way, I said again and again.

I can't see why you refuse to do the things in the proper way.


> objections agains the generic iommu=fullflush come up. The patch does
> not break anything and just moves the iommu=flush parameter (which is
> already available) to pci-dma.c to make it useable by AMD IOMMU too.

Breaking anything does mean that it's fine. My patch doesn't break
anything too.

I'm not against fullflush (as I said again and again). I guess that
it's the right move though it might be not so useful if VT-d doesn't
support it.

I'm against totally pointless nofullflush and the way you changed the
generic IOMMU code.
