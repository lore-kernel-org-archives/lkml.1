Return-Path: <linux-kernel-owner+w=401wt.eu-S933034AbXAYAR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbXAYAR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932984AbXAYAR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:17:58 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:43062 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933034AbXAYAR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:17:57 -0500
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jan 2007 19:17:57 EST
Message-ID: <45B7F567.7020100@tlinx.org>
Date: Wed, 24 Jan 2007 16:10:15 -0800
From: "Linda W." <lkml@tlinx.org>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: linux scheduler and "cache-mate" processors
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I had a few questions about the linux scheduler and how it
interacts with in a 4 CPU system where the L2 cache is shared
between "pairs" (on same die) of processors.

Some of the later Core processors have 4MB of
L2cache/processor, and on a single chip, both processors have
access to the full 8MB of cache.  At this point, AFAIK, Quad
processors are only implemented by putting 2 pairs of Core
chips and the two pairs don't share cache, acting, to some
extent, like a 2-socket system with Intel Dual Core
processors in each socket.

What I'm wondering is, say CPUs A&B share 1 cache, and C&D
share a 2nd cache.  

1) does the scheduler know enough to try to spread tasks
equally over both the pairs to make best use of the 16MB total
cache? (i.e. given cpu bound processes "1" and "2", if they
are both on CPU "A", then the "C-D" cache remains unused, but
keeping "1" on "a" and "2" on "C" would tend to minimize
their caches being consumed by each other.

2) Since either A&B both have access to the 8MB cache, then
if a process was running on "A", it seems it would have a
low migration cost to be scheduled on "B" -- i.e. shouldn't
the process, if it were migrated to "A"'s "cache-mate", "B",
be able to benefit by any previous caching done on "A"? 
If that's true, does the scheduler give preference, when
migrating a process, to a CPU's "cache-mate"? 

If these things aren't in, are they planned for future or being
worked on?

Thanks,
Linda W.
 



 
