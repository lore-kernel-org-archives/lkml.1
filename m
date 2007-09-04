Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbXIDM7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbXIDM7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 08:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbXIDM7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 08:59:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbXIDM7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 08:59:45 -0400
Message-ID: <46DD56BD.2070902@redhat.com>
Date: Tue, 04 Sep 2007 08:59:41 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Xu Yang <risingsunxy@googlemail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: mutex vs cache coherency protocol(for multiprocessor )
References: <ab40e9c0709031057y195467c7y63f74b753218b618@mail.gmail.com>
In-Reply-To: <ab40e9c0709031057y195467c7y63f74b753218b618@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xu Yang wrote:
> Hello everyone,
> 
> Just got a rough question in my head.
> 
> don't know whether anyone interested .
> 
> mutex vs cache coherency protocol(for multiprocessor)
> 
> both of these two can be used to protect shared resource in the memory.
> 
> are both of them necessary?
> 
> for example:
> 
> in a multiprocessor system, if there is only mutex no cache coherency.
> obviously this would cause problem.
> 
> what about there is no mutex mechanism, only cache coherency protocol
> in multiprocessor system? after consideration, I found this also could
> casue problem, when the processors are multithreading processors,
> which means more than one threads can be running on one processor. in
> this case if we only have cache coherency and no mutex, this would
> cause problem. because all the threads running on one processor share
> one cache, the cache coherency protocol can not be functioning
> anymore. the shrared resource could be crashed by different threads.
> 
> then if all the processors in the multiprocessor system are sigle
> thread processor, only one thread can be running one one processor. is
> it ok, if we only have cache coherency protocol ,no mutex mechanism?
> 
> anyone has any idea? all the comments are welcome and appreciated,
> including criticism.

Cache coherency is necessary for SMP locking primitives (and thus Linux SMP 
support), but it is hardly sufficient.  Take a look at all the exciting inline 
assembly in include/asm/ for spinlocks, atomic operations, etc.

	-- Chris
