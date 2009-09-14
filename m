Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbZINTeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbZINTeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 15:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZINTeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 15:34:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855AbZINTeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 15:34:05 -0400
Message-ID: <4AAE9B41.3020905@redhat.com>
Date: Mon, 14 Sep 2009 15:36:33 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH tracing/kprobes 4/7] tracing/kprobes: Add event	profiling
 support
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com> <20090911031253.GD16396@nowhere> <4AAA7938.7070200@redhat.com> <20090914030244.GC14306@nowhere> <4AAE7540.9090009@redhat.com> <20090914185540.GD6045@nowhere>
In-Reply-To: <20090914185540.GD6045@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Sep 14, 2009 at 12:54:24PM -0400, Masami Hiramatsu wrote:
>>>> I'd like to have a dispatcher function and flags internally :)
>>>
>>>
>>> You mean kprobes that could support multiple probes?
>>> That would be a nice solution IMHO...
>>
>> Yeah, actually kprobes could support multiple probes on the
>> same point. But kprobe structure has many extensions which
>> kprobe-tracer doesn't need, e.g. post_handler/break_handler,
>> opcode, arch sprcific instructions.
>> Kretprobe consumes more memories for storing return points :(.
>>
>> Thus, if we know there are two functions to be called on the
>> same probe point, I think it is better to have a dispatcher.
>> (Especially, in this case, we can call fixed functions, so
>> it's easier way.)
>
>
> Yeah, you could union the post_handler with profile_handler
> or something like that.

No, you can't do that, because kprobes calls post_handler if
it is not NULL.

>
> It depends if kprobes may need one day to support an undeterminate
> number of probes.

Kprobes itself is supporting those multiple kprobes on the same
address. I meant that we don't need to have multiple kprobes on
the same "kprobe-tracer's event". Even if introducing a dispatcher,
kprobe-tracer can support multiple trace-event at the same location.

> Also, is the post_handler called at the same location than the normal
> probe?

No, post_handler is called after single-stepping.

> And is a post handler called even if there is no normal handler?

Yes, it is.

Hmm, I assume I have told about kprobes infrastructure, and have you
told about kprobe-tracer?:)

> There might be some of such factors that would force you to handle a
> lot of corner cases, things that you wouldn't need to worry about
> if you just had to maintain a simple rcu list of probes to call.


Anyway, I never see who are using post_handler:). I'm not sure why
it is needed...

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

