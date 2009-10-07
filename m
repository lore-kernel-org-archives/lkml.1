Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbZJGBNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbZJGBNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 21:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758538AbZJGBNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 21:13:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537AbZJGBNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 21:13:17 -0400
Message-ID: <4ACBEB4E.20803@redhat.com>
Date: Tue, 06 Oct 2009 21:13:50 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: rostedt@goodmis.org, Ingo Molnar <mingo@elte.hu>,
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
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <4ACA25D5.10703@redhat.com> <20091005192609.GB6071@nowhere> <1254787973.13160.195.camel@gandalf.stny.rr.com> <4ACB52F6.7020106@redhat.com> <20091006224755.GC11007@nowhere>
In-Reply-To: <20091006224755.GC11007@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Oct 06, 2009 at 10:23:50AM -0400, Masami Hiramatsu wrote:
>> OK, so here are syntax ideas
>>
>> * current syntax
>> <Ftrace>
>> - $sp_var
>> - %regs
>> - @symbol
>> <Perf>
>> - local_var
> 
> 
> This one looks good.
> And why not turning @symbol into symbol?
> Then it's up to perf probe to find the right
> target.

Hmm, one big reason for separating local_vars
and others is that I'd like to check whether
perf-probe needs debuginfo or not.
If there is no local_vars, we don't need to
parse debuginfo. Sometimes, it is useful just
for setting up probe points.

> And @ can be used for raw addresses?

Yeah, but @ can be shared with symbols and raw addresses.
If the first char is digit, it's not a symbol.:-)

And also, @symbol actually has its syntax rule.:-)
its real syntax is:
@[MODULE:]SYMBOL[+OFFSET]
or
@ADDRESS (0xNN (base 16) or NN (base 10))

Perhaps, since perf-probe has another syntax rule,
I don't want to confuse users. :-P

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

