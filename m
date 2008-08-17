Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbYHQEgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbYHQEgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 00:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYHQEgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 00:36:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:57034 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbYHQEgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 00:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=h1zW7V7iayWose3SRYl1gFwLTE/xUWsj6B4Aiz51dcXwaDcjLUqNBKySUxsnupL8Mk
         vVOugMmQnIVdmO0JukkelJQFQyr9YB+TMfo/BPqk29hXAF2V7grf3yT13totpOmeOrnz
         qVWA0fRMEM6FjlJJCR4Myd0iSoC1zFp5nICNw=
Message-ID: <15e66e4e0808162136r2a439ee9wbb20f2b1f8fabc77@mail.gmail.com>
Date: Sat, 16 Aug 2008 23:36:03 -0500
From: "Greg Donald" <gdonald@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: INFO: task reiserfs/0:1322 blocked for more than 120 seconds
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this while rsync'ng an NFS share onto a local disk:

[42374.151062] INFO: task reiserfs/0:1322 blocked for more than 120 seconds.
[42374.186295] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[42374.229433] reiserfs/0    D c1f36180     0  1322      2
[42374.265246]        f5dbdedc 00000046 c1f36180 c1f36180 f5e932c0
1c823428 00002669 f5e932c0
[42374.273706]        f5e93514 c1f36180 00000000 f5dbc000 f62cc780
f5e932c0 00000002 00000001
[42374.313709]        00000000 00000000 f5e932c0 c013cc01 00000246
f5dbded4 c013cbce e31e12ec
[42374.356837] Call Trace:
[42374.417842]  [<c013cc01>] ? trace_hardirqs_on+0xb/0xd
[42374.451201]  [<c013cbce>] ? trace_hardirqs_on_caller+0xe9/0x111
[42374.489735]  [<c02e876b>] mutex_lock_nested+0x14b/0x22b
[42374.525760]  [<c01c9727>] ? flush_commit_list+0x119/0x505
[42374.560839]  [<c01c9727>] flush_commit_list+0x119/0x505
[42374.594183]  [<c01cca8e>] flush_async_commits+0x41/0x4b
[42374.629770]  [<c012ec1a>] run_workqueue+0xc3/0x18e
[42374.662893]  [<c012ebfe>] ? run_workqueue+0xa7/0x18e
[42374.697814]  [<c01cca4d>] ? flush_async_commits+0x0/0x4b
[42374.732504]  [<c012f609>] ? worker_thread+0x0/0x8a
[42374.765765]  [<c012f688>] worker_thread+0x7f/0x8a
[42374.797749]  [<c0131d61>] ? autoremove_wake_function+0x0/0x38
[42374.833713]  [<c0131c93>] kthread+0x40/0x69
[42374.865772]  [<c0131c53>] ? kthread+0x0/0x69
[42374.897774]  [<c010392f>] kernel_thread_helper+0x7/0x10
[42374.929777]  =======================
[42374.957001] 3 locks held by reiserfs/0/1322:
[42374.990140]  #0:  (reiserfs){--..}, at: [<c012ebe1>] run_workqueue+0x8a/0x18e
[42375.025754]  #1:  (&(&journal->j_work)->work){--..}, at:
[<c012ebfe>] run_workqueue+0xa7/0x18e
[42375.062963]  #2:  (&jl->j_commit_mutex){--..}, at: [<c01c9727>]
flush_commit_list+0x119/0x505


I deleted a few GBs of data and ran it again but was unable to
reproduce it.  This was on 2.6.27-rc3.

I don't see any corruption.  Fluke?


-- 
Greg Donald
