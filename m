Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZJSLBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZJSLBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 07:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbZJSLBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 07:01:00 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:51352 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034AbZJSLBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 07:01:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rYAxnBfbfy5BD9vVnbrxG3KY2RYdHmlkpybiyMF55D6nir5r246etdKScrs8Au8Mth
         fAOBOgaXX3KlPJrcXTqFz3hTYzCpBYkId0JJ8HNAYsD3uOaUJnKiMB6NKNHxYxRcOrA5
         8QCaXBTSauKFFHptW4WYd9iP9GNmF9ISfjjaA=
Date: Mon, 19 Oct 2009 13:00:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
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
Message-ID: <20091019110055.GA5549@nowhere>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com> <20091019075103.GF17960@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019075103.GF17960@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 09:51:03AM +0200, Ingo Molnar wrote:
> > So, what would you think about using -D (def) and -U (undef) ?
> 
> The simpest case should be no extra character at all:
> 
>   perf probe schedule


Yeah, I really prefer that too.


 
> > > All the other extensions and possibilities - arguments, variables, 
> > > source code lines, etc. should be natural and intuitive extensions 
> > > of this basic, minimal syntax.
> > 
> > Don't you like current space(' ') separated arguments? :-) I mean, 
> > what is 'natural' syntax in your opinion?
> 
> Yeah, space separated arguments are nice too. The question is how to 
> specify a more precise coordinate for the bit we want to probe - and how 
> to specify the information we want to extract. Something like:
> 
>   perf schedule+15


I personally don't imagine common easy usecases that imply relative line
offsets but rather absolute lines.

I guess the most immediate usecase is a direct function probe:

	perf probe schedule

Just to know if a function is matched.

If you want more precision, it also means you have you code editor opened
and want to set a precise point. Since you also have the absolute
line directly displayed by your editor, you don't want to calculate the relative
line but rather the absolute one.

Hmm?

Hence I rather imagine the following:

perf probe schedule.c:line

(Unfortunately, schedule:line is shorter but less intuitive
but that could be a shortcut).



> Or this:
> 
>   perf schedule:'switch_count = &prev->nivcsw'
> 
> would insert the probe to the source code that matches that statement 
> pattern. Rarely will people want to insert a probe to an absolutely line 
> number - that's a usage mode for higher level tools. (so we definitely 
> want to support it - but it should not use up valuable spots in our 
> options space.) Same goes for symbol offsets, etc. - humans will rarely 
> use them.



I don't understand your point. If your editor is opened and you have
the source code in front of you, why would you cut'n'paste a line instead
of actually write the line number?



> 
> We also want to have functionality that helps people find probe spots 
> within a function:
> 
>   perf probe --list-lines schedule
> 
> Would list the line numbers and source code of the schedule() function. 
> (similar to how GDB 'list' works) That way someone can have an ad-hoc 
> session of deciding what place to probe, and the line numbers make for 
> an easy ID of the statement to probe.


Agreed!

Thanks.

