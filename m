Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbXJPBBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbXJPBBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 21:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbXJPBAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 21:00:54 -0400
Received: from waste.org ([66.93.16.53]:41802 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbXJPBAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 21:00:53 -0400
Date: Mon, 15 Oct 2007 19:58:32 -0500
From: Matt Mackall <mpm@selenic.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 10/11] maps3: add /proc/kpagecount and /proc/kpageflags interfaces
Message-ID: <20071016005832.GD19691@waste.org>
References: <11.290135367@selenic.com> <1192488513.6118.98.camel@localhost> <20071015231106.GX19691@waste.org> <1192491297.6118.129.camel@localhost> <20071016003538.GC19691@waste.org> <1192495750.6118.152.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192495750.6118.152.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 05:49:10PM -0700, Dave Hansen wrote:
> On Mon, 2007-10-15 at 19:35 -0500, Matt Mackall wrote:
> > Perhaps we need something like:
> > 
> > flags = page->flags;
> > userflags = 
> >           FLAG_BIT(USER_REFERENCED, flags & PG_referenced) |
> >           ...
> > 
> > etc. for the flags we want to export. This will let us change to
> > 
> >          FLAG_BIT(USER_SLAB, PageSlab(page)) |
> > 
> > if we make a virtual slab bit.
> 
> Yeah, that looks like a pretty sane scheme.  Do we want to be any more
> abstract about it?  Perhaps instead of USER_SLAB, it should be
> USER_KERNEL_INTERNAL, or USER_KERNEL_USE.  The slab itself is going away
> as we speak. :)

Perhaps. SLUB is still "a slab-based allocator". SLOB isn't, but I
intend to start making it use PG_slab shortly anyway.
 
> > And it shows up in grep.
> > 
> > Unfortunately, i386 test_bit is an asm inline and not a macro so we
> > can't hope for the compiler to fold up a bunch of identity bit
> > mappings for us. 
> 
> We could also Yeah, that looks like a pretty sane scheme.  Do we want to
> be any more abstract about it?  Perhaps instead of USER_SLAB, it should
> be USER_KERNEL_INTERNAL, or USER_KERNEL_USE.  The slab itself is going
> away as we speak.
> 
> For the bits that we want to export, we could also add the unoptimized
> access functions for any that don't already have them:
> 
> #define __ClearPageReserved(page)       __clear_bit(PG_reserved, &(page)->flags)

Confused. Why are we interested in clear?

-- 
Mathematics is the supreme nostalgia of our time.
