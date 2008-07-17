Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbYGQS0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbYGQS0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759228AbYGQS0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:26:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:43552 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566AbYGQS0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:26:25 -0400
Subject: Re: [PATCH] : A better approach to compute int_sqrt in
	lib/int_sqrt.c
From: Peter Zijlstra <peterz@infradead.org>
To: Soumyadip Das Mahapatra <soumya.linux@yahoo.com>
Cc: linux-kernel@vger.kernel.org,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
In-Reply-To: <848307.13278.qm@web59505.mail.ac4.yahoo.com>
References: <848307.13278.qm@web59505.mail.ac4.yahoo.com>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 20:26:55 +0200
Message-Id: <1216319215.5232.116.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 14:35 -0700, Soumyadip Das Mahapatra wrote:


> 0 It is better because 
>          o it uses only one loop instead of two
>          o contains no division operator (older version has two)
>             which are surely comparatively slow task in computer

As Lennart has said, gcc is smart enough to transform a division by a
power-of-two into shifts.

> 0 Currently find . -name '*.[ch]' | xargs grep int_sqrt gives me this
>         ....
>         ./fs/nfs/write.c:       nfs_congestion_kb = (16*int_sqrt(totalram_pages)) << (PAGE_SHIFT-10);
>         ./drivers/video/fbmon.c:        h_period = int_sqrt(h_period);
>         ./mm/page_alloc.c:      min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
>         ./mm/oom_kill.c:        s = int_sqrt(cpu_time);
>         ./mm/oom_kill.c:        s = int_sqrt(int_sqrt(run_time));
>         ....

fs/nfs/write.c is init code
mm/page_alloc.c is also init code
mm/oom_kill.c isn't a hot path

which leaves the fbmon case, which after a quick peek is setup code, so
not a hot path either.

So while that doesn't preclude us from changing it if you can indeed
show its a better implementation, its not on anybodies hit-list.

