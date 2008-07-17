Return-Path: <linux-kernel-owner+w=401wt.eu-S1760680AbYGQSLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680AbYGQSLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbYGQSLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:11:00 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:49079 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757863AbYGQSK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:10:59 -0400
Date: Thu, 17 Jul 2008 14:10:59 -0400
To: Soumyadip Das Mahapatra <soumya.linux@yahoo.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] : A better approach to compute int_sqrt in lib/int_sqrt.c
Message-ID: <20080717181059.GL31126@csclub.uwaterloo.ca>
References: <848307.13278.qm@web59505.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <848307.13278.qm@web59505.mail.ac4.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 02:35:56PM -0700, Soumyadip Das Mahapatra wrote:
> Thanks Peter for noticing :-)
> Sorry, I should have it explained before. Really sorry
> for that. Here are they...
> 
> 0 It is better because 
>          o it uses only one loop instead of two
>          o contains no division operator (older version has two)
>             which are surely comparatively slow task in computer
> 
> 0 Currently find . -name '*.[ch]' | xargs grep int_sqrt gives me this
>         ....
>         ./fs/nfs/write.c:       nfs_congestion_kb = (16*int_sqrt(totalram_pages)) << (PAGE_SHIFT-10);
>         ./drivers/video/fbmon.c:        h_period = int_sqrt(h_period);
>         ./mm/page_alloc.c:      min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
>         ./mm/oom_kill.c:        s = int_sqrt(cpu_time);
>         ./mm/oom_kill.c:        s = int_sqrt(int_sqrt(run_time));
>         ....
>   So this function works in critical computing sections like frame-buffer, paging.
>   Which means betterment of this function should not be ignored.
>   Besides, if there is a better way to do things then why should not we do that ?
> 
> Anyways thanks :-)

So so far the line:
        if((m * m) > x)
overflows easily in which case the result is wrong.

Also at least on my Athlon 2500, this new algorithm takes 3.5 times
longer than the old one to get result when doing all square roots from 0
to 200000000, which is no improvement.

-- 
Len Sorensen
