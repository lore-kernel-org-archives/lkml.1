Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbZDVJSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbZDVJSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZDVJSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:18:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57746 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbZDVJSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:18:07 -0400
Message-ID: <49EEE104.9050709@cn.fujitsu.com>
Date: Wed, 22 Apr 2009 17:19:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/events: make struct trace_entry->type to be	int
 type
References: <49EEDB0E.5070207@cn.fujitsu.com> <20090422091045.GA6031@nowhere>
In-Reply-To: <20090422091045.GA6031@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Wed, Apr 22, 2009 at 04:53:34PM +0800, Li Zefan wrote:
>> struct trace_entry->type is unsigned char, while trace event's id is
>> int type, thus for a event with id >= 256, it's entry->type is cast
>> to (id % 256), and then we can't see the trace output of this event.
>>
>>  # insmod trace-events-sample.ko
>>  # echo foo_bar > /mnt/tracing/set_event
>>  # cat /debug/tracing/events/trace-events-sample/foo_bar/id
>>  256
>>  # cat /mnt/tracing/trace_pipe
>>            <...>-3548  [001]   215.091142: Unknown type 0
>>            <...>-3548  [001]   216.089207: Unknown type 0
>>            <...>-3548  [001]   217.087271: Unknown type 0
>>            <...>-3548  [001]   218.085332: Unknown type 0
>>
>> [ Impact: fix output for trace events with id >= 256 ]
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> 
> Indeed, now with the trace_events, we are approaching this possible
> overflow and the type is indeed an int:
> 
> struct trace_event *ftrace_find_event(int type)
> 
> Curious: does it only happen with the trace-event-sample?
> I doubt we already reached this threshold of event number.
> But anyway, it's a good thing.
> 

I guess we haven't reached this limit, at least for mainline. :)

And the biggest id is 48 in my config.

> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

