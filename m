Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYKSM6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYKSM6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 07:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYKSM56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 07:57:58 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:42693 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbYKSM55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 07:57:57 -0500
Date: Wed, 19 Nov 2008 14:57:50 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28-rc5
Message-ID: <20081119125748.GK7113@il.ibm.com>
References: <20081118154322.GX13394@amd.com> <20081119150504G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119150504G.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 03:05:24PM +0900, FUJITA Tomonori wrote:
> On Tue, 18 Nov 2008 16:43:22 +0100
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Joerg Roedel (4):
> >       AMD IOMMU: add parameter to disable device isolation
> >       AMD IOMMU: enable device isolation per default
> >       AMD IOMMU: fix fullflush comparison length
> >       AMD IOMMU: check for next_bit also in unmapped area
> > 
> >  Documentation/kernel-parameters.txt |    4 +++-
> >  arch/x86/kernel/amd_iommu.c         |    2 +-
> >  arch/x86/kernel/amd_iommu_init.c    |    6 ++++--
> >  3 files changed, 8 insertions(+), 4 deletions(-)
> > 
> > As the most important change these patches enable device isolation
> > per default. Tests have shown that there are drivers which have
> > bugs and do double-freeing of DMA memory.
> 
> What drivers? We need to fix them if they are mainline drivers.
> 
> > This can lead to data corruption with a hardware IOMMU when
> > multiple devices share the same protection domain.  Therefore
> > device isolation should be enabled by default.
> 
> Hmm, the change is just because of the bug workaround? If so, I'm not
> sure it's a good idea. We need to fix the buggy drivers anyway.

This won't work around the bug, it will just make its outcome less
severe (by restricting the fault to the offensive device only).

> device isolation is not free; e.g. use more memory rather than
> sharing a protection domain. I guess that more people prefer sharing
> a protection domain by default.

I doubt it, why use an isolation-capable IOMMU at all if not for the
increased reliability? The majority of modern devices---those that you
are likely to find on machines with an IOMMU---don't have DMA
limitations.

> It had been the default option for AMD IOMMU until you hit the
> bugs. IIRC, VT-d also shares a protection domain by default. It
> would be nice to avoid surprising users if the two virtualization
> IOMMUs works in the similar way.

Calgary has a per-bus protection domain, both on x86 and PPC.

Cheers,
Muli
-- 
The First Workshop on I/O Virtualization (WIOV '08)
Dec 2008, San Diego, CA, http://www.usenix.org/wiov08/
                       <->
SYSTOR 2009---The Israeli Experimental Systems Conference
http://www.haifa.il.ibm.com/conferences/systor2009/
