Return-Path: <linux-kernel-owner+w=401wt.eu-S1763123AbXGWKLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763123AbXGWKLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 06:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbXGWKLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 06:11:34 -0400
Received: from brick.kernel.dk ([80.160.20.94]:7059 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbXGWKLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 06:11:33 -0400
Date: Mon, 23 Jul 2007 12:11:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 3/3] readahead: scale max readahead size depending on
	memory size
Message-ID: <20070723101146.GF11657@kernel.dk>
References: <20070721210005.000228000@chello.nl> <20070721210052.497469000@chello.nl> <20070722082434.GR11657@kernel.dk> <1185093405.20032.205.camel@twins> <20070722085041.GS11657@kernel.dk> <1185095852.20032.229.camel@twins> <20070722164403.GU11657@kernel.dk> <20070723100438.GA13963@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070723100438.GA13963@lazybastard.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23 2007, Jörn Engel wrote:
> On Sun, 22 July 2007 18:44:03 +0200, Jens Axboe wrote:
> > > 
> > > >  I agree with the low point of 128k.
> > > 
> > > Perhaps that should be enforced then, because currently a system with
> > > <64M will get less.
> > 
> > I think it should remain the low point.
> 
> I believe this whole thing is fundamentally flawed.  The perfect
> readahead size depends on the device in question.  If we set a single
> system-wide value depending on memory size, it may easily be too small
> and too large at the same time.  Think hard disk and SSD.
> 
> It may make sense to have a _maximum_ readahead size which depends on
> memory size.  But the preferred size (if there is enough RAM) should
> depend solely on the device, possibly as a function of the
> bandwidth * read latency product.

The value IS the maximum read-ahead value, not an enforced minimum.

However, there's definitely room for improvement in the queue feedback.
Even for seekless devices like SSD, read-ahead may be beneficial due to
zero request -> request latency.

-- 
Jens Axboe

