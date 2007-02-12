Return-Path: <linux-kernel-owner+w=401wt.eu-S933003AbXBLFkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbXBLFkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 00:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933005AbXBLFkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 00:40:14 -0500
Received: from main.gmane.org ([80.91.229.2]:54118 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933003AbXBLFkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 00:40:12 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Vassili Karpov <av1474@comtv.ru>
Subject: CPU load
Date: Mon, 12 Feb 2007 05:33:08 +0000 (UTC)
Message-ID: <loom.20070212T063225-663@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 83.167.100.3 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

How does the kernel calculates the value it places in `/proc/stat' at
4th position (i.e. "idle: twiddling thumbs")?

For background information as to why this question arose in the first
place read on.

While writing the code dealing with video acquisition/processing at
work noticed that what top(1) (and every other tool that uses
`/proc/stat' or `/proc/uptime') shows some very strange results.

Top claimed that the system running one version of the code[A] is
idling more often than the code[B] doing the same thing but more
cleverly. After some head scratching one of my colleagues suggested a
simple test that was implemented in a few minutes.

The test consisted of a counter that incremented in an endless loop
also after certain period of time had elapsed it printed the value of
the counter.  Running this test (with priority set to the lowest
possible level) with code[A] and code[B] confirmed that code[B] is
indeed faster than code[A], in a sense that the test made more forward
progress while code[B] is running.

Hard-coding some things (i.e. the value of the counter after counting
for the duration of one period on completely idle system) we extended
the test to show the percentage of CPU that was utilized. This never
matched the value that top presented us with.

Later small kernel module was developed that tried to time how much
time is spent in the idle handler inside the kernel and exported this
information to the user-space. The results were consistent with our
expectations and the output of the test utility.

Two more points.

a. In the past (again video processing context) i have witnessed
   `/proc/stat' claiming that CPU utilization is 0% for, say, 20
   seconds followed by 5 seconds of 30% load, and then the cycle
   repeated. According to the methods outlined above the load is
   always at 30%.

b. In my personal experience difference between `/proc/stat' and
   "reality" can easily reach 40% (think i saw even more than that)

The module and graphical application that uses it, along with some
short README and a link to Usenet article dealing with the same
subject is available at:
http://www.boblycat.org/~malc/apc

Thanks


