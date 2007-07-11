Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbXGKSrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbXGKSrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbXGKSrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:47:09 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:13151 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbXGKSrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:47:07 -0400
Date: Wed, 11 Jul 2007 20:47:01 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Theodore Tso <tytso@mit.edu>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Amit Arora <aarora@in.ibm.com>, Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>, "Luck, Tony" <tony.luck@intel.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mark Fasheh <mark.fasheh@oracle.com>, linux-arch@vger.kernel.org
Subject: Re: fallocate-implementation-on-i86-x86_64-and-powerpc.patch
Message-ID: <20070711184701.GA9035@osiris.ibm.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710115251.GG2343@thunk.org> <20070710101558.cea7aab1.akpm@linux-foundation.org> <4693C580.2000506@garzik.org> <18068.5612.100418.782729@cargo.ozlabs.ibm.com> <20070710171650.642881db.akpm@linux-foundation.org> <18068.10601.792839.787025@cargo.ozlabs.ibm.com> <20070711153939.GA19456@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711153939.GA19456@thunk.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 11:39:39AM -0400, Theodore Tso wrote:
> On Wed, Jul 11, 2007 at 10:50:49AM +1000, Paul Mackerras wrote:
> > > On Wed, 11 Jul 2007 09:27:40 +1000
> > > Paul Mackerras <paulus@samba.org> wrote:
> > > 
> > > > We did come up with an order that worked for everybody, but that
> > > > discussion seemed to get totally ignored by the ext4 developers.
> 
> Well, in the end it was a toss-up between
> 
> asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> 
> and 
> 
> asmlinkage long sys_fallocate(loff_t offset, loff_t len, int fd, int mode)
> 
> There were a number of folks who preferred having int fd first, and I
> *thought* Amit had gotten agreement from either Martin or Heiko that
> it was ok to do this as an exception, even though it was extra work
> for that arch.  But if not, we can try going back the second
> alternative, or even the 6 32-bits args (off_high, off_low, len_high,
> len_low) approach, but I think that drew even more fire. 

The second approach would work for all architectures..  but some people
didn't like (no technical reason) not having fd as first argument.

Just go ahead with the current approach. s390 seems to be the only
architecture which suffers from this and I wouldn't like to start this
discussion again.
