Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbZIHNl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbZIHNl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 09:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbZIHNl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 09:41:58 -0400
Received: from nbd.name ([88.198.39.176]:48920 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbZIHNl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 09:41:58 -0400
X-Greylist: delayed 1921 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Sep 2009 09:41:58 EDT
Message-ID: <4AA6579C.2080607@openwrt.org>
Date: Tue, 08 Sep 2009 15:09:48 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Michael Buesch <mb@bu3sch.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu>	 <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu>	 <20090908074825.GA11413@elte.hu> <1252403400.4950.81.camel@pasglop>
In-Reply-To: <1252403400.4950.81.camel@pasglop>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Tue, 2009-09-08 at 09:48 +0200, Ingo Molnar wrote:
>> So either your MIPS system has some unexpected dependency on the 
>> scheduler, or there's something weird going on.
>> 
>> Mind poking on this one to figure out whether it's all repeatable 
>> and why that slowdown happens? Multiple attempts to reproduce it 
>> failed here for me.
> 
> Could it be the scheduler using constructs that don't do well on MIPS ? 
> 
> I remember at some stage we spotted an expensive multiply in there,
> maybe there's something similar, or some unaligned or non-cache friendly
> vs. the MIPS cache line size data structure, that sort of thing ...
> 
> Is this a SW loaded TLB ? Does it misses on kernel space ? That could
> also be some differences in how many pages are touched by each scheduler
> causing more TLB pressure. This will be mostly invisible on x86.
The TLB is SW loaded, yes. However it should not do any misses on kernel
space, since the whole segment is in a wired TLB entry.

- Felix
