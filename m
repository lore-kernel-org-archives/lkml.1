Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbZEKIOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbZEKIOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZEKIOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:14:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51049 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbZEKIOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:14:15 -0400
Date: Mon, 11 May 2009 10:14:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-rc deadline scheduler performance regression for iozone
	over NFS
Message-ID: <20090511081415.GL4694@kernel.dk>
References: <x49hc0f79k9.fsf@segfault.boston.devel.redhat.com> <20090508120119.8c93cfd7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508120119.8c93cfd7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08 2009, Andrew Morton wrote:
> On Thu, 23 Apr 2009 10:01:58 -0400
> Jeff Moyer <jmoyer@redhat.com> wrote:
> 
> > Hi,
> > 
> > I've been working on CFQ improvements for interleaved I/Os between
> > processes, and noticed a regression in performance when using the
> > deadline I/O scheduler.  The test uses a server configured with a cciss
> > array and 1Gb/s ethernet.
> > 
> > The iozone command line was:
> >   iozone -s 2000000 -r 64 -f /mnt/test/testfile -i 1 -w
> > 
> > The numbers in the nfsd's row represent the number of nfsd "threads".
> > These numbers (in MB/s) represent the average of 5 runs.
> > 
> >                v2.6.29
> > 
> > nfsd's  |   1    |  2   |   4   |   8
> > --------+---------------+-------+------
> > deadline| 43207 | 67436 | 96289 | 107590
> > 
> >               2.6.30-rc1
> > 
> > nfsd's  |   1   |   2   |   4   |   8
> > --------+---------------+-------+------
> > deadline| 43732 | 68059 | 76659 | 83231
> > 
> >     2.6.30-rc3.block-for-linus
> > 
> > nfsd's  |   1   |   2   |   4   |   8
> > --------+---------------+-------+------
> > deadline| 46102 | 71151 | 83120 | 82330
> > 
> > 
> > Notice the drop for 4 and 8 threads.  It may be worth noting that the
> > default number of NFSD threads is 8.
> > 
> 
> I guess we should ask Rafael to add this to the post-2.6.29 regression
> list.

I agree. It'd be nice to bisect this one down, I'm guessing some mm
change has caused this writeout regression.

-- 
Jens Axboe

