Return-Path: <linux-kernel-owner+w=401wt.eu-S1752115AbXA1RUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbXA1RUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 12:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbXA1RUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 12:20:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56622 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbXA1RUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 12:20:32 -0500
Date: Sun, 28 Jan 2007 17:20:27 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Fwd: [PATCH 2/7] lock_list: a fine grain locked double linked list]
Message-ID: <20070128172027.GA4913@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org
References: <1169999597.10987.33.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169999597.10987.33.camel@lappy>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Provide a simple fine grain locked double link list.
> 
> It is build upon the regular double linked list primitives, spinlocks and RCU.
> 
> Locking is peculiar in that edges are locked, this avoid the circular lock
> dependancy created by the fact that the regular linked lists are circular.
> 
> Item deletion requires that both surrounding elements are locked, however since
> the locking rules dictate that we lock elements in a single direction we have
> to lock the previous element while it might be deleted under us. Hence the
> requirement that all elements are RCU freed.

I think implicitly locked data structures are very bad for code readability
and debugability.  What's even worse here is that we have a requirement that
all members are RCU freed.

Note that we also have another implicitly locked (and refcounted) list
implementation in klist.[ch] - if we find consensus that we want implicitly
locked list we should figure out whether we want lock_list or klist semantics
and stick to one of them.

What uses do you have planned for this data structure?  In general I think
we'd be better off to simplify the data structures as in my files_list_lock
proposal instead of complicating the locking.

