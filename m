Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbZEWTyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbZEWTyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 15:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbZEWTyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 15:54:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44713 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbZEWTyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 15:54:04 -0400
Date: Sat, 23 May 2009 21:54:05 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ad van den Broek <advandenbroek.nl@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PIPE_SIZE aspects
Message-ID: <20090523195405.GW11363@kernel.dk>
References: <9f924d250905220239k1dc36aaeib3c2ec955267038a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f924d250905220239k1dc36aaeib3c2ec955267038a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22 2009, Ad van den Broek wrote:
> I searched the net regarding PIPE_SIZE aspects.
> This is what I found:
> 
> * The constant PIPE_SIZE
> establishes the number of bytes allocated for a pipe
> (the size of the pipe buffer)
> 
> * The default of PIPE_SIZE (in Linux 2.4) is PAGE_SIZE.
> * The default of PIPE_SIZE (in Linux 2.6) is 64K.
> 
> * PAGE_SIZE (in Linux 2.4) is CPU/hw depending,
>   may not be changed and is 4K for x86.
> * PAGE_SIZE (in Linux 2.6) is 64K.

No changes for PAGE_SIZE, it's still hw dependent (and, one some archs,
dependent on kernel config).

> * PIPE_SIZE can be changed in Linux 2.4,
>   but it should be NOT larger than PAGE_SIZE
>   or a patch should be implemented
> 
>  I found a patch (I believe the author is Julian Bradfield) at
>  http://lse.sourceforge.net/pipe/2.4.9-pipe.patch
>  and this patch is modified by Manfred Spraul which version can be found at
>  http://linuxperf.sourceforge.net/patches/2.4.13-largepipe.patch
>  It is tested with PIPE_SIZE from 1 upto 2,4,8 pages.
>  and the result is at http://lse.sourceforge.net/pipe/pipe-report.txt
> 
> 
> My questions:
>  Is the above info correct ?
>  Is the large pipe patch still correct for last 2.4.x versions ?
>  Is such a patch also required/possible in Linux 2.6
>  to allow PIPE_SIZE > PAGE_SIZE or is that different in 2.6 ?

2.6 uses an array of pages for the pipe. So while the x86 page size is
still 4kb, a pipe is by default 64kb because the array holds 16 pages.

I wrote a patch to set/get the pipe size for 2.6 if you are interested.
Find it here:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=24547ac4d97bebb58caf9ce58bd507a95c812a3f

-- 
Jens Axboe

