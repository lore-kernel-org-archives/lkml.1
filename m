Return-Path: <linux-kernel-owner+w=401wt.eu-S1031261AbXDZP3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031261AbXDZP3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031276AbXDZP3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:29:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41420 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031261AbXDZP3N (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:29:13 -0400
Date: Fri, 27 Apr 2007 01:28:51 +1000
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andy Whitcroft <apw@shadowen.org>, Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426152851.GY65285596@melbourne.sgi.com>
References: <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com> <463057D9.9030804@yahoo.com.au> <46309D16.70109@shadowen.org> <4630C061.10309@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4630C061.10309@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 01:08:17AM +1000, Nick Piggin wrote:
> Andy Whitcroft wrote:
> >Nick Piggin wrote:
> >
> 
> >>I don't understand what you mean at all. A block has always been a
> >>contiguous area of disk.
> >
> >
> >Lets take Nick's definition of block being a disk based unit for the
> >moment.  That does not change the key contention here, that even with
> >hardware specifically designed to handle 4k pages that hardware handles
> >larger contigious areas more efficiently.  David Chinner gives us
> >figures showing major overall throughput improvements from (I assume)
> >shorter scatter gather lists and better tag utilisation.  I am loath to
> >say we can just blame the hardware vendors for poor design.
> 
> So their controllers get double the throughput when going from 512K
> (128x4K pages) to 2MB (128x16K pages) requests. Do you really think
> it is to do with command processing overhead?

No - it has to do with things like the RAID controller caching behaviour, the
number of disks a single request can keep busy, getting I/os large
enough to avoid partial stripe writes, etc. Remember that this
controller is often on the other side of a HBA so large I/Os are
really desirable here....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
