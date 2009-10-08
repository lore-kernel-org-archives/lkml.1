Return-Path: <linux-kernel-owner+w=401wt.eu-S932527AbZJHO4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbZJHO4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 10:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932505AbZJHO4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 10:56:16 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:63494 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932437AbZJHO4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 10:56:15 -0400
From: Frans Pop <elendil@planet.nl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for CPU"
Date: Thu, 8 Oct 2009 16:55:36 +0200
User-Agent: KMail/1.9.9
Cc: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
References: <200910051500.55875.elendil@planet.nl> <1254974743.7797.21.camel@marge.simson.net> <20091008064041.67219b13@infradead.org>
In-Reply-To: <20091008064041.67219b13@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910081655.37485.elendil@planet.nl>
X-OriginalArrivalTime: 08 Oct 2009 14:55:37.0241 (UTC) FILETIME=[65358090:01CA4827]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 October 2009, Arjan van de Ven wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Thu, 24 Sep 2009 13:24:16 +0200
> Subject: [PATCH] x86, timers: check for pending timers after (device)
> interrupts
>
> Now that range timers and deferred timers are common, I found a
> problem with these using the "perf timechart" tool.
>
> It turns out that on x86, these two 'opportunistic' timers only
> get checked when another "real" timer happens.
> These opportunistic timers have the objective to save power by
> hitchhiking on other wakeups, as to avoid CPU wakeups by themselves
> as much as possible.

This patch makes quite a difference for me. iwlagn and phy0 now 
consistently show at ~10 ms or lower.

I do still get occasional high latencies, but those are for things like
"[rpc_wait_bit_killable]" or "Writing a page to disk", where I guess you'd 
expect them. Those high latencies are mostly only listed for "Global" and 
don't translate to individual processes.

On Thursday 08 October 2009, Arjan van de Ven wrote:
> On Thu, 08 Oct 2009 13:24:22 +0200 Mike Galbraith <efault@gmx.de> wrote:
> > Latencytop was accounting uninterruptible and interruptible sleep
> > time up to 5ms, which is not the latency the user is looking for.
>
> it is for everything but the scheduler latency!
>
> latencytop wants to show where you're waiting for disk, etc etc.
> that's not "time on runqueue".

The ~10 ms I still get for iwlagn and phy0 (and sometimes higher (~30 ms) 
for others like Xorg and artsd) is still "Scheduler: waiting for cpu'. If 
it is actually due to (un)interuptable sleep, isn't that a misleading 
label? I directly associated that with scheduler latency.

Or are those that are left now real scheduler latencies? The values are now 
low enough that they don't indicate a problem.

Thanks,
FJP

P.S. I may be seeing another issue in the latencytop GUI. Sometimes I see
"fsync() on a file (type 'F' for details)". But typing 'F' only gets me a 
search for a target starting with "F", no details.
