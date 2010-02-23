Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0BWTuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 14:50:01 -0500
Received: from www.tglx.de ([62.245.132.106]:34326 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab0BWTuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 14:50:00 -0500
Date: Tue, 23 Feb 2010 20:49:47 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: Kumar Gala <galak@kernel.crashing.org>, hjk@linutronix.de,
       "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Subject: Re: UIO support for >32-bit physical addresses on 32-bit platforms
Message-ID: <20100223194946.GA1941@local>
References: <A596AEB5-BAF0-4BF9-A9C0-44C50B9BCA34@kernel.crashing.org>
 <20100223150140.GA3781@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223150140.GA3781@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 07:01:41AM -0800, Greg KH wrote:
> On Tue, Feb 23, 2010 at 08:54:16AM -0600, Kumar Gala wrote:
> > Hans, Greg,
> > 
> > We are looking at using UIO for some driver work and noticed it
> > assumes the address for MMIO regions is an 'unsigned long'.  This is a
> > problem for the platforms we have in which we support a 36-bit
> > physical address in a 32-bit machine.
> > 
> > Should we just change addr/size in struct uio_mem to u64 always?

No, if I didn't miss something important, it's not feasible IMHO.

> > At
> > first I was thinking phys_addr_t but realized the addr could be PHYS,
> > LOGICAL, or VIRTUAL.
> 
> I think that would work out fine, Hans, any ideas if this would cause
> any problems with existing code or not?

It won't work. This is not a UIO problem. UIO just passes addr to other
system functions, and all of them use "unsigned long" for these addresses.
You'd have to change the whole memory management code.

Note that members vm_start and vm_end in struct vm_area_struct are
also unsigned long. Having an u64 in the UIO core doesn't help at all.

Memory above the 4G border can only be accessed through himem mechanisms
or be mapped to an address below that border in lowlevel arch code.

In most cases, I'd say it's bad board design to have memory-mapped hardware
above the 4G border on a 32-bit machine.

Thanks,
Hans

