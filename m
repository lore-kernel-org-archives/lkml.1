Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbYBSGKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbYBSGKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 01:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYBSGK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 01:10:27 -0500
Received: from mail.gmx.net ([213.165.64.20]:42244 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752154AbYBSGK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 01:10:26 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+4GeBj7xS4WWKnfGegcKqvWCy8IhqChLIO/w3pGV
	f8lhY5todASJ9N
Subject: Re: [PATCH 0/7] Single RQ group scheduling
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       dhaval@linux.vnet.ibm.com, tong.n.li@intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080218095535.629736000@chello.nl>
References: <20080218095535.629736000@chello.nl>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 07:10:21 +0100
Message-Id: <1203401421.4252.13.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-18 at 10:55 +0100, Peter Zijlstra wrote:
> This is my current queue for single RQ group scheduling.

I took these out for a brief maxcpus=1 spin yesterday, and noticed
something.  Running 4 copies of chew-max, one as a user, the context
switch rate was high (~1800/s).  I increased sched_min_granularity_ns to
see if that would lower it, and it did, but it also upset fairness.
With sched_min_granularity_ns bumped to half of sched_latency_ns (40ms
default) it was a largish skew.

top - 06:58:46 up 3 min, 15 users,  load average: 4.71, 2.53, 1.04
Tasks: 214 total,   9 running, 204 sleeping,   0 stopped,   1 zombie
Cpu(s): 39.0%us, 61.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 5389 mikeg     20   0  1464  364  304 R 40.1  0.0   0:29.71 0 chew-max
 5373 root      20   0  1464  364  304 R 19.0  0.0   0:16.30 0 chew-max
 5388 root      20   0  1464  364  304 R 19.0  0.0   0:15.79 0 chew-max
 5374 root      20   0  1464  364  304 R 18.6  0.0   0:15.90 0 chew-max

	-Mike


