Return-Path: <linux-kernel-owner+w=401wt.eu-S1761769AbZEGK4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761769AbZEGK4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 06:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZEGK4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 06:56:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33013 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbZEGK4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 06:56:06 -0400
Date: Thu, 7 May 2009 12:55:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, airlied@linux.ie
Subject: Re: IOMMU and graphics cards
Message-ID: <20090507105530.GB28398@elte.hu>
References: <20090428150531.GZ17438@amd.com> <1240932530.2567.91.camel@macbook.infradead.org> <20090428160448.GA17438@amd.com> <20090507164742V.fujita.tomonori@lab.ntt.co.jp> <20090507100114.GF4059@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507100114.GF4059@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Thu, May 07, 2009 at 04:47:14PM +0900, FUJITA Tomonori wrote:
> > On Tue, 28 Apr 2009 18:04:48 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > 
> > > Yes, it is in effect for other devices. But since its a security feature
> > > it only makes sense if it covers all devices.
> > 
> > For me, IOMMUs are not about security but accessing all memory space
> > (there are still lots of devices that are not capable of 64-bit DMA)
> > but I agree that this workaround is bad.
> 
> Yeah true. Another major reason for having an IOMMU is to enlarge the
> physical address range devices can access.
> 
> > Do you meant that AMD IOMMU code use the bitmap each device to manage
> > address space so enlarging the DMA address space wastes memory?
> 
> Its not only the bitmap. There are also the page tables that would waste
> memory if the aperture in the AMD IOMMU driver is enlarged to, say, 4GB.
> Most devices don't need such a large amount of DMA address space. As I
> found out VT-d does not have this problem because they implemented
> another allocator which can cover all possible memory.
> For the AMD IOMMU I currently implement a kind of a dynamically growing
> bitmap allocator to fix this problem.
> 
> > >  But unless this problem isn't solved the
> > > drivers won't be fixed, I guess.
> > > I guess the DRM code in the kernel may have the same problem with IOMMU
> > > enabled?
> > 
> > Looks like the DRM code uses the DMA API.
> 
> The proprietary drivers make problems so far. For the ATI one I am 
> in contact with the developers to try to fix it. But I can't do 
> anything about the other proprietary driver I am aware of :-(

One option would be to enumerate nvidia vga device memory resources, 
print a nasty warning if they are accessed while not mapped by any 
in-kernel driver (such as Noveau) and then install a workaround for 
their resources and exclude them from IOMMU coverage.

	Ingo
