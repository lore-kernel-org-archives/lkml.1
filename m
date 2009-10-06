Return-Path: <linux-kernel-owner+w=401wt.eu-S932759AbZJFOXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbZJFOXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932744AbZJFOXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:23:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932741AbZJFOXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:23:16 -0400
Message-ID: <4ACB52F6.7020106@redhat.com>
Date: Tue, 06 Oct 2009 10:23:50 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
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
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>	 <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com>	 <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com>	 <4ACA25D5.10703@redhat.com>  <20091005192609.GB6071@nowhere> <1254787973.13160.195.camel@gandalf.stny.rr.com>
In-Reply-To: <1254787973.13160.195.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 2009-10-05 at 21:26 +0200, Frederic Weisbecker wrote:
>> On Mon, Oct 05, 2009 at 12:59:01PM -0400, Masami Hiramatsu wrote:
>>> As far as I can see in arch/*/include/asm/ptrace.h, all registers start with
>>> alphabets :-). So, I'd like to suggest renaming sp-vars to '_sp-vars'.
>>>
>>> Then, we will have;
>>> - $local-vars
>>
>>
>> There is a risk of bash collision.
> 
> I actually prefer the "$" notation. As for bash collision, it is common
> for shell script writers to be able to distinguish a variable from bash.
> Yes we can backslash it, or quote it. But when I see a $var it sticks
> out to me that it is a variable. It's not hard to get around. For
> example, type:
> 
> $ echo "hello $DISPLAY"' or $DISPLAY'
> 
> and see what you get.
> 
> Makefiles and Perl use '$' for variables those that need to handle it
> with bash can easily cope with it.
> 
> So my vote is to keep the '$'. It is the most intuitive to what it
> means.
> 
> Just my 0.02¤

OK, so here are syntax ideas

* current syntax
<Ftrace>
- $sp_var
- %regs
- @symbol
<Perf>
- local_var

* $local syntax
<Ftrace>
- sp_var
- %regs
- @symbol
<Perf>
- $local_var

* non $ syntax 1
<Ftrace>
- %sp_var
- %regs
- @symbol
<Perf>
- local_var

* non $ syntax 2
<Ftrace>
- %%sp_var or %@sp_var
- %regs
- @symbol
<Perf>
- local_var

So, which one do you like to use? :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

