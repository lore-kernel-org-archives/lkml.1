Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbYB1JRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbYB1JRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 04:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbYB1JRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 04:17:18 -0500
Received: from relay2.sgi.com ([192.48.171.30]:53401 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755018AbYB1JRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 04:17:14 -0500
Date: Thu, 28 Feb 2008 03:17:10 -0600
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-Id: <20080228031710.3405e405.pj@sgi.com>
In-Reply-To: <20080228090847.GA1133@elte.hu>
References: <20080227222103.673194000@chello.nl>
	<20080228075010.GA28781@elte.hu>
	<20080228020808.3fd22f77.pj@sgi.com>
	<20080228090847.GA1133@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
>  The "bootup" cpuset is just 
> a convenience container to handle everything that the box booted up 
> with, and then we can shrink it (without having to enumerate every PID 
> and every irq and other resource explicitly) to make place for other 
> cpusets.

I'm not quite sure of what you're thinking here; rather I'm just
bouncing off the sound of your words.

But your words sound alot like what we at SGI call a 'boot' cpuset.

Our big honkin NUMA customers, who are managing most of the system
either for a few dedicated, very-important jobs, and/or under a
batch scheduler, need to leave a few nodes to run the classic Unix
load such as init, cron, assorted daemons and the admins login shell.

So we provide them some init script mechanisms that make it easy to
set this up, which includes moving every task (not many at the low
numbered init script time this runs) that isn't pinned (doesn't have
a restricted Cpus_allowed) into the boot cpuset, conventionally
named /dev/cpuset/boot.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
