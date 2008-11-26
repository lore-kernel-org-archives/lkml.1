Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbYKZMc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbYKZMc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYKZMct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:32:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYKZMcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:32:48 -0500
Date: Wed, 26 Nov 2008 13:32:46 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ying Han <yinghan@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>, David Rientjes <rientjes@google.com>,
       Rohit Seth <rohitseth@google.com>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
Message-ID: <20081126123246.GB23649@wotan.suse.de>
References: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com> <20081123091843.GK30453@elte.hu> <604427e00811251042t1eebded6k9916212b7c0c2ea0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <604427e00811251042t1eebded6k9916212b7c0c2ea0@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 10:42:47AM -0800, Ying Han wrote:
> >> The patch flags current->flags to PF_FAULT_MAYRETRY as identify that
> >> the caller can tolerate the retry in the filemap_fault call patch.
> >>
> >> Benchmark is done by mmap in huge file and spaw 64 thread each
> >> faulting in pages in reverse order, the the result shows 8%
> >> porformance hit with the patch.
> >
> > I suspect we also want to see the cases where this change helps?
> i am working on more benchmark to show performance improvement.

Can't you share the actual improvement you see inside Google?

Google must be doing something funky with threads, because both
this patch and their new malloc allocator apparently were due to
mmap_sem contention problems, right?

That was before the kernel and glibc got together to fix the stupid
mmap_sem problem in malloc (shown up in that FreeBSD MySQL thread);
and before private futexes. I would be interested to know if Google
still has problems that require this patch...

