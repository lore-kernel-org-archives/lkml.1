Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbZDICLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbZDICLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 22:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbZDICLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 22:11:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZDICLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 22:11:12 -0400
Message-ID: <49DD5964.8000803@cn.fujitsu.com>
Date: Thu, 09 Apr 2009 10:11:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Whitehouse <swhiteho@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       axboe@kernel.dk, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: Multiple Tracers
References: <1239197703.3359.25.camel@localhost.localdomain> <20090408135312.GR18581@elte.hu> <1239199899.3359.39.camel@localhost.localdomain> <20090408142413.GF12931@elte.hu>
In-Reply-To: <20090408142413.GF12931@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Arnaldo Carvalho de Melo <acme@redhat.com>

Ingo Molnar wrote:
> * Steven Whitehouse <swhiteho@redhat.com> wrote:
> 
>> Hi,
>>
>> On Wed, 2009-04-08 at 15:53 +0200, Ingo Molnar wrote:
>>> * Steven Whitehouse <swhiteho@redhat.com> wrote:
>>>
>>>> Hi,
>>>>
>>>> A little while back I posted a RFC patch which added gfs2 glock 
>>>> tracing to blktrace. There was a suggestion that I should look 
>>>> instead at the generic tracing code and add a new tracer, but I've 
>>>> come up with a couple of issues along the way.
>>>>
>>>> I think from what I can see that its only possible to run a single 
>>>> tracer at once, so running blktrace (for example) would preclude 
>>>> me from also tracing gfs2's glocks at the same time. Also, I can 
>>>> see no mechanism by which I could ensure the sequencing between 
>>>> the blktrace and glock traces other than exporting the blktrace 
>>>> sequence number, even if running multiple tracers at the same time 
>>>> was possible.
>>> There's a recent addition: the EVENT_TRACE() facility. Would that 
>>> suit your purposes?
>>>
>>> 	Ingo
>> If I can get both blktrace and glock trace info from it, then yes. 
>> I thought that the blktrace output went either via the original 
>> relayfs path, or via its own tracer so that it wasn't possible to 
>> use it and the event trace facility at the same time, unless I use 
>> blktrace via relayfs. From what I've read I thought that probably 
>> the relayfs interface for blktrace might eventually be removed in 
>> favour of the generic tracing interface, but I'm not 100% sure of 
>> that, so perhaps someone can confirm the plans in that area?
> 
> Tom Zanussi (Cc:-ed) recently converted the blktrace tracepoints to 

I guess you mean Arnaldo <acme@redhat.com> ;)

> a tracing framework - and i think much of that could be reused to 
> add EVENT_TRACE() tracepoints to blktrace too.
> 
> Tom, what's your take on this?
> 
> In general, this is the direction we want to take: EVENT_TRACE() 
> tracepoints that can be used in a generic way, in any tracer.
> 

Actually we've planed to do this, and for other tracers.

--
Zefan
