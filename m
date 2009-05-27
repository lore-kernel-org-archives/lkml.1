Return-Path: <linux-kernel-owner+w=401wt.eu-S1759768AbZE0FTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768AbZE0FTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758658AbZE0FTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:19:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61235 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755763AbZE0FTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:19:30 -0400
Message-ID: <4A1CCD84.2040607@cn.fujitsu.com>
Date: Wed, 27 May 2009 13:20:04 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@elte.hu, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       kosaki.motohiro@jp.fujitsu.com, Steven Rostedt <rostedt@goodmis.org>,
       fweisbec@gmail.com
Subject: Re: [PATCH 0/3] ftrace: add tracepoint for timer event
References: <4A1673AF.30508@cn.fujitsu.com> <alpine.LFD.2.00.0905262320330.1762@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905262320330.1762@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Thomas Gleixner wrote:
> On Fri, 22 May 2009, Xiao Guangrong wrote:
>> We already have debugobject in timer to init/activate/deactivate/free,
>> but it can't be covered function of there tracepoints, because:
>> 1: We can't get timer's lifecycle information in userspace by debugobject,
>>    it is necessary for system engineer to investigate system trouble caused
>>    by using timer.
>> 2: We can't get information of whole lifecycle of timer by debugobject, 
>>    for example, deactivation of a timer.
>> 3: There are many different tracing code in many kernel subsystem as
>>    blktrace, debugobject, and tracepoint is designed as generic way
>>    to unify these tracing way.
> 
> No. You can not unify debugobject into tracepoints. debugobjects is a
> totally different beast. It's main purpose is to prevent undebugable
> system crashes which we have seen several times e.g: freeing of an
> active timer, reinitializing of an active timer ...
> 
> Dealing with these problems is not covered by tracepoints by any
> means. The trace point does not prevent the system crash which happens
> 2 seconds after the fact that an active timer is kfree'd, debugobject
> does and it points you to the exact place where the shit happens.
> 
> I'm not opposed to add tracepoints to the timer code at all. In fact I
> appreciate that, but your idea of substituting debugobjects with
> tracing is just plain wrong.
> 
> It's the other way round. tracing can reuse the existing debugobject
> hooks to insert trace points, but it can not replace the functionality
> at all.
> 

Hello tglx:
Thanks for you review!

Totally agree.
Actually I do know the difference between debugobject and tracepoint. Sorry
for making you misunderstand what I said for my pool English.

Thanks,
Xiao Guangrong

> 	tglx
> 
> 
