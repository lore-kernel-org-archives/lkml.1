Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbZHXUAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbZHXUAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 16:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZHXUAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 16:00:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbZHXUAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 16:00:51 -0400
Message-ID: <4A92F157.9040709@redhat.com>
Date: Mon, 24 Aug 2009 13:00:23 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v3 2/4] tracing: Make syscall_(un)regfunc arch-specific
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <1250917125-6174-3-git-send-email-jistone@redhat.com> <20090823211422.GG6256@nowhere> <4A92EA8E.8020400@redhat.com> <20090824195759.GA5050@nowhere>
In-Reply-To: <20090824195759.GA5050@nowhere>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2009 12:58 PM, Frederic Weisbecker wrote:
> On Mon, Aug 24, 2009 at 12:31:26PM -0700, Josh Stone wrote:
>> On 08/23/2009 02:14 PM, Frederic Weisbecker wrote:
>>> I really don't like that.
>>> See how the s390 and x86 version of the above code are completely
>>> identical?
>>>
>>> Please put this in kernel/ptrace.c
>>
>> Yes, I see your point, and I think kernel/ptrace.c is a fine place for
>> it.  Making it conditional on CONFIG_TRACEPOINTS and
>> CONFIG_HAVE_FTRACE_SYSCALLS is probably best too, though I think the
>> latter should now be HAVE_SYSCALL_TRACEPOINTS.
> 
> 
> As you prefer, this new name can be indeed more verbose.

Actually, now I'm second-guessing the need to move these at all.  Since
they only make sense for CONFIG_TRACEPOINTS, can't they stay in
kernel/tracepoint.c and just be conditional on HAVE_SYSCALL_TRACEPOINTS?
 The only real change needed is for the tracepoint declarations to also
be conditional.

Josh

