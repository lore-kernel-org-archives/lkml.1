Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXFXNUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXFXNUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 09:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbXFXNUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 09:20:44 -0400
Received: from mail.suse.de ([195.135.220.2]:45613 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbXFXNUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 09:20:43 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] fsblock
References: <20070624014528.GA17609@wotan.suse.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 24 Jun 2007 16:16:29 +0200
In-Reply-To: <20070624014528.GA17609@wotan.suse.de>
Message-ID: <p73lke95tfm.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:
> 
> - Structure packing. A page gets a number of buffer heads that are
>   allocated in a linked list. fsblocks are allocated contiguously, so
>   cacheline footprint is smaller in the above situation.

It would be interesting to test if that makes a difference for 
database benchmarks running over file systems. Databases
eat a lot of cache so in theory any cache improvements
in the kernel which often runs cache cold then should be beneficial. 

But I guess it would need at least ext2 to test; Minix is probably not
good enough.

In general have you benchmarked the CPU overhead of old vs new code? 
e.g. when we went to BIO scalability went up, but CPU costs
of a single request also went up. It would be nice to not continue
or better reverse that trend.

> - Large block support. I can mount and run an 8K block size minix3 fs on
>   my 4K page system and it didn't require anything special in the fs. We
>   can go up to about 32MB blocks now, and gigabyte+ blocks would only
>   require  one more bit in the fsblock flags. fsblock_superpage blocks
>   are > PAGE_CACHE_SIZE, midpage ==, and subpage <.

Can it be cleanly ifdefed or optimized away?  Unless the fragmentation
problem is not solved it would seem rather pointless to me. Also I personally
still think the right way to approach this is larger softpage size.

-Andi
