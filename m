Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbYLYPUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbYLYPUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 10:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYLYPUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 10:20:30 -0500
Received: from www.tglx.de ([62.245.132.106]:50848 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbYLYPU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 10:20:29 -0500
Date: Thu, 25 Dec 2008 16:20:15 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
       Edward Estabrook <edward.estabrook.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, gregkh@suse.de,
       edward.estabrook@gmail.com, edward_estabrook@agilent.com
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
	(corrected)
Message-ID: <20081225152014.GA3079@local>
References: <208aa0f00812031751n27a75d21h8747054651639463@mail.gmail.com> <20081211003340.GB3078@local> <20081225123004.GA13640@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225123004.GA13640@8bytes.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 01:30:04PM +0100, Joerg Roedel wrote:
> On Thu, Dec 11, 2008 at 01:33:41AM +0100, Hans J. Koch wrote:
> > On Wed, Dec 03, 2008 at 05:51:30PM -0800, Edward Estabrook wrote:
> > > From: Edward Estabrook <Edward_Estabrook@agilent.com>
> > > 
> > > Here is a patch that adds the ability to dynamically allocate and use
> > > coherent DMA
> > > from userspace by extending the Userspace IO driver.  This patch applies against
> > > 2.6.28-rc6.
> > 
> > Hi Edward,
> > sorry I didn't answer sooner. It was not lack of interest in your work, I
> > just had to think about it (and had quite a lot of other work, too).
> > I consider your idea of having DMA coherent memory allocatable from userspace
> > a valid demand. However, the interface should be implemented differently.
> > 
> > As a general requirement, all information you need to pass to userspace has
> > to go through sysfs. This is a UIO design decision and should not be changed
> > lightly. Please don't fill information into the allocated memory.
> > 
> > We shouldn't mix dynamically allocated DMA regions with the already existing
> > static memory mappings. There should be an extra directory, maybe called
> > /sys/class/uio/uioN/dyn_dma_mem/ containing information about this kind of
> > DMA memory. This directory would not exist by default, it's only created if
> > some user actually allocates such memory.
> > 
> > In the UIO core, these mappings should be handled with a dynamic list, not
> > a static array. The number of possible mappings has to be limited to a
> > sensible maximum, maybe 50 or 100. The code handling the existing static
> > mappings could mostly stay as-is.
> 
> I like that idea of a seperate directory in sysfs. How about allocating
> DMA memory by creating files in this directory.

Nice idea, but AFAICT sysfs doesn't support creating files from userspace.

> The memory itself can be
> accessed via mmap() and the dma address can be gathered using read().
> When a file is closed the dma memory is unmapped.
> This would work great as long as /sys/class/uio/uioN/ belongs only to
> one physical device.

That's guaranteed.

Thanks,
Hans
