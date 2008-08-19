Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYHSSPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYHSSPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYHSSP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:15:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62347 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbYHSSP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:15:28 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5364"; a="5666491"
Message-ID: <48AB0DB6.9060802@qualcomm.com>
Date: Tue, 19 Aug 2008 11:15:18 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
References: <20080819103301.787700742@chello.nl> <20080819103844.459178947@chello.nl> <20080819110557.GA18608@elte.hu> <200808192117.52070.nickpiggin@yahoo.com.au> <20080819125954.GA20210@elte.hu>
In-Reply-To: <20080819125954.GA20210@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> [...] Let's retain our API specifications and backwards compatibilty 
>> by default. [...]
> 
> I agree with you that the 1 second default was a bit too tight - and we 
> should definitely change that (and it's changed already).
> 
> So changing the "allow RT tasks up to 10 seconds uninterrupted CPU 
> monopolization" is OK to me - it still keeps runaway CPU loops (which 
> are in the vast majority) debuggable, while allowing common-sense RT 
> task usage.
> 
> But changing that back to the other extreme: "allow lockups by default" 
> is unreasonable IMO - especially in the face of rtlimit that allows 
> unprivileged tasks to gain RT privileges.
> 
> As an experiment try running a 100% CPU using SCHED_FIFO:99 RT task. It 
> does not result in a usable Linux system - it interacts with too many 
> normal system activities. It is a very, very special mode of operation 
> and anyone using Linux in such a way has to take precautions and has to 
> tune things specially anyway. (has to turn off the softlockup watchdog, 
> has to make sure IO requests do not time out artificially, etc.) 
btw The tuning is actually very easy and straightforward ie not so 
special anymore. That's one of the use cases that my cpu isolation work 
was addressing. 2.6.27 will have most of the mechanisms available. All 
the tuning is done by the 'syspart' package:
http://git.kernel.org/?p=linux/kernel/git/maxk/syspart.git;a=summary

> You wont even get normal keyboard or console behavior in most cases.
Only on a single processor system.

> Furthermore, if by "API specifications" you mean POSIX - to get a 
> conformant POSIX run one has to change a lot of things on a typical 
> Linux system anyway. APIs and utilities have to be crippled to be "POSIX 
> compliant".
> 
> In other words: we use common sense when thinking about specifications. 
> The kernel's defaults are about being reasonable by default.
> 
> I have no _strong_ feelings about it, but i dont see the practical value 
> in going beyond 10 seconds - as it turns a rather useful robustness 
> feature off by default (and keeps it untested, etc.).
Same here. I do not mind setting sysctls. At the same time I agree with 
Nick that ideally we should not change the meaning of SCHED_FIFO.

Max
