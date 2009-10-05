Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZJEVIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZJEVIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZJEVIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:08:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbZJEVIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:08:06 -0400
Message-ID: <4ACA60E9.30404@redhat.com>
Date: Mon, 05 Oct 2009 17:11:05 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
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
Subject: Re: [PATCH tracing/kprobes v2 1/5] tracing/kprobes: Rename special
 variables syntax
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <20091005191829.GA6071@nowhere> <4ACA549F.9010300@redhat.com> <20091005205826.GE6071@nowhere>
In-Reply-To: <20091005205826.GE6071@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Oct 05, 2009 at 04:18:39PM -0400, Masami Hiramatsu wrote:
>> Frederic Weisbecker wrote:
>>> For the function arguments, I guess we don't need to worry
>>> anymore about r0, r1, etc... but we can deal with the true var
>>> name, without any kind of prefixes.
>>
>> This depends on ABI, function argument from ABI doesn't need
>> debuginfo, but it will be unstable on some arch, e.g. x86-32
>> with/without asmlinkage.
>>
>> Thus, I think that we can just describe where function arguments
>> will be(e.g. arg0 is ax) as a note for each architecture
>> in Documents/trace/kprobetrace.txt.
>
>
> Yeah that may help. Although everyone can look at the calling convention
> ABI for a given arch but that would still help.
>
>
>>> What about @return :-) ?
>>
>> Hmm, it might conflict with global symbol... Maybe, we can remove this
>> because retprobe already shows return address in the head of entry.
>
>
> It won't conflict since "return" is a reserved word and can't then be
> used as a symbol.
>
> But yeah, if it's an embeded field, we should remove it.
>
>
>>> What if we take the following:
>>>
>>> [Ftrace and perf probe side]
>>>
>>> %reg = registers, we can also play with deref and offsets like (%esp), 8(%esp), etc.
>>
>> Hmm, on x86-32, sp at intr context is not pointing the top of stack. actually&sp is
>> the real address of the stack :(
>> Perhaps, on x86-32, we can translate %sp to stack address in kprobe-tracer.
>
>
> Oh? You mean in the saved registers while triggering an int 3?

Yes, interrupt/exception handlers don't save sp on x86-32.

>>> arg(n) = arg number, where n is the number
>>
>> How about %N? or just adds a note in documents.
>>
>
>
> Hmm, the problem is that %1, %2, etc. is not very self-explainable.
>
> May be %arg1, %arg2, etc.. But would that sound confusing since we
> have % for registers?

As I sent right now, how about %argumentN ? it will not conflict with
register names...

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

