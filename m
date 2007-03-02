Return-Path: <linux-kernel-owner+w=401wt.eu-S2992624AbXCBWme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992624AbXCBWme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422692AbXCBWme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:42:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422679AbXCBWmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:42:33 -0500
Message-ID: <45E8A677.7000205@redhat.com>
Date: Fri, 02 Mar 2007 17:34:31 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Bill Irwin <bill.irwin@oracle.com>,
       Christoph Lameter <clameter@engr.sgi.com>, Mel Gorman <mel@skynet.ie>,
       npiggin@suse.de, mingo@elte.hu, jschopp@austin.ibm.com,
       arjan@infradead.org, torvalds@linux-foundation.org, mbligh@mbligh.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
References: <20070301101249.GA29351@skynet.ie>	<20070301160915.6da876c5.akpm@linux-foundation.org>	<45E842F6.5010105@redhat.com>	<20070302085838.bcf9099e.akpm@linux-foundation.org>	<Pine.LNX.4.64.0703020919350.16719@schroedinger.engr.sgi.com>	<20070302093501.34c6ef2a.akpm@linux-foundation.org>	<45E8624E.2080001@redhat.com>	<20070302100619.cec06d6a.akpm@linux-foundation.org>	<Pine.LNX.4.64.0703021012170.17676@schroedinger.engr.sgi.com>	<45E86BA0.50508@redhat.com>	<20070302211207.GJ10643@holomorphy.com>	<45E894D7.2040309@redhat.com>	<20070302135243.ada51084.akpm@linux-foundation.org>	<45E89F1E.8020803@redhat.com> <20070302142256.0127f5ac.akpm@linux-foundation.org>
In-Reply-To: <20070302142256.0127f5ac.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 02 Mar 2007 17:03:10 -0500
> Rik van Riel <riel@redhat.com> wrote:
> 
>> Andrew Morton wrote:
>>> On Fri, 02 Mar 2007 16:19:19 -0500
>>> Rik van Riel <riel@redhat.com> wrote:
>>>> Bill Irwin wrote:
>>>>> On Fri, Mar 02, 2007 at 01:23:28PM -0500, Rik van Riel wrote:
>>>>>> With 32 CPUs diving into the page reclaim simultaneously,
>>>>>> each trying to scan a fraction of memory, this is disastrous
>>>>>> for performance.  A 256GB system should be even worse.
>>>>> Thundering herds of a sort pounding the LRU locks from direct reclaim
>>>>> have set off the NMI oopser for users here.
>>>> Ditto here.
>>> Opterons?
>> It's happened on IA64, too.  Probably on Intel x86-64 as well.
> 
> Opterons seem to be particularly prone to lock starvation where a cacheline
> gets captured in a single package for ever.
> 
>>>> The main reason they end up pounding the LRU locks is the
>>>> swappiness heuristic.  They scan too much before deciding
>>>> that it would be a good idea to actually swap something
>>>> out, and with 32 CPUs doing such scanning simultaneously...
>>> What kernel version?
>> Customers are on the 2.6.9 based RHEL4 kernel, but I believe
>> we have reproduced the problem on 2.6.18 too during stress
>> tests.
> 
> The prev_priority fixes were post-2.6.18

We tested them.  They only alleviate the problem slightly in
good situations, but things still fall apart badly with less
friendly workloads.

>> I have no reason to believe we should stick our heads in the
>> sand and pretend it no longer exists on 2.6.21.
> 
> I have no reason to believe anything.  All I see is handwaviness,
> speculation and grand plans to rewrite vast amounts of stuff without even a
> testcase to demonstrate that said rewrite improved anything.

Your attitude is exactly why the VM keeps falling apart over
and over again.

Fixing "a testcase" in the VM tends to introduce problems for
other test cases, ad infinitum. There's a reason we end up
fixing the same bugs over and over again.

I have been looking through a few hundred VM related bugzillas
and have found the same bugs persist over many different
versions of Linux, sometimes temporarily fixed, but they seem
to always come back eventually...

> None of this is going anywhere, is is it?

I will test my changes before I send them to you, but I cannot
promise you that you'll have the computers or software needed
to reproduce the problems.  I doubt I'll have full time access
to such systems myself, either.

32GB is pretty much the minimum size to reproduce some of these
problems. Some workloads may need larger systems to easily trigger
them.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
