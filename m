Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbYBAVEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbYBAVEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760205AbYBAVEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:04:10 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:43546 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760121AbYBAVEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:04:08 -0500
Date: Fri, 1 Feb 2008 22:04:04 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix ext4 bitops
Message-ID: <20080201210404.GA31271@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080201200208.GA28274@wavehammer.waldi.eu.org> <20080201122257.9524c2bb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080201122257.9524c2bb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 12:22:57PM -0800, Andrew Morton wrote:
> On Fri, 1 Feb 2008 21:02:08 +0100
> Bastian Blank <bastian@waldi.eu.org> wrote:
> 
> > Fix ext4 bitops.
> 
> This is incomplete.  Please tell us what was "fixed".
> 
> If it was a build error then please quote the compile error output in the
> changelog, as well as the usual description of what the problem is, and how
> it was fixed.

| fs/ext4/mballoc.c: In function 'ext4_mb_generate_buddy':
| fs/ext4/mballoc.c:954: error: implicit declaration of function 'generic_find_next_le_bit'

The s390 specific bitops uses parts of the generic implementation.
Include the correct header.

> > diff --git a/include/asm-s390/bitops.h b/include/asm-s390/bitops.h
> > index dba6fec..47844fc 100644
> > --- a/include/asm-s390/bitops.h
> > +++ b/include/asm-s390/bitops.h
> > @@ -762,6 +762,8 @@ static inline int sched_find_first_bit(unsigned long *b)
> >   *    23 22 21 20 19 18 17 16 31 30 29 28 27 26 25 24
> >   */
> >  
> > +#include <asm-generic/bitops/le.h>
> > +
> >  #define ext2_set_bit(nr, addr)       \
> >  	__test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
> >  #define ext2_set_bit_atomic(lock, nr, addr)       \
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-s390" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
The idea of male and female are universal constants.
		-- Kirk, "Metamorphosis", stardate 3219.8
