Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbZJZQQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbZJZQQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbZJZQQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:16:22 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:63548 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510AbZJZQQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:16:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoEAE5l5UpGGN1W/2dsb2JhbACBUNZlhD8E
Date: Mon, 26 Oct 2009 12:11:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, GeunSik Lim <leemgs1@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Jesper Juhl <jj@chaosbits.net>, Adrian Bunk <bunk@stusta.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL
	v2,headers to Dual BSD/GPL
Message-ID: <20091026161123.GB8755@Krystal>
References: <20091023160257.GA30447@Krystal> <20091023160632.GA2198@Krystal> <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net> <20091026015357.GA6033@localhost> <023001ca55e1$436e38e0$808410ac@zhaoleiwin> <49b7c2350910252203o69811000w4551c01e6e2a10c7@mail.gmail.com> <20091026073048.GC8162@elte.hu> <4AE5A17D.5020202@polymtl.ca> <1256563793.26028.240.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1256563793.26028.240.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:05:20 up 69 days,  2:54,  2 users,  load average: 0.13, 0.14,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Mon, 2009-10-26 at 09:17 -0400, Pierre-Marc Fournier wrote:
> > Ingo Molnar wrote:
> > > 
> > > But i also disagree with it on a technical level: code duplication is 
> > > _bad_. Why does the code have to be duplicated in user-space like that? 
> > > I'd like Linux tracing code to be in the kernel repo. Why isnt this done 
> > > properly, as part of the kernel project - to make sure it all stays in 
> > > sync?
> > > 
> > 
> > If you mean that this code should solely be used inside the kernel, then
> > what you propose technically does not work. There is a very high cost to
> > accessing kernel code from userspace. This cost is simply unacceptable
> > for the kind of userspace tracing that is needed today.
> 
> I think that Ingo is thinking that the tracing is for the kernel, and is
> asking why the duplication needs to be done for tools tracing the
> kernel.
> 
> But what I think is trying to be done here is to use the same types of
> MACROS that we have in the kernel to do tracing in userspace. That a
> userspace program can add their own "TRACE_EVENT" and that the headers
> there will create a tracepoint for them the same way we currently do in
> the kernel.
> 
> Am I correct in my analysis?
> 
> -- Steve
> 

Hi Steve,

Yes, you are correct about the intent of making the static
instrumentation macros available to userspace. This is indeed our goal.

What Ingo is trying to propose (I guess) is to perform tracing through
the kernel (e.g. probably through a vDSO or syscall).

However, the licensing question here is for tracepoints, markers,
trace_event, which is a _static instrumentation_ mechanism. In this
case, the kernel cannot really help, because we have to build the
instrumentation into the application anyway, so we run into these
license problems, and it cannot be magically solved by the kernel. Or
maybe Ingo has a different perspective on static instrumentation that
would involve the kernel ? If it's the case, then I'd like to hear it.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
