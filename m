Return-Path: <linux-kernel-owner+w=401wt.eu-S932320AbZJSWxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbZJSWxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 18:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbZJSWxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 18:53:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962AbZJSWxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 18:53:08 -0400
Message-ID: <4ADCEE1B.40003@redhat.com>
Date: Mon, 19 Oct 2009 18:54:19 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf
 	probe and kprobe-tracer bugfixes
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com> <20091019075103.GF17960@elte.hu> <20091019110055.GA5549@nowhere> <20091019112125.GA12829@elte.hu> <4ADCC348.2020800@redhat.com>
In-Reply-To: <4ADCC348.2020800@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Ingo Molnar wrote:
>> For example you might want to probe the point within schedule that calls
>> switch_mm() - this could be done via:
>>
>>    perf probe schedule@switch_mm
>>
>> Or the point where 'next' gets assigned? Sure, you dont need to even
>> open the editor, if you know the rough outline of the function you can
>> probe it via:
>>
>>    perf probe schedule@'next ='
>>
>> Note that i was able to specify both probes without having opened an
>> editor - just based on the general knowledge of the scheduler.
> 
> It may be useful for return probe too :-)
> 
>  perf probe schedule@return

Hmm, IMHO,

>>    perf probe schedule@switch_mm

might be confused as 'probe schedule() called from switch_mm()'.

BTW, there might be several local/inline functions which have
same name.
I think we'd better provide a syntax for solving this issue.
And current syntax uses @ for this purpose as below.

 perf probe localfunc@file

Maybe, we still can use % for special matching,

 perf probe schedule%switch_mm

These can be combined with each other, as below.

 perf probe schedule@kernel/sched.c%switch_mm

Or, supporting lazy string pattern matching
 (reusing glob matching in ftrace?)

 perf probe schedule:'switch_mm(*);'

Just my thought.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

