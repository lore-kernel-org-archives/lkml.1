Return-Path: <linux-kernel-owner+w=401wt.eu-S933351AbYBTTgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351AbYBTTgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 14:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933209AbYBTTfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 14:35:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761272AbYBTTfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 14:35:08 -0500
Date: Wed, 20 Feb 2008 14:34:17 -0500
From: Rik van Riel <riel@redhat.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       oleg@tv-sign.ru, roland@redhat.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.25-rc2-mm1 - Kernel panic while bootup caused by
 signal_group_exit()
Message-ID: <20080220143417.6e419c5e@cuia.boston.redhat.com>
In-Reply-To: <47B7B3B9.2090706@linux.vnet.ibm.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<47B7B3B9.2090706@linux.vnet.ibm.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 09:40:33 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> [   25.512919] BUG: unable to handle kernel paging request at 9d74e37b
> [   25.514926] IP: [<c04a8fac>] proc_flush_task+0x5b/0x223

I wonder if this one is related.   Also with 2.6.25-rc2-mm1 on x86_64:

BUG: unable to handle kernel paging request at 0000000000200200
IP: [<ffffffff81043d3c>] free_pid+0x35/0x90
PGD 43c00c067 PUD 43e5f1067 PMD 0 
Oops: 0002 [1] SMP 
last sysfs file: /sys/devices/pnp0/00:0b/id
CPU 7 
Modules linked in: dm_multipath qla2xxx bnx2 iTCO_wdt iTCO_vendor_support serio_raw rtc_cmos pcspkr watchdog_core scsi_transport_fc watchdog_dev i5000_edac edac_core button dcdbas joydev sg sr_mod cdrom usb_storage ata_piix libata dm_snapshot dm_zero dm_mirror dm_mod shpchp megaraid_sas sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 1992, comm: S05kudzu Not tainted 2.6.25-rc2-mm1 #4
RIP: 0010:[<ffffffff81043d3c>]  [<ffffffff81043d3c>] free_pid+0x35/0x90
RSP: 0018:ffff81043c895e58  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff81043dd31440 RCX: ffff81043e5ffb08
RDX: 0000000000200200 RSI: 0000000000000046 RDI: 0000000000000000
RBP: ffff81043b9703c0 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff81043d1a R11: 0000000000000000 R12: ffff81043e5ffac0
R13: 0000000000000000 R14: 0000000000000000 R15: 00000000008cd530
FS:  00007f68f99786f0(0000) GS:ffff81043e7100c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000200200 CR3: 0000000436c1f000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process S05kudzu (pid: 1992, threadinfo ffff81043c894000, task ffff81043b9acb40)
Stack:  ffff81043dd31440 ffff81043b9703c0 ffff81043c84ae40 ffffffff81035a6d
 ffff81043b9703c0 0000000000000000 00000000000007cd ffffffff810362b7
 ffff81043c895f18 ffffffff81051316 0000000000000000 00007fff01989514
Call Trace:
 [<ffffffff81035a6d>] ? release_task+0x1be/0x346
 [<ffffffff810362b7>] ? do_wait+0x6c2/0xa0e
 [<ffffffff81051316>] ? trace_hardirqs_on_caller+0xf2/0x115
 [<ffffffff8102ac72>] ? default_wake_function+0x0/0xe
 [<ffffffff81051316>] ? trace_hardirqs_on_caller+0xf2/0x115
 [<ffffffff8103668d>] ? sys_wait4+0x8a/0xa1
 [<ffffffff8100be3b>] ? system_call_after_swapgs+0x7b/0x80

-- 
All Rights Reversed
