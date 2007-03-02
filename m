Return-Path: <linux-kernel-owner+w=401wt.eu-S1030180AbXCBWE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030180AbXCBWE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030506AbXCBWE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:04:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030180AbXCBWE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:04:26 -0500
Message-ID: <45E89F1E.8020803@redhat.com>
Date: Fri, 02 Mar 2007 17:03:10 -0500
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
References: <20070301101249.GA29351@skynet.ie>	<20070301160915.6da876c5.akpm@linux-foundation.org>	<45E842F6.5010105@redhat.com>	<20070302085838.bcf9099e.akpm@linux-foundation.org>	<Pine.LNX.4.64.0703020919350.16719@schroedinger.engr.sgi.com>	<20070302093501.34c6ef2a.akpm@linux-foundation.org>	<45E8624E.2080001@redhat.com>	<20070302100619.cec06d6a.akpm@linux-foundation.org>	<Pine.LNX.4.64.0703021012170.17676@schroedinger.engr.sgi.com>	<45E86BA0.50508@redhat.com>	<20070302211207.GJ10643@holomorphy.com>	<45E894D7.2040309@redhat.com> <20070302135243.ada51084.akpm@linux-foundation.org>
In-Reply-To: <20070302135243.ada51084.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 02 Mar 2007 16:19:19 -0500
> Rik van Riel <riel@redhat.com> wrote:
>> Bill Irwin wrote:
>>> On Fri, Mar 02, 2007 at 01:23:28PM -0500, Rik van Riel wrote:
>>>> With 32 CPUs diving into the page reclaim simultaneously,
>>>> each trying to scan a fraction of memory, this is disastrous
>>>> for performance.  A 256GB system should be even worse.
>>> Thundering herds of a sort pounding the LRU locks from direct reclaim
>>> have set off the NMI oopser for users here.
>> Ditto here.
> 
> Opterons?

It's happened on IA64, too.  Probably on Intel x86-64 as well.

>> The main reason they end up pounding the LRU locks is the
>> swappiness heuristic.  They scan too much before deciding
>> that it would be a good idea to actually swap something
>> out, and with 32 CPUs doing such scanning simultaneously...
> 
> What kernel version?

Customers are on the 2.6.9 based RHEL4 kernel, but I believe
we have reproduced the problem on 2.6.18 too during stress
tests.

I have no reason to believe we should stick our heads in the
sand and pretend it no longer exists on 2.6.21.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
