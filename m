Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZEGHtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZEGHtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 03:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZEGHtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 03:49:03 -0400
Received: from sh.osrg.net ([192.16.179.4]:58745 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbZEGHtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 03:49:01 -0400
Date: Thu, 7 May 2009 16:47:14 +0900
To: joerg.roedel@amd.com
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, airlied@linux.ie
Subject: Re: IOMMU and graphics cards
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090428160448.GA17438@amd.com>
References: <20090428150531.GZ17438@amd.com>
	<1240932530.2567.91.camel@macbook.infradead.org>
	<20090428160448.GA17438@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090507164742V.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 07 May 2009 16:47:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 18:04:48 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Tue, Apr 28, 2009 at 04:28:50PM +0100, David Woodhouse wrote:
> > On Tue, 2009-04-28 at 17:05 +0200, Joerg Roedel wrote:
> > 
> > For that device, yes. The IOMMU still catches errors from _other_
> > devices, of course.
> 
> Yes, it is in effect for other devices. But since its a security feature
> it only makes sense if it covers all devices.

For me, IOMMUs are not about security but accessing all memory space
(there are still lots of devices that are not capable of 64-bit DMA)
but I agree that this workaround is bad.


> > Is the reason you're doing this actually because of broken drivers? Or
> > just because of the performance implications? I've heard both cited as
> > reasons for the 1:1 mapping... and if it's mostly the former, then
> > perhaps the best way for me to help you is to stop enabling the option
> > in Fedora (rawhide, at least), so that the buggy drivers get _fixed_ and
> > you don't get stuck with "it works on Intel, why can't you make it
> > work?" reports?
> 
> Currently some graphics drivers don't work with IOMMU enabled because
> they don't use the DMA-API. The silently assume that device addess ==
> physical address.
> I don't know how it is solved for VT-d but for AMD IOMMU the available
> DMA memory address space is limited per device. This is a problem for
> graphics card drivers because, as developers told me, they may need
> gigabytes of DMA memory. I am currently thinking about ways to fix that
> without enlarging the DMA address space for each device (which would be
> a huge waste of memory).

Do you meant that AMD IOMMU code use the bitmap each device to manage
address space so enlarging the DMA address space wastes memory?


>  But unless this problem isn't solved the
> drivers won't be fixed, I guess.
> I guess the DRM code in the kernel may have the same problem with IOMMU
> enabled?

Looks like the DRM code uses the DMA API.


> > > 	* Implement a kernel command line option to enable/disable the
> > > 	  workaround (what should be default?)
> > > 	* Use the IOMMU-API and write a kernel module which creates a
> > > 	  direct mapped protection domain and assigns the graphics
> > > 	  cards to it (need to be done carefully to not break graphics 
> > > 	  drivers which do everything right and use the DMA-API)
> > > 	* Any other great idea?
> > 
> > I think I also prefer your second option. I don't like having this as a
> > hack in the IOMMU code.
> 
> Ok, so I will implement such a module and send the code around for
> discussion.

Yeah, the kernel boot option or the config option don't make sense
since distributions always need to enable the workaround.

btw, what graphic drivers are broken? No chance to fix them?
