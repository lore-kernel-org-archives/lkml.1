Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbYKOXbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbYKOXbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 18:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYKOXbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 18:31:11 -0500
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:35265 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751343AbYKOXbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 18:31:09 -0500
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Sat, 15 Nov 2008 23:30:51 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] using smp_processor_id() in preemptible
Message-ID: <20081115233050.GA13439@hades>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

while running latencytop, got the following:

...
[  775.663239] BUG: using smp_processor_id() in preemptible [00000000] code: latencytop/6585
[  775.663303] caller is native_sched_clock+0x3a/0x80
[  775.663314] Pid: 6585, comm: latencytop Tainted: G        W 2.6.28-rc4-00355-g9c7c354 #1
[  775.663322] Call Trace:
[  775.663343]  [<ffffffff803a94e4>] debug_smp_processor_id+0xe4/0xf0
[  775.663356]  [<ffffffff80213f7a>] native_sched_clock+0x3a/0x80
[  775.663368]  [<ffffffff80213e19>] sched_clock+0x9/0x10
[  775.663381]  [<ffffffff8024550d>] proc_sched_show_task+0x8bd/0x10e0
[  775.663395]  [<ffffffff8034466e>] sched_show+0x3e/0x80
[  775.663408]  [<ffffffff8031039b>] seq_read+0xdb/0x350
[  775.663421]  [<ffffffff80368776>] ? security_file_permission+0x16/0x20
[  775.663435]  [<ffffffff802f4198>] vfs_read+0xc8/0x170
[  775.663447]  [<ffffffff802f4335>] sys_read+0x55/0x90
[  775.663460]  [<ffffffff8020c67a>] system_call_fastpath+0x16/0x1b
...

I am running 2.6.28-rc4-00355-g9c7c354 and, after taking a look at the code, it
looks like the problem is in commit 7cbaef9c83e58bbd4bdd534b09052b6c5ec457d5,
where native_sched_clock is modified to use __cycles_2_ns instead of
cycles_2_ns.

-- 
Luis Henriques
