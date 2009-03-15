Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbZCOPRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbZCOPRU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 11:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZCOPRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 11:17:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:9022 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbZCOPRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 11:17:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DJBH5jigkGQWKVTfAk6gJDaJ/VJwVu2vpq5euM+uyZav0Oucin0M0JZ4QXFfq9BIgs
         YGwPSQeMqzaoBKVALaqPFQPyBV0PuVH677h4VrZh3wLYRx4H6CG9s9z0RF0Rs4UiCK4e
         TDbOZStd3uQ1BIy3xNLGNGv7F1cc729c7JpR8=
Date: Sun, 15 Mar 2009 16:16:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>
Subject: Re: [RFC][PATCH 2/2] tracing/x86: basic implementation of syscall
	tracing for x86-64
Message-ID: <20090315151657.GB5105@nowhere>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236401580-5758-3-git-send-email-fweisbec@gmail.com> <20090313163207.GA3354@Krystal> <20090313163702.GA9082@elte.hu> <20090313165020.GD3354@Krystal> <20090315044405.GB11150@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090315044405.GB11150@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 05:44:05AM +0100, Ingo Molnar wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > 
> > > > * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > > >
> > > > > Provide the ptrace hooks and arch specific syscall numbers 
> > > > > to ftrace arch indepedant syscall numbers. For now it only 
> > > > > supports 4 syscalls to provide an example.
> > > > > 
> > > > 
> > > > Hi Frederic,
> > > > 
> > > > I already have the equivalent TIF_KERNEL_TRACE flag in my 
> > > > LTTng tree added to every Linux architecture. You might want 
> > > > to re-use this work rather than re-doing this. I don't mind 
> > > > changing the flag name.
> > > 
> > > Yeah. Note that the TIF bits are just one part - there are other 
> > > bits needed for HAVE_FTRACE_SYSCALLS arch support.
> > > 
> > > Also, i'd eventually expect the TIF bits to be converted to a 
> > > tracehook callback, not spread it to other architectures.
> > > 
> > 
> > The nice part about the TIF bit is that it permits adding this 
> > syscall tracing feature without increasing the size of the 
> > thread_info struct nor adding any extra tests in entry.S. Does 
> > the tracehook callback have these features ?
> 
> yes. Tracehook just factors out common interfacing points - with 
> one specific implementation for now: ptrace. For syscall tracing 
> that means it wraps TIF_SYSCALL_TRACE in essence.
> 
> 	Ingo


Since I didn't want to experience conflicts against ptrace, I haven't
played with the tracehooks.

But anyway, I wrote this low level part of syscall tracing having in mind
the fact that utrace does this work very much better. That's why I wrote it
to be very basic and simple enough to do the job, but waiting for a better
code that is already written somewhere else.

So now there is some code which does that on both utrace and Lttng.

I would be pleased to see these patches which handle these flags properly
on LKML :-)

Frederic.



