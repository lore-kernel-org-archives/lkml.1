Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYLCNLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYLCNLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYLCNLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:11:32 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:51019 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbYLCNLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:11:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tlNR5lPMBwllvHHrSB7vpLF6HF+om6+/TiGN3eCZW4Ofb8TkqJwVvK97t/TaQbr6zW
         S2wYxD0S06FxrRp/KlHnVNKF6Yd5uGlwB3IG5SQk6BWg7J5MgG+f3UhFfKRKBnJc14ub
         l0f2kqWIQYTPrEaOaY3CmyeZOJmPikA7tTbcU=
Message-ID: <c62985530812030511p7768dba0gce8cf84655b9ac35@mail.gmail.com>
Date: Wed, 3 Dec 2008 14:11:29 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: improve duration output
Cc: "Ingo Molnar" <mingo@elte.hu>, "Tim Bird" <tim.bird@am.sony.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812030649480.29045@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4935E19C.3090501@gmail.com> <4935E226.3060906@gmail.com>
	 <20081203081906.GH21006@elte.hu>
	 <alpine.DEB.1.10.0812030649480.29045@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/3 Steven Rostedt <rostedt@goodmis.org>:
> Actually, I was also thinking of keeping the CPU number in front:
>
>  ------------------------------------------
>  0)    cat-2796    =>   events/-9
>  ------------------------------------------
>
> This way we can easily grep for a common CPU and still get the context
> switches:
>
> grep '^0)' trace > /tmp/trace0

I agree. More easy to grep. Ingo, Peter, others, what do you think?

> Of course it will probably also work without the '^' now, but then it
> might grab ftrace_printks with a '0)' if we add those.


I proposed a solution for ftrace_printk (which I planned to implement
this evening).
Since we are in a C-style output, that would be good  to put the ftrace_printk
as /* C comments */ inside just below the function that called it.
Like this:

func_that_called_ftrace_printk {
    /* Message from ftrace_printk */
}

This way we keep the idea of comment which comes along the role of
ftrace_printk and we know
which function called it, at which depth.....

Do you like it this way?
