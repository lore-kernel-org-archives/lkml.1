Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbZD1WOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbZD1WOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbZD1WOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:14:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbZD1WO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:14:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=sUT12jO3G3blB2FuENrBTHQtcT83lny8Xzru3DG7XhbfTLWU1N3VJdBOxLEhgVdxZ
	B7qMZYzBGVnJb5HAV4v+g==
Date: Tue, 28 Apr 2009 15:14:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dan Williams <dan.j.williams@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Bug #13116] Can't boot with nosmp
In-Reply-To: <49F4DF40.50302@intel.com>
Message-ID: <alpine.DEB.2.00.0904281507240.30946@chino.kir.corp.google.com>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera> <Fg2zLW93smL.A.oGE.Zd48JB@chimera> <49F4DF40.50302@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009, Dan Williams wrote:

> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> 
> This is still unresolved.
> 
> Stephen, please send your config.
> 

Given the stack for the initial report, why would a config other than 
enabling CONFIG_DMA_ENGINE help if there's no ifdefs involved?

This is happening in the for_each_possible_cpu() loop within 
dma_channel_rebalance(), which makes sense since the machine boots fine 
normally but not with `nosmp'.

channel_table[] is not being initialized per-cpu for non-online cpus?


BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff803d6b6b>] dma_channel_rebalance+0x46/0x1d1
PGD 1d8db067 PUD 179bc067 PMD 0 
Oops: 0002 [#1] SMP 
last sysfs file: /sys/kernel/uevent_seqnum
CPU 0 
Modules linked in: async_tx(+) xor raid1 raid0 multipath linear md_mod virtio_blk sg sr_mod cdrom \
pata_acpi virtio_pci virtio_ring virtio floppy uhci_hcd usbcore ata_piix ata_generic thermal processor \
                fan thermal_sys
Pid: 1789, comm: modprobe Not tainted 2.6.29-1-amd64-vyatta #1 
RIP: 0010:[<ffffffff803d6b6b>]  [<ffffffff803d6b6b>] dma_channel_rebalance+0x46/0x1d1
RSP: 0018:ffff880017a6de78  EFLAGS: 00010283
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000020 R09: ffffffff8063ab00
R10: ffffffffa0106d80 R11: ffff880001010300 R12: 000000000000000c
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fe9c51536e0(0000) GS:ffffffff806ac080(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000001d903000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 1789, threadinfo ffff880017a6c000, task ffff88001fb14380)
Stack:
 0000000000000000 ffffffff805fc4e8 0000000000001ee9 ffffffff805fc4e8
 0000000000000000 0000000000000000 0000000000000000 ffffffff803d730a
 00000000fffffffe ffffffffa0106d80 0000000000001ee9 ffffffffa0109000
Call Trace:
 [<ffffffff803d730a>] dmaengine_get+0xca/0xdd
 [<ffffffffa0109000>] async_tx_init+0x0/0x1b [async_tx]
 [<ffffffffa0109009>] async_tx_init+0x9/0x1b [async_tx]
 [<ffffffff80209051>] _stext+0x51/0x120
 [<ffffffff8032bfde>] __up_read+0x13/0x8d
 [<ffffffff8024aa4d>] __blocking_notifier_call_chain+0x51/0x5f
 [<ffffffff80257c75>] sys_init_module+0xa0/0x1ba
 [<ffffffff8020be5b>] system_call_fastpath+0x16/0x1b
