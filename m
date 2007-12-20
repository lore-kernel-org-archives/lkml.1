Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbXLTIDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbXLTIDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 03:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbXLTIC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 03:02:56 -0500
Received: from brick.kernel.dk ([87.55.233.238]:15418 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380AbXLTICz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 03:02:55 -0500
Date: Thu, 20 Dec 2007 08:58:14 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       dougg@torque.net
Subject: Re: [PATCH 0/5] sg_ring for scsi
Message-ID: <20071220075814.GH13958@kernel.dk>
References: <200712201645.19035.rusty@rustcorp.com.au> <20071220160741K.fujita.tomonori@lab.ntt.co.jp> <200712201853.48643.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712201853.48643.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20 2007, Rusty Russell wrote:
> On Thursday 20 December 2007 18:07:41 FUJITA Tomonori wrote:
> > On Thu, 20 Dec 2007 16:45:18 +1100
> >
> > Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > OK, some fixes since last time, as I wade through more SCSI drivers. 
> > > Some drivers use "use_sg" as a flag to know whether the request_buffer is
> > > a scatterlist: I don't need the counter, but I still need the flag, so I
> > > fixed that in a more intuitive way (an explicit ->sg pointer in the cmd).
> >
> > use_sg and the request_buffer will be removed shortly.
> >
> > http://marc.info/?l=linux-scsi&m=119754650614813&w=2
> 
> Thanks!  Is there a git tree somewhere with these changes?
> 
> > I think that we tried the similar idea before, scsi_sgtable, but we
> > seem to settle in the current simple approach.
> 
> Yes, a scsi-specific solution is a bad idea: other people use sg.  
> Manipulating the magic chains is horrible; it looks simple to the places 
> which simply want to iterate through it, but it's awful for code which wants 
> to create them.

The current code looks like that to minimize impact on 2.6.24, see this
branch:

http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=sg

for how it folds into lib/sg.c and the magic disappears from SCSI.
Rusty, nobody claimed the sg code in 2.6.24 is perfect. I like to get
things incrementally there.

-- 
Jens Axboe

