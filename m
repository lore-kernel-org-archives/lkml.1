Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbYISXfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbYISXfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 19:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYISXfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 19:35:37 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:52667 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbYISXfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:35:36 -0400
Message-ID: <f488382f0809191635o45f3ed17vc23380eab41b2878@mail.gmail.com>
Date: Fri, 19 Sep 2008 16:35:35 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip FIXED] ftrace: add nop tracer
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20080919142326.29834d11.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221818803-9616-1-git-send-email-steven@uplinklabs.net>
	 <20080919142326.29834d11.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 2:23 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 19 Sep 2008 03:06:43 -0700
> Steven Noonan <steven@uplinklabs.net> wrote:
>
>> --- a/kernel/trace/trace.h
>> +++ b/kernel/trace/trace.h
>> @@ -339,6 +339,10 @@ extern int trace_selftest_startup_preemptirqsoff(struct tracer *trace,
>>  extern int trace_selftest_startup_wakeup(struct tracer *trace,
>>                                        struct trace_array *tr);
>>  #endif
>> +#ifdef CONFIG_NOP_TRACER
>> +extern int trace_selftest_startup_nop(struct tracer *trace,
>> +                                      struct trace_array *tr);
>> +#endif
>>  #ifdef CONFIG_CONTEXT_SWITCH_TRACER
>>  extern int trace_selftest_startup_sched_switch(struct tracer *trace,
>>                                              struct trace_array *tr);
>
> Consider omitting the ifdefs around the declarations.
>
> pro: the code looks nicer and is less likely to suffer build errors
> with weird config combinations.
>
> con: build errors are reported at link-time rather than at compile-time.
>
> Personally, I think pro>con here.
>

I merely based this on one of the other tracers, so the ifdefs are
basically copied and renamed.
