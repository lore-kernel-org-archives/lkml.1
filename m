Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZJFLAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZJFLAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 07:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbZJFLAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 07:00:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598AbZJFLAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 07:00:33 -0400
Date: Tue, 6 Oct 2009 13:00:00 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH][RFC] add MAP_UNLOCKED mmap flag
Message-ID: <20091006110000.GJ9832@redhat.com>
References: <20091006095111.GG9832@redhat.com>
 <200910061249.53030.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910061249.53030.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 12:49:52PM +0200, Arnd Bergmann wrote:
> On Tuesday 06 October 2009, Gleb Natapov wrote:
> > If application does mlockall(MCL_FUTURE) it is no longer possible to
> > mmap file bigger than main memory or allocate big area of anonymous
> > memory. Sometimes it is desirable to lock everything related to program
> > execution into memory, but still be able to mmap big file or allocate
> > huge amount of memory and allow OS to swap them on demand. MAP_UNLOCKED
> > allows to do that.
> > 
> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > diff --git a/include/asm-generic/mman.h b/include/asm-generic/mman.h
> > index 32c8bd6..0ab4c74 100644
> > --- a/include/asm-generic/mman.h
> > +++ b/include/asm-generic/mman.h
> > @@ -12,6 +12,7 @@
> >  #define MAP_NONBLOCK   0x10000         /* do not block on IO */
> >  #define MAP_STACK      0x20000         /* give out an address that is best suited for process/thread stacks */
> >  #define MAP_HUGETLB    0x40000         /* create a huge page mapping */
> > +#define MAP_UNLOKED    0x80000         /* pages are unlocked */
> >  
> >  #define MCL_CURRENT    1               /* lock all current mappings */
> >  #define MCL_FUTURE     2               /* lock all future mappings */
> 
> Not all architectures use asm-generic/mman.h, so you have to change
> the other architectures separately if you add a flag.
> 
Ah, good to know. Thanks.

--
			Gleb.
