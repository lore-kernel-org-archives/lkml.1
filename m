Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbYFROMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbYFROMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYFROMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:12:32 -0400
Received: from in.cluded.net ([195.159.98.120]:58003 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbYFROMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:12:32 -0400
X-OS: [Linux] 2.6.8 and newer (?)
Message-ID: <485917CF.1010401@uw.no>
Date: Wed, 18 Jun 2008 16:12:31 +0200
From: "Daniel K." <dk@uw.no>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RT-Scheduler/cgroups: Possible overuse of resources assigned via
 cpu.rt_period_us and cpu.rt_runtime_us
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mkdir /dev/cgroup
mount -t cgroup -o cpu,cpuset cgroup /dev/cgroup

mkdir /dev/cgroup/0

echo 3 > /dev/cgroup/0/cpuset.cpus
echo 0 > /dev/cgroup/0/cpuset.mems
echo 100000 > /dev/cgroup/0/cpu.rt_period_us
echo   5000 > /dev/cgroup/0/cpu.rt_runtime_us

schedtool -R -p 1 -e burnP6 &
[1] 3309
echo 3309 > /dev/cgroup/0/tasks

At this point I'd expect the burnP6 task to use 5% of the available CPU
resources in the cgroup (5000/100000), but the real CPU usage, as
reported by top, is 20% This is 4 times the expected result, and as I
have 4 cores, I think there is a strong hint of correlation there.

Maybe with a 4 core system there really is 4 000 000 us available for
every 1 wall-time second?

However, I have only assigned one core (3) to _this_ cgroup, so I think
this cgroup is overusing its assigned resources.

What do you think?


Daniel K.
