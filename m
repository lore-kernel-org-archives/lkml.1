Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbYB2SY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbYB2SY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYB2SYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:24:21 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42349 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbYB2SYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:24:20 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5242"; a="1030531"
Message-ID: <47C84DCD.5040803@qualcomm.com>
Date: Fri, 29 Feb 2008 10:24:13 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 1/2] add ALL_CPUS option to stop_machine_run()
References: <20080202210828.840735763@polymtl.ca> <20080202211204.268876860@polymtl.ca> <20080226225242.GA15926@redhat.com> <20080227190519.GA14335@Krystal> <20080228163303.GA6195@redhat.com> <47C73121.2000109@qualcomm.com> <20080229090050.GA19519@elte.hu>
In-Reply-To: <20080229090050.GA19519@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Max Krasnyanskiy <maxk@qualcomm.com> wrote:
> 
>>> -allow stop_mahcine_run() to call a function on all cpus. Calling 
>>> stop_machine_run() with a 'ALL_CPUS' invokes this new behavior.
>>>  stop_machine_run() proceeds as normal until the calling cpu has 
>>>  invoked 'fn'. Then, we tell all the other cpus to call 'fn'.
>> Jason, we're actually trying to reduce the usage of the stop_machine 
>> in general. [...]
> 
> please talk in your own name. Stop-machine is a very elegant tool that 
> simplifies a lot of hard things in the kernel and is reasonably fast as 
> well. We've just recently added two new usages of it and more are 
> planned.
> 
> _you_ might be the one who wants to 'reduce the usage of stop_machine' - 
> but that means it is _you_ who first has to convert a number of very 
> difficult pieces of code to "something else".
Sure I started the discussion but I suppose you missed Andi's and other 
replies. All I said that people should think twice before relying on it.
btw I'm ok if I _am_ the _one_ who has to convert those pieces of code, that's 
part of the fun :). But if people keep adding stuff which uses stom_machine 
that may be pretty difficult :).

btw Being an RT guy you do not think that stop machine is evil ? I mean from 
the overhead and especially latency perspective. By overhead I mean if you 
have 100+ cpu box that Paul and other guys have mentioned here. Every single 
CPU has to be frozen. You said it's reasonably fast. I guess it depends what's 
reasonable. And from the latency perspective all bets are off. We have no 
guaranties whatsoever as to hold long it will take for cpu X to get frozen 
(there numerous factors here) and all the other cpus have to wait for it.
As I said for some things there is just no other way but to use the 
stop_machine but we should try to minimize that as much as possible.

Max

