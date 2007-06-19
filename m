Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbXFSFMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbXFSFMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 01:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXFSFMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 01:12:42 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36808 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbXFSFMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 01:12:41 -0400
From: Vernon Mauery <vernux@us.ibm.com>
To: Vernon Mauery <vernux@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [-RT] multiple streams have degraded performance
Date: Mon, 18 Jun 2007 22:12:21 -0700
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@redhat.com>, Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706182212.22633.vernux@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In looking at the performance characteristics of my network I found that 
2.6.21.5-rt15 suffers from degraded thoughput with multiple threads.  The 
test that I did this with is simply invoking 1, 2, 4, and 8 instances of 
netperf at a time and measuring the total throughput.  I have two 4-way 
machines connected with 10GbE cards.  I tested several kernels (some older 
and some newer) and found that the only thing in common was that with -RT 
kernels the performance went down with concurrent streams.

While the test was showing the numbers for receiving as well as sending, the 
receiving numbers are not reliable because that machine was running a -RT 
kernel for these tests.

I was just wondering if anyone had seen this problem before or would have any 
idea on where to start hunting for the solution.

--Vernon

The key for this is 'default' was invoked like:
netperf -c -C -l 60 -H 10.2.2.4 -t UDP_STREAM -- -m 1472 -M 1472
and '1Msock' was invoked like:
netperf -c -C -l 60 -H 10.2.2.4 -t UDP_STREAM -- -m 1472 -M 1472 -s 1M -S 1M

2.6.21
==============
default: 1 streams: Send at 2844.2 Mb/s, Receive at 2840.1 Mb/s
default: 2 streams: Send at 3927.9 Mb/s, Receive at 3603.9 Mb/s
default: 4 streams: Send at 4197.4 Mb/s, Receive at 3776.3 Mb/s
default: 8 streams: Send at 4223.9 Mb/s, Receive at 3848.9 Mb/s
1Msock: 1 streams: Send at 4232.3 Mb/s, Receive at 3914.4 Mb/s
1Msock: 2 streams: Send at 5428.8 Mb/s, Receive at 3853.2 Mb/s
1Msock: 4 streams: Send at 6202.1 Mb/s, Receive at 3774.8 Mb/s
1Msock: 8 streams: Send at 6225.1 Mb/s, Receive at 3754.7 Mb/s

2.6.21.5-rt15
===============
default: 1 streams: Send at 3091.6 Mb/s, Receive at 3048.1 Mb/s
default: 2 streams: Send at 3768.8 Mb/s, Receive at 3714.2 Mb/s
default: 4 streams: Send at 1873.6 Mb/s, Receive at 1825.9 Mb/s
default: 8 streams: Send at 1806.5 Mb/s, Receive at 1792.7 Mb/s
1Msock: 1 streams: Send at 3680.4 Mb/s, Receive at 3255.6 Mb/s
1Msock: 2 streams: Send at 4129.8 Mb/s, Receive at 3991.5 Mb/s
1Msock: 4 streams: Send at 1862.1 Mb/s, Receive at 1787.1 Mb/s
1Msock: 8 streams: Send at 1790.2 Mb/s, Receive at 1556.8 Mb/s
