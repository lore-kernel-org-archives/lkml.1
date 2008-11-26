Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbYKZLcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbYKZLcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYKZLcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:32:43 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:51727 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYKZLcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:32:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=aSSXe81JqDbjyVid7kzmHJ2AIFVPjnOJuV7+OetyBfXneHfaK+bPh0pcjAO8h69+FR
         OvqH8CwpqOm5qeytSk/BqbYDWOPCR25LP72cKg+zyI1YsTnQM72s1FsVeWWe/K+tovA9
         mntI2Z0EgFnLoVTV1hZx8TAWqozCtHzybkj2Y=
Message-ID: <c62985530811260332m20a3388dy7bdc1fc15811898d@mail.gmail.com>
Date: Wed, 26 Nov 2008 12:32:41 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/function-return-tracer: set a more human readable output
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811252113270.26424@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492C90E5.8070907@gmail.com> <20081126003936.GA26937@elte.hu>
	 <20081126020459.GA16374@elte.hu>
	 <alpine.DEB.1.10.0811252113270.26424@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/26 Steven Rostedt <rostedt@goodmis.org>:
>
> On Wed, 26 Nov 2008, Ingo Molnar wrote:
>>
>> The changes would be:
>>
>> 1) Compression of non-nested calls into a single line.
>>
>>    Implementing this probably necessiates some trickery with the
>>    ring-buffer: we'd have to look at the next entry as well and see
>>    whether it closes the function call.
>
> The latency_trace file does this already:
>
> You can look into the trace buffer without moving it with:
>
>  entry = ring_buffer_iter_peek(iter->buffer_iter[iter->cpu], &ts);
>
> where, ts will give you the time stamp, it can be NULL if you do not care.
>
> When your print function is called, the item in the ring buffer has
> already been consumed. So the peek will give you the next item in the ring
> buffer.
>>
>> 2) Adding a closing ';' semicolon to single-line calls. It's the C
>>    syntax and i'm missing it :-)
>>
>> 3) The first column: single-character visual shortcuts for "overhead".
>>    This is a concept we used in the -rt tracer and it still lives in
>>    the latency tracer bits of ftrace and is quite useful:
>>
>>     '+' means "overhead spike": overhead is above 10 usecs.
>>     '!' means "large overhead": overhead is above 100 usecs.
>>
>>    These give at-a-glance hotspot analysis - hotspots are easier to
>>    miss as pure numbers.
>
> The latency_trace file has this too. And it uses the above peek to figure
> it out ;-)


That's right, the latency_trace does it. But it is based on a
ring-buffer entry timestamp.
I wanted to use ring-buffer entry timestamp, but it would be hard to
calculate the duration
since the return trace of a function doesn't often follow immediately
its entry trace.
And I can't reuse lat_print_timestamp() because I need the nsec
remaining part....

This is too specific to reuse latency_trace...
