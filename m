Return-Path: <linux-kernel-owner+w=401wt.eu-S965164AbXDVH1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164AbXDVH1o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965044AbXDVH1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:27:44 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965164AbXDVH1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:27:43 -0400
Date: Sun, 22 Apr 2007 00:26:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
Subject: Re: [PATCH 10/10] mm: per device dirty threshold
Message-Id: <20070422002606.ef060060.akpm@linux-foundation.org>
In-Reply-To: <1177156902.2934.96.camel@lappy>
References: <20070420155154.898600123@chello.nl>
	<20070420155503.608300342@chello.nl>
	<20070421025532.916b1e2e.akpm@linux-foundation.org>
	<1177156902.2934.96.camel@lappy>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Apr 2007 14:01:36 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Sat, 2007-04-21 at 02:55 -0700, Andrew Morton wrote:
>
> > > +
> > > +		__mod_bdi_stat64(bdi, BDI_WRITEOUT, -half);
> > > +		bdi->cycles += cycle;
> > > +	}
> > > +	bdi->cycles = global_cycle;
> > > +	spin_unlock_irqrestore(&bdi->lock, flags);
> > > +}
> > 
> > Here we get to the real critical substance of the patchset, and I don't
> > have a clue what it's doing nor how it's doing it.  And I bet nobody else
> > does either.
> 
> I shall send a comment patch; but let me try to explain:
> 
> I am trying to keep a floating proportion between the BDIs based on
> writeout events.

The term "writeout event" hasn't been defined.  I assume that it refers to
something like "one call to balance_dirty_pages()".  Or maybe "one pass
through balance_dirty_pages()'s inner loop".  Or maybe something else. 
This is important, because the reader is already a bit lost.

> That is, each device is given a share equal to its
> proportion of completed writebacks

In what units are "writebacks" measured?  Pages?

> (writeback, we are in the process of
> writing vs. writeout, we have written). This proportion is measured in a
> 'time'-span measured itself in writeouts.

time is measured how?  jiffies?  Calls to balance_dirty_pages(), or passes
around its inner loop, or...

> Example:
> 
>   device A completes 4, device B completes 12 and, device C 16 writes.

writes of what?  One page??

I think you get my point ;) Please start from the top.  Define terms before
using them, always specify in what units all things are being measured,
assume *no* prior knowledge apart from general kernel-fu.

