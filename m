Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbXFSGwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbXFSGwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 02:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbXFSGwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 02:52:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56901 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbXFSGwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 02:52:17 -0400
Subject: Re: [-RT] multiple streams have degraded performance
From: Peter Zijlstra <peterz@infradead.org>
To: Vernon Mauery <vernux@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <200706182212.22633.vernux@us.ibm.com>
References: <200706182212.22633.vernux@us.ibm.com>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 08:51:38 +0200
Message-Id: <1182235898.7348.361.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-18 at 22:12 -0700, Vernon Mauery wrote:
> In looking at the performance characteristics of my network I found that 
> 2.6.21.5-rt15 suffers from degraded thoughput with multiple threads.  The 
> test that I did this with is simply invoking 1, 2, 4, and 8 instances of 
> netperf at a time and measuring the total throughput.  I have two 4-way 
> machines connected with 10GbE cards.  I tested several kernels (some older 
> and some newer) and found that the only thing in common was that with -RT 
> kernels the performance went down with concurrent streams.
> 
> While the test was showing the numbers for receiving as well as sending, the 
> receiving numbers are not reliable because that machine was running a -RT 
> kernel for these tests.
> 
> I was just wondering if anyone had seen this problem before or would have any 
> idea on where to start hunting for the solution.

could you enable CONFIG_LOCK_STAT

echo 0 > /proc/lock_stat

<run your test>

and report the output of (preferably not 80 column wrapped):

grep : /proc/lock_stat | head

or otherwise if there are any highly contended network locks listed?

 - Peter

