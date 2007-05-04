Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbXEDL7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbXEDL7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXEDL7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:59:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbXEDL7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:59:05 -0400
Message-ID: <463B1FF6.1030904@redhat.com>
Date: Fri, 04 May 2007 07:58:46 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au>
In-Reply-To: <463B108C.10602@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Rik van Riel wrote:
>> With lazy freeing of anonymous pages through MADV_FREE, performance of
>> the MySQL sysbench workload more than doubles on my quad-core system.
> 
> OK, I've run some tests on a 16 core Opteron system, both sysbench with
> MySQL 5.33 (set up as described in the freebsd vs linux page), and with
> ebizzy.
> 
> What I found is that, on this system, MADV_FREE performance improvement
> was in the noise when you look at it on top of the MADV_DONTNEED glibc
> and down_read(mmap_sem) patch in sysbench.

Interesting, very different results from my system.

First, did you run with the properly TLB batched version of
the MADV_FREE patch?  And did you make sure that MADV_FREE
takes the mmap_sem for reading?   Without that, I did see
a similar thing to what you saw...

Secondly, I'll have to try some test runs one of the larger
systems in the lab.

Maybe the results from my quad core Intel system are not
typical; maybe the results from your 16 core Opteron are
not typical.  Either way, I want to find out :)

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
