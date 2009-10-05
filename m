Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbZJEWgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbZJEWgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 18:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbZJEWgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 18:36:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbZJEWgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 18:36:03 -0400
Message-ID: <4ACA7577.30407@redhat.com>
Date: Mon, 05 Oct 2009 18:38:47 -0400
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
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <20091005191829.GA6071@nowhere> <4ACA549F.9010300@redhat.com> <20091005205826.GE6071@nowhere> <4ACA60E9.30404@redhat.com> <20091005212137.GG6071@nowhere> <4ACA6660.7020607@redhat.com> <20091005215548.GH6071@nowhere>
In-Reply-To: <20091005215548.GH6071@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Oct 05, 2009 at 05:34:24PM -0400, Masami Hiramatsu wrote:
>> Hmm, one idea hits me, how about this? :)
>> - %register
>> - %%spvars (%%retval, %%arg0)
>
>
> The problem is that such % or %% symbols have a specific
> mean in some other well known areas.
>
> If we borrow the % from the AT&T assembly syntax style
> to use register names, that we can retrieve in gcc inline
> assembly, then one may expect %% to have a meaning inspired
> from the same area. %% has its sense in gcc inline assembly,
> but applied there, it looks confusing.
>
> I mean, I'm trying to think like someone reading a perf probe
> command line without any documentation. The more this person
> can understand this command line without documentation, the better.
> We know that % is used for register names, some people know that %%
> is used for register names too but when we are in gcc inline assembly
> with var to reg resolution and need true registers name.

Hmm, but %%reg syntax is only for the special case of gcc-inline
assembly (e.g. assembler template, see
http://www.ibiblio.org/gferg/ldp/GCC-Inline-Assembly-HOWTO.html#s3).
So, I guess it will not be so confusing.

> Then if I try to mirror this sense from gcc to perf probe use,
> I feel confused, especially in the case of %%arg1.
>
> In this case, we should rather have %%register and %arg0 :)
>
> Hm, %register is a clear pattern.
>
> Somehow, %retval looks clear too, retval is verbose enough and
> % is still logical as return values are most of the time (always?)
> put in a register.
>
> But %%arg0 looks confusing.

Then, can we use @@ for prefix of special variables?? :-)

I'm so anxious about collision between register name and
those vars.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

