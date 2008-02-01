Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbYBAUZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbYBAUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbYBAUZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:25:22 -0500
Received: from gir.skynet.ie ([193.1.99.77]:46969 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbYBAUZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:25:20 -0500
Date: Fri, 1 Feb 2008 20:25:18 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Gerhard Pircher <gerhard_pircher@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Commit for mm/page_alloc.c breaks boot process on my machine
Message-ID: <20080201202518.GJ18688@csn.ul.ie>
References: <20080201184254.174020@gmx.net> <20080201191119.GI18688@csn.ul.ie> <20080201200518.174050@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080201200518.174050@gmx.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/02/08 21:05), Gerhard Pircher didst pronounce:
> 
> -------- Original-Nachricht --------
> > Datum: Fri, 1 Feb 2008 19:11:19 +0000
> > Von: Mel Gorman <mel@csn.ul.ie>
> > An: Gerhard Pircher <gerhard_pircher@gmx.net>
> > CC: linux-kernel@vger.kernel.org
> > Betreff: Re: Commit for mm/page_alloc.c breaks boot process on my machine
> 
> > With this patch, early boot would use pages from lower PFNs. Without the
> > patch, it would use memory from higher PFNs. That is the only real
> > difference.
> > 
> > 1. Is there any chance that all of your memory is not being properly
> >    initialised?
> Do you mean uninitialized hardware? That shouldn't be a problem, since
> older kernels (e.g. 2.6.19 with platform patches for arch/ppc) are running
> fine.
> 

I meant uninitialised memory but I also wonder could something like this
happen if you are trying to use memory that doesn't exist. i.e. you are
trying to access more memory than you really have but you indicate later
that this is not the case.

> > 2. Any chance of seeing a dmesg log?
> That's a little bit of a problem. The kernel log in memory doesn't show
> any kernel oops, but is also fragmented (small fragments seem to have been
> overwritten with 0x0).

err, that doesn't sound very healthy.

> I could extract it by using the U-boot firmware,
> but that takes some time, as the serial console is not yet working.
> I tried to boot the kernel with 512MB and 1.5GB RAM. The amount of memory
> doesn't have any effect and the amount of memory is reported correctly
> in the kernel log.
> 
> > 3. If you boot with the patch reverted and then do something to consume
> > all memory like build loads of kernel trees simultaneously, do you see
> > any problems?
> Well, I can't answer this question. The kernel currently locks up when
> loading the INIT program. But that is another problem (I still have to
> bisect it) and doesn't seem to be related to this problem.

INIT would be the first MOVABLE allocation so it would be using memory
at the end of the physical adddress range. i.e. the crash happens when
memory towards the end and the only difference between the patch applied
and reverted is when it happens.

Could you try booting with 16MB less memory using mem=?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
