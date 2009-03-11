Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZCKM06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZCKM06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZCKM0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:26:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:41492 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285AbZCKM0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:26:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,342,1233561600"; 
   d="scan'208";a="119096722"
Date: Wed, 11 Mar 2009 20:26:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: jack marrow <jackmarrow2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Memory usage per memory zone
Message-ID: <20090311122611.GA8804@localhost>
References: <e2dc2c680903110341g6c9644b8j87ce3b364807e37f@mail.gmail.com> <20090311114353.GA759@localhost> <e2dc2c680903110451m3cfa35d9s7a9fd942bcee39eb@mail.gmail.com> <20090311121123.GA7656@localhost> <e2dc2c680903110516v2c66d4a4h6a422cffceb12e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e2dc2c680903110516v2c66d4a4h6a422cffceb12e2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 02:16:38PM +0200, jack marrow wrote:
> 2009/3/11 Wu Fengguang <fengguang.wu@intel.com>:
> > On Wed, Mar 11, 2009 at 01:51:32PM +0200, jack marrow wrote:
> >> 2009/3/11 Wu Fengguang <fengguang.wu@intel.com>:
> >> > Hi jack,
> >> >
> >> > On Wed, Mar 11, 2009 at 11:41:43AM +0100, jack marrow wrote:
> >> >> Hello,
> >> >>
> >> >> I have a box where the oom-killer is killing processes due to running
> >> >> out of memory in zone_normal. I can see using slabtop that the inode
> >> >
> >> > How do you know that the memory pressure on zone normal stand out alone?
> >>
> >> For the normal zone only, I see "all_unreclaimable: yes" and 3 megs of free ram:
> >>
> >> kernel: Normal free:2576kB min:3728kB low:7456kB high:11184kB
> >> active:1304kB inactive:128kB present:901120kB pages_scanned:168951
> >> all_unreclaimable? yes
> >
> > It's normal behavior.  Linux kernel tries hard to utilize most of
> > the free memory for caching files :)
> 
> With all_unreclaimable = yes is normal?

Ah, perhaps not.

Can you paste /proc/vmstat, /proc/meminfo, /proc/zoneinfo and
/proc/slabinfo? Thank you.

> >
> >> >> caches are using up lots of memory and guess this is the problem, so
> >> >> have cleared them using an echo to drop_caches.
> >> >
> >> > It would better be backed by concrete numbers...
> >> >
> >> >>
> >> >> I would quite like to not guess though - is it possible to use slabtop
> >> >> (or any other way) to view ram usage per zone so I can pick out the
> >> >> culprit?
> >> >
> >> > /proc/zoneinfo and /proc/vmstat do have some per-zone numbers.
> >> > Some of them deal with slabs.
> >>
> >> Thanks, I'll read up on how to interpret these.
> >>
> >> Do you recommend these two files for tracking down memory usage per
> >> process per zone?
> >
> > No, the two interfaces provide system wide counters.  We have the well
> > known tools "ps" and "top" for per-process numbers, hehe.
> 
> ps and top do not have per-zone numbers. How do I get those?

Maybe through the pagemap interface: Documentation/vm/pagemap.txt

Thanks,
Fengguang

