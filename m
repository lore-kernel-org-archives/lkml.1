Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbYGaJec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbYGaJec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 05:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbYGaJdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 05:33:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:50476 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbYGaJdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:33:52 -0400
Subject: Re: Switching TestSetPageLocked to trylock_page
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200807311726.51816.nickpiggin@yahoo.com.au>
References: <200807311726.51816.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 11:33:48 +0200
Message-Id: <1217496828.8157.80.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 17:26 +1000, Nick Piggin wrote:
> Hi,
> 
> I'm wondering if I could get a patch merged which changes all
> TestSetPageLocked and replaces them with trylock_page?
> 
> It would be done so there are no functional changes.
> 
> The reason I want to (aside from having a slightly more
> intuitive API), is to facilitate the implementation of lockdep
> on page lock, and also to use lock semantics bitops for the
> lock rather than the big-hammer barriers that come with
> test_and_set_bit.
> 
> The lock bitops stuff is one of the parts of my patchset to speed
> up page lock functions (which results in nearly 50% faster
> pagecache throughput on my G5, and even slightly faster on x86)...
> 
> Anyway, I remember you said these kinds of changes are appropriate
> for just after -rc1, and I agree it shouldn't cause much pain.
> 
> Fixing up patch conflicts is literally a matter of
> s/!TestSetPageLocked/trylock_page
> s/TestSetPageLocked/!trylock_page
> 
> Thoughts?

I'm all for it ;-)

