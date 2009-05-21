Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbZEUTJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbZEUTJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 15:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbZEUTJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 15:09:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45473 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbZEUTJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 15:09:31 -0400
Message-ID: <4A15A69F.3040604@redhat.com>
Date: Thu, 21 May 2009 15:08:15 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page allocator
References: <20090520183045.GB10547@oblivion.subreption.com> <1242852158.6582.231.camel@laptop>
In-Reply-To: <1242852158.6582.231.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> Seems like a particularly wasteful use of a pageflag. Why not simply
> erase the buffer before freeing in those few places where we know its
> important (ie. exactly those places you now put the pageflag in)?

You don't always know this at page free time.

I could see the PG_sensitive flag being used from
userspace through mmap or madvise flags.  This way
the sensitive memory from a program like gpg would
be cleaned, even if gpg died in a segfault accident.

I could also imagine the suspend-to-disk code skipping
PG_sensitive pages when storing data to disk, and
replacing it with some magic signature so programs
that use special PG_sensitive buffers can know that
their crypto key disappeared after a restore.

