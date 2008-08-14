Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbYHNJEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbYHNJEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758267AbYHNJDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:03:39 -0400
Received: from lemon.ertos.nicta.com.au ([203.143.174.143]:40745 "EHLO
	lemon.gelato.unsw.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758250AbYHNJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:03:37 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] deadline-iosched: performance, style and documentation changes
Date: Thu, 14 Aug 2008 18:17:12 +1000
Message-Id: <1218701835-17327-1-git-send-email-aaronc@gelato.unsw.edu.au>
X-Mailer: git-send-email 1.5.4.5
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 203.143.161.65
X-SA-Exim-Mail-From: aaronc@gelato.unsw.edu.au
X-SA-Exim-Scanned: No (on lemon.gelato.unsw.edu.au); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jens,

Patch 1 changes deadline to dispatch in a CSCAN-like manner for improved
throughput.  This fixes two performance issues, namely deadline avalanche
that occurs under high load, and FCFS-like behaviour for mixed read/write
workloads.  Benchmark results are below.

Patches 2 and 3 introduce some non-functional changes, mostly for style
and documentation.

Thanks,
  -- Aaron


-----------------------------------x8-----------------------------------

Figures quoted in KiB/s unless otherwise noted.  Disk under test is a 73GiB
15krpm Cheetah.  Host machine is a 2-way IA64 w/ 2GiB RAM.


fio 16KiB reads
-------------------------------

Load      Bandwidth      %
        New      Old
32    3585.789 3580.412  0.1
64    3657.062 3361.460  8.8
128   3844.572 2459.811  56
256   3860.864 2455.446  57
512   3896.296 2472.468  58


fio 16KiB read/write (50/50)
-------------------------------

Load      Bandwidth      %
        New      Old
32    3461.336 2630.765  32
64    3715.625 2369.822  57
128   3931.525 2375.380  66
256   3953.333 2377.132  66


fio 1MiB reads
-------------------------------

Load       Bandwidth       %
        New        Old
32    49502.789 45744.023  8.2
64    50109.827 45776.416  9.5
128   50232.672 45884.900  9.5
256   50641.255 46266.082  9.5


fio 1MiB read/write (50/50)
-------------------------------

Load       Bandwidth       %
        New        Old
32    48543.272 44557.494  8.9
64    49388.251 44597.785  11
128   49794.080 45131.637  10
256   50632.356 45777.333  11


Postmark 
-------------------------------

5 instances, 10k files, 100 dirs, 15k xacts, XFS

Old: 10.79 xact/s
New: 11.26 xact/s  (+4.2%)



