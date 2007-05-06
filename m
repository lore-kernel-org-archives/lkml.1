Return-Path: <linux-kernel-owner+w=401wt.eu-S1750773AbXEFWnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750773AbXEFWnv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 18:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbXEFWnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 18:43:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXEFWnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 18:43:50 -0400
Message-ID: <463E5A00.6070708@redhat.com>
Date: Sun, 06 May 2007 18:43:12 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au> <463B598B.80200@redhat.com> <463BC62C.3060605@yahoo.com.au>
In-Reply-To: <463BC62C.3060605@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> OK, sure. I think we need more numbers though.

Thinking about the issue some more, I think I know just the
number we might want to know.

It is pretty obvious that the kernel needs to do less work
with the MADV_FREE code present.  However, it is possible
that userspace needs to do more work, by accessing pages
that are not in the CPU cache, or in another CPU's cache.

In the test cases where you see similar performance on the
workload with and without the MADV_FREE code, are you by any
chance seeing lower system time and higher user time?

I think that maybe for 2.6.22 we should just alias MADV_FREE
to run with the MADV_DONTNEED functionality, so that the glibc
people can make the change on their side while we figure out
what will be the best thing to do on the kernel side.

I'll send in a patch that does that once Linus has committed
your most recent flood of patches.  What do you think?

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
