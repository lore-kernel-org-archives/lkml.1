Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbZIXUdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbZIXUdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 16:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZIXUdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 16:33:23 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:39095 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZIXUdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 16:33:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bMILDyr+rYKRPo3CXw3S7zr6bKv7k5dKAxYJ7MoZ8CGiWeWfwmUcjmhQq1+SOREWc3
         335h05bNkQ89vKa61Tg8AI06XN660G5VDF0Saq57XTZRnVriA3coAH3OM63RxODtJMzI
         4ketUGFQ3HESwLzyvO5nDbSfg4mcabGzGfDpY=
Date: Thu, 24 Sep 2009 22:33:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
Message-ID: <20090924203321.GA8662@nowhere>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com> <20090924201509.GA26573@elte.hu> <20090924201622.GA15459@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924201622.GA15459@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 10:16:22PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Ingo,
> > > 
> > > This is new iteration of the bkl tracepoints + filter
> > > regex support. It addresses the reviews that were posted
> > > in the previous RFC version.
> > > 
> > > Please pull from:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > > 	tracing/core
> > > 
> > > Thanks;
> > > Frederic.
> > > 
> > > Frederic Weisbecker (5):
> > >       tracing/bkl: Add bkl ftrace events
> > >       tracing/filters: Cleanup useless headers
> > >       tracing/event: Cleanup the useless dentry variable
> > >       tracing/filters: Provide basic regex support
> > >       tracing/filters: Unify the regex parsing helpers
> > > 
> > >  include/linux/smp_lock.h           |   19 ++++-
> > >  include/trace/events/bkl.h         |   61 ++++++++++++++
> > >  kernel/trace/ftrace.c              |   64 +--------------
> > >  kernel/trace/trace.h               |   36 ++++++--
> > >  kernel/trace/trace_events.c        |   23 +++---
> > >  kernel/trace/trace_events_filter.c |  155 +++++++++++++++++++++++++++++++----
> > >  lib/kernel_lock.c                  |   11 ++-
> > >  7 files changed, 262 insertions(+), 107 deletions(-)
> > >  create mode 100644 include/trace/events/bkl.h
> > 
> > Pulled, thanks a lot Frederic! These bits look very useful.
> > 
> > It would be perf-ect now to complete the filters-via-perf-events changes 
> > Li Zefan is working on ;-)
> 
> There's one thing Peter noticed: this is not C syntax anymore. It would 
> be really nice to keep filter expressions a subset of C.
> 
> 	Ingo


You mean the use of stars for the regexes?
Hm, but that looks a intuitive way to define a regex string.
We can't stricly imitate the C without sticking into its
limitations. But it's still a subset of C with this feature.

Or I'm probably missing something?

