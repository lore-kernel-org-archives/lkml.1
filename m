Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0BWBS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 20:18:29 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:35373
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752181Ab0BWBS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 20:18:28 -0500
X-SpamScore: -29
X-BigFish: VPS-29(zz1432R98dN936eM9371Pab9bhzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B832CD1.3010602@am.sony.com>
Date: Mon, 22 Feb 2010 17:18:09 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to	function_graph
 tracer
References: <4B733721.3030503@am.sony.com> <4B7338BF.1070505@am.sony.com> <20100220144302.GB5354@nowhere> <1266850663.24271.4425.camel@gandalf.stny.rr.com> <20100222181705.GF5055@nowhere>
In-Reply-To: <20100222181705.GF5055@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2010 10:17 AM, Frederic Weisbecker wrote:
> On Mon, Feb 22, 2010 at 09:57:43AM -0500, Steven Rostedt wrote:
>> On Sat, 2010-02-20 at 15:43 +0100, Frederic Weisbecker wrote:
>>>
>>> Instead of having yet another check here, may be should we
>>> have a dedicated stub trace_graph_entry?
>>>
>>>> @@ -254,6 +263,10 @@ static void __trace_graph_return(struct trace_array *tr,
>>>>  	if (unlikely(__this_cpu_read(per_cpu_var(ftrace_cpu_disabled))))
>>>>  		return;
>>>>
>>>> +	if (tracing_thresh &&
>>>> +		(trace->rettime - trace->calltime < tracing_thresh))
>>>> +		return;
>>>> +
>>>
>>>
>>>
>>> And perhaps we can do the same for the return handler?
>>> We could have a trace_graph_return_threshold that
>>> performs the above check and then relies on trace_graph_return.
>>
>> So you mean to register a different type of function to the graph tracer
>> if trace_thresh is enabled? That does sound like a better idea.
> 
> 
> Yeah, this is going to optimize both types of tracing. And I would
> also like to prevent from adding new checks in the common graph
> tracing if possible. User's cpus and cachelines deserve better :)

I'll take a look at doing it this way, and see what I come
up with.  If I can re-use most of trace_graph_entry and
trace_graph_return (and I don't see why not), it should be
a pretty small patch.

 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

