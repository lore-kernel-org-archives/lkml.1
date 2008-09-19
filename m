Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYISUTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYISUTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 16:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYISUTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 16:19:23 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:38005 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbYISUTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 16:19:22 -0400
X-BigFish: VPS-31(z1039oz1418M1432R98dR1805M179dR936fQ873fnzz10d3izz2f39iz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7GLRQ-04-3MR-01
Date: Fri, 19 Sep 2008 22:19:09 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove fullflush and nofullflush in IOMMU generic option
Message-ID: <20080919201909.GC10692@amd.com>
References: <20080919180118.GV24392@amd.com> <20080920034750X.fujita.tomonori@lab.ntt.co.jp> <20080919195216.GB10692@amd.com> <20080920050229Z.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080920050229Z.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Sep 2008 20:19:09.0547 (UTC) FILETIME=[F93853B0:01C91A94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 05:02:16AM +0900, FUJITA Tomonori wrote:
> On Fri, 19 Sep 2008 21:52:16 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Sat, Sep 20, 2008 at 03:48:11AM +0900, FUJITA Tomonori wrote:
> > > On Fri, 19 Sep 2008 20:01:18 +0200
> > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > 
> > > > On Sat, Sep 20, 2008 at 02:40:35AM +0900, FUJITA Tomonori wrote:
> > > > > On Fri, 19 Sep 2008 19:30:04 +0200
> > > > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > > > 
> > > > > > On Sat, Sep 20, 2008 at 02:09:21AM +0900, FUJITA Tomonori wrote:
> > > > > > > 
> > > > > > > Please keep it for AMD option for now. Please send a patch to make it
> > > > > > > generic to other IOMMU people and give them a chance to discuss on
> > > > > > > it.
> > > > > > >
> > > > > > 
> > > > > > Btw, you already agreed with a generic iommu= parameter for lazy IO/TLB
> > > > > > flushing"
> > > > > > 
> > > > > > 
> > > > > >  > True. We should merge common parameters across IOMMUs into the
> > > > > >  > iommu= parameter some time in the future, I think. It would also be the
> > > > > >  > place for the IOMMU size parameter.
> > > > > > 
> > > > > >  Hmm, now is better than the future? I think that now you can add
> > > > > >  something like 'disable_batching_flush' as a common parameter and
> > > > > >  change AMD IOMMU to use it.
> > > > > > 
> > > > > > in http://lkml.org/lkml/2008/9/17/376
> > > > > > 
> > > > > > And since we already have a iommu=fullflush parameter it makes sense of
> > > > > > make it generic.
> > > > > 
> > > > > I'm not against fullflush but we need to discuss it with other people
> > > > > before making the change.
> > > > 
> > > > Weird. Just 2 hours ago you wrote:
> > > > 
> > > > |http://lkml.org/lkml/2008/9/19/106
> > > > |
> > > > |For me, adding these boot parameters doesn't make sense.
> > > 
> > > See:
> > > 
> > > http://lkml.org/lkml/2008/9/19/221
> > 
> > Removing nofullflush and moving fullflush to the generic code are two
> > different questions. You talk about the first and I talk about the
> > second here. We should make sure we talk about the same things
> > when we flame each other ;)
> 
> And the root cause is that your patch does the two different things.
> 
> So please revert the changes. I've already send a patch to do
> that. Please do these things in the proper way. If you think that you
> are free to remove nofullflush from GART, send a patch to do that. If
> you think that fullflush should be generic, send a patch to do it with
> CC'ed to IOMMU people.

I don't think that there is a reason to revert the patch until
objections agains the generic iommu=fullflush come up. The patch does
not break anything and just moves the iommu=flush parameter (which is
already available) to pci-dma.c to make it useable by AMD IOMMU too.

Joerg


-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

