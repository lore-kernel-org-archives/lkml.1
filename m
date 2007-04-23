Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbXDWTzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbXDWTzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 15:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbXDWTzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 15:55:49 -0400
Received: from dialup.esmr.ru ([85.94.3.83]:42653 "EHLO localhost.localdomain"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751570AbXDWTzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 15:55:49 -0400
Date: Mon, 23 Apr 2007 23:55:02 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linuxppc-dev@ozlabs.org, linux-pcmcia@lists.infradead.org,
       lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH][RFC] PCMCIA support for 8xx using platform devices
Message-ID: <20070423235502.734e6e67@localhost.localdomain>
In-Reply-To: <20070423075957.GA22811@infradead.org>
References: <20070422232658.5f427fd3@localhost.localdomain>
	<200704222349.42368.arnd@arndb.de>
	<20070423101427.3a1d4983@localhost.localdomain>
	<20070423075957.GA22811@infradead.org>
X-Mailer: Claws Mail 2.8.1cvs91 (GTK+ 2.10.9; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 08:59:57 +0100
Christoph Hellwig wrote:

> On Mon, Apr 23, 2007 at 10:14:27AM +0400, Vitaly Bordug wrote:
> > On Sun, 22 Apr 2007 23:49:41 +0200
> > Arnd Bergmann wrote:
> > 
> > > On Sunday 22 April 2007, Vitaly Bordug wrote:
> > > > This utilizes PCMCIA on mpc885ads and mpc866ads from
> > > > arch/powerpc. In the new approach, direct IMMR accesses from
> > > > within drivers/ were totally eliminated, that requires
> > > > hardware_enable, hardware_disable, voltage_set board-specific
> > > > functions to be moved over to BSP code section
> > > > (arch/powerpc/platforms/8xx in 885 case). There is just no way
> > > > to have both arch/ppc and arch/powerpc approaches to work
> > > > simultaneously because of that.  
> > > 
> > > Maybe I'm missing a key issue here, but what's the point of adding
> > > more platform_devices for stuff that is already in the device
> > > tree? Shouldn't this be made an of_platform_driver instead so you
> > > can use the existing of_device directly?
> > > 
> > Was thinking of it but platform_device is better for migration
> > purposes. Hence, assuming somebody would want to have pcmcia
> > working not bothering to add whole arch/powerpc support, it can be
> > accomplished quickly.
> 
> That's a horrible argument.  Please do it properly, and let arch/ppc
> die as it should.  We shouldn't be adding anything to it anymore
> anyway.
> 
I understand your point, but we shouldn't trash existing bits either. Things are a bit different with embedded
stuff, and especially in case of 8xx, there are targets without OF-powered uboot. Bootwrapper thing might be helpful in resolving it, but not a holy tablet after all.

The main point is: current 8xx pcmcia code is a holy mess of ifdefs, direct immr accesses (assuming it is io_block_mapped 1:1) etc. And limiting pcmcia to 885ads only (the only 8xx that supports OF so far) is not good.
We have to admit, that many 8xx boards will remain in ppc/ for a while, and instead of just dropping BSP bits
I'm going to let them be refactored via pdevs (with announcement in feature removal reference) as it would take couple of hrs only. If nobody will care, then the whole 8xx pcmcia driver will be cleaned up and switched 
to of_device.

Does that make sense?

-- 
Sincerely, Vitaly

