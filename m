Return-Path: <linux-kernel-owner+w=401wt.eu-S1031246AbXECMgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031246AbXECMgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031247AbXECMgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:36:52 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:47223 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031246AbXECMgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:36:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M+fK3ED1f6FQidlODCcGYoF7NGI8vT6WzC6d7s6orOftXJHTkAF5rEQt5eSjSM/+EObBtKlcB0nphjW5uvdfLTyutEeXbeHsPmzfYrBx9/YO4QZK7X4BAESdatzr3fRF1R5IvXNmZfuOhNwlspEfFW9JbnfgeZ65ZMEpIYYuO4I=
Message-ID: <6bffcb0e0705030536s61d42ec0x27a4b54ddef234a3@mail.gmail.com>
Date: Thu, 3 May 2007 14:36:49 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Gary Martin" <gm4rtin@gmail.com>
Subject: Re: Kernel Oops on 2.6.18-1.2869.fc6 is this a bug?
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <43806ba60705030524g2a8b0e54m2dda6f52615eba77@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43806ba60705030524g2a8b0e54m2dda6f52615eba77@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gary,

On 03/05/07, Gary Martin <gm4rtin@gmail.com> wrote:
> I have a system running Fedora Core 6 on a Dell PE4400 that crashed
> and became unresponsive, I captured the following kernel oops in
> /var/log/messages:
>
> Apr 30 08:52:11 hostname kernel: list_del corruption. prev->next
> should be d5507478, but was 0000008f
> Apr 30 08:52:11 hostname kernel: ------------[ cut here ]------------
> Apr 30 08:52:11 hostname kernel: kernel BUG at lib/list_debug.c:65!
> Apr 30 08:52:11 hostname kernel: invalid opcode: 0000 [#1]
> Apr 30 08:52:11 hostname kernel: SMP
> Apr 30 08:52:11 hostname kernel: last sysfs file:
> /devices/pci0000:00/0000:00:04.0/irq
>  Apr 30 08:52:11 hostname kernel: Modules linked in: ipv6 autofs4
> dm_multipath video sbs i2c_ec button battery ac lp i2c_piix4 sr_mod
> i2c_core st cdrom e100 sg floppy pcspkr mii parport_pc tg3 parport
> serio_raw dm_snapshot dm_zero dm_mirror dm_mod aic7xxx
> scsi_transport_spi aacraid sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd
> uhci_hcd
> Apr 30 08:52:11 hostname kernel: CPU:    0
> Apr 30 08:52:11 hostname kernel: EIP:    0060:[<c04e5913>]    Not tainted VLI
> Apr 30 08:52:11 hostname kernel: EFLAGS: 00010296   (2.6.18-1.2869.fc6 #1)
> Apr 30 08:52:11 hostname kernel: EIP is at list_del+0x23/0x6c
> Apr 30 08:52:11 hostname kernel: eax: 00000048   ebx: d5507478   ecx:
> c0671c50   edx: 00000096
> Apr 30 08:52:11 hostname kernel: esi: d5507428   edi: f7d98e40   ebp:
> 00000282   esp: f7feff38
> Apr 30 08:52:11 hostname kernel: ds: 007b   es: 007b   ss: 0068
> Apr 30 08:52:11 hostname kernel: Process events/0 (pid: 8, ti=f7fef000
> task=c2ec05c0 task.ti=f7fef000)
> Apr 30 08:52:11 hostname kernel: Stack: c063707b d5507478 0000008f
> d5507420 c04b7ae6 d5507420 d5507428 f7d98e40
> Apr 30 08:52:11 hostname kernel:        c04b772c c067ece0 c067ece4
> c042fa34 00000246 f7d98e40 f7d98e60 c04b7675
> Apr 30 08:52:11 hostname kernel:        00000000 f7d98e60 f7d98e40
> f7d98e58 00000000 c043032c 00000001 00000000
> Apr 30 08:52:11 hostname kernel: Call Trace:
> Apr 30 08:52:11 hostname kernel:  [<c04b7ae6>] keyring_destroy+0x28/0x65
> Apr 30 08:52:11 hostname kernel:  [<c04b772c>] key_cleanup+0xb7/0xd0
> Apr 30 08:52:11 hostname kernel:  [<c042fa34>] run_workqueue+0x83/0xc5
> Apr 30 08:52:11 hostname kernel:  [<c043032c>] worker_thread+0xd9/0x10d
> Apr 30 08:52:11 hostname kernel:  [<c04327f3>] kthread+0xc0/0xed
> Apr 30 08:52:11 hostname kernel:  [<c0405447>] kernel_thread_helper+0x7/0x10
> Apr 30 08:52:11 hostname kernel: DWARF2 unwinder stuck at
> kernel_thread_helper+0x7/0x10
> Apr 30 08:52:11 hostname kernel: Leftover inexact backtrace:
> Apr 30 08:52:11 hostname kernel:  =======================
> Apr 30 08:52:11 hostname kernel: Code: 00 00 89 c3 eb e8 90 90 53 89
> c3 83 ec 0c 8b 40 04 8b 00 39 d8 74 1c 89 5c 24 04 89 44 24 08 c7 04
> 24 7b 70 63 c0 e8 df bc f3 ff <0f> 0b 41 00 b8 70 63 c0 8b 03 8b 40 04
> 39 d8 74 1c 89 5c 24 04
> Apr 30 08:52:11 hostname kernel: EIP: [<c04e5913>] list_del+0x23/0x6c
> SS:ESP 0068:f7feff38
> Apr 30 08:52:20 hostname kernel:  <3>BUG: soft lockup detected on CPU#0!
> Apr 30 08:52:20 hostname kernel:  [<c0405876>] dump_trace+0x69/0x1af
> Apr 30 08:52:20 hostname kernel:  [<c04059d4>] show_trace_log_lvl+0x18/0x2c
> Apr 30 08:52:20 hostname kernel:  [<c0405f83>] show_trace+0xf/0x11
> Apr 30 08:52:20 hostname kernel:  [<c0406080>] dump_stack+0x15/0x17
> Apr 30 08:52:20 hostname kernel:  [<c04498a9>] softlockup_tick+0xad/0xc4
> Apr 30 08:52:20 hostname kernel:  [<c042a39a>] update_process_times+0x39/0x5c
> Apr 30 08:52:20 hostname kernel:  [<c04148c5>]
> smp_apic_timer_interrupt+0x5b/0x62
> Apr 30 08:52:20 hostname kernel:  [<c040512f>] apic_timer_interrupt+0x1f/0x30
> Apr 30 08:52:20 hostname kernel: DWARF2 unwinder stuck at
> apic_timer_interrupt+0x1f/0x30
> Apr 30 08:52:20 hostname kernel: Leftover inexact backtrace:
> Apr 30 08:52:20 hostname kernel:  [<c0609f2f>] __write_lock_failed+0xf/0x20
> Apr 30 08:52:20 hostname kernel:  [<c04e57f9>] _raw_write_lock+0x5d/0x74
> Apr 30 08:52:20 hostname kernel:  [<c04b7ffd>] keyring_publish_name+0x2c/0x6d
> Apr 30 08:52:20 hostname kernel:  [<c04b804c>] keyring_instantiate+0xe/0x13
> Apr 30 08:52:20 hostname kernel:  [<c04b6fa4>]
> __key_instantiate_and_link+0x2f/0xa8
> Apr 30 08:52:20 hostname kernel:  [<c04b820d>] keyring_alloc+0x53/0x6a
> Apr 30 08:52:20 hostname kernel:  [<c04b9888>] alloc_uid_keyring+0x4c/0xb2
> Apr 30 08:52:20 hostname kernel:  [<c042a80d>] alloc_uid+0x95/0x13c
> Apr 30 08:52:20 hostname kernel:  [<c042d66f>] set_user+0xb/0x8e
> Apr 30 08:52:20 hostname kernel:  [<c042ef3a>] sys_setresuid+0x111/0x1dd
> Apr 30 08:52:20 hostname kernel:  [<c0404027>] syscall_call+0x7/0xb
> Apr 30 08:52:20 hostname kernel:  =======================
>
> Is this a bug?

Yes, it is.

>  Please let me know if I can provide any other
> information to determine the cause of this crash.  Thanks.

You need to upgrade the kernel "yum upgrade kernel.i686"

If the problem still appears, fill bug report in RedHat bugzilla
https://bugzilla.redhat.com/bugzilla/index.cgi

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
