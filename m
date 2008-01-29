Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbYA2ARQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbYA2ARQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYA2ARB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:17:01 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:54772 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbYA2ARA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:17:00 -0500
Message-ID: <479E6F71.4040906@qualcomm.com>
Date: Mon, 28 Jan 2008 16:12:33 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, Paul Jackson <pj@sgi.com>
Subject: Re: [CPUISOL] CPU isolation extensions
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>	 <1201511305.6149.30.camel@lappy>  <479E1FD4.5040606@qualcomm.com> <1201563706.2826.34.camel@imap.mvista.com>
In-Reply-To: <1201563706.2826.34.camel@imap.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Mon, 2008-01-28 at 10:32 -0800, Max Krasnyanskiy wrote:
>> Just this patches. RT patches cannot achieve what I needed. Even RTAI/Xenomai can't do that.
>> For example I have separate tasks with hard deadlines that must be enforced in 50usec kind 
>> of range and basically no idle time whatsoever. Just to give more background it's a wireless
>> basestation with SW MAC/Scheduler. Another requirement is for the SW to know precise timing
>> because SW. For example there is no way we can do predictable 1-2 usec sleeps. 
>> So I wrote a user-space engine that does all this, it requires full control of the CPU ie minimal
>> overhead from the kernel, just IPIs for memory management and that's basically it. When my legal 
>> department lets me I'll do a presentation on this stuff at Linux RT conference or something. 
> 
> What kind of hardware are you doing this on? 
All kinds of HW. I mentioned it in the intro email.
Here are the highlights
	HP XW9300 (Dual Opteron NUMA box) and XW9400 (Dual Core Opteron)
	HP DL145 G2 (Dual Opteron) and G3 (Dual Core Opteron)
	Dell Precision workstations (Core2 Duo and Quad) 
	Various Core2 Duo based systems uTCA boards
		Mercury AXA110 (1.5Ghz)
		Concurrent Tech AM110 (2.1Ghz)

This scheme should work on anything that lets you disable SMI on the isolated core(s).

> Also I should note there is HRT (High resolution timers) which provided microsecond level
> granularity ..
Not accurate enough and way too much overhead for what I need. I know at this point it probably 
sounds like I'm talking BS :). I wish I've released the engine and examples by now. Anyway let 
me just say that SW MAC has crazy tight deadlines with lots of small tasks. Using nanosleep() & 
gettimeofday() is simply not practical. So it's all TSC based with clever time sync logic between
HW and SW.

Max
