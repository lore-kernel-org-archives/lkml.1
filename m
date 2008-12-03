Return-Path: <linux-kernel-owner+w=401wt.eu-S1751370AbYLCNSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbYLCNSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbYLCNRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:17:52 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:8317 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYLCNRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:17:51 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: improve duration
 output
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <c62985530812030511p7768dba0gce8cf84655b9ac35@mail.gmail.com>
References: <4935E19C.3090501@gmail.com> <4935E226.3060906@gmail.com>
	 <20081203081906.GH21006@elte.hu>
	 <alpine.DEB.1.10.0812030649480.29045@gandalf.stny.rr.com>
	 <c62985530812030511p7768dba0gce8cf84655b9ac35@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Dec 2008 14:17:44 +0100
Message-Id: <1228310264.9673.238.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 14:11 +0100, Frédéric Weisbecker wrote:
> 2008/12/3 Steven Rostedt <rostedt@goodmis.org>:
> > Actually, I was also thinking of keeping the CPU number in front:
> >
> >  ------------------------------------------
> >  0)    cat-2796    =>   events/-9
> >  ------------------------------------------
> >
> > This way we can easily grep for a common CPU and still get the context
> > switches:
> >
> > grep '^0)' trace > /tmp/trace0
> 
> I agree. More easy to grep. Ingo, Peter, others, what do you think?

Everything that aids parsing is good :-)

> > Of course it will probably also work without the '^' now, but then it
> > might grab ftrace_printks with a '0)' if we add those.
> 
> 
> I proposed a solution for ftrace_printk (which I planned to implement
> this evening).
> Since we are in a C-style output, that would be good  to put the ftrace_printk
> as /* C comments */ inside just below the function that called it.
> Like this:
> 
> func_that_called_ftrace_printk {
>     /* Message from ftrace_printk */
> }
> 
> This way we keep the idea of comment which comes along the role of
> ftrace_printk and we know
> which function called it, at which depth.....
> 
> Do you like it this way?

Yep

