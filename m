Return-Path: <linux-kernel-owner+w=401wt.eu-S1761578AbZBNCLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578AbZBNCLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 21:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbZBNCLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 21:11:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:57212 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbZBNCLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 21:11:23 -0500
Message-ID: <49962812.8030902@kernel.org>
Date: Sat, 14 Feb 2009 11:10:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
Subject: Re: #tj-percpu has been rebased
References: <49833350.1020809@kernel.org> <49939964.4070607@kernel.org> <49939B08.1050801@kernel.org> <200902140728.55954.rusty@rustcorp.com.au> <4996141A.1050506@kernel.org> <49962413.9020101@zytor.com>
In-Reply-To: <49962413.9020101@zytor.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 14 Feb 2009 02:10:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

H. Peter Anvin wrote:
> Okay, let's think about this a bit.
> 
> At least for x86, there are two cases:
> 
> - 32 bits.  The vmalloc area is *extremely* constrained, and has the
> same class of fragmentation issues as main memory.  In fact, it might
> have *more* just by virtue of being larger.

We can go for smaller chunks but I don't really see any perfect
solution here.  If a machine is doing 16 way SMP on 32bit, it's not
gonna scale very well anyway.

> - 64 bits.  At this point, we have with current memory sizes(*) an
> astronomically large virtual space.  Here we have no real problem
> allocating linearly in virtual space, either by giving each CPU some
> very large hunk of virtual address space (which means each percpu area
> is contiguous in virtual space) or by doing large contiguous allocations
> out of another range.
> 
> It doesn't seem to make sense to me at first glance to be any advantage
> to interlacing the CPUs.  Quite on the contrary, it seems to utterly
> preclude ever doing PMDs with a win, since (a) you'd be allocating real
> memory for CPUs which aren't actually there and (b) you'd have the wrong
> NUMA associativity.

For (a), we can do hotplug online/offline thing for dynamic areas if
necessary.  (b) why would it have the wrong NUMA associativity?

Thanks.

-- 
tejun
