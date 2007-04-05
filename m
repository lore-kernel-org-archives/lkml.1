Return-Path: <linux-kernel-owner+w=401wt.eu-S1946098AbXDEIcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946098AbXDEIcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946099AbXDEIcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:32:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946098AbXDEIce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:32:34 -0400
Message-ID: <4614B3FB.2090405@redhat.com>
Date: Thu, 05 Apr 2007 04:31:55 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com>	<20070403202937.GE355@devserv.devel.redhat.com>	<4614A5CC.5080508@redhat.com> <20070405100848.db97d835.dada1@cosmosbay.com>
In-Reply-To: <20070405100848.db97d835.dada1@cosmosbay.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:

> Could you please add this patch and see if it helps on your machine ?
> 
> [PATCH] VM : mm_struct's mmap_cache should be close to mmap_sem
> 
> Avoids cache line dirtying

I could, but I already know it's not going to help much.

How do I know this?  I already have 66% idle time when running
with my patch (and without Nick Piggin's patch to take the
mmap_sem for reading only).  Interestingly, despite the idle
time increasing from 10% to 66%, throughput triples...

Saving some CPU time will probably only increase the idle time,
I see no reason your patch would reduce contention and increase
throughput.

I'm not saying your patch doesn't make sense - it probably does.
I just suspect it would have zero impact on this particular
scenario, because of the already huge idle time.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
