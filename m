Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbYBEAHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbYBEAHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757352AbYBEAHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:07:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:45263 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330AbYBEAHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:07:00 -0500
Subject: Re: Commit for mm/page_alloc.c breaks boot process on my machine
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Gerhard Pircher <gerhard_pircher@gmx.net>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
In-Reply-To: <20080201200518.174050@gmx.net>
References: <20080201184254.174020@gmx.net>
	 <20080201191119.GI18688@csn.ul.ie>  <20080201200518.174050@gmx.net>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 11:06:36 +1100
Message-Id: <1202169996.7079.20.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-01 at 21:05 +0100, Gerhard Pircher wrote:
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

No, it looks more to me like you aren't properly defining the available
memory somewhere, or along those lines. Are you using CONFIG_HIGHMEM ? I
think there have been some issues until recent patches from Kumar, if
you try to reserve memory in the highmem region (though that may not be
your problem).

Or maybe you are colliding with some of the non-coherent hacks ?

> > 2. Any chance of seeing a dmesg log?
> That's a little bit of a problem. The kernel log in memory doesn't show
> any kernel oops, but is also fragmented (small fragments seem to have been
> overwritten with 0x0). I could extract it by using the U-boot firmware,
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

What happens without CONFIG_HIGHMEM ?

Ben.


