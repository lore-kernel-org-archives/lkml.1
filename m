Return-Path: <linux-kernel-owner+w=401wt.eu-S933673AbZINVHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673AbZINVHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbZINVHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:07:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757166AbZINVHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:07:34 -0400
Message-ID: <4AAEB149.2070300@redhat.com>
Date: Mon, 14 Sep 2009 17:10:33 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH tracing/kprobes 0/7] tracing/kprobes: kprobe-based	event
 tracer update and perf support
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090911013332.GB16396@nowhere> <4AAA74D2.9060203@redhat.com> <20090914025949.GB14306@nowhere> <4AAE7A5D.8010503@redhat.com> <20090914205250.GG6045@nowhere>
In-Reply-To: <20090914205250.GG6045@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Sep 14, 2009 at 01:16:13PM -0400, Masami Hiramatsu wrote:
>> Frederic Weisbecker wrote:
>>> On Fri, Sep 11, 2009 at 12:03:30PM -0400, Masami Hiramatsu wrote:
>>>> Frederic Weisbecker wrote:
>>>>> May be another step in the todo-list that would be nice: define the format
>>>>> for a type. Like it's done from ftrace events.
>>>>
>>>> Thanks!
>>>>
>>>> BTW, I'm not sure what the type means. Each event already has its own
>>>> event ID and event_call. Could you tell me which part of ftrace I should
>>>> refer to ?
>>>>
>>>
>>>
>>> Actually I meant the format for a field.
>>> Say you define filename=arg1, it would be nice to have
>>>
>>> 	print "%s", filename
>>>
>>> in the format file.
>>
>> Ah, indeed. It is better to support 'type' casting for each argument.
>> I think type casting can be done as below syntax.
>>
>> NAME=ARG:TYPE
>> e.g.
>> jiffies64=@jiffies64:u64
>> message=%ax:str
>>
>
>
> Yeah looks good!
>
>
>
>>> Hmm, now that I think about it, we can't dereference an array...for now :-)
>>
>> :-)
>> BTW, currently, an entry of the array can be shown, e.g. +10(sa).
>> Hmm, for more complex dereference(e.g. accessing a->b[a->c]), it might need
>> another dereferencing syntax(e.g. "sa[16][sa[8]]"), or
>> just allow to use braces(e.g. "+(+8(sa))(+16(sa))").
>
>
> Well, that may be too much complexity.
> I guess if we want multi level dereference, say you want a->b->c
> it should be sufficient to probe the point where b->c gets it's
> value (if any).
>
> But it would be nice to fetch a range: sa[begin:end]
> Or at least just giving the length of the range.

Hmm, I think it is better to treat the range as a type, because
we don't know how to express each entry without the type.

NAME=ARG:TYPE[LEN]
e.g.
regs=sa:u64[16]

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

