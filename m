Return-Path: <linux-kernel-owner+w=401wt.eu-S1765785AbYEBB5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765785AbYEBB5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbYEBB53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:57:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40292 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbYEBB52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:57:28 -0400
Date: Thu, 1 May 2008 21:57:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       hch@infradead.org, adobriyan@gmail.com, bunk@kernel.org
Subject: Re: [PATCH] add typecheck on irqsave and friends for correct flags
In-Reply-To: <20080501184905.b7e0dade.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0805012155530.27082@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805011946290.12785@gandalf.stny.rr.com>
 <20080501172810.fa39dad6.akpm@linux-foundation.org>
 <Pine.LNX.4.58.0805012114180.31096@gandalf.stny.rr.com>
 <20080501184905.b7e0dade.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 1 May 2008, Andrew Morton wrote:
> >
> > Then we would have been forced to do the
> >
> > 	irqflags_t spin_lock_irqsave(spinlock_t *lock);
> >
> > trick. Which would probably be the better long term solution, but the
> > biggest PITA for you in the short term.
>
> We should have done that from day one.  If there's an architecture out
> there which cannot fit its interrupt state into its unsigned long (hard to
> believe) then it'll need to pull stunts with cookies and lookups or
> something.  And on 64-bit architectures we're using 4 more bytes of local
> storage than is needed.
>
> But I don't think we've had enough problems with this particular issue to
> justify a kernel-wide edit like that.  And this patch should settle the
> issue.

I'm just thinking of all the wonderful tricks at hand if we had a special
irqflags_t type. But I'm sure you don't want any more special tricks from
us with respect to spinlocks ;-)

-- Steve

