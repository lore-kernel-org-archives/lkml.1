Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbXIYWNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbXIYWNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 18:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbXIYWNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 18:13:37 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47514 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbXIYWNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 18:13:37 -0400
Subject: KPROBES: Instrumenting a function's call site
From: Avishay Traeger <atraeger@cs.sunysb.edu>
To: prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 25 Sep 2007 18:12:38 -0400
Message-Id: <1190758358.30061.13.camel@rockstar.fsl.cs.sunysb.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I am trying to use kprobes to measure the latency of a function by
instrumenting its call site.  Basically, I find the call instruction,
and insert a kprobe with a pre-handler and post-handler at that point.
The pre-handler measures the latency (reads the TSC counter).  The
post-handler measures the latency again, and subtracts the value that
was read in the pre-handler to compute the total latency of the called
function.

So to measure the latency of foo(), I basically want kprobes to do this:
pre_handler();
foo();
post_handler();

The problem is that the latencies that I am getting are consistently low
(~10,000 cycles).  When I manually instrument the functions, the latency
is about 20,000,000 cycles.  Clearly something is not right here.

Is this a known issue?  Instead of using the post-handler, I can try to
add a kprobe to the following instruction with a pre-handler.  I was
just curious if there was something fundamentally wrong with the
approach I took, or maybe a bug that you should be made aware of.

Please CC me on any replies (not subscribed to LKML).

Thanks,
Avishay

