Return-Path: <linux-kernel-owner+w=401wt.eu-S1751779AbZIKHEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbZIKHEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbZIKHEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:04:48 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:51179 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100AbZIKHEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:04:48 -0400
From: Frans Pop <elendil@planet.nl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [long] Another BFS versus CFS shakedown
Date: Fri, 11 Sep 2009 09:04:49 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jens Axboe <jens.axboe@oracle.com>
References: <200909090142.41738.elendil@planet.nl> <20090911062032.GB27833@elte.hu>
In-Reply-To: <20090911062032.GB27833@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909110904.50487.elendil@planet.nl>
X-OriginalArrivalTime: 11 Sep 2009 07:04:50.0745 (UTC) FILETIME=[27D50290:01CA32AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 September 2009, Ingo Molnar wrote:
> Note, the one you used was a still buggy version of latt.c producing
> bogus latency numbers - you will need the fix to it attached below.

Yes, I'm aware of that and have already copied Jens' latest version.

> Furthermore, the following tune might be needed on mainline to make
> it produce consistently good max numbers (not just good averages):
>
>    echo 0 > /proc/sys/kernel/sched_wakeup_granularity_ns

Ack. I've seen the patches to change some defaults floating by.
Hmmm. I think the proposed new default for my system is 2ms with 2 CPUs?

I will not test against TIP at this time, but I plan to do the following:
- repeat my tests now using vanilla 2.6.31 for both BFS and CFS
  This will provide a baseline to verify improvements.
- do two additional runs with CFS with some modified tunables
- do one more run probably when .32-rc2 is out
  I'd expect that to have the scheduler fixes, while the worst post-merge
  issues should be resolved.

I also have a couple of ideas for getting additional data. I'll post my 
results as follow-ups.

I'm very impressed with the responses to the issues that have been raised, 
but I think we do owe Con a huge thank you for setting off that process.

I also think there is a lot to be said for having a very straightforward 
alternative scheduler available for baseline comparisons. It's much 
easier to come out and say "something's broken" if you know some latency 
issue is not due to buggy hardware or applications or orange bunnies with 
a cosmic ray gun. I'll not go into the question whether such a scheduler 
should be in mainline or not.

Cheers,
FJP
