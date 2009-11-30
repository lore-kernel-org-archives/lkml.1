Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbZK3KAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbZK3KAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZK3KAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:00:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33494 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbZK3KAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:00:36 -0500
Date: Mon, 30 Nov 2009 05:00:41 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091130100041.GA29610@infradead.org>
References: <20091123145409.GA29627@wotan.suse.de> <alpine.LFD.2.00.0911280927180.2561@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911280927180.2561@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 09:30:18AM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 23 Nov 2009, Nick Piggin wrote:
> > 
> > Last time this issue came up that I could see, I don't think
> > there were objections to making rwlocks fair, the main
> > difficulty seemed to be that we allow reentrant read locks
> > (so a write lock waiting must not block arbitrary read lockers).
> 
> We have at least one major rwlock user - tasklist_lock or whatever. And 
> that one definitely depends on being able to do 'rwlock()' in an 
> interrupt, without other rwlock'ers having to disable irq's (even if there 
> might be a new writer coming in on another cpu).

How long will this use be around?  I've seen some slow progress toward
replacing most read side uses of the task list lock with RCU.  While we
still have lots of read side users now I wonder when they'll go away.

