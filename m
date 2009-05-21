Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbZEUNP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbZEUNP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZEUNPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:15:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35996 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbZEUNPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:15:51 -0400
Date: Thu, 21 May 2009 09:15:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ftrace: Add task_comm support for trace_event
In-Reply-To: <4A14FDFE.2080402@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905210915080.4632@gandalf.stny.rr.com>
References: <4A14FDFE.2080402@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 21 May 2009, Zhaolei wrote:

> If we use trace_event alone(without function trace, .etc),
> it can't output enough task command information.
> 
> Before patch:
>  # echo 1 > debugfs/tracing/events/sched/sched_switch/enable
>  # cat debugfs/tracing/trace
>  # tracer: nop
>  #
>  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>  #              | |       |          |         |
>             <...>-2289  [000] 526276.724790: sched_switch: task bash:2289 [120] ==> sshd:2287 [120]
>             <...>-2287  [000] 526276.725231: sched_switch: task sshd:2287 [120] ==> bash:2289 [120]
>             <...>-2289  [000] 526276.725452: sched_switch: task bash:2289 [120] ==> sshd:2287 [120]
>             <...>-2287  [000] 526276.727181: sched_switch: task sshd:2287 [120] ==> swapper:0 [140]
>            <idle>-0     [000] 526277.032734: sched_switch: task swapper:0 [140] ==> events/0:5 [115]
>             <...>-5     [000] 526277.032782: sched_switch: task events/0:5 [115] ==> swapper:0 [140]
>  ...
> 
> After patch:
>  # tracer: nop
>  #
>  #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>  #              | |       |          |         |
>              bash-2269  [000] 527347.989229: sched_switch: task bash:2269 [120] ==> sshd:2267 [120]
>              sshd-2267  [000] 527347.990960: sched_switch: task sshd:2267 [120] ==> bash:2269 [120]
>              bash-2269  [000] 527347.991143: sched_switch: task bash:2269 [120] ==> sshd:2267 [120]
>              sshd-2267  [000] 527347.992959: sched_switch: task sshd:2267 [120] ==> swapper:0 [140]
>            <idle>-0     [000] 527348.531989: sched_switch: task swapper:0 [140] ==> events/0:5 [115]
>          events/0-5     [000] 527348.532115: sched_switch: task events/0:5 [115] ==> swapper:0 [140]

Heh, this was on my todo list today. Thanks, I'll suck up this patch, if 
Ingo doesn't get to it first. If he does.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
