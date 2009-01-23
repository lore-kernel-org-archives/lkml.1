Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZAWKgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZAWKgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbZAWKgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:36:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:24147 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbZAWKgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:36:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IYQtIGENuI1L3nMXW8LyHevPrl6IN42WWreL+X39y/Ag2AaNJ7rrDW9u1H26jJWvF0
         mw24rkfeXCjeeBeOAZLTOhzX1p0avT8dPT1jQpy3mNVLpMzD8A8AT7mSjXP2439sUg4B
         8i2h7YPj25dZMPPqKQK5ykU9N+cMYK8wQx/xg=
MIME-Version: 1.0
In-Reply-To: <20090123101949.GD15188@elte.hu>
References: <497917b5.09cc660a.5f4c.ffffc568@mx.google.com>
	 <20090123101949.GD15188@elte.hu>
Date: Fri, 23 Jan 2009 11:36:38 +0100
Message-ID: <c62985530901230236v4a8f5d6od80924cb6542d994@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] tracing/function-graph-tracer: various fixes and 
	features
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/23 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>>
>> This patch brings various bugfixes:
>>
>> _ Drop the first irrelevant task switch on the very beginning of a trace.
>> _ Drop the OVERHEAD word from the headers, the DURATION word is sufficient and will not
>>   overlap other columns.
>> _ Make the headers fit well their respective columns whatever the selected options.
>
>> About features, one can now disable the duration (this will hide the
>> overhead too for convenient reasons and because on doesn't need overhead
>> if it hasn't the duration
>
> very nice! I've applied this to tip/tracing/function-graph-tracer, thanks
> Frederic!
>
> this:
>
>> I guess no one needs the nanosec precision here, the main goal is to
>> find when happened the events on a cpu when the trace switches from one
>> cpu to another.
>>
>> ie:
>>
>>   274.874760 |   1)   0.676 us    |      _spin_unlock();
>>   274.874762 |   1)   0.609 us    |      native_load_sp0();
>>   274.874763 |   1)   0.602 us    |      native_load_tls();
>>   274.878739 |   0)   0.722 us    |                  }
>>   274.878740 |   0)   0.714 us    |                  native_pmd_val();
>>   274.878741 |   0)   0.730 us    |                  native_pmd_val();
>>
>> Here there is a 4000 usecs difference when we switch the cpu.
>
> Still needs a solution - if we do cross-CPU traces we want to have a
> global trace clock with 'seemless' transition between CPUs.
>
>        Ingo
>

So it doesn't only need a monotonic clock. It needs a global
consistent clock like ktime for example?
Unfortunately this one uses seq_locks and would add some drawbacks
like verifying if the traced
function doesn't hold the write seq_lock and it will bring some more
ftrace recursion...
