Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbXJANWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbXJANWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 09:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbXJANWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 09:22:14 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:38290 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758116AbXJANWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:22:12 -0400
Date: Mon, 1 Oct 2007 16:22:09 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.22.6 + oprofile oops
Message-ID: <20071001132209.2opuueap4nih2img@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20070922112335.4wqatiewgeiottty@m.safari.iki.fi> <p73ejgf6sch.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ejgf6sch.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.16 (2007-09-19)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 12:29:18 +0200, Andi Kleen wrote:
> Sami Farin <safari-kernel@safari.iki.fi> writes:
... 
> Can you reproduce it with a non tainted kernel without any patches like CFS applied?

I tried without CFS and it Oopsed just as nicely,
the only difference was that in call trace before
:oprofile:wq_sync_buffer there's now cache_reap.

Call Trace:
 [<ffffffff80231988>] get_task_mm+0x18/0x50
 [<ffffffff88316b64>] :oprofile:sync_buffer+0xf4/0x450
 [<ffffffff88316650>] :oprofile:wq_sync_buffer+0x0/0x60
 [<ffffffff88316683>] :oprofile:wq_sync_buffer+0x33/0x60
 [<ffffffff80289f10>] cache_reap+0x0/0x130
 [<ffffffff80243269>] run_workqueue+0x89/0x120
 [<ffffffff80243cf7>] worker_thread+0xc7/0x130
 [<ffffffff802474d0>] autoremove_wake_function+0x0/0x40
 [<ffffffff80243c30>] worker_thread+0x0/0x130
 [<ffffffff802470cd>] kthread+0x4d/0x80
 [<ffffffff8020aa78>] child_rip+0xa/0x12
 [<ffffffff80247080>] kthread+0x0/0x80
 [<ffffffff8020aa6e>] child_rip+0x0/0x12

> The oops happens because oprofile tries to reference a NULL task in
> its event buffer for a context switch, which might well be a minor
> merging mistake or similar in the CFS backport.

...
> > 2007-09-22 13:53:32.527385634 <4>[ 3372.390442] Call Trace:
> > 2007-09-22 13:53:32.527390314 <4>[ 3372.390457]  [<ffffffff80232b88>] get_task_mm+0x18/0x60
> > 2007-09-22 13:53:32.527391990 <4>[ 3372.390484]  [<ffffffff8831abd4>] :oprofile:sync_buffer+0xf4/0x480
> > 2007-09-22 13:53:32.527393666 <4>[ 3372.390544]  [<ffffffff8831a6b0>] :oprofile:wq_sync_buffer+0x0/0x60
> > 2007-09-22 13:53:32.527399673 <4>[ 3372.390576]  [<ffffffff8831a6e3>] :oprofile:wq_sync_buffer+0x33/0x60
> > 2007-09-22 13:53:32.527401419 <4>[ 3372.390602]  [<ffffffff80244bfd>] run_workqueue+0xcd/0x170
> > 2007-09-22 13:53:32.527406238 <4>[ 3372.390635]  [<ffffffff802456b3>] worker_thread+0xb3/0x120
> > 2007-09-22 13:53:32.527421324 <4>[ 3372.390652]  [<ffffffff80249000>] autoremove_wake_function+0x0/0x40
> > 2007-09-22 13:53:32.527423140 <4>[ 3372.390684]  [<ffffffff80245600>] worker_thread+0x0/0x120
> > 2007-09-22 13:53:32.527424816 <4>[ 3372.390697]  [<ffffffff80248bfd>] kthread+0x4d/0x80
> > 2007-09-22 13:53:32.527426423 <4>[ 3372.390730]  [<ffffffff8020abc8>] child_rip+0xa/0x12
> > 2007-09-22 13:53:32.527428099 <4>[ 3372.390810]  [<ffffffff80248bb0>] kthread+0x0/0x80
> > 2007-09-22 13:53:32.527444931 <4>[ 3372.390822]  [<ffffffff8020abbe>] child_rip+0x0/0x12

-- 
Do what you love because life is too short for anything else.

