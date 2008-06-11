Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbYFKDlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbYFKDlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 23:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbYFKDlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 23:41:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:59317 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922AbYFKDla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 23:41:30 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-arch@vger.kernel.org,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       David Miller <davem@davemloft.net>, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <200806111329.35894.nickpiggin@yahoo.com.au>
References: <1211852026.3286.36.camel@pasglop> <adaskvl3yb0.fsf@cisco.com>
	 <200806101219.34995.jbarnes@virtuousgeek.org>
	 <200806111329.35894.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 11 Jun 2008 13:40:44 +1000
Message-Id: <1213155644.25745.60.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-11 at 13:29 +1000, Nick Piggin wrote:
> 
> Exactly, yes. I guess everybody has had good intentions here, but
> as noticed, what is lacking is coordination and documentation.
> 
> You mention strong ordering WRT spin_unlock, which suggests that
> you would prefer to take option #2 (the current powerpc one): io/io
> is ordered and io is contained inside spinlocks, but io/cacheable
> in general is not ordered.

IO/cacheable -is- ordered on powepc in what we believe is the direction
that matter: IO reads are fully ordered vs. anything and IO writes are
ordered vs. previous cacheable stores. The only "relaxed" situation is
IO writes followed by cacheable stores, which I believe shouldn't be
a problem. (except for spinlocks for which we use the flag trick)

> I *would* prefer that io/cacheable actually is strongly ordered with
> the default accessors. Because if you have that, then the driver
> writer never has to care about memory ordering, provided they use
> correct locking for SMP issues. Same as x86. With option 2, there
> are still windows where you could possibly have issues.
> 
> For any high performance drivers that are well maintained (ie. the
> ones where slowdown might be noticed), everyone should have a pretty
> good handle on memory ordering requirements, so it shouldn't take
> long to go through and convert them to relaxed accessors.

Ben.


