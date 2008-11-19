Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbYKSO7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbYKSO7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 09:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYKSO7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 09:59:37 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34940 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753519AbYKSO7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 09:59:36 -0500
Date: Wed, 19 Nov 2008 09:59:34 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
       Jens Axboe <axboe@kernel.dk>
cc: "Hommel, Thomas (GE EntSol, Intelligent Platforms)" 
	<Thomas.Hommel@gefanuc.com>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: ISP1760 driver crashes
In-Reply-To: <4923F120.6000303@linutronix.de>
Message-ID: <Pine.LNX.4.44L0.0811190951570.2418-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008, Sebastian Andrzej Siewior wrote:

> Hommel, Thomas (GE EntSol, Intelligent Platforms) wrote:
> 
> > I indeed have HIGHMEM enabled in my configuration.
> > I recompiled the kernel without HIGHMEM and it works. I don't think that
> > this a satisfying solution for a board with up to 2GB of RAM and
> > considerable amount of VMALLOC space, but at least this works.
> > If you have any more ideas how to circumvent this, please let me know.
> Sure, this is not a sollution but atleast now I know what happens:
> - The kernel allocates memory for transfer
> - the memory is highmem and not in kernel so the buffer is NULL
> - we don't have a dma-mask and therefore the dma address is 0
> - boom
> 
> The sollution would be probably to prevent the usb-storage core to 
> allocate memory from HIGHMEM.

usb-storage doesn't allocate the memory.  The memory is allocated by 
the block layer or the filesystem.

> Now I don't if there is a flag for something 
> like that and I am not using that. On the other hand this may be broken 
> for a long time and you are the first one which has that much memory with 
> no DMA-capable USB controller.

Jens, is there any way to tell the kernel that a device uses PIO and 
therefore its buffers shouldn't be allocated in high memory?  For 
example, shouldn't a NULL dma_mask do this?

If not, are there standard routines to set up bounce buffers for such 
devices?

Alan Stern

