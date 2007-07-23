Return-Path: <linux-kernel-owner+w=401wt.eu-S1763760AbXGWKIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763760AbXGWKIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 06:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXGWKI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 06:08:26 -0400
Received: from lazybastard.de ([212.112.238.170]:56244 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbXGWKI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 06:08:26 -0400
Date: Mon, 23 Jul 2007 12:04:38 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 3/3] readahead: scale max readahead size depending on memory size
Message-ID: <20070723100438.GA13963@lazybastard.org>
References: <20070721210005.000228000@chello.nl> <20070721210052.497469000@chello.nl> <20070722082434.GR11657@kernel.dk> <1185093405.20032.205.camel@twins> <20070722085041.GS11657@kernel.dk> <1185095852.20032.229.camel@twins> <20070722164403.GU11657@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070722164403.GU11657@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 July 2007 18:44:03 +0200, Jens Axboe wrote:
> > 
> > >  I agree with the low point of 128k.
> > 
> > Perhaps that should be enforced then, because currently a system with
> > <64M will get less.
> 
> I think it should remain the low point.

I believe this whole thing is fundamentally flawed.  The perfect
readahead size depends on the device in question.  If we set a single
system-wide value depending on memory size, it may easily be too small
and too large at the same time.  Think hard disk and SSD.

It may make sense to have a _maximum_ readahead size which depends on
memory size.  But the preferred size (if there is enough RAM) should
depend solely on the device, possibly as a function of the
bandwidth * read latency product.

Jörn

-- 
Joern's library part 12:
http://physics.nist.gov/cuu/Units/binary.html
