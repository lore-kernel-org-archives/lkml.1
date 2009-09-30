Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZI3QAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZI3QAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 12:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbZI3QAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 12:00:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45848 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbZI3QAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 12:00:04 -0400
Date: Wed, 30 Sep 2009 12:00:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Philipp Reisner <philipp.reisner@linbit.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, drbd-dev@lists.linbit.com,
       mingo@elte.hu, rostedt@goodmis.org
Subject: Re: [Drbd-dev] [PATCH -next] drbd: trace depends on TRACING
Message-ID: <20090930160001.GA3765@infradead.org>
References: <20090925133830.1ba29584.sfr@canb.auug.org.au> <4ABD4C28.9070202@oracle.com> <200909291732.51383.philipp.reisner@linbit.com> <20090929153747.GA29621@infradead.org> <20090930080221.GA8032@barkeeper1-xen.linbit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930080221.GA8032@barkeeper1-xen.linbit>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 10:02:21AM +0200, Lars Ellenberg wrote:
> TRACE_EVENT macros depend on, and use TRACE_POINTS.
> And those trace points are what compiles away if !CONFIG_TRACEPOINTS, no?

Everything compiles away when the right options are not selected.

> If using tracepoints directly, not using the (admittedly elegant)
> trace-events macro system, is in fact not wanted anymore, then
> Documentation/trace/* should be changed accordingly.

I could not find anything actively suggesting to use them.  And if you
look at current mainline there is in fact no user of raw tracepoints
left and none should be introduced.  If you add fancy new tracing it
might be a good idea to run it past Ingo and Steve, btw.

Ingo, now that we killed all raw tracepoints users, what do you think
about removing Documentation/trace/tracepoints.txt and
samples/tracepoints so that people have no easy way to use them?

Even better would be making their use really hard, which is not too easy
as they are used by TRACE_EVENT underneath.

> So what is the plan, going forward?

The plan is that all new tracing should use TRACE_EVENT.  If that
doesn't work for some reason bring it up with the tracing people
for discussion.

