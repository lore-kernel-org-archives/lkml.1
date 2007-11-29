Return-Path: <linux-kernel-owner+w=401wt.eu-S933131AbXK2VxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbXK2VxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762760AbXK2VxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:53:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:32618 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762694AbXK2VxJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:53:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,230,1194249600"; 
   d="scan'208";a="328766798"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: kondemand: kernel BUG at kernel/workqueue.c:258!
Date: Thu, 29 Nov 2007 13:47:34 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE2FA920@orsmsx423.amr.corp.intel.com>
In-Reply-To: <474F3248.3040808@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kondemand: kernel BUG at kernel/workqueue.c:258!
Thread-Index: Acgy0OPB3RKS5Dg7SgmeESEsGy2TUAAAHaig
References: <474F3248.3040808@gmail.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Jiri Slaby" <jirislaby@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>
Cc: "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Nov 2007 21:47:17.0817 (UTC) FILETIME=[696A0A90:01C832D1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Jiri Slaby [mailto:jirislaby@gmail.com] 
>Sent: Thursday, November 29, 2007 1:43 PM
>To: Pallipadi, Venkatesh; Nakajima, Jun
>Cc: Linux kernel mailing list
>Subject: kondemand: kernel BUG at kernel/workqueue.c:258!
>
>Hi,
>
>while trying to evoke another bug by endlessly change 
>governors, this appeared:
>kernel BUG at .../kernel/workqueue.c:258!
>invalid opcode: 0000 [1] PREEMPT SMP
>CPU 0
>Modules linked in: iwl3945 mac80211 cfg80211 tun 
>cpufreq_userspace rfcomm
>l2cap hci_usb bluetooth kvm_intel arc4 ecb blkcipher kvm cryptomgr
>crypto_algapi acpi_cpufreq fglrx(P) asus_laptop sr_mod cdrom ehci_hcd
>uhci_hcd battery
>Pid: 443, comm: kondemand/0 Tainted: P        2.6.23 #38
>RIP: 0010:[<ffffffff802484ba>]  [<ffffffff802484ba>] 
>run_workqueue+0xca/0x120
>RSP: 0000:ffff81003ff3bea0  EFLAGS: 00010283
>RAX: ffff81003fc08200 RBX: ffff810001e0a300 RCX: 0000000000000000
>RDX: ffff810001e0a300 RSI: ffff81003ff3bed0 RDI: ffff81003fc08180
>RBP: ffff81003fc08180 R08: ffff81003ff3a000 R09: 0000000000000000
>R10: 0000003a18d529f0 R11: 0000000000000001 R12: ffff810001e0a2f8
>R13: ffffffff803c7160 R14: ffff81003fc08188 R15: 0000000000000000
>FS:  0000000000000000(0000) GS:ffffffff805db000(0000) 
>knlGS:0000000000000000
>CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>CR2: 0000003a18a9afa0 CR3: 000000002e431000 CR4: 00000000000026e0
>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>Process kondemand/0 (pid: 443, threadinfo ffff81003ff3a000, task
>ffff81003fe67560)
>Stack:  ffff81003fc08198 ffff81003fc08180 ffffffff80249060 
>ffff81003fc08188
> 0000000000000000 ffffffff80249125 0000000000000000 ffff81003fe67560
> ffffffff8024cb20 ffff81003ff3bee8 ffff81003ff3bee8 00000000fffffffc
>Call Trace:
> [<ffffffff80249060>] worker_thread+0x0/0x130
> [<ffffffff80249125>] worker_thread+0xc5/0x130
> [<ffffffff8024cb20>] autoremove_wake_function+0x0/0x30
> [<ffffffff80249060>] worker_thread+0x0/0x130
> [<ffffffff80249060>] worker_thread+0x0/0x130
> [<ffffffff8024c71b>] kthread+0x4b/0x80
> [<ffffffff8020cbb8>] child_rip+0xa/0x12
> [<ffffffff8021fff0>] flat_send_IPI_mask+0x0/0x70
> [<ffffffff8024c6d0>] kthread+0x0/0x80
> [<ffffffff8020cbae>] child_rip+0x0/0x12
>
>
>Code: 0f 0b eb fe 66 90 65 48 8b 34 25 00 00 00 00 48 c7 c7 10 98
>RIP  [<ffffffff802484ba>] run_workqueue+0xca/0x120
> RSP <ffff81003ff3bea0>
>

Kernel version?

Thanks,
Venki
