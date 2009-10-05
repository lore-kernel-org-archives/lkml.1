Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZJEU7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZJEU7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbZJEU7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:59:11 -0400
Received: from mail-ew0-f213.google.com ([209.85.219.213]:42829 "EHLO
	mail-ew0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbZJEU7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fmr4AztzRLLHZwWK+nlq+oLv0r3K53UNKenxUwP9Z4pK0qE7fz8X4PiGqY/9Y3XRso
         zmeK1E/C1oy76xlu56XmeXeAGzg7UyiMg67IDddEcPeGf7OZ+mB2edS0k/FbFSNTRXDa
         ivlA2FgZr0lsLjSx+NBQjEJkuFbujEQxiB/9U=
Date: Mon, 5 Oct 2009 22:58:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20091005205826.GE6071@nowhere>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <20091005191829.GA6071@nowhere> <4ACA549F.9010300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACA549F.9010300@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 04:18:39PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
>> For the function arguments, I guess we don't need to worry
>> anymore about r0, r1, etc... but we can deal with the true var
>> name, without any kind of prefixes.
>
> This depends on ABI, function argument from ABI doesn't need
> debuginfo, but it will be unstable on some arch, e.g. x86-32
> with/without asmlinkage.
>
> Thus, I think that we can just describe where function arguments
> will be(e.g. arg0 is ax) as a note for each architecture
> in Documents/trace/kprobetrace.txt.


Yeah that may help. Although everyone can look at the calling convention
ABI for a given arch but that would still help.


>> What about @return :-) ?
>
> Hmm, it might conflict with global symbol... Maybe, we can remove this
> because retprobe already shows return address in the head of entry.


It won't conflict since "return" is a reserved word and can't then be
used as a symbol.

But yeah, if it's an embeded field, we should remove it.


>> What if we take the following:
>>
>> [Ftrace and perf probe side]
>>
>> %reg = registers, we can also play with deref and offsets like (%esp), 8(%esp), etc.
>
> Hmm, on x86-32, sp at intr context is not pointing the top of stack. actually &sp is
> the real address of the stack :(
> Perhaps, on x86-32, we can translate %sp to stack address in kprobe-tracer.



Oh? You mean in the saved registers while triggering an int 3?



> > %return = return value
>
> or %retval? :)


Yeah, better!


>
>> @return = return addr
>
> I'd like to remove it, because it's already shown.


Ok.



>> arg(n) = arg number, where n is the number
>
> How about %N? or just adds a note in documents.
>


Hmm, the problem is that %1, %2, etc. is not very self-explainable.

May be %arg1, %arg2, etc.. But would that sound confusing since we
have % for registers?



>> [Perf probe only]
>>
>> var = variable name, global or local, we can deal with shadow issues later
>>        through variable scope: func_name:var, filename:var, whatever for now
>>        it's not a problem. Local also includes argument names.
>
> That's fine to me. :-)
>


Great :)
Thanks!

