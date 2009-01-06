Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbZAFXYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbZAFXYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbZAFXYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:24:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbZAFXYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:24:19 -0500
Date: Tue, 6 Jan 2009 18:24:18 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.29 -mm merge plans
Message-ID: <20090106232418.GB25103@infradead.org>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org> <20090106225744.GA10553@infradead.org> <20090106151131.b6c4ff0b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106151131.b6c4ff0b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 03:11:31PM -0800, Andrew Morton wrote:
> > I'm not sure this is a good idea.  Concurrent syncs are a bad idea
> > to start with and we should just synchronyze do_sync completely.
> > sync_filesystems as one of the main components of do_sync already
> > is synchronized in that way, and taking that to a higher level would
> > get rid of all the worries about concurrent syncs.
> 
> Yes, single-threading sys_sync() would fix the problem which that patch
> addresses.
> 
> However there are a lot of performance and correctness issues around
> sys_sync()-versus-fsync(), etc for which such a simple fix won't be
> acceptable.

fsync should really not much interac with sync at that level.  While
they both end up at same primitives at the lowest level those aren't
the ones we're trying to protect against.  I'm currently in the process
of a major rework of sys_sync/do_sync to make it work properly for
modern filesystems and the global synchronization was one of the first
things I did..

So if you have any workloads where that causes a problem please send
them my way.  Not that I can really thing of them, given the global
nature of sys_sync I can't see any benefit of doing multiple of these
in parallel.
