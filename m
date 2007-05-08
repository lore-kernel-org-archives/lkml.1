Return-Path: <linux-kernel-owner+w=401wt.eu-S966597AbXEHSfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966597AbXEHSfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966899AbXEHSfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:35:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967515AbXEHSfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:35:45 -0400
Date: Tue, 8 May 2007 14:35:28 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rik van Riel <riel@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
Message-ID: <20070508183528.GM355@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au> <463B598B.80200@redhat.com> <463BC62C.3060605@yahoo.com.au> <463E5A00.6070708@redhat.com> <464014B0.7060308@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464014B0.7060308@yahoo.com.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 04:12:00PM +1000, Nick Piggin wrote:
> I didn't actually check system and user times for the mysql
> benchmark, but that's exactly what I had in mind when I
> mentioned the poor cache behaviour this patch could cause. I
> definitely did see user times go up in benchmarks where I
> measured.
> 
> We have percpu and cache affine page allocators, so when
> userspace just frees a page, it is likely to be cache hot, so
> we want to free it up so it can be reused by this CPU ASAP.
> Likewise, when we newly allocate a page, we want it to be one
> that is cache hot on this CPU.

malloc has per-thread arenas, so when using MADV_FREE the pages
should be local to the thread as well (unless the thread has switched
to a different CPU also to the CPU) and in case of sysbench should
be cache hot as well (it is reused RSN).  With MADV_DONTNEED you need to
clear the pages while that is not necessary with MADV_FREE.

	Jakub
