Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbXIYO6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbXIYO6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbXIYO6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:58:44 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:59188 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbXIYO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:58:43 -0400
Message-ID: <46F92219.9020406@hp.com>
Date: Tue, 25 Sep 2007 10:58:33 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Reply-To: Alan.Brunelle@hp.com
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: btrace <linux-btrace@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: Linux Kernel Markers - performance characterization with large
 IO load on large-ish system
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Taking Linux 2.6.23-rc6 + 2.6.23-rc6-mm1 as a basis, I took some sample 
runs of the following on both it and after applying Mathieu Desnoyers 
11-patch sequence (19 September 2007).

    * 32-way IA64 + 132GiB + 10 FC adapters + 10 HP MSA 1000s (one 72GiB
      volume per MSA used)

    * 10 runs with each configuration, averages shown below
          o 2.6.23-rc6 + 2.6.23-rc6-mm1 without blktrace running
          o 2.6.23-rc6 + 2.6.23-rc6-mm1 with blktrace running
          o 2.6.23-rc6 + 2.6.23-rc6-mm1 + markers without blktrace running
          o 2.6.23-rc6 + 2.6.23-rc6-mm1 + markers with blktrace running

    * A run consists of doing the following in parallel:
          o Make an ext3 FS on each of the 10 volumes
          o Mount & unmount each volume
                + The unmounting generates a tremendous amount of writes
                  to the disks - thus stressing the intended storage
                  devices (10 volumes) plus the separate volume for all
                  the blktrace data (when blk tracing is enabled).
                + Note the times reported below only cover the
                  make/mount/unmount time - the actual blktrace runs
                  extended beyond the times measured (took quite a while
                  for the blk trace data to be output). We're only
                  concerned with the impact on the "application"
                  performance in this instance.

Results are:

Kernel                                 w/out BT   STDDEV     w/ BT    STDDEV
-------------------------------------  ---------  ------   ---------  ------
2.6.23-rc6 + 2.6.23-rc6-mm1            14.679982    0.34   27.754796    2.09
2.6.23-rc6 + 2.6.23-rc6-mm1 + markers  14.993041    0.59   26.694993    3.23

It looks to be about 2.1% increase in time to do the make/mount/unmount 
operations with the marker patches in place and no blktrace operations. 
With the blktrace operations in place we see about a 3.8% decrease in 
time to do the same ops.

When our Oracle benchmarking machine frees up, and when the 
marker/blktrace patches are more stable, we'll try to get some "real" 
Oracle benchmark runs done to gage the impact of the markers changes to 
performance...

Alan D. Brunelle
Hewlett-Packard / Open Source and Linux Organization / Scalability and 
Performance Group

