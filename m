Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbYLCNTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbYLCNTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbYLCNTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:19:37 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:47634 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbYLCNTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:19:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rQVVRgy+Tm9iCEnK6SKtv246s/WgGyOSbk+/lGaTQj+hdUqLbUlOpz0UDd3nKMVJvq
         yCjPAEJYFfdJMZlcfetVYemPVCh/pXszH7HC5qnwYazFuG1pLP9M2I4NvdhtCnj5pWU9
         mqlSDng9dYu5ymxzb7SSK/rH9Wt5HQmMCPHQk=
Message-ID: <c62985530812030519r5698f3e9gd0e7d0f580c0140@mail.gmail.com>
Date: Wed, 3 Dec 2008 14:19:32 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 4/5] ftrace: function graph return for function entry
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0812030645370.29045@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081203045001.367443457@goodmis.org>
	 <20081203045044.002248353@goodmis.org>
	 <20081203081301.GF21006@elte.hu>
	 <alpine.DEB.1.10.0812030645370.29045@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/3 Steven Rostedt <rostedt@goodmis.org>:
>
> On Wed, 3 Dec 2008, Ingo Molnar wrote:
>
>>
>> * Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> > From: Steven Rostedt <srostedt@redhat.com>
>> >
>> > Impact: feature, let entry function decide to trace or not
>> >
>> > This patch lets the graph tracer entry function decide if the tracing
>> > should be done at the end as well. This requires all function graph
>> > entry functions return 1 if it should trace, or 0 if the return should
>> > not be traced.
>>
>> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
>> > index 47aa5f0..cef05a2 100644
>> > --- a/arch/x86/kernel/entry_64.S
>> > +++ b/arch/x86/kernel/entry_64.S
>> > @@ -119,6 +119,9 @@ ENTRY(mcount)
>> >  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> >     cmpq $ftrace_stub, ftrace_graph_return
>> >     jnz ftrace_graph_caller
>> > +
>> > +   cmpq $ftrace_graph_entry_stub, ftrace_graph_entry
>> > +   jnz ftrace_graph_caller
>>
>> hm, that's in the hotpath. What's the point of this? Do we want some sort
>> of configuration vector that allows per function graphing versus
>> entry-only traces?
>
> Actually, I'm fine with taking it out. But when we register a function
> graph, we register both a entry and exit. I would think it should still
> work if one was still set as the default. Unless we document it someplace
> that either the entry or exit must be set.


I like it that way too. One should choose wether setting a callback on
entry or return or both.
But it makes sense for me that should work with only one...

...unless. Actually setting only a callback on entry shoud better been
done from the ftrace-function-tracer.

> This change has the function graph work if one or the other is set to
> something other than the default.
>
> Also, this is only in the static ftrace path, not dynamic, but then again,
> maybe that means it is even hotter.
>
> I'm fine with pulling this out. It was not really needed, I was just
> trying to make it intuitive.
>
> -- Steve
>
