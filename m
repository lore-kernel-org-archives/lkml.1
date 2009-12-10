Return-Path: <linux-kernel-owner+w=401wt.eu-S934257AbZLJMDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257AbZLJMDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 07:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934186AbZLJMDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 07:03:36 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:59414 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934125AbZLJMDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 07:03:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VBc8nx/fO5cQmqeS6wa1VPkaPE0LyJRTLUY18KE+tF55ZRFg3Vop5yFGEoxsvQz9/h
         MidShUS/ft++UzOA3cFnQxm9PT0qX2y1vXVWoqMtqYaVl941DhYbYSrokfCrY809+Hz/
         U9vLV0xj9lPpVrRhplti+LsXNcdtLG2ckY9xY=
Date: Thu, 10 Dec 2009 13:03:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tim Bird <tim.bird@am.sony.com>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
Message-ID: <20091210120332.GA5042@nowhere>
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210070800.GB16874@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 08:08:00AM +0100, Ingo Molnar wrote:
> 
> * Tim Bird <tim.bird@am.sony.com> wrote:
> 
> > Add function duration tracer.
> > 
> > Signed-off-by: Tim Bird <tim.bird@am.sony.com>
> > ---
> >  kernel/trace/Kconfig          |    8
> >  kernel/trace/Makefile         |    1
> >  kernel/trace/trace.c          |   32 ++
> >  kernel/trace/trace_duration.c |  527 ++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 568 insertions(+)
> 
> Please do it in a cleaner an more generic fashion: add a "function 
> event" that perf can see and process, so all the output embellishment 
> can be done outside of the kernel, in tools/perf/.
> 
> We want to wind down the current maze of ftrace plugins, not extend 
> them. We already obsoleted the following ftrace plugins: scheduler, 
> sysprof, blktrace, kmem, scheduler, etc. There's more work ongoing and 
> broad agreement between folks developing it that this is the way 
> forward.
> 
> The function tracer / function graph tracer is a holdout due to its 
> complexity - but that by no means weakens the argument and the necessity 
> to migrate it.
> 
> ftrace plugins were a nice idea originally and a clear improvement over 
> existing alternatives, but now that we've got a technicaly superior, 
> unified event framework that can do what the old plugins did and much 
> more, we want to improve that and not look back ...


I agree. If we can abstract it out in a struct trace_event rather than a
struct tracer, then please try. I doubt we can't.

The trace events are more unified.

This makes me feel I'm going to try converting the function graph tracer
into an event during the next cycle. It does not mean I could make it
usable as a perf event right away in the same shot that said, as you can
guess this is not a trivial plug. The current perf fast path is not yet
adapted for that.

But at least this will be a good step forward.

