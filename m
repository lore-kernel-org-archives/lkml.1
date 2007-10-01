Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbXJAMdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbXJAMdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 08:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXJAMdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 08:33:08 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:3894 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbXJAMdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 08:33:06 -0400
Date: Mon, 1 Oct 2007 14:32:30 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Pierre-Yves Paulus <py@idlum.be>
Cc: linux-kernel@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
       BlueZ development <bluez-devel@lists.sourceforge.net>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Warnings and Oops on 2.6.23-rc6 while activily using rfcomm
 links (mm/slab.c)
Message-ID: <20071001143230.3c370b2e@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46FD2CA0.3050704@idlum.be>
References: <46F92364.3080603@idlum.be>
	<46F952BD.4010009@redhat.com>
	<46FA5E2E.3010300@idlum.be>
	<20070927085658.1c66f1c8@gondolin.boeblingen.de.ibm.com>
	<46FBC1AE.4020404@idlum.be>
	<46FBF17A.6030009@idlum.be>
	<20070928085438.4eb5a38f@gondolin.boeblingen.de.ibm.com>
	<46FD1200.9020407@idlum.be>
	<46FD1670.5070109@idlum.be>
	<46FD2CA0.3050704@idlum.be>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 18:32:32 +0200,
Pierre-Yves Paulus <py@idlum.be> wrote:

This looks more informational, thanks.

> DEV: Unregistering device. ID = 'rfcomm0'
> PM: Removing info for No Bus:rfcomm0
> kobject_uevent_env
> fill_kobj_path: path = '/class/tty/rfcomm0'
> fill_kobj_path: path = 
> '/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
> kobject rfcomm0: cleaning up
> device_create_release called for rfcomm0

Here rfcomm0 was unregistered and released.

> bus bluetooth: remove device acl00126253F906
> PM: Removing info for bluetooth:acl00126253F906
> kobject_uevent_env
> fill_kobj_path: path = 
> '/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
> kobject acl00126253F906: cleaning up

And here the corresponding physdev.

> BUG: unable to handle kernel NULL pointer dereference at virtual address 
> 00000000
>   printing eip:
> c0249e29
> *pde = 00000000
> Oops: 0000 [#1]
> Modules linked in: rfcomm l2cap battery ipv6 dm_snapshot dm_mirror 
> dm_mod softdog loop parport_pc parport floppy rtc pcspkr ac button 
> psmouse serio_raw snd_cs5535audio snd_ac97_codec ac97_bus snd_pcm 
> snd_timer snd soundcore snd_page_alloc geode_rng cs5535_gpio hci_usb 
> bluetooth geode_aes blkcipher tsdev evdev usbhid hid reiserfs ide_disk 
> generic amd74xx ide_core ohci_hcd sata_via ata_generic 8139cp libata 
> 8139too usbcore mii scsi_mod thermal processor fan
> CPU:    0
> EIP:    0060:[<c0249e29>]    Not tainted VLI
> EFLAGS: 00010017   (2.6.23-rc8 #1)
> EIP is at skb_dequeue+0x23/0x4a
> eax: 00000282   ebx: 00000282   ecx: 00000000   edx: caf8ab8c
> esi: c8428d48   edi: c8428c00   ebp: c8428c0c   esp: c124ff60
> ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
> Process events/0 (pid: 5, ti=c124e000 task=c1243500 task.ti=c124e000)
> Stack: caf8ab8c c024b0a1 c8428c00 d02f4075 c8428d60 c020eb8d c08978a8 
> 00000000
>         00000000 00000000 cf7ab680 c8428d48 c020eac4 00000000 c01279a9 
> c124ffb4
>         00000046 c1243500 cf7ab680 cf7ab680 c0127ffe c124ffd0 c01280b0 
> 00000000
> Call Trace:
>   [<c024b0a1>] skb_queue_purge+0x11/0x17
>   [<d02f4075>] rfcomm_tty_flush_buffer+0x1c/0x33 [rfcomm]
>   [<c020eb8d>] do_tty_hangup+0xc9/0x2d0
>   [<c020eac4>] do_tty_hangup+0x0/0x2d0
>   [<c01279a9>] run_workqueue+0x7d/0x103
>   [<c0127ffe>] worker_thread+0x0/0xbe
>   [<c01280b0>] worker_thread+0xb2/0xbe
>   [<c012a510>] autoremove_wake_function+0x0/0x35
>   [<c012a363>] kthread+0x36/0x5b
>   [<c012a32d>] kthread+0x0/0x5b
>   [<c0104e17>] kernel_thread_helper+0x7/0x10
>   =======================

rfcomm0 is already freed, maybe this code is still trying to access it?

> Code: 89 42 0a 5b 5e 5f 5d c3 53 89 c2 9c 58 90 8d b4 26 00 00 00 00 89 
> c3 fa 90 8d b4 26 00 00 00 00 90 8b 0a 39 d1 75 04 31 c9 eb 17 <8b> 01 
> ff 4a 08 89 02 89 50 04 c7 01 00 00 00 00 c7 41 04 00 00
> EIP: [<c0249e29>] skb_dequeue+0x23/0x4a SS:ESP 0068:c124ff60
> WARNING: at lib/kref.c:33 kref_get()
>   [<c01c6db7>] kref_get+0x34/0x3d
>   [<c01c61a9>] kobject_get+0xf/0x13
>   [<c022578d>] get_device+0xe/0x14
>   [<c02257a6>] device_move+0x13/0x114
>   [<d02f4b7c>] rfcomm_tty_close+0x23/0x61 [rfcomm]
>   [<c020f88d>] release_dev+0x1c0/0x54e
>   [<d02f40e5>] rfcomm_dev_destruct+0x59/0x65 [rfcomm]
>   [<d02f4725>] rfcomm_dev_ioctl+0x329/0x4d0 [rfcomm]
>   [<c0130c96>] tick_program_event+0x2a/0x49
>   [<c0248124>] release_sock+0xc/0x74
>   [<c020fc22>] tty_release+0x7/0xa
>   [<c015dabd>] __fput+0x93/0x147
>   [<c015b66a>] filp_close+0x51/0x58
>   [<c02a8b0e>] __sched_text_start+0x1d6/0x245
>   [<c015c70b>] sys_close+0x54/0x83
>   [<c0103c72>] syscall_call+0x7/0xb
>   =======================
> DEVICE: moving 'rfcomm0' to '<NULL>'
> kobject <NULL>: cleaning up
> device_create_release called for rfcomm0

But here someone still tries to move rfcomm0 around? It already is gone
and released... The code path has no reference on rfcomm0. (Well,
device_move() tries to get a reference on the device to be moved, but
that doesn't help since the device is already gone.)

This looks like a race inside rfcomm. The device_unregister() either
needs to be delayed until after device_move() has finished, or the
thread calling device_move() needs to have a reference. (device_move()
on an unregistered device should just fail but not oops.) Marcel?
