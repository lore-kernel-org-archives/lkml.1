Return-Path: <linux-kernel-owner+w=401wt.eu-S935698AbYBCF7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935698AbYBCF7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 00:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYBCF7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 00:59:00 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:34284 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYBCF67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 00:58:59 -0500
Message-ID: <47A557E3.4080206@qualcomm.com>
Date: Sat, 02 Feb 2008 21:57:55 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       srostedt@redhat.com, ghaskins@novell.com
Subject: Re: Integrating cpusets and cpu isolation [was Re: [CPUISOL] CPU
 isolation extensions]
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>	<1201511305.6149.30.camel@lappy>	<20080128085910.7d38e9f5.pj@sgi.com>	<479E20DA.2080403@qualcomm.com>	<20080128130637.60db148e.pj@sgi.com>	<47A21C53.2010502@qualcomm.com> <20080202001612.98354ff2.pj@sgi.com>
In-Reply-To: <20080202001612.98354ff2.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> Here is the list of things of issues with sched_load_balance flag from CPU isolation 
>> perspective:
> 
> A separate thread happened to start up on lkml.org, shortly after
> yours, that went into this in considerable detail.
> 
> For example, the interaction of cpusets, sched_load_balance,
> sched_domains and real time scheduling is examined in some detail on
> this thread.  Everyone participating on that thread learned something
> (we all came into it with less than a full picture of what's there.)
> 
> I would encourage you to read it closely.  For example, the scheduler
> code should not be trying to access per-cpuset attributes such as
> the sched_load_balance flag (you are correct that this would be
> difficult to do because of the locking; however by design, that is
> not to be done.)
> 
> This thread begins at:
> 
>     scheduler scalability - cgroups, cpusets and load-balancing
>     http://lkml.org/lkml/2008/1/29/60
> 
> Too bad we didn't think to include you in the CC list of that
> thread from the beginning.

Paul, I actually mentioned at the beginning of my email that I did read that thread
started by Peter. I did learn quite a bit from it :)
You guys did not discuss isolation stuff though. The thread was only about scheduling
and my cpu isolation extension patches deal with other aspects. 

Sounds like at this point we're in agreement that sched_load_balance is not suitable
for what I'd like to achieve. But how about making cpusets aware of the cpu_isolated_map ?
Even without my patches it's somewhat of an issue right now. I mean of you use isolcpus= 
boot option to put cpus into null domain, cpusets will not be aware of it. The result maybe 
a bit confusing if an isolated cpu is added to some cpuset.

Max
