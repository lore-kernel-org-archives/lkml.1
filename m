Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbZJ3Auq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbZJ3Auq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZJ3Aup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:50:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbZJ3Auo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:50:44 -0400
Message-ID: <4AEA382C.5080307@redhat.com>
Date: Thu, 29 Oct 2009 20:49:48 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 0/3][RFC] tracing/kprobes: prevent jprobes from crashing
 function graph tracer
References: <20091029205151.852744305@goodmis.org>	 <4AEA10EC.8000103@redhat.com>	 <1256854653.26028.3255.camel@gandalf.stny.rr.com>	 <4AEA23AB.9020605@redhat.com> <1256861174.26028.3261.camel@gandalf.stny.rr.com>
In-Reply-To: <1256861174.26028.3261.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Steven Rostedt wrote:
> On Thu, 2009-10-29 at 19:22 -0400, Masami Hiramatsu wrote:
>> Steven Rostedt wrote:
> 
>>>> I think we can skip those user handlers, because those are irregular
>>>> functions and user can control (enable/disable) it.
>>>
>>> True, but it may be nice to still trace them.
>>
>> Hm, in that case, I think we can change jprobe_return() to call
>> f-g-tracer's return handler if needed as below;
>> ---
>> static inline jprobe_return(void)
>> {
>> 	implicit_function_return();	/* This executes f-g-tracer prologue */
>> 	__jprobe_return();	/* This should be notraced */
>> }
> 
> Hmm, That looks like it can be quite a hack. We don't know at that
> moment if the handler has been traced or not. We can't always do the
> function graph logic.

Ah, right. Perhaps, jprobe might be able to save the address of top
of the stack and check if it has been modified to return_to_handler
at jprobe_return().

But anyway, I think your patch can fix that too. :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

