Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbYILHAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbYILHAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 03:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbYILHAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 03:00:08 -0400
Received: from arirang.snu.ac.kr ([147.46.240.156]:1552 "EHLO
	arirang.snu.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbYILHAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 03:00:07 -0400
X-Greylist: delayed 1244 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2008 03:00:07 EDT
From: "Eunsung Kim" <eskim@arirang.snu.ac.kr>
To: <linux-kernel@vger.kernel.org>
Subject: Performance of "kirqd" in SMP Internet Server 
Date: Fri, 12 Sep 2008 15:39:20 +0900
Message-ID: <001f01c914a2$4c856d80$e5904880$@snu.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AckUokkjLsXWEtJNQ72yesduklz2Hw==
Content-Language: ko
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there.

I am looking for improving network interrupt balancing mechanism in SMP
internet server.
So I have analyzed kirqd in Linux kernel and I have done the following
experiment to realize impact of kirqd.

-------------------------------------------------------------

- Server spec.
CPU: AMD Phenom 9550 Quad-Core (each core 2.2 GHz)
Network card: RealTek Gigabit Ethernet
Network driver: R8169 disabled NAPI

- Client spec.
CPU: Intel Pentium 4 CPU 3.20GHz
Network card: Marvell Gigabit Ethernet

- Network
Connected with gigabit switch

- Benchmark tool
Netperf (throughput for TCP_STREAM in 10 mins)

- Comparison (throughput)
1. kernel 2.6.19.2 (smp_affinity of network irq is CPU 0.)
2. kernel 2.6.19.2 enabled kirqd

-------------------------------------------------------------

Experimental result present that there is no difference between 1 and 2.
Both have achieved throughput of about 940 Mbps via the experiment.
Throughput of 1 describes that netperf traffic can't saturate the server
system and then it is normal traffic.

I have thought that kirqd will 
- get "good" performance due to removing "receive livelock" of a CPU under
high traffic.
- get "poor" performance due to cache miss under low or normal traffic.

But the result for normal traffic doesn't so.
Is it correct?

I had no idea of how to generate high traffic and couldn't perform it.
How can I generate high traffic to saturate the server system?

I wonder whether my experimental setup is correct or not.
How do I have to configure experiment to discover a strong or weak point of
kirqd?

Please comment on my experiment result and setup, and
tell me the web link if there are experiment materials for the system
performance of kirqd


regards.

-- Eunsung

+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=
 Eunsung Kim
 PhD candidate
 Distibuted Computing System Laboratory
 School of Computer Science and Engineering
 Seoul National University
 Tel: +82-2-876-2159
 Email: eskim@dcslab.snu.ac.kr
+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+= 



