Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbZCPLRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbZCPLRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbZCPLRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:17:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53446 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbZCPLRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:17:20 -0400
Message-ID: <49BE354C.3090506@cn.fujitsu.com>
Date: Mon, 16 Mar 2009 19:17:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rolando Martins <rolando.martins@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: cgroup, RT cpu balance question
References: <b6a2d2e20903160356y67db8472k43577d706a393d96@mail.gmail.com>
In-Reply-To: <b6a2d2e20903160356y67db8472k43577d706a393d96@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rolando Martins wrote:
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

Then what do you expect? You put the task into cgroup/3 in which the allowed
cpus are restricted to CPU3, so of cause the scheduler will never schedule
the task to run on other cpus.

Please refer to Documentation/cgroups/cpusets.txt for the usage of cpusets.
