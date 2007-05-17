Return-Path: <linux-kernel-owner+w=401wt.eu-S1760471AbXEQXpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760471AbXEQXpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbXEQXpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:45:11 -0400
Received: from omta05ps.mx.bigpond.com ([144.140.83.195]:32376 "EHLO
	omta05ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbXEQXpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:45:10 -0400
Message-ID: <464CE8FD.4070205@bigpond.net.au>
Date: Fri, 18 May 2007 09:45:01 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au> <20070516063625.GA9058@elte.hu>
In-Reply-To: <20070516063625.GA9058@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta05ps.mx.bigpond.com from [144.131.192.218] using ID pwil3058@bigpond.net.au at Thu, 17 May 2007 23:45:06 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Williams <pwil3058@bigpond.net.au> wrote:
> 
>> Load balancing appears to be badly broken in this version.  When I 
>> started 4 hard spinners on my 2 CPU machine one ended up on one CPU 
>> and the other 3 on the other CPU and they stayed there.
> 
> could you try to debug this a bit more?

I've now done this test on a number of kernels: 2.6.21 and 2.6.22-rc1 
with and without CFS; and the problem is always present.  It's not 
"nice" related as the all four tasks are run at nice == 0.

It's possible that this problem has been in the kernel for a while with 
out being noticed as, even with totally random allocation of tasks to 
CPUs without any (attempt to balance), there's a quite high probability 
of the desirable 2/2 split occurring.  So one needs to repeat the test 
several times to have reasonable assurance that the problem is not 
present.  I.e. this has the characteristics of an intermittent bug with 
all the debugging problems that introduces.

The probabilities for the 3 split possibilities for random allocation are:

	2/2 (the desired outcome) is 3/8 likely,
	1/3 is 4/8 likely, and
	0/4 is 1/8 likely.

I'm pretty sure that this problem wasn't present when smpnice went into 
the kernel which is the last time I did a lot of load balance testing.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
