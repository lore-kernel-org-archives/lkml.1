Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbZDQT7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbZDQT7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZDQT7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:59:01 -0400
Received: from gw.goop.org ([64.81.55.164]:59031 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbZDQT7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:59:00 -0400
Message-ID: <49E8DF78.2050203@goop.org>
Date: Fri, 17 Apr 2009 12:58:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/4] tracing: move __DO_TRACE out of line
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-2-git-send-email-jeremy@goop.org> <20090417154640.GB8253@elte.hu> <20090417161005.GA16361@Krystal> <20090417162326.GG8253@elte.hu> <49E8D91F.1060005@goop.org> <20090417194613.GA30544@elte.hu>
In-Reply-To: <20090417194613.GA30544@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Taking __do_trace_sched_switch out of lines inserts this into the 
>> hot path (6 instructions, 31 bytes):
>>
>>        cmpl    $0, __tracepoint_sched_switch+8(%rip)   #, __tracepoint_sched_switch.state
>>        je      .L1748  #,
>>        movq    -136(%rbp), %rdx        # next,
>>        movq    -144(%rbp), %rsi        # prev,
>>        movq    %rbx, %rdi      # rq,
>>        call    __do_trace_sched_switch #
>> .L1748:
>>     
>
> Hm, why isnt this off-line in the function? It's marked unlikely(), 
> isnt it?
>   

Yes, its unlikely().  I don't know why it doesn't move it; I've never 
seen unlikely() do anything useful.

> also, did you investigate the effect on the _instrumented_ function 
> itself? (i.e. the non-tracing related bits) A function call clobbers 
> various registers and creates pressure on gcc to shuffle registers 
> around.
>   

Well, there's a function call in either case, so I don't think it makes 
much difference.

    J
