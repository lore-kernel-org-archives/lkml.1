Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbYJCPwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbYJCPwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbYJCPwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:52:11 -0400
Received: from mail.lang.hm ([64.81.33.126]:46984 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbYJCPwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:52:10 -0400
Date: Fri, 3 Oct 2008 08:52:26 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
       chris@arachsys.com
Subject: application syncing options (was Re: [PATCH] Memory management
 livelock)
In-Reply-To: <200810031254.29121.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0810030845070.14680@asgard.lang.hm>
References: <20080911101616.GA24064@agk.fab.redhat.com> <20080923154905.50d4b0fa.akpm@linux-foundation.org> <200810031232.23836.nickpiggin@yahoo.com.au> <200810031254.29121.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; format=flowed
Content-ID: <alpine.DEB.1.10.0810030845072.14680@asgard.lang.hm>
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Nick Piggin wrote:

>> *What* is, forever? Data integrity syncs should have pages operated on
>> in-order, until we get to the end of the range. Circular writeback could
>> go through again, possibly, but no more than once.
>
> OK, I have been able to reproduce it somewhat. It is not a livelock,
> but what is happening is that direct IO read basically does an fsync
> on the file before performing the IO. The fsync gets stuck behind the
> dd that is dirtying the pages, and ends up following behind it and
> doing all its IO for it.
>
> The following patch avoids the issue for direct IO, by using the range
> syncs rather than trying to sync the whole file.
>
> The underlying problem I guess is unchanged. Is it really a problem,
> though? The way I'd love to solve it is actually by adding another bit
> or two to the pagecache radix tree,  that can be used to transiently tag
> the tree for future operations. That way we could record the dirty and
> writeback pages up front, and then only bother with operating on them.
>
> That's *if* it really is a problem. I don't have much pity for someone
> doing buffered IO and direct IO to the same pages of the same file :)

I've seen lots of discussions here about different options in syncing. in 
this case a fix is to do a fsync of a range. I've also seen discussions of 
how the kernel filesystem code can do ordered writes without having to 
wait for them with the use of barriers, is this capability exported to 
userspace? if so, could you point me at documentation for it?

David Lang
