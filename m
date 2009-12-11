Return-Path: <linux-kernel-owner+w=401wt.eu-S1761782AbZLKAYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782AbZLKAYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbZLKAYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:24:00 -0500
Received: from home.kolivas.org ([59.167.196.135]:34659 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758016AbZLKAYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:24:00 -0500
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Subject: BFS v0.311 CPU scheduler for 2.6.32
Date: Fri, 11 Dec 2009 11:24:18 +1100
User-Agent: KMail/1.12.1 (Linux/2.6.32-ck1; KDE/4.3.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912111124.18118.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to briefly announce the availability of the latest stable BFS CPU 
scheduler version 0.311 for the new stable linux kernel, 2.6.32.

http://ck.kolivas.org/patches/bfs/2.6.32-sched-bfs-311.patch

Changes since the last announced version, 0.304 are trivial apart from minimal 
scalability improvements to make the most of SMT (hyperthreading) and to 
improve NUMA performance. Here is the summary from the documentation of the 
changes:

When choosing an idle CPU for a waking task, the cache locality is determined
according to where the task last ran and then idle CPUs are ranked from best
to worst to choose the most suitable idle CPU based on cache locality, NUMA
node locality and hyperthread sibling business. They are chosen in the
following preference (if idle):

* Same core, idle or busy cache, idle threads
* Other core, same cache, idle or busy cache, idle threads.
* Same node, other CPU, idle cache, idle threads.
* Same node, other CPU, busy cache, idle threads.
* Same core, busy threads.
* Other core, same cache, busy threads.
* Same node, other CPU, busy threads.
* Other node, other CPU, idle cache, idle threads.
* Other node, other CPU, busy cache, idle threads.
* Other node, other CPU, busy threads.

(The brief rundown for the average user means that if you have a hyperthreaded 
CPU, it will use real cores before hyperthread siblings)


A quick summary of the features of BFS:

Excellent interactivity and responsiveness with a very simple, low overhead 
design (9000 lines less code than the mainline CPU scheduler)

Suited and scalable for any respectable number of CPUs, whether separate 
socket, multicore and/or multithreaded, from 1 to many (although won't scale 
well to 4096).

Only one tunable which almost never needs changing.

Features SCHED_IDLEPRIO and SCHED_ISO scheduling policies as well.

To run something idleprio, use schedtool like so:

schedtool -D -e make -j4

To run something isoprio, use schedtool like so:

schedtool -I -e amarok

Features subtick accounting for better CPU usage reporting.


More comprehensive documentation is included in the patch.

-- 
-ck
