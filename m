Return-Path: <linux-kernel-owner+w=401wt.eu-S1762700AbYEXWU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762700AbYEXWU5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 18:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbYEXWUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 18:20:47 -0400
Received: from www.tglx.de ([62.245.132.106]:58421 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbYEXWUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 18:20:46 -0400
Date: Sun, 25 May 2008 00:20:33 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
       Uwe Kleine-K??nig <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable
	interrupts
Message-ID: <20080524222033.GB3198@local>
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local> <20080523055527.GA28963@digi.com> <20080523104454.4e2af6ec@bluebox.local> <20080523091009.GA22821@digi.com> <20080523120308.7bec1e1c@bluebox.local> <20080523105604.GA23800@digi.com> <20080523135557.27fe4855@bluebox.local> <20080524044354.GA8129@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080524044354.GA8129@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 09:43:54PM -0700, Greg KH wrote:
> On Fri, May 23, 2008 at 01:55:57PM +0200, Hans J. Koch wrote:
> > Sometimes it is necessary to enable/disable the interrupt of a UIO device
> > from the userspace part of the driver. With this patch, the UIO kernel driver
> > can implement an "irqcontrol()" function that does this. Userspace can write
> > an s32 value to /dev/uioX (usually 0 or 1 to turn the irq off or on). The
> > UIO core will then call the driver's irqcontrol function.
> 
> Why not just a new sysfs file for the uio device, irq_enabled, or
> something like that?  That way our main read/write path is left alone.

Hi Greg,
this is in a fast path, so I'm not sure if a sysfs file is not too much
overhead. Special devices in embedded boards sometimes generate a
considerable irq load, and I think it might be problem to do a sysfs
write operation a few thousand times per second.

Thanks,
Hans
