Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZIKOz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZIKOz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZIKOz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:55:27 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:50287 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZIKOz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C7PerreuAcY8HI3bNEeZcv/K/U7PrzaqJBUZyEQStSIeoHqFrS5YNJfinT5iRPriAF
         qyeAjMLRDE8OqoS8a+s/DFEcQ0/pIF1I8FC+ov1Gi0Z2v8C5l3kfGXIrT7GMjTNfPSAy
         0Gr9MsQFeyGHfnZVDGKN8ixFjaVwgzdQrDFys=
Date: Fri, 11 Sep 2009 16:55:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [PATCH 3/3] tracing: add latency format to function_graph
	tracer
Message-ID: <20090911145521.GA6119@nowhere>
References: <20090911135452.866274568@goodmis.org> <20090911135626.824079836@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911135626.824079836@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 09:54:55AM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> While debugging something with the function_graph tracer, I found the
> need to see the preempt count of the traces. Unfortunately, since
> the function graph tracer has its own output formatting, it does not
> honor the latency-format option.
> 
> This patch makes the function_graph tracer honor the latency-format
> option, but still keeps control of the output. But now we have the
> same details that the latency-format supplies.
> 
>  # tracer: function_graph
>  #
>  #      _-----=> irqs-off
>  #     / _----=> need-resched
>  #    | / _---=> hardirq/softirq
>  #    || / _--=> preempt-depth
>  #    ||| /
>  #    ||||
>  # CPU||||  DURATION                  FUNCTION CALLS
>  # |  ||||   |   |                     |   |   |   |
>   3)  d..1  1.333 us    |        idle_cpu();
>   3)  d.h1              |        tick_check_idle() {
>   3)  d.h1  0.550 us    |          tick_check_oneshot_broadcast();
>   3)  d.h1              |          tick_nohz_stop_idle() {
>   3)  d.h1              |            ktime_get() {
>   3)  d.h1              |              ktime_get_ts() {
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Great!! Thanks a lot!
That was in my todo list :-)

Oh, BTW, what would you think about addding the current->lock_depth
in the latency format? That may help debug the bkl...


