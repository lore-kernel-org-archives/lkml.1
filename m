Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbXJXPa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbXJXPa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 11:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758409AbXJXPah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 11:30:37 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45706 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbXJXPac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 11:30:32 -0400
Date: Wed, 24 Oct 2007 09:30:31 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Matt Mackall <mpm@selenic.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Message-ID: <20071024153031.GA27248@parisc-linux.org>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx> <20071023221116.GL17536@waste.org> <20071024014920.GU27248@parisc-linux.org> <20071024152036.GX19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024152036.GX19691@waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 10:20:36AM -0500, Matt Mackall wrote:
> On Tue, Oct 23, 2007 at 07:49:20PM -0600, Matthew Wilcox wrote:
> > I presume slob is different?  Actually, slob doesn't seem to
> > provide krealloc, so I think stringbuf won't work on slob.  Will you
> > have time to fix this?
> 
> http://lxr.linux.no/source/mm/slob.c#L207

That's 2.6.22.6; I was looking at 2.6.23, where clameter had moved
krealloc into mm/util.c.  So that explains why I thought slob didn't
provide it.  Apologies for the confusion.

> Yep, slob is different, it has no kmalloc buckets.

OK.  I have no problem with making stringbuf allocate max(oldsize * 1.5,
newsize+1).

> > extern void sb_printf(struct stringbuf *sb, gfp_t gfp, const char *fmt, ...)
> >         __attribute__((format(printf, 3, 4)));
> > 
> > ?  Any objections?
> 
> Fine by me.

OK, I'll do that for the next round of patches.

> Most of these objects will have very short lifetimes, so there's very
> little downside.

I agree.  It was good for testing though, when I inadvertently wrote to
the wrong bit of the string on a realloc ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
