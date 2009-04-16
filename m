Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbZDPRyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbZDPRyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbZDPRyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:54:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37524 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbZDPRyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:54:05 -0400
Subject: Re: [PATCH 2/2] tracing/events/lockdep: move tracepoints within
 recursive protection
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0904161343110.20429@gandalf.stny.rr.com>
References: <20090416161543.199331330@goodmis.org>
	 <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop>
	 <alpine.DEB.2.00.0904161343110.20429@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 19:53:48 +0200
Message-Id: <1239904428.23397.3278.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 13:45 -0400, Steven Rostedt wrote:
> On Thu, 16 Apr 2009, Peter Zijlstra wrote:
> 
> > On Thu, 2009-04-16 at 12:15 -0400, Steven Rostedt wrote:
> > > plain text document attachment
> > > (0002-tracing-events-lockdep-move-tracepoints-within-recu.patch)
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > With the current location of the tracepoints in lockdep, the system
> > > can hard lockup in minutes when the tracepoints are enabled.
> > > 
> > > Moving the tracepoints outside inside the lockdep protection solves
> > > the issue.
> > 
> > NAK
> 
> Can we at least add this as a workaround. Basically, the lockdep
> tracepoints are broken as is. I do not plan on changing the logic of the 
> events to prevent nesting. That's a feature I use. If we don't allow 
> nesting, we must drop events, which is bad.

No, I would say any nesting is a bug, and should stop tracing and print
a splat. No need to drop events.

> The other answer is simply to remove the trace points in lockdep, until 
> they work again.

Well, they worked when I added them, so someone broke it.

