Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYFJR7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYFJR7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYFJR7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:59:30 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9883 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbYFJR73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:59:29 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5314"; a="3643095"
Message-ID: <484EC121.8010806@qualcomm.com>
Date: Tue, 10 Jun 2008 11:00:01 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       mingo@elte.hu, menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: prevent bound kthreads from changing	cpus_allowed
References: <alpine.DEB.1.10.0806051255500.31157@chino.kir.corp.google.com> <20080605152953.dcfefa47.pj@sgi.com> <alpine.DEB.1.10.0806051357480.32537@chino.kir.corp.google.com> <484D99AD.4000306@qualcomm.com> <1213080240.31518.5.camel@twins> <484E9FE8.9040504@qualcomm.com> <20080610170005.GA6038@tv-sign.ru>
In-Reply-To: <20080610170005.GA6038@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Oleg Nesterov wrote:
> On 06/10, Max Krasnyansky wrote:
>> Peter Zijlstra wrote:
>>> Per cpu workqueues should stay on their cpu.
>>>
>>> What you're really looking for is a more fine grained alternative to
>>> flush_workqueue().
>> Actually I had a discussion on that with Oleg Nesterov. If you remember my
>> original solution (ie centralized cpu_isolate_map) was to completely redirect
>> work onto other cpus. Then you pointed out that it's the flush_() that really
>> makes the box stuck. So I started thinking about redoing the flush. While
>> looking at the code I realized that if I only change the flush_() then queued
>> work can get stale so to speak. ie Machine does not get stuck but some work
>> submitted on the isolated cpus will sit there for a long time. Oleg pointed
>> out exact same thing. So the simplest solution that does not require any
>> surgery to the workqueue is to just move the threads to other cpus.
> 
> Cough... I'd like to mention that I _personally agree with Peter, cwq->thread's
> should stay on their cpu.
I never argued against the _should stay_ ;-). What I'm arguing against is the
_must stay_ which is a big difference. I'll start a separate thread on this.

> I just meant that from the workqueue.c pov it is (afaics) OK to move cwq->thread
> to other CPUs, in a sense that this shouldn't add races or hotplug problems, etc.
Yep. That's what I was referring to in the explanation that I send to Peter.

> But still this doesn't look right to me.
Yeah, it's all about perceptions. We'll fix that ;-).

Max

