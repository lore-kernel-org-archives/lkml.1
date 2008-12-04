Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYLDCPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYLDCPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 21:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYLDCPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 21:15:30 -0500
Received: from ozlabs.org ([203.10.76.45]:40189 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbYLDCP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 21:15:28 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: Yet more ARM breakage in linux-next
Date: Thu, 4 Dec 2008 12:45:24 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, "Stephen Rothwell" <sfr@canb.auug.org.au>
References: <20081203192905.GA12502@flint.arm.linux.org.uk> <200812040952.44957.rusty@rustcorp.com.au> <8bd0f97a0812031733n18184927m2b4fcfa0ed05cd7b@mail.gmail.com>
In-Reply-To: <8bd0f97a0812031733n18184927m2b4fcfa0ed05cd7b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812041245.24568.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008 12:03:57 Mike Frysinger wrote:
> On Wed, Dec 3, 2008 at 18:22, Rusty Russell wrote:
> > On Thursday 04 December 2008 07:11:09 Andrew Morton wrote:
> >> On Wed, 3 Dec 2008 19:29:05 +0000
> >>
> >> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> >> > This seems to be causing lots of ARM breakage:
> >> >
> >> > lib/find_next_bit.c:183: error: implicit declaration of function
> >> > '__fls'
> >> >
> >> > Whoever's responsible,
> >>
> >> git-blame?
> >
> > It's me.  Turns out sparc, avr32 and arm all don't define __fls in their
> > asm/bitops.h, and I'm the first one to use it in generic code.
>
> the Blackfin port also does not ... you going to post a change for
> that since the build breaks for Blackfin atm too ?
> -mike

Sure, why not join the party!

(Hmm, maybe I should change that list to a shorter list of archs which
*do* define __fls?)

blackfin: define __fls

Like fls, but can't be handed 0 and returns the bit number.

(I broke this arch in linux-next by using __fls in generic code).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/blackfin/include/asm/bitops.h b/arch/blackfin/include/asm/bitops.h
--- a/arch/blackfin/include/asm/bitops.h
+++ b/arch/blackfin/include/asm/bitops.h
@@ -213,6 +213,7 @@ static __inline__ int __test_bit(int nr,
 #endif				/* __KERNEL__ */
 
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
 
 #endif				/* _BLACKFIN_BITOPS_H */

