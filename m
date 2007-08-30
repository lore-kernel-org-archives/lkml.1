Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbXH3SiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbXH3SiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbXH3SiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:38:01 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:40100 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156AbXH3SiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:38:00 -0400
Date: Thu, 30 Aug 2007 14:37:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 4/4] Port of blktrace to the Linux Kernel Markers.
Message-ID: <20070830183758.GB15657@Krystal>
References: <20070827160540.007809201@polymtl.ca> <20070827160710.807499112@polymtl.ca> <20070830172128.GA14460@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070830172128.GA14460@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:35:58 up 31 days, 18:54,  7 users,  load average: 0.32, 0.31, 0.33
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Mon, Aug 27, 2007 at 12:05:44PM -0400, Mathieu Desnoyers wrote:
> > Here is the first stage of a port of blktrace to the Linux Kernel Markers. The
> > advantage of this port is that it minimizes the impact on the running when
> > blktrace is not active.
> > 
> > A few remarks : this patch has the positive effect of removing some code
> > from the block io tracing hot paths, minimizing the i-cache impact in a
> > system where the io tracing is compiled in but inactive.
> > 
> > It also moves the blk tracing code from a header (and therefore from the
> > body of the instrumented functions) to a separate C file.
> > 
> > There, as soon as one device has to be traced, all devices have to
> > execute the tracing function call when they pass by the instrumentation site.
> > This is slower than the previous inline function which tested the condition
> > quickly.
> > 
> > It does not make the code smaller, since I left all the specialized
> > tracing functions for requests, bio, generic, remap, which would go away
> > once a generic infrastructure is in place to serialize the information
> > passed to the marker. This is mostly why I consider it as a step towards the
> > full improvements that could bring the markers.
> 
> I like this as it moves the whole tracing code out of line.  It would
> be nice if we could make blktrace a module with this, but we'd need
> to change the interface away from an ioctl on the block device for that.
> 
> Btw, something that really shows here and what I noticed in my sputrace
> aswell is that there is a lot of boilerplate code due to the varargs
> trace handlers.  We really need some way to auto-generate the boilerplate
> for the trace function to avoid coding this up everywhere.

Or we can use a vprintk-like function to parse the format string and
serialize the information into trace buffers. I prefer this latter
option because, overall, it will localize the probes in a few bytes of
functions instead of duplicating the memory and instruction cache
required by multiple serializing functions.

I have the code ready, but I do not want to flood LKML with patches
neither....

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
