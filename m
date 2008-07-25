Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbYGYHeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbYGYHeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 03:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYGYHdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 03:33:17 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38196 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997AbYGYHdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 03:33:16 -0400
X-Sasl-enc: hom0DGaTvq25HxBmpK7pWv/txEpY3at/qIoDReijF205 1216971194
Message-ID: <488981B7.1060002@ladisch.de>
Date: Fri, 25 Jul 2008 09:33:11 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alex <arghness@gmail.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: DMA with PCIe and very large DMA transfers
References: <e17d70da0807240806h329bba4aw60e6fad82bcffabd@mail.gmail.com> <200807241302.19656.jbarnes@virtuousgeek.org>
In-Reply-To: <200807241302.19656.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Thursday, July 24, 2008 8:06 am Alex wrote:
> > I'm also interested in knowing if any drivers perform very large DMA
> > transfers. I'm putting together a driver for a specialist high-speed
> > data acquisition device that typically might need a DMA buffer of
> > 100-500MB (ouch!) in the low 32 bit address space (or possibly 36 bit
> > address space, but I'm not sure if this is possible to allocate
> > without allocating as much as possible and then discarding?) but only
> > supports a very limited number of scatter/gather entries (between 1
> > and 4). [...]
>
> It sounds like you'll probably have fairly special purpose configurations.  In
> that case, it may be reasonable to reserve your large DMA buffers at boot
> time, assuming you need large, contiguous chunks of physical memory.

Most of the sound drivers do this because few chips support SG.

> > I assume that to allocate that much memory in physical contiguous
> > addresses will require a driver to be loaded as soon as possible at
> > startup. I was thinking about trying to grab a lot of high-order pages
> > and try and make them one contiguous block - is that feasible?
> > Browsing the archives, I found references to early allocation for
> > large buffers, but no direct links to existing examples or recommended
> > techniques on how to stitch pages together in to a single buffer.

Have a look into sound/core/memalloc.c.  It tries to get a contiguous
block from the kernel; I don't think that it's possible to do this
manually if the kernel has failed.


Regards,
Clemens
