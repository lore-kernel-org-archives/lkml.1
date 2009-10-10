Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZJJIB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZJJIB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 04:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZJJIBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 04:01:55 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42984 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbZJJIBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 04:01:54 -0400
Date: Sat, 10 Oct 2009 10:01:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fio rand read/write regression with 2.6.32-rc3
Message-ID: <20091010080117.GN9228@kernel.dk>
References: <1255153724.25078.68.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255153724.25078.68.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10 2009, Zhang, Yanmin wrote:
> Comparing with 2.6.23-rc1's result, fio rand read write has regression
> on my 2*4 core stoakley machine (8GB memory) with a JBOD of 12 disks.
> 
> Every disk has 8 1-GB files. Start 8 sub-processes per disk and every
> process random chooses a file on the disk to do 36 times of file read or
> write on the file and then choose another file.
> 
> 
> fio_mmap_rand_read_4k regresion is about 35%.

Heh, I seem to recollect I told Linus that this would cost is 30-40%
performance. So not totally crazy.

So yes, this isn't hugely unexpected. If you send me your fio job files,
I'll try and see what I can do about it.

> Bisect down to patch:
> 1d2235152dc745c6d94bedb550fea84cffdbf768 is first bad commit
> commit 1d2235152dc745c6d94bedb550fea84cffdbf768
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Fri Oct 2 19:27:04 2009 +0200
> 
>     cfq-iosched: add a knob for desktop interactiveness
> 
> 
> After I revert the patch against 2.6.23-rc3, fio_mmap_rand_read_4k regression
> disappears.
> 
> fio_mmap_randrw_4k has less than 20% regression and reverting the patch
> could restore performance.
> 
> On another stoakley machine with another JBOD, we see the similiar regression.
> 
> ffsb rand read/write has a bigger regression and reverting the patch
> could restore performance.
> 
> Yanmin
> 
> 

-- 
Jens Axboe

