Return-Path: <linux-kernel-owner+w=401wt.eu-S1761001AbXEPOoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761001AbXEPOoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 10:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756646AbXEPOnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 10:43:55 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10578 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbXEPOnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 10:43:53 -0400
Date: Wed, 16 May 2007 10:42:05 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: filesystem benchmarking fun
Message-ID: <20070516144205.GV26766@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I've been spending some time lately on filesystem benchmarking, in part
because my pet FS project is getting more stable and closer to release.
Now seems like a good time to step back and try to find out what
workloads we think are most important and see how well Linux is doing on
them.  So, I'll start with my favorite three benchmarks and why I think
they matter.  Over time I hope to collect a bunch of results for all of
us to argue about.

* fio: http://brick.kernel.dk/snaps/
Fio can abuse a file via just about every api in the kernel.  aio, dio,
syslets, splice etc.  It can thread, fork, record and playback traces
and provides good numbers for throughput and latencies on various
sequential and random io loads.

* fs_mark: http://developer.osdl.org/dev/doubt/fs_mark/index.html
This one covers most of the 'use the FS as a database' type workloads,
and can vary the number of files, directory depth etc.  It has detailed
timings for reads, writes, unlinks and fsyncs that make it good for
simulating mail servers and other setups.

* compilebench: http://oss.oracle.com/~mason/compilebench/
Tries to benchmark the filesystem allocator by aging the FS through
simulated kernel compiles, patch runs and other operations.

It's easy to get caught up in one benchmark or another and try to use
them for bragging rights.  But, what I want to do is talk about the
workloads we're trying to optimize for and our current methods for
measuring success.  If we don't have good benchmarks for a given
workload, I'd like to try and collect ideas on how to make one.

For example, I'll pick on xfs for a minute.  compilebench shows the
default FS you get from mkfs.xfs is pretty slow for untarring a bunch of
kernel trees.  Dave Chinner gave me some mount options that make it
dramatically better, but it still writes at 10MB/s on a sata drive that
can do 80MB/s.  Ext3 is better, but still only 20MB/s. 

Both are presumably picking a reasonable file and directory layout.
Still, our writeback algorithms are clearly not optimized for this kind
of workload.  Should we fix it?

-chris

