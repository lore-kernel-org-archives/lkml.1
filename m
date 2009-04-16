Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZDPPvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZDPPvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 11:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZDPPve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 11:51:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41083 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbZDPPvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 11:51:33 -0400
Date: Thu, 16 Apr 2009 11:51:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/5] tracing/events: add startup tests for events
In-Reply-To: <20090416154132.GC6004@nowhere>
Message-ID: <alpine.DEB.2.00.0904161151001.20429@gandalf.stny.rr.com>
References: <20090416021830.556671772@goodmis.org> <20090416021928.239106997@goodmis.org> <20090416154132.GC6004@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Apr 2009, Frederic Weisbecker wrote:
> > +	sysname = kmalloc(4, GFP_KERNEL);
> > +	if (WARN_ON(!sysname)) {
> > +		pr_warning("Can't allocate memory, giving up!\n");
> > +		return 0;
> > +	}
> > +	memcpy(sysname, "*:*", 4);
> > +	ret = ftrace_set_clr_event(sysname, 1);
> > +	if (WARN_ON_ONCE(ret)) {
> > +		kfree(sysname);
> > +		pr_warning("error enabling all events\n");
> > +		return 0;
> > +	}
> > +
> > +	event_test_stuff();
> > +
> > +	/* reset sysname */
> > +	memcpy(sysname, "*:*", 4);
> 
> 
> 
> Nano thing, because you are using it twice:
> Why not strcpy?
> 

Because cut and paste was so much easier ;-)

-- Steve

