Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZJEQ4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZJEQ4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 12:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbZJEQ4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 12:56:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbZJEQ4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 12:56:17 -0400
Message-ID: <4ACA25D5.10703@redhat.com>
Date: Mon, 05 Oct 2009 12:59:01 -0400
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
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com>
In-Reply-To: <4AC830F0.2010003@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
>> On Fri, Oct 02, 2009 at 05:48:42PM -0400, Masami Hiramatsu wrote:
>>>    FETCHARGS	: Arguments. Each probe can have up to 128 args.
>>>     %REG	: Fetch register REG
>>> -  sN	: Fetch Nth entry of stack (N>= 0)
>>> -  sa	: Fetch stack address.
>>>     @ADDR	: Fetch memory at ADDR (ADDR should be in kernel)
>>>     @SYM[+|-offs]	: Fetch memory at SYM +|- offs (SYM should be a data symbol)
>>> -  aN	: Fetch function argument. (N>= 0)(*)
>>> -  rv	: Fetch return value.(**)
>>> -  ra	: Fetch return address.(**)
>>> +  $sN	: Fetch Nth entry of stack (N>= 0)
>>> +  $sa	: Fetch stack address.
>>> +  $aN	: Fetch function argument. (N>= 0)(*)
>>> +  $rv	: Fetch return value.(**)
>>> +  $ra	: Fetch return address.(**)
>>
>>
>>
>> I feel uncomfortable with that, because of bash scripts that
>> may use it and always need to escape it with antislashes or
>> use single quotes for it to not be replaced by a random variable
>> value. If one uses double quotes without antislashes to protect
>> the command line, the result is unpredictable, depending of
>> the current set of variables...
>>
>> May be we can use # instead of $ ? That's a kind of pity because
>> $ suggested a variable whereas # suggests a constant, we are then
>> losing this self-explainable characteristic for kprobes
>> "specific variable fetchs". But that will work without ambiguity.
>
> Hmm, # is widely used for comment, including some kernel pseudo
> file interfaces, kprobe_events too. Comments are useful if a
> probe list is restored from a file.
>
> For accessing local variables, kprobe-tracer needs to support *at least*
> below variables:
> - Registers
> - Stack address (if a register points stack address, this isn't needed)
>
> Below special vars are complementary aliases.
> - Function arguments
> - Return value
> - Return address
>
> and I'd like perf-probe to have a transparent syntax with kprobe-tracer.
>
> This means, if we can remove special vars except registers, or rename it
> non-conflictable name with registers, we just need to separate name spaces
> of
> - Regsiters
> - Local variables
>
> Here, local variables will support fields of data structs, and it will
> use '->' expression. Since'>' means redirection in bash, local variables
> need to be *escaped* in this case. Thus, I think we can use '$' prefix
> for it. (I'm OK, because this is similar syntax to systemtap:-).
>
> So, if you don't like %regs, $svars and locals, we can use regs and $locals :-)

As far as I can see in arch/*/include/asm/ptrace.h, all registers start with
alphabets :-). So, I'd like to suggest renaming sp-vars to '_sp-vars'.

Then, we will have;
- $local-vars
- @global-symbol
- regs
- _sp-vars
- +|-Offs(ARG)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

