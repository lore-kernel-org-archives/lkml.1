Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbXI2RFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbXI2RFi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 13:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756398AbXI2RFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 13:05:31 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:39940 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756394AbXI2RFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 13:05:30 -0400
Date: Sat, 29 Sep 2007 20:05:23 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: oprofile Mailing List <oprofile-list@lists.sourceforge.net>
Subject: Re: 2.6.22.6 + oprofile oops
Message-ID: <20070929170523.mepbfbdqwhnyrx3z@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
	oprofile Mailing List <oprofile-list@lists.sf.net>
References: <20070922112335.4wqatiewgeiottty@m.safari.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070922112335.4wqatiewgeiottty@m.safari.iki.fi>
User-Agent: Mutt/1.5.16 (2007-09-19)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 14:23:35 +0300, Sami Farin wrote:
> x86_64 SMP kernel v2.6.22.6 (not using callgraph).
> sometimes oprofile works for a longer time... but not this time.
> 
> 2007-09-22 13:53:32.527237777 <1>[ 3372.390188] Unable to handle kernel NULL pointer dereference at 0000000000000650 RIP: 
> 2007-09-22 13:53:32.527245948 <1>[ 3372.390195]  [<ffffffff80652f44>] _spin_lock+0x4/0x20
> 2007-09-22 13:53:32.527247694 <4>[ 3372.390211] PGD 13a6c067 PUD 3ad91067 PMD 0 
> 2007-09-22 13:53:32.527249371 <0>[ 3372.390216] Oops: 0002 [1] SMP 
> 2007-09-22 13:53:32.527250837 <4>[ 3372.390220] CPU 0 
> 2007-09-22 13:53:32.527252304 <4>[ 3372.390227] <snip>
...
> 2007-09-22 13:53:32.527385634 <4>[ 3372.390442] Call Trace:
> 2007-09-22 13:53:32.527390314 <4>[ 3372.390457]  [<ffffffff80232b88>] get_task_mm+0x18/0x60
> 2007-09-22 13:53:32.527391990 <4>[ 3372.390484]  [<ffffffff8831abd4>] :oprofile:sync_buffer+0xf4/0x480
> 2007-09-22 13:53:32.527393666 <4>[ 3372.390544]  [<ffffffff8831a6b0>] :oprofile:wq_sync_buffer+0x0/0x60
> 2007-09-22 13:53:32.527399673 <4>[ 3372.390576]  [<ffffffff8831a6e3>] :oprofile:wq_sync_buffer+0x33/0x60
> 2007-09-22 13:53:32.527401419 <4>[ 3372.390602]  [<ffffffff80244bfd>] run_workqueue+0xcd/0x170
> 2007-09-22 13:53:32.527406238 <4>[ 3372.390635]  [<ffffffff802456b3>] worker_thread+0xb3/0x120
> 2007-09-22 13:53:32.527421324 <4>[ 3372.390652]  [<ffffffff80249000>] autoremove_wake_function+0x0/0x40
> 2007-09-22 13:53:32.527423140 <4>[ 3372.390684]  [<ffffffff80245600>] worker_thread+0x0/0x120
> 2007-09-22 13:53:32.527424816 <4>[ 3372.390697]  [<ffffffff80248bfd>] kthread+0x4d/0x80
> 2007-09-22 13:53:32.527426423 <4>[ 3372.390730]  [<ffffffff8020abc8>] child_rip+0xa/0x12
> 2007-09-22 13:53:32.527428099 <4>[ 3372.390810]  [<ffffffff80248bb0>] kthread+0x0/0x80
> 2007-09-22 13:53:32.527444931 <4>[ 3372.390822]  [<ffffffff8020abbe>] child_rip+0x0/0x12

This is easy to trigger with "ping -f 127.0.0.1" (as root).
Oopses inside 0.1s.  If you can't reproduce, try more events and/or smaller
sample count.

May I suggest something: if system is too slow to process events,
find out which event is triggering too often, double the sample count
for it, reset all counters, and log an informative kernel message.
If that's why it's crashing...   if it's some other reason, tough luck
:)

> 2007-09-22 13:53:32.527446817 <4>[ 3372.390844] 
> 2007-09-22 13:53:32.527448144 <4>[ 3372.390846] 
> 2007-09-22 13:53:32.527449541 <4>[ 3372.390846] Code: f0 ff 0f 79 09 f3 90 83 3f 00 7e f9 eb f2 c9 c3 66 66 66 2e 
> 2007-09-22 13:53:32.527455757 <1>[ 3372.390866] RIP  [<ffffffff80652f44>] _spin_lock+0x4/0x20
> 2007-09-22 13:53:32.527457433 <4>[ 3372.390876]  RSP <ffff81003e5fddc0>
> 2007-09-22 13:53:32.527463090 <0>[ 3372.390878] CR2: 0000000000000650
> 
> BTW. does somebody have callgraph working on x86_64 with oprofile?
> I get instant freeze and I need to power cycle system... (callgraph worked on IA-32)

-- 
Do what you love because life is too short for anything else.

