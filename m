Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0CERQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:16:23 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:60149 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab0CERQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:16:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=iio7WUhyKC9OT2Sq2RWcJEW7E14I26pZnigkDMdNMAF/P+W4JaNVO3dVmxWK+GlrH7
         s6fxi1tO+uXu8Do/azGryTLC9lEGU8AEc33EafFvGl/a1MinenTfGguWzGY/0XS4nfzv
         O8KepgNPyLmpfjRYDgPVCqbanFyhdpBYEf+3Y=
Date: Fri, 5 Mar 2010 18:16:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.33: ftrace triggers soft lockup
Message-ID: <20100305171614.GC5244@nowhere>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com> <1267710847.10871.102.camel@gandalf.stny.rr.com> <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com> <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com> <1267801603.10871.1725.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1267801603.10871.1725.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 10:06:43AM -0500, Steven Rostedt wrote:
> On Fri, 2010-03-05 at 15:16 +0800, Américo Wang wrote:
> > On Fri, Mar 5, 2010 at 12:14 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> > > On Thu, Mar 4, 2010 at 9:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > >> On Wed, 2010-03-03 at 14:04 +0800, Américo Wang wrote:
> > >>> I am not sure if this is ftrace's fault, but it is ftrace who triggers
> > >>> the soft lockup. On my machine, it is pretty easy, just run:
> > >>>
> > >>> echo function_graph > current_tracer
> > >>>
> 
> > >
> > > I can't say that because I didn't try -rc6.
> > >
> > 
> > Sigh, 2.6.33-rc6 doesn't work, even 2.6.32 doesn't work...
> 
> So basically you are saying that the function_graph tracer, when enabled
> has a high overhead? Well, unfortunately, that's expected.
> 
> The function_graph tracer traces the start and end of every function. It
> uses the same mechanism as function tracer to trace the start of the
> function (mcount), but to trace the exit of a function, in the enter of
> the function it hijacks the return address and replaces it to call a
> trampoline. This trampoline will do the trace and then jump back to the
> original return address.
> 
> Doing this breaks branch prediction in the CPU, as the CPU uses call/ret
> as part of its branch prediction analysis. So function graph tracing is
> not just twice as slow as function tracing, it actually has a bigger
> impact than that.


It's true it has a high overhead, but not to the point of
making the whole system unusable. We are supposed to be even
far from that. I'm currently able to turn on the function graph
tracer and use firefox without problems. It's just a bit slower
but it's far from a visible starvation.

And Li seems to see the same thing.
For now I can not test, but I will try this week-end.

