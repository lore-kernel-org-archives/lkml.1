Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbZDODkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbZDODkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbZDODkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:40:10 -0400
Received: from smtp-out.google.com ([216.239.33.17]:54459 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbZDODkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:40:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=SnPuYwUAGIdz61fILckLeEjqXoyujX98B8Mj2NmjsqKjdeoZqMqwKbi2P7jina/wU
	yE7TUa1ItYqYbaJ15T8Iw==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904142219570.31421@gandalf.stny.rr.com>
References: <20090414172337.280621613@goodmis.org>
	 <20090414172641.457760734@goodmis.org>
	 <1239736986.22720.266.camel@laptop>
	 <alpine.DEB.2.00.0904142219570.31421@gandalf.stny.rr.com>
Date: Tue, 14 Apr 2009 20:40:02 -0700
Message-ID: <5df78e1d0904142040v3a46ce24m77a4fcea84f92027@mail.gmail.com>
Subject: Re: [PATCH 5/8] tracing/events: move the ftrace event tracing code to 
	core
From: Jiaying Zhang <jiayingz@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Michael Rubin <mrubin@google.com>, Martin Bligh <mbligh@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think merging these structures together can also allow you to move
certain parts of code to the general functions in kernel/trace/trace_events.c
so you don't need to define those functions for individual events.

Jiaying

On Tue, Apr 14, 2009 at 7:25 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 14 Apr 2009, Peter Zijlstra wrote:
>
>> On Tue, 2009-04-14 at 13:23 -0400, Steven Rostedt wrote:
>> > + * static struct trace_event ftrace_event_type_<call> = {
>> > + *     .trace                  = ftrace_raw_output_<call>, <-- stage 2
>> > + * };
>>
>> > + * static struct ftrace_event_call __used
>> > + * __attribute__((__aligned__(4)))
>> > + * __attribute__((section("_ftrace_events"))) event_<call> = {
>> > + *     .name                   = "<call>",
>> > + *     .system                 = "<system>",
>> > + *     .raw_init               = ftrace_raw_init_event_<call>,
>> > + *     .regfunc                = ftrace_reg_event_<call>,
>> > + *     .unregfunc              = ftrace_unreg_event_<call>,
>> > + *     .show_format            = ftrace_format_<call>,
>> > + * }
>>
>> Is there a good reason these are two different structs?
>>
>> I've always wondered about that, it seems natural to unify them and to
>> generalize the reverse lookup hash that is now private to trace_output.
>>
>> The trace_event_profile code could use that reverse lookup, that linear
>> search it currently does it really lame.
>
> Hmm, I'll have to look at that. Of course that means touching these crazy
> macros again ;-)
>
> -- Steve
>
>
