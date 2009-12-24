Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbZLXOcr (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 24 Dec 2009 09:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZLXOcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 09:32:46 -0500
Received: from smtp.freemail.gr ([81.171.104.132]:36878 "EHLO smtp.freemail.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZLXOcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 09:32:46 -0500
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Dec 2009 09:32:45 EST
From: Carl <carlr@freemail.gr>
Date: Thu, 24 Dec 2009 16:12:21 +0200
To: linux-kernel@vger.kernel.org
Subject: CPU eaten by unknown code
Message-ID: <cpueatenbyunknowncode123890udwn9w8nfd9we>
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I was benchmarking two programs and at some points i was getting
completely crazy results. Upon futher investigation it was discovered
that at some times the benchmarked programs would take much longer
to run because "somebody" was eating CPU.

Naturally i tried to stop any other processes that could be running
(also note that this is a dual-core system and the benchmarks used
only the one CPU, so theoretically, even another process like cron
might run on the other CPU without interrupting the benchmarks).
No result.

So i wrote a reduced testcase that would exploit the problem.
It's a small python script that keeps printing the time it takes
to run a tripple for-loop, forever.
On my system (Dual core Athlon 64, 32bit kernel+user) the standard
time to run the loop is 1.2 secs. However, this is what happens:

The loop takes 1.2 seconds for about 138 seconds.
The loop takes 2.4 second for about 45 seconds.
And this repeats forever.

In other words, every 138 seconds something is "running" for
45 seconds and it takes 50% of my CPU time!

I have been completely unable to discover what is this thing.
It is not some process as I would see it with 'ps' and 'top'.
It could not be something like flushing the disc cache because
45 seconds is just too much.
The network cable is completely unpluged.
The thing is not visible through /proc/stat cpuload: the system
load is 0% and the only way to understand this thing is eating
CPU is by looking that the for-loop in the python script takes
double time to run.
I cannot completely exclude the possibility that I've been rootkitted
although I believe this is a pretty secure system.

tested on linux 2.6.31.5 and 2.6.29.4

This is a real WTF. 45 seconds with 50% of the CPU is a *lot* of
processing power for a 2.5GHz system. What could be running all this
time? Anybody else seeing similar results? Ideas on how to disable
this so one can run benchmarks on a really "idle" system?

The script:
It prints the time to run the for-loop. It +/-5% deviation from
the previous value it prints a dot. Run for at least 5 minutes on
an idle system...

======================================================>8
# idle.py

import time, sys

def r ():
	for i in xrange (10):
		for i in xrange (1000):
			for i in xrange (1000):
				i = i + 1

def t ():
	t0 = time.time ()
	r ()
	return int (10000*(time.time () - t0))


l = None
while 1:
	x = t ()
	if l is not None:
		if -dt <= x - l <= dt:
			sys.stdout.write (".")
			sys.stdout.flush ()
		else:
			print "(%i secs)"%(time.time () - lt)
			lt = time.time ()
			print "Time to run loop:", x/10000.0
	else:
		dt = x / 20
		lt = time.time ()
		print "Time to run loop:", x/10000.0
	l = x

