Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbXJIVfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbXJIVfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 17:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbXJIVfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 17:35:14 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:56862 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbXJIVfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 17:35:13 -0400
Date: Tue, 9 Oct 2007 14:00:25 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: remove zero_page (was Re: -mm merge plans for 2.6.24)
In-Reply-To: <200710090117.47610.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0710091350090.17543@blonde.wat.veritas.com>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
 <200710030345.10026.nickpiggin@yahoo.com.au>
 <alpine.LFD.0.999.0710030813090.3579@woody.linux-foundation.org>
 <200710090117.47610.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007, Nick Piggin wrote:
> 
> The commit b5810039a54e5babf428e9a1e89fc1940fabff11 contains the note
> 
>   A last caveat: the ZERO_PAGE is now refcounted and managed with rmap
>   (and thus mapcounted and count towards shared rss).  These writes to
>   the struct page could cause excessive cacheline bouncing on big
>   systems.  There are a number of ways this could be addressed if it is
>   an issue.
> 
> And indeed this cacheline bouncing has shown up on large SGI systems.
> There was a situation where an Altix system was essentially livelocked
> tearing down ZERO_PAGE pagetables when an HPC app aborted during startup.
> This situation can be avoided in userspace, but it does highlight the
> potential scalability problem with refcounting ZERO_PAGE, and corner
> cases where it can really hurt (we don't want the system to livelock!).
> 
> There are several broad ways to fix this problem:
> 1. add back some special casing to avoid refcounting ZERO_PAGE
> 2. per-node or per-cpu ZERO_PAGES
> 3. remove the ZERO_PAGE completely
> 
> I will argue for 3. The others should also fix the problem, but they
> result in more complex code than does 3, with little or no real benefit
> that I can see. Why?

Sorry, I've no useful arguments to add (and my testing was too much
like yours to add any value), but I do want to go on record as still
a strong supporter of approach 3 and your patch.

Hugh
