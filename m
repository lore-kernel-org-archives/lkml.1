Return-Path: <linux-kernel-owner+w=401wt.eu-S1031021AbXDPXN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031021AbXDPXN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 19:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030991AbXDPXN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 19:13:29 -0400
Received: from mail23.syd.optusnet.com.au ([211.29.133.164]:48360 "EHLO
	mail23.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031020AbXDPXN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 19:13:28 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: Staircase cpu scheduler v17.1
Date: Tue, 17 Apr 2007 09:13:24 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704170913.24622.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all

Here is the current release of the Staircase cpu scheduler (the original 
generation I design that spurned development elsewhere for RSDL), for 
2.6.21-rc7

http://ck.kolivas.org/patches/pre-releases/2.6.21-rc7/2.6.21-rc7-ck1/patches/sched-staircase-17.1.patch

To remind people where this cpu scheduler fits into the picture:

-It is purpose built with interactivity first and foremost.
-It aims to be mostly fair most of the time
-It is has strong semantics desribing the cpu relationship between different 
nice levels (nice 19 is 1/20th the cpu of nice 0).
-It is resistant to most forms of starvation
-Latency of tasks that are not heavily cpu bound is exceptionally low 
irrespective of nice level -if they stay within their cpu bounds; What this 
means is you can have and audio application if it uses very little cpu 
running at nice 19 and it will still be unlikely to skip audio in the 
presence of a kernel compile nice -20.
-Therefore you can renice X or whatever to your heart's content, but then... 
you don't need to renice X with this design.
-The design is a single priority array very low overhead small codebase (the 
diffstat summary obviously muddied by removing more comments is 4 files 
changed, 418 insertions(+), 714 deletions(-))
4 files changed, 418 insertions(+), 714 deletions(-)

Disadavantages:
-There are heuristics
-There are some rare cpu usage patterns that can lead to excessive unfairness 
and relative starvation.

Bonuses:
With the addition of further patches in that same directory above it has:
- An interactive tunable flag which further increases the fairness and makes 
nice values more absolutely determine latency (instead of cpu usage vs 
entitlement determining latency as the default above)
/proc/sys/kernel/interactive 
- A compute tunable which makes timeslices much longer and has delayed 
preemption for maximum cpu cache utilisation for compute intensive workloads
/proc/sys/kernel/compute 
- A soft realtime unprivileged policy for normal users with a tunable maximum 
cpu usage set to 80% by default
/proc/sys/kernel/iso_cpu
- A background scheduling class that uses zero cpu usage resources if any 
other task wants cpu.

This is unashamedly a relatively unfair slightly starveable cpu scheduler with 
exceptional quality _Desktop_ performance as it was always intended to be. 

It is NOT intended for mainline use as mainline needs a general purpose cpu 
scheduler (remember!). I have no intention of pushing it as such given its 
disadvantages, and don't really care about those disadvantages as I have no 
intention of trying to "plug up" the theoretical exploits and disadvantages 
either since desktops aren't really affected BUT this scheduler is great fun 
to use. Unfortunately the version of this scheduler in plugsched is not up to 
date with this code. Perhaps if demand for plugsched somehow turns the world 
on its head then this code may have a place elsewhere too.

Enjoy! If you don't like it? Doesn't matter; you have a choice so just use 
something else. This is code that will only be in -ck.

-- 
-ck
