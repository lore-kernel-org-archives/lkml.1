Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbXEKN1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbXEKN1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 09:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758535AbXEKN0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 09:26:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbXEKN0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 09:26:39 -0400
Message-Id: <20070511131541.992688403@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 11 May 2007 15:15:41 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH 0/2] convert mmap_sem to a scalable rw_mutex
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I was toying with a scalable rw_mutex and found that it gives ~10% reduction in
system time on ebizzy runs (without the MADV_FREE patch).

2-way x86_64 pentium D box:


2.6.21

/usr/bin/time ./ebizzy -m -P
60.10user 137.72system 1:49.59elapsed 180%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+33555877minor)pagefaults 0swaps

/usr/bin/time ./ebizzy -m -P
59.73user 139.50system 1:50.28elapsed 180%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+33555878minor)pagefaults 0swaps

/usr/bin/time ./ebizzy -m -P
59.49user 137.74system 1:49.22elapsed 180%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+33555877minor)pagefaults 0swaps

2.6.21-rw_mutex

/usr/bin/time ./ebizzy -m -P
57.85user 124.30system 1:42.99elapsed 176%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+33555877minor)pagefaults 0swaps

/usr/bin/time ./ebizzy -m -P
58.09user 124.11system 1:43.18elapsed 176%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+33555876minor)pagefaults 0swaps

/usr/bin/time ./ebizzy -m -P
57.36user 124.92system 1:43.52elapsed 176%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+33555877minor)pagefaults 0swaps


-- 

