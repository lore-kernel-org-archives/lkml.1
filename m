Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbZJLUTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbZJLUTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758074AbZJLUTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:19:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069AbZJLUTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:19:31 -0400
Message-ID: <4AD39002.2080907@redhat.com>
Date: Mon, 12 Oct 2009 16:22:26 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v3 4/7] tracing/kprobes: Avoid field	name
 confliction
References: <20091007222733.1684.32035.stgit@dhcp-100-2-132.bos.redhat.com> <20091007222807.1684.26880.stgit@dhcp-100-2-132.bos.redhat.com> <20091012173752.GB5059@nowhere> <4AD37FEF.9050807@redhat.com> <20091012194852.GB4748@nowhere>
In-Reply-To: <20091012194852.GB4748@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Oct 12, 2009 at 03:13:51PM -0400, Masami Hiramatsu wrote:
>> Frederic Weisbecker wrote:
>>> The conflict issue might not be obvious for a user desperately trying to set
>>> a kprobe. Even for other failcases, it might not be obvious (blacklisted
>>> symbols, syntax errors...)
>>>
>>> May be should you improve the error granularity and print a KERN_DEBUG
>>> message?
>>
>> Agreed, and kprobes error handling should be improved too (in the most cases,
>> it just returns -EINVAL).
>>
>> Thank you.
>>
>
>
> And btw, I'm enable to create a probe, neither through ftrace nor perf:
>
> 	$ sudo ./perf probe -P 'p:sys_close sys_close $retval'
> 	Adding new event: p:sys_close sys_close+0 $retval
>
> 	Error: Failed to create event: Invalid argument
>
>
> 	# echo 'p:sys_open sys_open $retval'>  /debug/tracing/kprobe_events
> 	bash: echo: write error : Invalid argument
>
> I suspect I missed something very obvious with the syntax :)

Ah, only kretprobe events can use $retval :-)
So, you should specify 'r' instead of 'p'.

-P 'r:sys_close sys_close $retval'


> I've applied your patches in:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/kprobes
>
> Thanks.

Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

