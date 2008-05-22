Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbYEVUIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbYEVUIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYEVUI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:08:26 -0400
Received: from www.tglx.de ([62.245.132.106]:43202 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbYEVUIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:08:25 -0400
Date: Thu, 22 May 2008 22:08:15 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Tom Spink <tspink@gmail.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Uwe =?utf-8?B?S2xlaW5lLUvDg8K2bmln?= <Uwe.Kleine-Koenig@digi.com>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable
	interrupts
Message-ID: <20080522200814.GD3226@local>
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local> <7b9198260805221247t715660d1l4085fe8c310f89c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b9198260805221247t715660d1l4085fe8c310f89c@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 08:47:16PM +0100, Tom Spink wrote:

Hi Tom,

> 2008/5/22 Hans J. Koch <hjk@linutronix.de>:
> > Sometimes it is necessary to enable/disable the interrupt of a UIO device
> > from the userspace part of the driver. With this patch, the UIO kernel driver
> > can implement an "irqcontrol()" function that does this. Userspace can write
> > an s32 value to /dev/uioX (usually 0 or 1 to turn the irq off or on). The
> > UIO core will then call the driver's irqcontrol function.
> >
> > Signed-off-by: Hans J. Koch <hjk@linutronix.de>
> 
> <snip>
> 
> Hi,
> 
> I wonder if it would be better to implement this as an ioctl,

No way. We don't want to introduce new ioctls.

> rather
> than a write to the device.  Writing to a device is a pretty generic
> thing, and this patch would tie that up to specifically controlling
> interrupts.  

UIO userspace drivers do their whole work by accessing the device's
memory directly. The purpose of the kernel part is mainly

1) allow this memory to be mapped
2) handle interrupts

We have an mmap() implementation for 1) and a read() implementation to
wait for interrupts. Now we add write to enable/disable interrupts,
which completes 2). Looks clean to me.

> An ioctl would be more appropriate, IMO, as you are
> issuing a controlling command, i.e. disable or enable interrupts.
> 
> By the way, I have absolutely no idea how the UIO driver works, other
> than reading http://lwn.net/Articles/232575/

You could read the docs that come with the kernel sources:
Documentation/DocBook/uio_howto

Thanks,
Hans

