Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbXJXBta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbXJXBta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 21:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXJXBtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 21:49:22 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55523 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbXJXBtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 21:49:22 -0400
Date: Tue, 23 Oct 2007 19:49:20 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Matt Mackall <mpm@selenic.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Message-ID: <20071024014920.GU27248@parisc-linux.org>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx> <20071023221116.GL17536@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023221116.GL17536@waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 05:11:16PM -0500, Matt Mackall wrote:
> You might want to consider growing the buffer by no less than a small
> constant factor like 1.3x. This will keep things that do short concats
> in a loop from degrading to O(n^2) performance due to realloc and
> memcpy.

I looked at slab and slub, and would grow the buffer by no less than
1.5x each time, thanks to the buckets.  I'd initially implemented 2x,
but switched to allocating size+1 and calling ksize() as being a more
efficient implementation.

I presume slob is different?  Actually, slob doesn't seem to
provide krealloc, so I think stringbuf won't work on slob.  Will you
have time to fix this?

> Should probably just bite the bullet and pass a flag.

Hrm.

extern void sb_printf(struct stringbuf *sb, gfp_t gfp, const char *fmt, ...)
        __attribute__((format(printf, 3, 4)));

?  Any objections?

> > +#define INITIAL_SIZE 32
> 
> Too small. That will guarantee that most users end up doing a realloc.
> Can we have 128 instead?

I don't care.  Sure!

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
