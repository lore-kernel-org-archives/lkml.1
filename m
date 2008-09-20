Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbYITHeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbYITHeN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 03:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbYITHd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 03:33:58 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:47620 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYITHd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 03:33:58 -0400
Message-ID: <f488382f0809200033x10d43767j95e5958a2715d14c@mail.gmail.com>
Date: Sat, 20 Sep 2008 00:33:56 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH -tip FIXED] ftrace: add nop tracer
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080920061659.GF25713@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221818803-9616-1-git-send-email-steven@uplinklabs.net>
	 <20080919142326.29834d11.akpm@linux-foundation.org>
	 <f488382f0809191635o45f3ed17vc23380eab41b2878@mail.gmail.com>
	 <20080920061659.GF25713@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 11:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Steven Noonan <steven@uplinklabs.net> wrote:
>
>> On Fri, Sep 19, 2008 at 2:23 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > On Fri, 19 Sep 2008 03:06:43 -0700
>> > Steven Noonan <steven@uplinklabs.net> wrote:
>> >
>> >> --- a/kernel/trace/trace.h
>> >> +++ b/kernel/trace/trace.h
>> >> @@ -339,6 +339,10 @@ extern int trace_selftest_startup_preemptirqsoff(struct tracer *trace,
>> >>  extern int trace_selftest_startup_wakeup(struct tracer *trace,
>> >>                                        struct trace_array *tr);
>> >>  #endif
>> >> +#ifdef CONFIG_NOP_TRACER
>> >> +extern int trace_selftest_startup_nop(struct tracer *trace,
>> >> +                                      struct trace_array *tr);
>> >> +#endif
>> >>  #ifdef CONFIG_CONTEXT_SWITCH_TRACER
>> >>  extern int trace_selftest_startup_sched_switch(struct tracer *trace,
>> >>                                              struct trace_array *tr);
>> >
>> > Consider omitting the ifdefs around the declarations.
>> >
>> > pro: the code looks nicer and is less likely to suffer build errors
>> > with weird config combinations.
>> >
>> > con: build errors are reported at link-time rather than at compile-time.
>> >
>> > Personally, I think pro>con here.
>> >
>>
>> I merely based this on one of the other tracers, so the ifdefs are
>> basically copied and renamed.
>
> yeah. Feel free to send a separate patch that implements Andrew's
> clean-up suggestion. I agree that pro>con.
>

How about this patch gets applied to -tip and I submit one that drops
the ifdefs on this and the other tracers?
