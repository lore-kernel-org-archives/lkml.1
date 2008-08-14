Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbYHNJFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbYHNJFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYHNJEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:04:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754971AbYHNJEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:04:31 -0400
Date: Thu, 14 Aug 2008 02:04:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc1 oops when plugging USB disk
Message-Id: <20080814020416.20b18659.akpm@linux-foundation.org>
In-Reply-To: <20080801133509.GD19548@ics.muni.cz>
References: <20080801133509.GD19548@ics.muni.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008 15:35:09 +0200 Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:

> Hello,
> 
> in 2.6.27-rc1 I got the following oops when plugging USB disk:
> 
> [16362.911493] usb 1-4.3: new high speed USB device using ehci_hcd and address 6
> [16363.009899] usb 1-4.3: configuration #1 chosen from 1 choice
> [16363.015300] usb 1-4.3: New USB device found, idVendor=152d, idProduct=2338
> [16363.015311] usb 1-4.3: New USB device strings: Mfr=1, Product=2, SerialNumber=5
> [16363.015316] usb 1-4.3: Product: USB to ATA/ATAPI Bridge
> [16363.015320] usb 1-4.3: Manufacturer: JMicron
> [16363.015324] usb 1-4.3: SerialNumber: 222291142391
> [16363.232194] general protection fault: 0000 [1] SMP 
> [16363.232194] CPU 0 
> [16363.232194] Modules linked in: i915 drm rfcomm l2cap tp_smapi thinkpad_ec fuse hci_usb bluetooth thinkpad_acpi e1000e snd_hda_intel rfkill wmi uhci_hcd ehci_hcd intel_agp [last unloaded: crypto_blkcipher]
> [16363.232194] Pid: 17890, comm: modprobe Tainted: G        W 2.6.27-rc1 #4
> [16363.232194] RIP: 0010:[<ffffffff8034b518>]  [<ffffffff8034b518>] strcmp+0x8/0x30
> [16363.232194] RSP: 0018:ffff880010eebd10  EFLAGS: 00010246
> [16363.232194] RAX: ffffffff80624b80 RBX: 0000000000006480 RCX: ffff880010eebde8
> [16363.232194] RDX: 0000000000000000 RSI: ffffc200041ac15f RDI: ffff680000002120
> [16363.232194] RBP: ffff880010eebde8 R08: ffff880010eebde8 R09: ffffc200041a4400
> [16363.232194] R10: ffff8800796cac6c R11: 00000000796cac60 R12: ffffffff8051e280
> [16363.232194] R13: ffffc200041ac15f R14: 0000000000000000 R15: 0000000000000000
> [16363.232194] FS:  00007f2c143da6e0(0000) GS:ffffffff80685200(0000) knlGS:0000000000000000
> [16363.232194] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [16363.232194] CR2: 00007f4df1b2af7c CR3: 0000000010d1a000 CR4: 00000000000006e0
> [16363.232194] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [16363.232194] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [16363.232194] Process modprobe (pid: 17890, threadinfo ffff880010eea000, task ffff880010dc2100)
> [16363.232194] Stack:  ffffffff8025eb4e 0000000000000648 ffffffff8051e280 ffff880010eebde8
> [16363.232194]  ffffffff8025eb10 0000000000000000 ffffffff8025df13 0000000300000000
> [16363.232194]  ffffc200041a6c10 ffff880010eebde8 ffffffffa00649a0 ffff880010eebf40
> [16363.232194] Call Trace:
> [16363.232194]  [<ffffffff8025eb4e>] ? find_symbol_in_section+0x3e/0xd0
> [16363.232194]  [<ffffffff8025eb10>] ? find_symbol_in_section+0x0/0xd0
> [16363.232194]  [<ffffffff8025df13>] ? each_symbol_in_section+0x63/0xa0
> [16363.232194]  [<ffffffff8025e4a5>] ? find_symbol+0x45/0x1a0
> [16363.232194]  [<ffffffff80260bc6>] ? sys_init_module+0xec6/0x1b20
> [16363.232194]  [<ffffffff8028e97f>] ? do_mmap_pgoff+0x26f/0x3c0
> [16363.232194]  [<ffffffff802a6fde>] ? sys_newfstat+0x2e/0x50
> [16363.232194]  [<ffffffff8020c4cb>] ? system_call_fastpath+0x16/0x1b
> [16363.232194] 
> [16363.232194] 
> [16363.232194] Code: 44 00 00 42 0f b6 04 06 88 01 84 c0 74 0e 48 ff c1 49 ff c0 4c 39 c2 75 ea c6 01 00 48 89 f8 c3 0f 1f 00 31 d2 66 0f 1f 44 00 00 <0f> b6 0c 17 89 c8 2a 04 16 84 c0 75 0b 48 ff c2 84 c9 75 ec 31 
> [16363.232194] RIP  [<ffffffff8034b518>] strcmp+0x8/0x30
> [16363.232194]  RSP <ffff880010eebd10>
> [16363.232255] ---[ end trace 9bc0e3446c5a7e94 ]---
> 

Is this still happening in 2.6.27-rc3?

Thanks.
