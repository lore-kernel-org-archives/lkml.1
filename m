Return-Path: <linux-kernel-owner+w=401wt.eu-S1030274AbXDCXkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030274AbXDCXkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030275AbXDCXkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:40:11 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47641 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030274AbXDCXkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:40:08 -0400
Subject: Re: 2.6.21-rc5-mm4
From: Badari Pulavarty <pbadari@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704031556310.12071@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <1175632311.6185.1.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031339080.11001@schroedinger.engr.sgi.com>
	 <1175640812.6185.6.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031556310.12071@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 16:40:08 -0700
Message-Id: <1175643608.6185.15.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 15:59 -0700, Christoph Lameter wrote:
> On Tue, 3 Apr 2007, Badari Pulavarty wrote:
> 
> > > > SLUB code hangs my ppc64 machine on boot.
> > > 
> > > Could you enable NMI or something and get me a stackdump? PPC is notorious 
> > > for having strange NUMA issues. Any fallbacks from node 0 on bootstrap? Is 
> > > there memory on node 0?
> > 
> > 
> > Seems to be an issue with calibrate_delay() spinning in a tight
> > loop :(
> > 
> > BTW, machine boots fine with SLAB code - not sure why ?
> 
> SLUB does not guarantee the special casing that SLAB provides for 
> page sized allocations via kmalloc. SLAB aligns page sized allocations on 
> page boundaries and does not allow full debugging of page sized 
> allocations in order to keep these slabs on page sized boundaries.
> 
> I suspect this is related. I could add the same special casing to SLUB. 
> But I really wish we would get rid of special slab behavior depending on 
> the size of the slab. Maybe there is no way around it. Sigh.
> 
> What is the data that calibrate delay is looking at?


Its stuck in following .. 

                while ((loops_per_jiffy <<= 1) != 0) {
                        /* wait for "start of" clock tick */
                        ticks = jiffies;
                        while (ticks == jiffies)
                                /* nothing */;
                        /* Go .. */
                        ticks = jiffies;
                        __delay(loops_per_jiffy);
                        ticks = jiffies - ticks;
                        if (ticks)
                                break;
                }

Its stuck in (tight loop)

	while (ticks == jiffies)
                   /* nothing */;

I have no idea, what this code is supposed to be doing :(
Let me know, what I can do for you.

Thanks,
Badari

