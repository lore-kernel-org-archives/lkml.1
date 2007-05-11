Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbXEKODy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbXEKODy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 10:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758491AbXEKODr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 10:03:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38406 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbXEKODq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 10:03:46 -0400
Date: Fri, 11 May 2007 15:03:37 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] scalable rw_mutex
Message-ID: <20070511140337.GA3515@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>
References: <20070511131541.992688403@chello.nl> <20070511132321.895740140@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511132321.895740140@chello.nl>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 03:15:42PM +0200, Peter Zijlstra wrote:
> Scalable reader/writer lock.
> 
> Its scalable in that the read count is a percpu counter and the reader fast
> path does not write to a shared cache-line.
> 
> Its not FIFO fair, but starvation proof by alternating readers and writers.

While this implementation looks pretty nice I really hate growing more
and more locking primitives.  Do we have any rwsem user that absolutley
needs FIFO semantics or could we convert all user over (in which case
the objection above is of course completely moot)

