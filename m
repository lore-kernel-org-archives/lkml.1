Return-Path: <linux-kernel-owner+w=401wt.eu-S932925AbZJGMKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbZJGMKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932850AbZJGMKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:10:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932839AbZJGMKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 08:10:21 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: zach.brown@oracle.com, linux-aio <linux-aio@kvack.org>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v4 0/3] aio: implement request batching [more performance numbers]
References: <x49zl8976g3.fsf@segfault.boston.devel.redhat.com>
	<x49eipga02o.fsf@segfault.boston.devel.redhat.com>
	<20091006180628.GB5216@kernel.dk>
	<x49y6no8jxw.fsf@segfault.boston.devel.redhat.com>
	<20091007105259.GD8703@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 07 Oct 2009 08:09:10 -0400
In-Reply-To: <20091007105259.GD8703@kernel.dk> (Jens Axboe's message of "Wed,
	7 Oct 2009 12:52:59 +0200")
Message-ID: <x49k4z72yop.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> So here's a pretty basic test. It does random reads from a bunch of
> devices, I tested both 4kb and 64kb block sizes. Queue depth used is 32
> for both cases, but note that this test uses a thread per device (so the
> queue depth is 32 per device). Results are averaged over 3 runs.
> slat/clat are the submission and completion latencies, they are in
> microseconds here.
>
> 4kb random reads
>
> kernel               sys     IOPS       slat    clat
> ----------------------------------------------------
> 2.6.32-rc3+patch    25.8%   192500      7.9     2606
> 2.6.32-rc3          27.4%   191300      8.4     2612
>
>
>
> 64kb random reads
>
> kernel               sys     IOPS       slat    clat
> ----------------------------------------------------
> 2.6.32-rc3+patch     2.5%    24590      9.7     9681
> 2.6.32-rc3           2.5%    24580      9.4     9691
>
> So pretty close, nothing earth shattering here. What the results above
> do not show is that the 4kb test runs very stable with your patch.
> Mainline fluctuates somewhat in the bandwidth, most likely due to the
> varying depth.

OK, good news.  Thanks for testing!

Cheers,
Jeff
