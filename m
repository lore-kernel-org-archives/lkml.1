Return-Path: <linux-kernel-owner+w=401wt.eu-S932647AbXH3RVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647AbXH3RVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 13:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667AbXH3RVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 13:21:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48986 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292AbXH3RVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 13:21:32 -0400
Date: Thu, 30 Aug 2007 18:21:28 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 4/4] Port of blktrace to the Linux Kernel Markers.
Message-ID: <20070830172128.GA14460@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>
References: <20070827160540.007809201@polymtl.ca> <20070827160710.807499112@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827160710.807499112@polymtl.ca>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 12:05:44PM -0400, Mathieu Desnoyers wrote:
> Here is the first stage of a port of blktrace to the Linux Kernel Markers. The
> advantage of this port is that it minimizes the impact on the running when
> blktrace is not active.
> 
> A few remarks : this patch has the positive effect of removing some code
> from the block io tracing hot paths, minimizing the i-cache impact in a
> system where the io tracing is compiled in but inactive.
> 
> It also moves the blk tracing code from a header (and therefore from the
> body of the instrumented functions) to a separate C file.
> 
> There, as soon as one device has to be traced, all devices have to
> execute the tracing function call when they pass by the instrumentation site.
> This is slower than the previous inline function which tested the condition
> quickly.
> 
> It does not make the code smaller, since I left all the specialized
> tracing functions for requests, bio, generic, remap, which would go away
> once a generic infrastructure is in place to serialize the information
> passed to the marker. This is mostly why I consider it as a step towards the
> full improvements that could bring the markers.

I like this as it moves the whole tracing code out of line.  It would
be nice if we could make blktrace a module with this, but we'd need
to change the interface away from an ioctl on the block device for that.

Btw, something that really shows here and what I noticed in my sputrace
aswell is that there is a lot of boilerplate code due to the varargs
trace handlers.  We really need some way to auto-generate the boilerplate
for the trace function to avoid coding this up everywhere.
