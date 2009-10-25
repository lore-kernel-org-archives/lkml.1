Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbZJYQ3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbZJYQ3X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 12:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZJYQ3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 12:29:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58938 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbZJYQ3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 12:29:22 -0400
Date: Sun, 25 Oct 2009 17:29:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, Jason Baron <jbaron@redhat.com>,
       cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: move gfs2 tracepoints to inclue/trace/events dir
Message-ID: <20091025162913.GC20391@elte.hu>
References: <20091009160115.GA2647@redhat.com> <20091009234555.GA28257@infradead.org> <1255340583.2675.23.camel@localhost.localdomain> <20091012100037.GA11653@elte.hu> <20091025075037.GD9482@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091025075037.GD9482@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Oct 12, 2009 at 12:00:37PM +0200, Ingo Molnar wrote:
>
> > yeah. I have no objection to adding it to include/trace/. 
> > Tracepoints are a fundamentally global business.
> > 
> > Subsystems can opt to hide their tracepoints locally, but it's 
> > better to have a global view about what's out there, so that it can 
> > be extended coherently, etc.
> 
> We're lacking quite a bit coherence even with it.  The originally 
> reason why there were global was that the infrastructure couldn't cope 
> with having the either in modules or elsewhere in the source tree at 
> all.
> 
> We have managed to avoid global directories for drivers/filesystems 
> for as much as we can lately.  Having everything in a directory makes 
> sure it's self-contained and people don't use it accidentally from 
> other modules, which also applies to trace events - we don't want 
> people accidentally use gfs2 tracepoints from a driver (and if you 
> think that's far fetched look at the recent example of a driver using 
> debugging macros from the networking code that got pulled in 
> accidentally somewhere).

Tracepoints are closer to documentation than to filesystem 
functionality. And you are wrong when you say that everything related to 
filesystems is 'modular' - we have all documentation concentrated in 
Documentation/filesystems/ - and that is good so.

Just like we have library functions for filesystems concentrated in 
fs/*.c.

I think you are looking at it way too rigidly without considering the 
other side of the equation. Modularity has its costs: it hides details 
and makes it harder to compare implementations.

	Ingo
