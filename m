Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbYKMXsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbYKMXsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYKMXsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:48:16 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:23383 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYKMXsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:48:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bw+HSsEcKE+XHLGFrBRRyCFbTIqZ8aQzLXcQMowBYs3GF8QpexoD9KwYxaqJySsf7Q
         2WFKa9JMu0YHicg0kAp/zlsZfWnUwNZ93Okg4yayrREebv/6vpuXvz9Yii9LMWXfJXWW
         q8EbV7Cib/V+zqnyTPmrr1fBYuT7SbHX5njQY=
Message-ID: <c62985530811131548i176af7e4k2d3b8300f7c425f@mail.gmail.com>
Date: Fri, 14 Nov 2008 00:48:14 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tracing/function-return-tracer: Call prepare_ftrace_return by registers
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081113100938.GA24602@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <491B4F63.3090909@gmail.com> <20081112221623.GB6125@elte.hu>
	 <c62985530811121422w6d33de3cp506bdf1aa96efd81@mail.gmail.com>
	 <alpine.DEB.1.10.0811121824380.21116@gandalf.stny.rr.com>
	 <c62985530811121535t13a60c93y9e4c22e365ca1b34@mail.gmail.com>
	 <alpine.DEB.1.10.0811121911340.30248@gandalf.stny.rr.com>
	 <20081113085949.GG25479@elte.hu> <20081113091454.GH25479@elte.hu>
	 <c62985530811130202r7721c927w58beb34ec92c34f7@mail.gmail.com>
	 <20081113100938.GA24602@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/13 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> That's right, it's much more better for the eyes. I didn't want to
>> output such a disposition from the kernel because I thought that
>> would result in too much strings work from kernel-space. But
>> actually, as you suggest,
>>  if I append a depth field in the trace that could be easy and not
>> so costly. I just have a last thought about post-processing parsing.
>> Would it make it harder for that?
>
> humans are the priority targets for tracer output - tools are a
> distant second target. Whatever is nice for humans is also usually
> easy to process via tools. A tool can set an option flag just fine.
>
> To help tooling, add a trace_options flag for more predictable/faster
> output. We already have the binary output format for example.
>
>> Why not a flag that could be set through iter_ctrl (which has
>> changed its name yesterday) and that could let the user to choose
>> its output? That's where I renew my proposition to make the tracers
>> able to propose custom flags for this file with a new callback such
>> as tracer_ctrl, or tracer_opt.
>
> yes, your proposal is fine.
>
>> But as you say, why not set it through a flag.
>
> yes - and make the defaults for flags favor human visual parsing.
>
>> > Easiest would be to add a depth field to the trace entry as well, to
>> > make sure we get the right depth in the end, even if we somehow mix up
>> > the trace entries.
>>
>> Yeah, that's good! I will just have to output "\t" * depth to have
>> the correct indentation.
>
> i'd suggest spaces for the function indentation, because we'll also
> have quite deep call stacks in practice.
>
> and i'd suggest you flip around the cost field to something like:
>
>  [...]
>               getnstimeofday() {
>                set_normalized_timespec() {
>                 clocksource_read() {
>  ( 1547 ns)       acpi_pm_read()
>  ( 1951 ns)      } clocksource_read()
>  ( 2200 ns)     } set_normalized_timespec()
>  ( 2354 ns)    } getnstimeofday()
>
> that makes it fixed-width up to the inevitable variable-length field,
> the function name.
>
>        Ingo
>

Ok, I will add all of these in my workqueue. Thanks :)
