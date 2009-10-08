Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbZJHM6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbZJHM6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 08:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757971AbZJHM6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 08:58:24 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42553 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757928AbZJHM6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 08:58:23 -0400
Date: Thu, 8 Oct 2009 14:57:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091008125746.GL9228@kernel.dk>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain> <20091008123622.GA30316@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008123622.GA30316@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08 2009, Nick Piggin wrote:
> On Wed, Oct 07, 2009 at 07:56:33AM -0700, Linus Torvalds wrote:
> > On Wed, 7 Oct 2009, Nick Piggin wrote:
> > > 
> > > OK, I have a really basic patch that does store-free path walking
> > > (except on the final element).
> > 
> > Yay!
> > 
> > > dbench is pretty nasty still because it seems to do a lot of stupid 
> > > things like reading from /proc/mounts all the time.
> > 
> > You should largely forget about dbench, it can certainly be a useful 
> > benchmark, but at the same time it's certainly not a _meaningful_ one.
> > There are better things to try.
> 
> OK, here's one you might find interesting. It is a cached git diff
> workload in a linux kernel tree. I actually ran it in a loop 100
> times in order to get some reasonable sample sizes, then I ran
> parallel and serial configs (PreloadIndex = true/false). Compared
> plain kernel with all vfs patches to now.
> 
> 2.6.32-rc3 serial
> 5.35user 7.12system 0:12.47elapsed 100%CPU
> 
> 2.6.32-rc3 parallel
> 5.79user 17.69system 0:09.41elapsed 249%CPU
> 
> vfs serial
> 5.30user 5.62system 0:10.92elapsed 100%CPU
> 
> vfs parallel
> 4.86user 0.68system 0:06.82elapsed 81%CPU

Since the box was booted anyway, I tried the git test too. Results are
with 2.6.32-rc3 serial being the baseline 1.00 scores, smaller than 1.00
are faster and vice versa.

2.6.32-rc3 serial
real    1.00
user    1.00
sys     1.00

2.6.32-rc3 parallel
real    0.80
user    0.83
sys     8.38

sys time, auch...

vfs serial
real    0.86
user    0.93
sys     0.84

vfs parallel
real    0.43
user    0.72
sys     0.13

Let me know if you want profiles or anything like that. I'd say that
looks veeeery tasty.

-- 
Jens Axboe

