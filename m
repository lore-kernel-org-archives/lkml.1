Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbZHKMBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbZHKMBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZHKMBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:01:42 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63480 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZHKMBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pltiaQxrocEczq8q4Zfjqjj9rV4duuc/0ujP8EhalBEc1LwmyCRvLyAC1LlBQb80iV
         UL4WzmvUaunS4s+QPucv3zQU40sj+ODAHCymL9aJJCzwhDYwZq1Vk5kyXZHFYhU/ByF4
         9DQ1yofo2Anfqr49PKqdX97vHY8JasvwJ4BgA=
Date: Tue, 11 Aug 2009 14:01:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090811120135.GE4938@nowhere>
References: <cover.1249932670.git.jbaron@redhat.com> <aa785a0431b72327d288ef9b921e824d7f494de2.1249932670.git.jbaron@redhat.com> <20090811105010.GB4938@nowhere> <20090811114512.GA585@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811114512.GA585@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 01:45:12PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > +struct trace_event event_syscall_enter = {
> > > +	.trace			= print_syscall_enter,
> > > +	.type			= TRACE_SYSCALL_ENTER
> > > +};
> > > +
> > > +struct trace_event event_syscall_exit = {
> > > +	.trace			= print_syscall_exit,
> > > +	.type			= TRACE_SYSCALL_EXIT
> > > +};
> > > -- 
> > > 1.6.2.5
> > > 
> > 
> > Nice.
> > 
> > It's a bit too bad that enter and exit must be that separated 
> > whereas their callbacks are pretty the same.
> > 
> > But I guess if we want to nicely decouple both, we don't have the 
> > choice.
> 
> Yeah - and enter and exit are different, in terms of state.
> 
> One thing that would be nice in the future (as an add-on - this 
> patch-set looks useful already) is to allow the sampling of user 
> register state as well via these tracepoints. That way we'd have a 
> much faster (and completely transparent) implementation of strace in 
> essence, with unique features such as system-wide or per cpu 
> strace-ing.
> 
> 	Ingo


Indeed, a missing piece is the syscall record sampling with registers.
Actually, IMO the registers themselves are not the right piece to export
to perfcounter. It's too low-level.

What we need are the fetched arguments, because a lot of them are adresses
(even user adresses), pretty useless for perf tools.

We can already and easily implement that simple args, like we do for ftrace.
That's pretty trivial.

