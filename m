Return-Path: <linux-kernel-owner+w=401wt.eu-S1161444AbXDWLqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161444AbXDWLqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 07:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161460AbXDWLqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 07:46:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161444AbXDWLqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 07:46:14 -0400
Message-ID: <462C9C74.8040707@redhat.com>
Date: Mon, 23 Apr 2007 07:45:56 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>,
       jakub@redhat.com, drepper@redhat.com
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com>	<20070420135715.f6e8e091.akpm@linux-foundation.org>	<462932BE.4020005@redhat.com> <20070420150618.179d31a4.akpm@linux-foundation.org> <4629524C.5040302@redhat.com> <462ACA40.8070407@yahoo.com.au> <462B0156.9020407@redhat.com> <462BFAF3.4040509@yahoo.com.au> <462C2DC7.5070709@redhat.com> <462C2F33.8090508@redhat.com> <462C7A6F.9030905@redhat.com>
In-Reply-To: <462C7A6F.9030905@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:

> First some ebizzy runs...

This is interesting.  Ginormous speedups in ebizzy[1] on my quad core
test system.  The following numbers are the average of 10 runs, since
ebizzy shows some variability.

You can see a big influence from the tlb batching and from Nick's
madv_sem patch.  The reduction in system time from 100 seconds to
3 seconds is way more than I had expected, but I'm not complaining.
The 4 fold reduction in wall clock time is a nice bonus.

According to Val, ebizzy shows the weaknesses of Linux with a real
workload, so this could be a useful result.

kernel
                    user     system     wall clock    %CPU

vanilla             186s    101s       123s          230%
madv_free (madv)    175s     96s       120s          230%
mmap_sem (sem)      100s     40s        40s          370%
madv+sem            200s    140s       100s          393%
madv+sem+tlb        118s      3s        30s          395%
madv+tlb            150s     10s        50s          310%

[1] http://www.ussg.iu.edu/hypermail/linux/kernel/0604.2/1699.html
-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
