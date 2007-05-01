Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbXEABYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbXEABYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 21:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbXEABYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 21:24:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbXEABYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 21:24:11 -0400
Message-ID: <463696A9.8020909@redhat.com>
Date: Mon, 30 Apr 2007 21:23:53 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Michael Kerrisk <mtk-manpages@gmx.net>
Subject: Re: MADV_FREE functionality
References: <20070430162007.ad46e153.akpm@linux-foundation.org>	<46368FAA.3080104@redhat.com> <20070430181839.c548c4da.akpm@linux-foundation.org>
In-Reply-To: <20070430181839.c548c4da.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>> If you need any additional information, please let me know.
> 
> The patch doesn't update the various comments in madvise.c at all, which is
> a surprise.  Could you please check that they are all accurate and complete?

I'll take a look.

> Also, where did we end up with the Solaris compatibility?
> 
> The patch I have at present retains MADV_FREE=0x05 for sparc and sparc64
> which should be good.
> 
> Did we decide that the Solaris and Linux implementations of MADV_FREE are
> compatible?

Yes, the Linux, Solaris and FreeBSD implementations of MADV_FREE
appear to have equivalent semantics.

> What about the Solaris and Linux MADV_DONTNEED implementations?

This was never, and is still not, the same.  Linux will throw
away the data in anonymous pages while POSIX says we should
simply move the data to swap.  I assume Solaris and FreeBSD
will move the data to swap instead of throwing it away.

For file backed pages I suspect they all behave the same.

This is the reason that inside glibc, POSIX_MADV_DONTNEED is
a noop.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
