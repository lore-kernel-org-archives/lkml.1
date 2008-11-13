Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYKMNQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYKMNQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYKMNQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:16:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:59164 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbYKMNQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:16:36 -0500
Date: Thu, 13 Nov 2008 08:16:34 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 1/1] ftrace: do not update max buffer with no users
In-Reply-To: <alpine.DEB.1.10.0811130752480.7458@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0811130815080.7458@gandalf.stny.rr.com>
References: <20081113043449.751885305@goodmis.org> <20081113043751.796120007@goodmis.org> <20081113084040.GD25479@elte.hu> <alpine.DEB.1.10.0811130752480.7458@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 13 Nov 2008, Steven Rostedt wrote:
> > > Reported-by: Pekka Paalanen <pq@iki.fi>
> > > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > > ---
> > >  kernel/trace/trace.c |  171 ++++++++++++++++++++++++++------------------------
> > >  1 files changed, 88 insertions(+), 83 deletions(-)
> > 
> > This is _way_ too much churn for .28, we need a much simpler solution.
> 
> The line count is very misleading. The 83 insertions and deletions where 
> moved code or indentation:
> 

> 
> As you can easily see, the change only added the test for max_tr.buffer
> exists, and indented the rest.
> 
> The other parts you can easily see that they are not changed.
> But, we could separate out the moved code and ifdef protection for 29, 
> even though I feel nervous that some config might use them, and break at 
> runtime. This change will break the compile if it happens. Without the 
> change, we find out at runtime :-(

Also, if you are worried about line count, I could just leave the code in 
place, and add more ifdefs around them, and leave the consolidation of the 
code for 29.

-- Steve

