Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab0BSArr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:47:47 -0500
Received: from kroah.org ([198.145.64.141]:34866 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab0BSArq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:47:46 -0500
Date: Thu, 18 Feb 2010 16:47:19 -0800
From: Greg KH <greg@kroah.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linux-usb <linux-usb@vger.kernel.org>, dbrownell@users.sourceforge.net
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA
 support
Message-ID: <20100219004719.GA15965@kroah.com>
References: <4B7CAF95.6020306@gmail.com>
 <20100218042626.GB11649@kroah.com>
 <51f3faa71002172113o65a85ed6y5fa39d0b3a96f7ce@mail.gmail.com>
 <20100218052223.GA13254@kroah.com>
 <51f3faa71002181633w1649a648s37ae73da342d0c3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51f3faa71002181633w1649a648s37ae73da342d0c3f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 06:33:42PM -0600, Robert Hancock wrote:
> On Wed, Feb 17, 2010 at 11:22 PM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Feb 17, 2010 at 11:13:05PM -0600, Robert Hancock wrote:
> >> On Wed, Feb 17, 2010 at 10:26 PM, Greg KH <greg@kroah.com> wrote:
> >> > On Wed, Feb 17, 2010 at 09:10:13PM -0600, Robert Hancock wrote:
> >> >> Add a module parameter to allow the user to enable 64-bit DMA support in EHCI,
> >> >> which has been forcibly disabled since 2003 - see:
> >> >>
> >> >> http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg17230.html
> >> >>
> >> >> At that time the comment was "it'd only matter on a few big Intel boxes anyway",
> >> >> however the situation is much different today when many new machines have 4GB
> >> >> or more of RAM and IOMMU/SWIOTLB are thus needlessly required for USB transfers.
> >> >> For now, the support remains disabled by default and is controlled by an
> >> >> allow_64bit module parameter.
> >> >>
> >> >> Note that some USB device drivers may require updates to pass the DMA
> >> >> capabilities up to their higher layers to avoid unnecessary IOMMU or bounce-
> >> >> buffer use (i.e. networking layer NETIF_F_HIGHDMA). Some of these checks were
> >> >> disabled by the patch listed above, and more may be required again today.
> >> >> However, those previous checks were done incorrectly using dma_supported,
> >> >> which checks to see whether a device's DMA mask can be validly set to a given
> >> >> mask, not whether its previously set mask will accomodate the mask passed in.
> >> >>
> >> >> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
> >> >
> >> > What is the "advantage" that setting this option would allow people to
> >> > do that the code currently does not? ?Is such an advantage measurable at
> >> > the slow rates that the EHCI driver controls?
> >>
> >> I expect it would likely be quite system-dependent. However,
> >> particularly with devices like high-speed USB storage on systems with
> >> lots of RAM, especially 8GB or more (where more of the memory can't be
> >> addressed with 32-bit than can), I suspect it would likely be
> >> measurable in terms of CPU usage, throughput or both, especially if
> >> there's no hardware IOMMU and software bounce-buffering is required.
> >
> > So you did not measure it?
> >
> > Hm, I guess this change must not be necessary :)
> 
> I'll try and run some tests and see what I can quantify. However, I
> only have 4GB of RAM on my machine (with a 1GB memory hole) and so a
> random memory allocation only has a 25% chance of ending up in the
> area where it would make a difference, so it may take a bit of doing.

Without any good justification, including real tests being run, I can't
take this patch, the risk is just too high.

And really, for USB 2.0 speeds, I doubt you are going to even notice
this kind of overhead, it's in the noise.  Especially given that almost
always the limiting factor is the device itself, not the host.

thanks,

greg k-h
