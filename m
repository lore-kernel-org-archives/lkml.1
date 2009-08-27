Return-Path: <linux-kernel-owner+w=401wt.eu-S1751330AbZH0R3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbZH0R3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbZH0R3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:29:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbZH0R3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:29:23 -0400
Message-ID: <4A96C345.3060505@redhat.com>
Date: Thu, 27 Aug 2009 13:32:53 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] tracing/kprobes: Add dynamic tracepoints +	instruction
 decoder
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <4A969F96.2020107@redhat.com> <20090827152539.GE6058@nowhere>
In-Reply-To: <20090827152539.GE6058@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Aug 27, 2009 at 11:00:38AM -0400, Masami Hiramatsu wrote:
>> Frederic Weisbecker wrote:
>>> Ingo,
>>>
>>> This is the kprobes tracing pile of patches. I've tested it
>>> successfully by setting some kprobes through debugfs by hand.
>>>
>>> It brings no known regressions.
>>>
>>> However, the stress test provided by Masami have revealed some
>>> unstable points. Some symbols are unsafe to probe and raise
>>> probing recursion.
>>>
>>> I've added a tiny patch in the series that helps identifying the
>>> kprobe that has raised such situation.
>>> For example it has learned me today that it's unsafe to trace
>>> ret_from_exception() (obviously: it's on the int 3 handler path).
>>
>> Thank you, Frederic.
>>
>> I'm currently fixing those problems on x86-64 (on kvm).
>> I'll also check it on x86-32, and fix it.
>>
>> Thanks
>
>
>
> Cool.
> Don't hesitate to interate through small patches that fix these
> sites.
>
> So that I can continue to test it over time and report you what I find,
> may be I can try to fix some of them too.
>
> I haven't fixed ret_from_exception because I wasn't sure about the
> right thing to do: putting it in the kprobes section or blacklist its
> name. It's a bit more delicate to put assembly code into sections so... :)

It depends on implementation, but I think blacklist is the last resort. :)
AFAIK, some assembly codes are already pushed into kprobes section.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

