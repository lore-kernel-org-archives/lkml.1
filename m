Return-Path: <linux-kernel-owner+w=401wt.eu-S933016AbXGKUal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbXGKUal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762916AbXGKUaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:30:07 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:37229 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761193AbXGKUaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:30:03 -0400
Subject: Re: fallocate-implementation-on-i86-x86_64-and-powerpc.patch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Theodore Tso <tytso@mit.edu>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Amit Arora <aarora@in.ibm.com>, Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>, "Luck, Tony" <tony.luck@intel.com>,
       Mark Fasheh <mark.fasheh@oracle.com>, linux-arch@vger.kernel.org
In-Reply-To: <20070711184701.GA9035@osiris.ibm.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <20070710115251.GG2343@thunk.org>
	 <20070710101558.cea7aab1.akpm@linux-foundation.org>
	 <4693C580.2000506@garzik.org>
	 <18068.5612.100418.782729@cargo.ozlabs.ibm.com>
	 <20070710171650.642881db.akpm@linux-foundation.org>
	 <18068.10601.792839.787025@cargo.ozlabs.ibm.com>
	 <20070711153939.GA19456@thunk.org>  <20070711184701.GA9035@osiris.ibm.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 11 Jul 2007 22:32:36 +0200
Message-Id: <1184185957.6471.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 20:47 +0200, Heiko Carstens wrote:
> > There were a number of folks who preferred having int fd first, and I
> > *thought* Amit had gotten agreement from either Martin or Heiko that
> > it was ok to do this as an exception, even though it was extra work
> > for that arch.  But if not, we can try going back the second
> > alternative, or even the 6 32-bits args (off_high, off_low, len_high,
> > len_low) approach, but I think that drew even more fire. 
> 
> The second approach would work for all architectures..  but some people
> didn't like (no technical reason) not having fd as first argument.

For s390 we would have liked the second approach with the two int's as
last arguments since it would avoid the wrapper in the kernel. It does
not avoid the wrapper in user space since the call uses 6 register on 31
bit. So the fallocate call need special treatement in glibc so I don't
mind that it needs another wrapper in the kernel.

> Just go ahead with the current approach. s390 seems to be the only
> architecture which suffers from this and I wouldn't like to start this
> discussion again.

Yes, don't worry about s390 for fallocate, the patch that had been in
-mm only had an incorrect system call number. The wrapper is fine.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


