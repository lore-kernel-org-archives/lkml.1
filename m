Return-Path: <linux-kernel-owner+w=401wt.eu-S1759936AbXEaGZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936AbXEaGZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 02:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbXEaGZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 02:25:07 -0400
Received: from brick.kernel.dk ([80.160.20.94]:1928 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbXEaGZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 02:25:04 -0400
Date: Thu, 31 May 2007 08:24:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: device-mapper development <dm-devel@redhat.com>,
       David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>,
       Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,  filesystems, and dm/md.
Message-ID: <20070531062404.GH32105@kernel.dk>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <465DAA15.3070703@cfl.rr.com> <465DDE1D.3000809@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465DDE1D.3000809@cfl.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30 2007, Phillip Susi wrote:
> >That would be the exactly how I understand Documentation/block/barrier.txt:
> >
> >"In other words, I/O barrier requests have the following two properties.
> >1. Request ordering
> >...
> >2. Forced flushing to physical medium"
> >
> >"So, I/O barriers need to guarantee that requests actually get written
> >to non-volatile medium in order." 
> 
> I think you misinterpret this, and it probably could be worded a bit 
> better.  The barrier request is about constraining the order.  The 
> forced flushing is one means to implement that constraint.  The other 
> alternative mentioned there is to use ordered tags.  The key part there 
> is "requests actually get written to non-volatile medium _in order_", 
> not "before the request completes", which would be synchronous IO.

No Stephan is right, the barrier is both an ordering and integrity
constraint. If a driver completes a barrier request before that request
and previously submitted requests are on STABLE storage, then it
violates that principle. Look at the code and the various ordering
options.

-- 
Jens Axboe

