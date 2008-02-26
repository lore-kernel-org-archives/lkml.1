Return-Path: <linux-kernel-owner+w=401wt.eu-S1763494AbYBZTeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763494AbYBZTeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 14:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755062AbYBZTd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 14:33:57 -0500
Received: from spiffy.freedom.ind.br ([201.35.65.91]:34008 "EHLO
	freedom.ind.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754103AbYBZTd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:33:56 -0500
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: oops when using git gc --auto
References: <87tzjvhmy7.fsf@ossystems.com.br>
	<200802270033.31297.nickpiggin@yahoo.com.au>
From: Otavio Salvador <otavio@debian.org>
Organization: O.S. Systems Ltda.
X-URL: http://www.debian.org/~otavio/
X-Attribution: O.S.
Date: Tue, 26 Feb 2008 16:36:14 -0300
In-Reply-To: <200802270033.31297.nickpiggin@yahoo.com.au> (Nick Piggin's message of "Wed\, 27 Feb 2008 00\:33\:31 +1100")
Message-ID: <87zltnjys1.fsf@ossystems.com.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> On Wednesday 27 February 2008 00:22, Otavio Salvador wrote:
>> Hello,
>>
>> Today I got this oops, someone has an idea of what's going wrong?
>>
>> Unable to handle kernel paging request at 0000020000000000 RIP:
>>  [<ffffffff802735c3>] find_get_pages+0x3c/0x69
>
> At this point, the most likely candidate is a memory corruption
> error, probably hardware. Can you run memtest86 for a few hours
> to get a bit more confidence in the hw (preferably overnight)?
>
> I did recently see another quite similar corruption in the
> pagecache radix-tree, though. Coincidence maybe?

I let it running at lunch time and all went OK. I've also let burnP6
running later and nothing happened. Looks like hw is OK.

I've just got another oops, with same kernel.

Unable to handle kernel paging request at ffff83006d922370 RIP: 
 [<ffffffff8027a79b>] shrink_page_list+0x16f/0x570
PGD 0 
Oops: 0000 [1] SMP 
CPU 2 
Modules linked in: sha256_generic aes_generic aes_x86_64 cbc blkcipher nvidia(P) rfcomm l2cap bluetooth ac battery ipv6 nfs lockd nfs_acl sunrpc bridge ext2 mbcache dm_crypt tun kvm_intel kvm loop snd_hda_intel snd_usb_audio snd_pcm snd_timer snd_usb_lib snd_rawmidi snd_seq_device snd_hwdep snd i2c_i801 soundcore snd_page_alloc intel_agp serio_raw button pcspkr e1000e i2c_core psmouse evdev xfs dm_mirror dm_snapshot dm_mod raid0 md_mod sg sr_mod cdrom sd_mod usbhid hid pata_marvell usb_storage floppy ahci ata_generic libata scsi_mod uhci_hcd ehci_hcd thermal processor fan
Pid: 213, comm: kswapd0 Tainted: P        2.6.24-1-amd64 #1
RIP: 0010:[<ffffffff8027a79b>]  [<ffffffff8027a79b>] shrink_page_list+0x16f/0x570
RSP: 0018:ffff81007ac8bbe0  EFLAGS: 00010286
RAX: 0000000000010009 RBX: ffff810001e888a8 RCX: ffff810001e888d0
RDX: ffff83006d922350 RSI: 0000000000000001 RDI: ffff810001e888a8
RBP: ffff81007d1b9258 R08: ffff81007d776407 R09: 0000000000000000
R10: 0000000000000009 R11: 0000000000000002 R12: 0000000000000001
R13: ffff81007ac8be70 R14: ffff81007ac8bda0 R15: ffff81007ac8be01
FS:  0000000000000000(0000) GS:ffff81007d776340(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffff83006d922370 CR3: 000000006d4ac000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process kswapd0 (pid: 213, threadinfo ffff81007ac8a000, task ffff81007cc03800)
Stack:  0000000600000000 0000000000000002 0000000000000002 0000000000000001
 ffff810001dc79e0 ffff810001dc7a18 ffff810001dc7fc8 ffff810001dc8000
 0000000000000000 0000000000000001 0000000000000000 0000000000000001
Call Trace:
 [<ffffffff80279da1>] isolate_lru_pages+0x5d/0x1d9
 [<ffffffff80279da1>] isolate_lru_pages+0x5d/0x1d9
 [<ffffffff8027acb9>] shrink_inactive_list+0x11d/0x381
 [<ffffffff8027b002>] shrink_zone+0xe5/0x108
 [<ffffffff8027b500>] kswapd+0x2fc/0x49b
 [<ffffffff80413b5b>] thread_return+0x3d/0xab
 [<ffffffff80247ff2>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8027b204>] kswapd+0x0/0x49b
 [<ffffffff80247ed3>] kthread+0x47/0x74
 [<ffffffff8020cc48>] child_rip+0xa/0x12
 [<ffffffff80247e8c>] kthread+0x0/0x74
 [<ffffffff8020cc3e>] child_rip+0x0/0x12


Code: 48 83 7a 20 00 0f 85 47 03 00 00 48 8d 42 30 48 39 42 30 0f 
RIP  [<ffffffff8027a79b>] shrink_page_list+0x16f/0x570
 RSP <ffff81007ac8bbe0>
CR2: ffff83006d922370
---[ end trace b01014a6540e7663 ]---

-- 
        O T A V I O    S A L V A D O R
---------------------------------------------
 E-mail: otavio@debian.org      UIN: 5906116
 GNU/Linux User: 239058     GPG ID: 49A5F855
 Home Page: http://otavio.ossystems.com.br
---------------------------------------------
"Microsoft sells you Windows ... Linux gives
 you the whole house."
