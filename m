Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbZJYHuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbZJYHuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 03:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZJYHug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 03:50:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47915 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZJYHug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 03:50:36 -0400
Date: Sun, 25 Oct 2009 03:50:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, Jason Baron <jbaron@redhat.com>,
       cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: move gfs2 tracepoints to inclue/trace/events dir
Message-ID: <20091025075037.GD9482@infradead.org>
References: <20091009160115.GA2647@redhat.com> <20091009234555.GA28257@infradead.org> <1255340583.2675.23.camel@localhost.localdomain> <20091012100037.GA11653@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012100037.GA11653@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 12:00:37PM +0200, Ingo Molnar wrote:
> yeah. I have no objection to adding it to include/trace/. Tracepoints 
> are a fundamentally global business.
> 
> Subsystems can opt to hide their tracepoints locally, but it's better to 
> have a global view about what's out there, so that it can be extended 
> coherently, etc.

We're lacking quite a bit coherence even with it.  The originally reason
why there were global was that the infrastructure couldn't cope with
having the either in modules or elsewhere in the source tree at all.

We have managed to avoid global directories for drivers/filesystems for
as much as we can lately.  Having everything in a directory makes sure
it's self-contained and people don't use it accidentally from other
modules, which also applies to trace events - we don't want people
accidentally use gfs2 tracepoints from a driver (and if you think
that's far fetched look at the recent example of a driver using
debugging macros from the networking code that got pulled in
accidentally somewhere).


