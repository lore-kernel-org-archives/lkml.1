Return-Path: <linux-kernel-owner+w=401wt.eu-S934278AbZKXVpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278AbZKXVpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934035AbZKXVpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:45:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934015AbZKXVpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:45:24 -0500
Message-ID: <4B0C53ED.8060808@redhat.com>
Date: Tue, 24 Nov 2009 16:45:17 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>, Jason Baron <jbaron@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v3 0/3] tracepoint: Add signal events
References: <20091120213108.14708.97871.stgit@dhcp-100-2-132.bos.redhat.com> <20091123175740.GA15594@elte.hu> <20091124212247.GA11773@redhat.com>
In-Reply-To: <20091124212247.GA11773@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 11/23, Ingo Molnar wrote:
>>
>> * Masami Hiramatsu<mhiramat@redhat.com>  wrote:
>>
>>> Hi,
>>>
>>> These patches add signal related tracepoints including
>>> signal generation, delivery, and loss. First patch also
>>> moves signal-sending tracepoint from events/sched.h to
>>> events/signal.h.
>>>
>>> Changes in v3
>>> - Add Docbook style comments
>>>
>>> Changes in v2
>>> - Add siginfo arguments
>>>
>>> Thank you,
>>>
>>> ---
>>>
>>> Masami Hiramatsu (3):
>>>        tracepoint: Add signal loss events
>>>        tracepoint: Add signal deliver event
>>>        tracepoint: Move signal sending tracepoint to events/signal.h
>>>
>>>
>>>   Documentation/DocBook/tracepoint.tmpl |    5 +
>>>   include/trace/events/sched.h          |   25 -----
>>>   include/trace/events/signal.h         |  173 +++++++++++++++++++++++++++++++++
>>>   kernel/signal.c                       |   27 ++++-
>>>   4 files changed, 198 insertions(+), 32 deletions(-)
>>>   create mode 100644 include/trace/events/signal.h
>>
>> Would be nice to have Roland's and Oleg's Acked-by tags in the patches -
>> to show that this is a representative and useful looking set of signal
>> events.
>
> Sorry, I can't really comment these patches.
>
> I mean, I do not know which info is useful and which is not.
> For example, I am a bit surprized we report trace_signal_lose_info()
> but please do not consider this as if I think we shouldn't. Just I
> do not know.
>
> OTOH, we do not report if __send_signal() fails just because the
> legacy signal is already queued. We do not report who sends the signal,
> we do not report if it was private or shared. zap_process, complete_signal
> can "send" SIGKILL via sigaddset, this won't be noticed. But again, it is
> not that I think this should be reported.
>
> In short: I think any info may be useful, and these patches can help.
> But I do not understand what exactly should be reported to userspace.

Yeah, any comments are welcome:-) IMHO, these tracepoints are just for
providing options for users who care about who sent the signal, etc.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

