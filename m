Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbXJPAtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbXJPAtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXJPAtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:49:15 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34319 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbXJPAtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:49:14 -0400
Subject: Re: [PATCH 10/11] maps3: add /proc/kpagecount and /proc/kpageflags
	interfaces
From: Dave Hansen <haveblue@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <20071016003538.GC19691@waste.org>
References: <11.290135367@selenic.com> <1192488513.6118.98.camel@localhost>
	 <20071015231106.GX19691@waste.org> <1192491297.6118.129.camel@localhost>
	 <20071016003538.GC19691@waste.org>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 17:49:10 -0700
Message-Id: <1192495750.6118.152.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 19:35 -0500, Matt Mackall wrote:
> Perhaps we need something like:
> 
> flags = page->flags;
> userflags = 
>           FLAG_BIT(USER_REFERENCED, flags & PG_referenced) |
>           ...
> 
> etc. for the flags we want to export. This will let us change to
> 
>          FLAG_BIT(USER_SLAB, PageSlab(page)) |
> 
> if we make a virtual slab bit.

Yeah, that looks like a pretty sane scheme.  Do we want to be any more
abstract about it?  Perhaps instead of USER_SLAB, it should be
USER_KERNEL_INTERNAL, or USER_KERNEL_USE.  The slab itself is going away
as we speak. :)

> And it shows up in grep.
> 
> Unfortunately, i386 test_bit is an asm inline and not a macro so we
> can't hope for the compiler to fold up a bunch of identity bit
> mappings for us. 

We could also Yeah, that looks like a pretty sane scheme.  Do we want to
be any more abstract about it?  Perhaps instead of USER_SLAB, it should
be USER_KERNEL_INTERNAL, or USER_KERNEL_USE.  The slab itself is going
away as we speak.

For the bits that we want to export, we could also add the unoptimized
access functions for any that don't already have them:

#define __ClearPageReserved(page)       __clear_bit(PG_reserved, &(page)->flags)

Anybody changing bit behavior will certainly go check all of the
callers, such as ClearPageReserved() *and* __ClearPageReserved().

-- Dave

