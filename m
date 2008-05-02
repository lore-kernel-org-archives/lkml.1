Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYEBBu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYEBBu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbYEBBuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:50:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754370AbYEBBuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:50:16 -0400
Date: Thu, 1 May 2008 18:49:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       hch@infradead.org, adobriyan@gmail.com, bunk@kernel.org
Subject: Re: [PATCH] add typecheck on irqsave and friends for correct flags
Message-Id: <20080501184905.b7e0dade.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.58.0805012114180.31096@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805011946290.12785@gandalf.stny.rr.com>
	<20080501172810.fa39dad6.akpm@linux-foundation.org>
	<Pine.LNX.4.58.0805012114180.31096@gandalf.stny.rr.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 21:16:48 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 1 May 2008, Andrew Morton wrote:
> > > This patch adds a typecheck inside the irqsave and restore functions
> > > to flag these cases.
> >
> > hm, not exactly a thing of beauty, but it could have been worse.
> 
> Beauty is in the eye of the beholder.
>  (a mother always thinks their kid is beautiful ;-).

As long as your patch doesn't soil its diaper.

> >
> >
> > If we had implemeted these things properly, as
> >
> > 	unsigned long spin_lock_irqsave(spinlock_t *lock);
> 
> Then we would have been forced to do the
> 
> 	irqflags_t spin_lock_irqsave(spinlock_t *lock);
> 
> trick. Which would probably be the better long term solution, but the
> biggest PITA for you in the short term.

We should have done that from day one.  If there's an architecture out
there which cannot fit its interrupt state into its unsigned long (hard to
believe) then it'll need to pull stunts with cookies and lookups or
something.  And on 64-bit architectures we're using 4 more bytes of local
storage than is needed.

But I don't think we've had enough problems with this particular issue to
justify a kernel-wide edit like that.  And this patch should settle the
issue.


