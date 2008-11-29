Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbYK2DY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbYK2DY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 22:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYK2DYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 22:24:16 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:35682 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbYK2DYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 22:24:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=isMitNouMR1KrIRFtLabqac1CCAAEseLjGgE4h+Pn4L6BaqTqWULr2fbtH0imwziUG
         uIlJC+xrpQTKcYWx93TqN/okLFQsTNBfA3PREBO5PAFx7Utjf634iKyZUC6eYd+MCqzX
         EqCjh9yhUk/WPLy91QMprTzjfYfMkpnWnJ2Yo=
Message-ID: <c62985530811281924t759b9c9as35333453b1664d96@mail.gmail.com>
Date: Sat, 29 Nov 2008 04:24:14 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-graph-tracer: adjustments of the trace informations
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Tim Bird" <tim.bird@am.sony.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081128141738.GE28138@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492F3076.7050104@gmail.com> <20081128091800.GA1725@elte.hu>
	 <c62985530811280555m3b6eaa7fwb50bbe0f5c13bdd3@mail.gmail.com>
	 <20081128141738.GE28138@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/28 Ingo Molnar <mingo@elte.hu>:
> Yeah, that needs updating. I supposed you'd be working on the task+pid
> column anyway, and do a helper function that prints the task-pid couple.
> Then that helper can be used in the context-switch case too to print out
> a uniform ID.


Ok.



> Another thing that would be nice is to separate out the "cpu)" printing
> bits into a helper function. Right now what exists cannot be used in a
> seq-manner, so i couldnt reuse it.
>


Isn't it the case with print_graph_cpu() ?

> Anyway, i wont change it (just wanted to get a final-ish output to look
> at) so feel free to clean it all up thoroughly :)
>
> Today i played with the graph-tracer on a testbox _way_ too much.
> Combined with the wildcard filter it's _really_ addictive. Kernel
> developers, beware!


:-)


>
> One thing that came up: it would be nice to have an 'inverted' wildcard
> to punch out certain functions from the filter list. For example i did in
> the shell:
>
>  $ echo 'sys_*'    >> set_ftrace_filter
>  $ echo '*socket*' >> set_ftrace_filter
>  $ echo '*timer*'  >> set_ftrace_filter
>  $ echo '*skb*'    >> set_ftrace_filter
>
> and looked at the trace and found that certain functions are too verbose
> and not really interesting - so i wanted to exclude them.
>
> We've got set_ftrace_notrace but it's not really an inverse wildcard but
> a complementary set of filter functions - which is not the same and not
> as easy to think about as a single set of filter functions.
>
> what i think would be more natural to do is via the filter file itself,
> via an extension like:
>
>  $ echo '!timer_*' >> set_ftrace_filter
>
> which would eliminate the functions matching that negative pattern. Such
> negative wildcards would act on the current set of functions, while
> set_ftrace_notrace is permanent and cannot be used to shape an arbitrary
> set of functions iteratively.


Ok, I'll add it in my workqueue (unless Steven does it).
