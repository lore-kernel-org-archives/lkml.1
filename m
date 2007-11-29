Return-Path: <linux-kernel-owner+w=401wt.eu-S1763617AbXK2Vml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763617AbXK2Vml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760956AbXK2Vm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:42:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:16858 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbXK2Vm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:42:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=YFIRLacFnCPpSezVSiTNB9KCcebpW37ClYXohXWvLsekfowvnPZT7dCaSVxyLpCXYxi1DuHvazB5KqCIJovWbAXqmTIBrFcHJ7WNy5fCO2CFwEE4Z+3qrotbuDz7qiCA3lRj0Yb064+bTMiJX+QgpHmjfexBSrpoezY+BrPn3H4=
Message-ID: <474F3248.3040808@gmail.com>
Date: Thu, 29 Nov 2007 22:42:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jun Nakajima <jun.nakajima@intel.com>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: kondemand: kernel BUG at kernel/workqueue.c:258!
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while trying to evoke another bug by endlessly change governors, this appeared:
kernel BUG at .../kernel/workqueue.c:258!
invalid opcode: 0000 [1] PREEMPT SMP
CPU 0
Modules linked in: iwl3945 mac80211 cfg80211 tun cpufreq_userspace rfcomm
l2cap hci_usb bluetooth kvm_intel arc4 ecb blkcipher kvm cryptomgr
crypto_algapi acpi_cpufreq fglrx(P) asus_laptop sr_mod cdrom ehci_hcd
uhci_hcd battery
Pid: 443, comm: kondemand/0 Tainted: P        2.6.23 #38
RIP: 0010:[<ffffffff802484ba>]  [<ffffffff802484ba>] run_workqueue+0xca/0x120
RSP: 0000:ffff81003ff3bea0  EFLAGS: 00010283
RAX: ffff81003fc08200 RBX: ffff810001e0a300 RCX: 0000000000000000
RDX: ffff810001e0a300 RSI: ffff81003ff3bed0 RDI: ffff81003fc08180
RBP: ffff81003fc08180 R08: ffff81003ff3a000 R09: 0000000000000000
R10: 0000003a18d529f0 R11: 0000000000000001 R12: ffff810001e0a2f8
R13: ffffffff803c7160 R14: ffff81003fc08188 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff805db000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000003a18a9afa0 CR3: 000000002e431000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kondemand/0 (pid: 443, threadinfo ffff81003ff3a000, task
ffff81003fe67560)
Stack:  ffff81003fc08198 ffff81003fc08180 ffffffff80249060 ffff81003fc08188
 0000000000000000 ffffffff80249125 0000000000000000 ffff81003fe67560
 ffffffff8024cb20 ffff81003ff3bee8 ffff81003ff3bee8 00000000fffffffc
Call Trace:
 [<ffffffff80249060>] worker_thread+0x0/0x130
 [<ffffffff80249125>] worker_thread+0xc5/0x130
 [<ffffffff8024cb20>] autoremove_wake_function+0x0/0x30
 [<ffffffff80249060>] worker_thread+0x0/0x130
 [<ffffffff80249060>] worker_thread+0x0/0x130
 [<ffffffff8024c71b>] kthread+0x4b/0x80
 [<ffffffff8020cbb8>] child_rip+0xa/0x12
 [<ffffffff8021fff0>] flat_send_IPI_mask+0x0/0x70
 [<ffffffff8024c6d0>] kthread+0x0/0x80
 [<ffffffff8020cbae>] child_rip+0x0/0x12


Code: 0f 0b eb fe 66 90 65 48 8b 34 25 00 00 00 00 48 c7 c7 10 98
RIP  [<ffffffff802484ba>] run_workqueue+0xca/0x120
 RSP <ffff81003ff3bea0>
