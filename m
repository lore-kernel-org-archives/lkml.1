Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbZIHSPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbZIHSPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZIHSPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:15:24 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:48033 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022AbZIHSPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:15:23 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-02.arcor-online.net 202223FE166
Message-ID: <4AA69F3A.4090600@arcor.de>
Date: Tue, 08 Sep 2009 21:15:22 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <h81v7t$p6e$1@ger.gmane.org> <20090907110146.GB6393@nowhere>
In-Reply-To: <20090907110146.GB6393@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2009 02:01 PM, Frederic Weisbecker wrote:
> On Mon, Sep 07, 2009 at 06:38:36AM +0300, Nikos Chantziaras wrote:
>> Unfortunately, I can't come up with any way to somehow benchmark all of
>> this.  There's no benchmark for "fluidity" and "responsiveness". Running
>> the Doom 3 benchmark, or any other benchmark, doesn't say anything about
>> responsiveness, it only measures how many frames were calculated in a
>> specific period of time.  How "stable" (with no stalls) those frames were
>> making it to the screen is not measurable.
>
>
> That looks eventually benchmarkable. This is about latency.
> For example, you could try to run high load tasks in the
> background and then launch a task that wakes up in middle/large
> periods to do something. You could measure the time it takes to wake
> it up to perform what it wants.
>
> We have some events tracing infrastructure in the kernel that can
> snapshot the wake up and sched switch events.
>
> Having CONFIG_EVENT_TRACING=y should be sufficient for that.
>
> You just need to mount a debugfs point, say in /debug.
>
> Then you can activate these sched events by doing:
>
> echo 0>  /debug/tracing/tracing_on
> echo 1>  /debug/tracing/events/sched/sched_switch/enable
> echo 1>  /debug/tracing/events/sched/sched_wake_up/enable
>
> #Launch your tasks
>
> echo 1>  /debug/tracing/tracing_on
>
> #Wait for some time
>
> echo 0>  /debug/tracing/tracing_off
>
> That will require some parsing of the result in /debug/tracing/trace
> to get the delays between wake_up events and switch in events
> for the task that periodically wakes up and then produce some
> statistics such as the average or the maximum latency.
>
> That's a bit of a rough approach to measure such latencies but that
> should work.

I've tried this with 2.6.31-rc9 while running mplayer and alt+tabbing 
repeatedly to the point where mplayer starts to stall and drop frames. 
This produced a 4.1MB trace file (132k bzip2'ed):

     http://foss.math.aegean.gr/~realnc/kernel/trace1.bz2

Uncompressed for online viewing:

     http://foss.math.aegean.gr/~realnc/kernel/trace1

I must admit that I don't know what it is I'm looking at :P
