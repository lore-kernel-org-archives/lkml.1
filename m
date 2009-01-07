Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZAGKym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZAGKym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 05:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZAGKye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 05:54:34 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:7259 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZAGKyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 05:54:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TfrmGQvvpdF+yeH+h6Qd6QtsxSmFQfaW+hUKU9ZGN8x0OKlieatllNj5vcH6yyXogl
         USGUWU5EUM/LhPkpShgoe6kYj+vkl8bzMOY6EHJB6RlpUYiuFMX9cHcAcDZnPGreVuPK
         772okpXkdwuMcl0iy4veDbDR2S8wZqK8e5hDw=
Message-ID: <c4e36d110901070254g7f3f3393qef23f3f50322550b@mail.gmail.com>
Date: Wed, 7 Jan 2009 11:54:30 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: kvm poweroff deadlock
Cc: "Avi Kivity" <avi@qumranet.com>
In-Reply-To: <c4e36d110901060713w28a6e3acq47e91ec53b4b6344@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110901060713w28a6e3acq47e91ec53b4b6344@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/6 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> Hi
>
> While testing latest  2.6.29-rc  inside qemu-kvm guest I've got this
> deadlock while executing poweroff:
>
> sd 0:0:0:0: [sda] Stopping disk
>
> ACPI: Preparing to enter system sleep state S5
>

Hi

This might be related to my previous post - but today with
commit: ede6f5aea054d3fb67c78857f7abdee602302043

I'm getting this oops inside qemu guest while doing poweroff:

ACPI: Preparing to enter system sleep state S5

Disabling non-boot CPUs ...

BUG: unable to handle kernel paging request at 000077ffe1adad5f

IP: [<ffffffff802592d4>] queue_work_on+0x44/0x60

PGD 0

Oops: 0000 [#1] SMP

last sysfs file:
/sys/devices/pci0000:00/0000:00:01.1/host1/target1:0:0/1:0:0:0/block/sdc/removable

CPU 0

Modules linked in: nfs lockd nfs_acl auth_rpcgss sunrpc autofs4 ipv6
dm_crypt crypto_blkcipher crypto_algapi dm_mod loop rtc_cmos i2c_piix4
uhci_hcd rtc_core rtc_lib 8139cp psmouse serio_raw evdev floppy
i2c_core mii usbcore button

Pid: 4168, comm: halt Not tainted 2.6.28 #104

RIP: 0010:[<ffffffff802592d4>]  [<ffffffff802592d4>] queue_work_on+0x44/0x60

RSP: 0018:ffff88001e47dd68  EFLAGS: 00010246

RAX: 000077ffe1adad5f RBX: ffff88001dd7e040 RCX: ffff88001dd7e040

RDX: 0000000000000000 RSI: ffff88001dd7e040 RDI: 0000000000000000

RBP: ffff88001e47dd68 R08: 0000000000000000 R09: ffffffff806ce8b8

R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000

R13: 0000000000000000 R14: ffffffff806ce8b8 R15: 0000000000000001

FS:  0000000000000000(0000) GS:ffffffff8090d040(0063) knlGS:00000000f7e626b0

CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b

CR2: 000077ffe1adad5f CR3: 000000001df5c000 CR4: 00000000000006e0

DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Process halt (pid: 4168, threadinfo ffff88001e47c000, task ffff88001e91a210)

Stack:

 ffff88001e47dd98 ffffffff80286607 0000000000000010 0000000000000001

 00000000ffffffea ffffffff806ce8b8 ffff88001e47ddf8 ffffffff80524620

 0000000000000010 0000000000000001 000000000000000f 0000001d4321fedc

Call Trace:

 [<ffffffff80286607>] __stop_machine+0xe7/0x140

 [<ffffffff80524620>] _cpu_down+0x120/0x2f0

 [<ffffffff802468fa>] disable_nonboot_cpus+0x8a/0x120

 [<ffffffff80257141>] kernel_power_off+0x21/0x50

 [<ffffffff80257420>] sys_reboot+0x110/0x230

 [<ffffffff8023c03f>] ? finish_task_switch+0x5f/0x110

 [<ffffffff8023bfe0>] ? finish_task_switch+0x0/0x110

 [<ffffffff8053618b>] ? thread_return+0x3d/0x702

 [<ffffffff80254439>] ? sys_kill+0xd9/0x200

 [<ffffffff802543dd>] ? sys_kill+0x7d/0x200

 [<ffffffff8020d1a9>] ? retint_swapgs+0xe/0x13

 [<ffffffff8026f18a>] ? trace_hardirqs_on_caller+0x16a/0x1d0

 [<ffffffff80538e0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f

 [<ffffffff802319c8>] sysenter_dispatch+0x7/0x2c

 [<ffffffff80538e0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f

Code: 1f 84 00 00 00 00 00 48 8d 41 08 48 39 41 08 75 2c 44 8b 46 20
48 8b 06 45 85 c0 48 f7 d0 0f 45 3d 02 56 47 00 48 89 ce 48 63 d7 <48>
8b 3c d0 e8 e3 fe ff ff ba 01 00 00 00 c9 89 d0 c3 0f 0b eb

RIP  [<ffffffff802592d4>] queue_work_on+0x44/0x60

 RSP <ffff88001e47dd68>

CR2: 000077ffe1adad5f

---[ end trace 862d0eb04a8b6d35 ]---

PM: Removing info for No Bus:vcs1

PM: Removing info for No Bus:vcsa1


Zdenek
