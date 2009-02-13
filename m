Return-Path: <linux-kernel-owner+w=401wt.eu-S1761380AbZBMETS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761380AbZBMETS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 23:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758891AbZBMETA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 23:19:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61688 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758871AbZBMES7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 23:18:59 -0500
Date: Thu, 12 Feb 2009 23:18:56 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/7][RFC] powerpc64: port of the function graph tracer
In-Reply-To: <1234498320.26036.33.camel@pasglop>
Message-ID: <alpine.DEB.1.10.0902122316130.15469@gandalf.stny.rr.com>
References: <20090212011051.265346435@goodmis.org>  <20090212011342.880486000@goodmis.org> <1234498320.26036.33.camel@pasglop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 13 Feb 2009, Benjamin Herrenschmidt wrote:

> > On Wed, 2009-02-11 at 20:10 -0500, Steven Rostedt wrote:
> > 
> > +# timers used by tracing
> > +CFLAGS_REMOVE_time.o = -pg -mno-sched-epilog
> >  endif
> 
> That means no tracing of the timer interrupts etc... maybe we should
> just move the specific function that we don't want traced out to a
> separate file ? 

The function graph tracer calls cpu_clock, which calls sched_clock, 
to get the times. There's no protection against recursion here, since
we want to let interrupts still be recorded, and we do not need to disable
interrupts.

But if the cpu_clock calls something that is traced, it will recurse, and 
cause a lockup. What ever functions those are, we could annotate with
notrace. I just used the x86 blind method of 'dont trace this file'.


> 
> Appart from that, it looks ok, though I might have missed something :-)

Thanks,

-- Steve

