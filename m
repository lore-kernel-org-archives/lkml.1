Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbXD0Re7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbXD0Re7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbXD0Re7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:34:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35608 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756089AbXD0Rew (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:34:52 -0400
Date: Sat, 28 Apr 2007 03:34:32 +1000
From: David Chinner <dgc@sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427173432.GJ32602149@melbourne.sgi.com>
References: <20070426190438.3a856220.akpm@linux-foundation.org> <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org> <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com> <20070426235542.bad7035a.akpm@linux-foundation.org> <Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com> <20070427002640.22a71d06.akpm@linux-foundation.org> <20070427163620.GI32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427163620.GI32602149@melbourne.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 02:36:20AM +1000, David Chinner wrote:
> The test was writing a single 50GB file to a fresh filesystem, and
> then reading it back. Run on two different dm stripes - a 4-disk
> RAID) and a 8disk RAID0 stripe, with a stripe unit of 512k.  Disks
> are 10krpm SAS, external jbod on PCI-X good for ~850MB/s read and
> ~750MB/s write.  Server is 4p intel x86_64 with 16GB RAM.
> 
>                     READ            WRITE
> blksz  disks     tput   sys       tput    sys
> -----  -----    -----   ----      -----  ----
>  4k      4       332     35s      203     76s
> 64k      4       173     20s      273     21s
>  4k      8       403     35s      443     76s
> 64k      8       634     21s      540     21s
> 
> Throughput in MB/s.

Some more information - stripe unit on the dm raid0 is 512k.
I have not attempted to increase I/O sizes at all yet - these test are
just demonstrating efficiency improvements in the filesystem.

These numbers for 32GB files.

                    READ            WRITE
disks  blksz     tput   sys       tput    sys
-----  -----    -----   ----      -----  ----
  1     4k        89     18s       57     44s
  1    16k        46     13s       67     18s
  1    64k        75     12s       68     12s
  2     4k       179     20s      114     43s
  2    16k        55     13s      132     18s
  2    64k       126     12s      126     12s
  4     4k       350     20s      214     43s
  4    16k       350     14s      264     19s
  4    64k       176     11s      266     12s
  8     4k       415     21s      446     41s
  8    16k       655     13s      518     19s
  8    64k       664     12s      552     12s
 12     4k       413     20s      633     33s
 12    16k       736     14s      741     19s
 12    64k       836     12s      743     12s

Throughput in MB/s.


Consistent improvement across the write results, first time
I've hit the limits of the PCI-X bus with a single buffered
I/O thread doing either reads or writes.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
