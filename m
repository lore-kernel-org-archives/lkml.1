Return-Path: <linux-kernel-owner+w=401wt.eu-S1764028AbYBLSyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764028AbYBLSyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761198AbYBLSyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:54:06 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:55634 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755951AbYBLSyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:54:05 -0500
Date: Wed, 13 Feb 2008 00:23:55 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Regression in latest sched-git
Message-ID: <20080212185355.GA6320@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I've been running the latest sched-git through some tests. Here is
essentially what I am doing,

1. Mount the control group
2. Create 3-4 groups
3. Start kernbench inside each group
4. Run cpu hogs in each group

Essentially the idea is to see how the system responds under extreme CPU
load.

This is what I get (and this is in a shell which belongs to the root
group)
[root@llm11 ~]# time sleep 1

real    0m1.212s
user    0m0.004s
sys     0m0.000s
[root@llm11 ~]# time sleep 1

real    0m1.200s
user    0m0.000s
sys     0m0.004s
[root@llm11 ~]# time sleep 1

real    0m1.266s
user    0m0.000s
sys     0m0.000s
[root@llm11 ~]# time sleep 1

real    0m1.113s
user    0m0.000s
sys     0m0.000s
[root@llm11 ~]# 

On the sched-devel tree that I have, the same gives me following
results.

[root@llm11 ~]# time sleep 1

real    0m1.057s
user    0m0.000s
sys     0m0.004s
[root@llm11 ~]# time sleep 1

real    0m1.038s
user    0m0.000s
sys     0m0.004s
[root@llm11 ~]# time sleep 1

real    0m1.075s
user    0m0.000s
sys     0m0.000s
[root@llm11 ~]# time sleep 1

real    0m1.071s
user    0m0.000s
sys     0m0.000s
[root@llm11 ~]# time sleep 1

real    0m1.073s
user    0m0.000s
sys     0m0.004s
[root@llm11 ~]# time sleep 1

real    0m1.055s
user    0m0.000s
sys     0m0.004s

I agree this is not a very great test. Its getting a bit late here. I
will get some better test case tomorrow morning (and if you have some, I
can try those as well). I just did not want the tree to get merged in
without further discussion.

-- 
regards,
Dhaval
