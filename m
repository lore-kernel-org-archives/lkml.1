Return-Path: <linux-kernel-owner+w=401wt.eu-S965880AbXEHPAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965880AbXEHPAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934347AbXEHPAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:00:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934247AbXEHPAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:00:35 -0400
Message-ID: <4640906B.2020301@redhat.com>
Date: Tue, 08 May 2007 10:59:55 -0400
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
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au> <463B598B.80200@redhat.com> <463BC62C.3060605@yahoo.com.au> <463E5A00.6070708@redhat.com> <464014B0.7060308@yahoo.com.au>
In-Reply-To: <464014B0.7060308@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> We have percpu and cache affine page allocators, so when
> userspace just frees a page, it is likely to be cache hot, so
> we want to free it up so it can be reused by this CPU ASAP.
> Likewise, when we newly allocate a page, we want it to be one
> that is cache hot on this CPU.

Actually, isn't the clear page function capable of doing
some magic, when it writes all zeroes into the page, that
causes the zeroes to just live in CPU cache without the old
data ever being loaded from RAM?

That would sure be faster than touching RAM.  Not sure if
we use/trigger that kind of magic, though :)

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
