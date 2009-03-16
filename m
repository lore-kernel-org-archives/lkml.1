Return-Path: <linux-kernel-owner+w=401wt.eu-S1760660AbZCPLTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbZCPLTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbZCPLSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:18:55 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37977 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbZCPLSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:18:55 -0400
Date: Mon, 16 Mar 2009 16:48:11 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Rolando Martins <rolando.martins@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: cgroup, RT cpu balance question
Message-ID: <20090316111811.GB3949@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <b6a2d2e20903160356y67db8472k43577d706a393d96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2d2e20903160356y67db8472k43577d706a393d96@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 10:56:04AM +0000, Rolando Martins wrote:
> Hi,
> I have one question regarding RT cpu balance using cgroup.
> 
> cgroup
> echo 1 > cpuset.sched_load_balance
> 
> cgroup/2
> echo 0 > cpuset.mems
> echo 0-2 > cpuset.cpus
> echo 450000 > cpu.rt_runtime_us
> 
> cgroup/3
> echo 0 > cpuset.mems
> echo 3 > cpuset.cpus
> echo 450000 > cpu.rt_runtime_us
> 
> 
> I have a small test that uses a loop to utilize 100% cpu (SCHED_FIFO).
> When I run 2 tests on cgroup/3, it only uses bandwidth from cpu 3
> (100%), the balancing isn't happening.
> As I use the SCHED_FIFO, the 2 processes run sequentially.
> 
> Is this the expected behavior? Shouldn't the domains balance the spare
> cpu bandwidth?
> 

Yes, this is expected behavior. The cpuset has limited the task's allowed
CPUs to CPU 3. With that, it will use the bandwidth only from CPU 3. As
you noted, since the process are SCHED_FIFO, they will run sequentially.

-- 
regards,
Dhaval
