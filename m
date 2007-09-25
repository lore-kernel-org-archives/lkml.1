Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbXIYROA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbXIYROA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbXIYRNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:13:52 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:33097 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbXIYRNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:13:51 -0400
Date: Tue, 25 Sep 2007 13:13:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, btrace <linux-btrace@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Linux Kernel Markers - performance characterization with large IO load on large-ish system
Message-ID: <20070925171349.GA6057@Krystal>
References: <46F92219.9020406@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46F92219.9020406@hp.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:11:37 up 57 days, 17:30,  5 users,  load average: 0.48, 0.64, 0.59
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan D. Brunelle (Alan.Brunelle@hp.com) wrote:
> Taking Linux 2.6.23-rc6 + 2.6.23-rc6-mm1 as a basis, I took some sample 
> runs of the following on both it and after applying Mathieu Desnoyers 
> 11-patch sequence (19 September 2007).
> 
>    * 32-way IA64 + 132GiB + 10 FC adapters + 10 HP MSA 1000s (one 72GiB
>      volume per MSA used)
> 
>    * 10 runs with each configuration, averages shown below
>          o 2.6.23-rc6 + 2.6.23-rc6-mm1 without blktrace running
>          o 2.6.23-rc6 + 2.6.23-rc6-mm1 with blktrace running
>          o 2.6.23-rc6 + 2.6.23-rc6-mm1 + markers without blktrace running
>          o 2.6.23-rc6 + 2.6.23-rc6-mm1 + markers with blktrace running
> 
>    * A run consists of doing the following in parallel:
>          o Make an ext3 FS on each of the 10 volumes
>          o Mount & unmount each volume
>                + The unmounting generates a tremendous amount of writes
>                  to the disks - thus stressing the intended storage
>                  devices (10 volumes) plus the separate volume for all
>                  the blktrace data (when blk tracing is enabled).
>                + Note the times reported below only cover the
>                  make/mount/unmount time - the actual blktrace runs
>                  extended beyond the times measured (took quite a while
>                  for the blk trace data to be output). We're only
>                  concerned with the impact on the "application"
>                  performance in this instance.
> 
> Results are:
> 
> Kernel                                 w/out BT   STDDEV     w/ BT    STDDEV
> -------------------------------------  ---------  ------   ---------  ------
> 2.6.23-rc6 + 2.6.23-rc6-mm1            14.679982    0.34   27.754796    2.09
> 2.6.23-rc6 + 2.6.23-rc6-mm1 + markers  14.993041    0.59   26.694993    3.23
> 

Interesting results, although we cannot say any of the solutions has much
impact due to the std dev.

Also, it could be interesting to add the "blktrace compiled out" as a
base line.

Thanks for running those tests,

Mathieu

> It looks to be about 2.1% increase in time to do the make/mount/unmount 
> operations with the marker patches in place and no blktrace operations. 
> With the blktrace operations in place we see about a 3.8% decrease in 
> time to do the same ops.
> 
> When our Oracle benchmarking machine frees up, and when the 
> marker/blktrace patches are more stable, we'll try to get some "real" 
> Oracle benchmark runs done to gage the impact of the markers changes to 
> performance...
> 
> Alan D. Brunelle
> Hewlett-Packard / Open Source and Linux Organization / Scalability and 
> Performance Group
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
