Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbZHUA5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbZHUA5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 20:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZHUA5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 20:57:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbZHUA5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 20:57:44 -0400
Message-ID: <4A8DF197.2080107@redhat.com>
Date: Thu, 20 Aug 2009 21:00:07 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?UTF-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [TOOL] kprobestest : Kprobe stress test tool
References: <20090813203403.31965.20973.stgit@localhost.localdomain> <4A847E30.9050903@redhat.com> <20090820184331.GA6078@nowhere> <4A8DA7CE.2040702@redhat.com> <20090821000108.GC6078@nowhere>
In-Reply-To: <20090821000108.GC6078@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
>> Most of them can be fixed just by adding __kprobes.
>> Some of them which are already in the another section, kprobes
>> should check the symbols are in the section.
>
>
> You mean the blacklist?
>
> I also fear that putting bad kprobed functions into the kprobe
> section or into the blacklist may hide some kprobe internal bugs.
>
> Doing so is indeed mandatory for functions that trigger tracing
> recursion of things like that, but what if kprobe has an internal
> bug that only triggers while probe a certain class of function.
>
> Ie: it would be nice to identify the reason of the crash for
> each culprit in these lists.
 >
 > That may even help to find the others in advance.

Indeed, actually I've found some bugs while making jump-optimization
patches by using this stress test.
But some of them are obviously what we just forget to add __kprobes,
since those will be called from kprobes int3 handling functions.

And also, many lock-related code has been changed. I think
kprobes should use raw_*_lock, or prohibit to probe lock monitoring
functions like lockdep, because it will cause recursive call.

>
> Also kprobes seems to be a very fragile feature (that's what
> this selftest unearthes at least for me).
> And it really needs a recursion detection that stops every kprobing
> while reaching a given threshold of recursion. Something
> that would dump the stack and the falling kprobe structure.

Hmm, kprobes already has recursion detection(kp->nmiss), so
maybe, we can check it.

>
> That would avoid such hard lockups and also help to identify
> the dangerous symbols to probe.
>
>
>
>>> The problem is that I don't have any serial line in this
>>> box then I can't catch any crash log.
>>> My K7 testbox also died in my arms this afternoon.
>>>
>>> But I still have two other testboxes (one P2 and one P3),
>>> hopefully I could reproduce the problem in these boxes
>>> in which I can connect a serial line.
>>
>> Thank you for helping me to find it!
>>
>>> I've pushed your patches in the following git tree:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/fgrederic/random-tracing.git \
>>> 	tracing/kprobes
>>>
>>> So you can send patches on top of this one.
>>
>> Great! I've found another trivial bugs, so I'll fix those on it.
>
> Cool :)
>
> Btw, here is the result of your stress test in a PIII (attaching the log
> and the config).

Thanks, I'll check that.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

