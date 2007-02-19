Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbXBSOH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbXBSOH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932273AbXBSOH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:07:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:58781 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbXBSOHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:07:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=oft6EZKPw6Bs06ofYx66aS1FHOEzFxWgIXxTBJootvEux4curYF5w2LZAJm5fPeF2dlUV9b/bP8uEDfGDeHhBSRlffGLv68AbXEBYMf8WoTwhVsFta/QtvDMX+f9cqLzXesm8rFGEazo69MO5IwnUvwe9ROyp1SnV8L8dW+kAQk=
Message-ID: <45D9AF43.6010406@googlemail.com>
Date: Mon, 19 Feb 2007 15:08:03 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Frederik Deweerdt <deweerdt@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mattia Dongili <malattia@linux.it>,
       Laurent Riffard <laurent.riffard@free.fr>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [-mm patch] fix locking in __make_request (was Re: 2.6.20-mm2:
 Oops in generic_make_request)
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>	 <45D84F73.8060904@free.fr> <20070218175805.GB5567@inferi.kami.home>	 <20070218114903.a8160301.akpm@linux-foundation.org>	 <6bffcb0e0702181205v5755fc0es284c5be32f85d304@mail.gmail.com>	 <20070220130408.GB566@slug> <6bffcb0e0702190552r67f878csb5e5c49dfa7c050c@mail.gmail.com>
In-Reply-To: <6bffcb0e0702190552r67f878csb5e5c49dfa7c050c@mail.gmail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski napisał(a):
> Hi Frederik,
> 
> On 20/02/07, Frederik Deweerdt <deweerdt@free.fr> wrote:
>> Hi Michal,
>>
>> This seems to be a locking problem in __make_request, check_plug_merge()
>> should be called with the q->queue_lock held.
>> Could you try the following patch? It silenced the oops for me.
> 
> For me too, but Jens dislikes this patch.

Now I know why...

Code:  Bad EIP value.
EIP: [<6b6b6b6b>] 0x6b6b6b6b SS:ESP 0068:f45f9bf8
note: ksmserver[20993] exited with preempt_count 2
BUG: sleeping function called from invalid context at /mnt/md0/devel/linux-mm/kernel/rwsem.c:20
in_atomic():1, irqs_disabled():1
no locks held by ksmserver/20993.
irq event stamp: 0
hardirqs last  enabled at (0): [<00000000>] 0x0
hardirqs last disabled at (0): [<c0121bc6>] copy_process+0x539/0x137d
softirqs last  enabled at (0): [<c0121be4>] copy_process+0x557/0x137d


BUG: unable to handle kernel NULL pointer dereference at virtual address 00000118
 printing eip:
c01f3f12
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
last sysfs file: /devices/platform/i2c-9191/9191-0290/temp2_input
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss evdev snd_pcm skge intel_agp snd_timer agpgart snd 8139too soundcore sk98lin i2c_i801 mii snd_page_alloc ide_cd cdrom rtc unix
CPU:    0
EIP:    0060:[<c01f3f12>]    Not tainted VLI
EFLAGS: 00210297   (2.6.20-mm2 #19)
EIP is at blk_unplug_current+0x60/0x156
eax: f3f97298   ebx: 00000001   ecx: c043db74   edx: 00000000
esi: f3f97284   edi: 00000000   ebp: dda39d94   esp: dda39d58
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process swriter.bin (pid: 20846, ti=dda38000 task=dda79510 task.ti=dda38000)
Stack: dda79510 c03369fd 00000000 dda79510 c03369fd 00000000 dda39d90 f3f97298
       c011e710 c7403fac 00200046 dda39d90 00000001 c04abda0 06f75d80 dda39da8
       c03339bb dda79f38 dda79f30 c7403f98 dda39db0 c0333a2f dda39db8 c015e380
Call Trace:
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c01053c4>] show_stack_log_lvl+0x9d/0xac
 [<c01055c0>] show_registers+0x1ed/0x34c
 [<c010583c>] die+0x11d/0x234
 [<c011a8e1>] do_page_fault+0x47c/0x55b
 [<c0336d54>] error_code+0x7c/0x84
 [<c03339bb>] io_schedule+0x3d/0x9a
 [<c0333a2f>] io_wait_schedule+0x17/0x1d
 [<c015e380>] sleep_on_page+0xa/0xc
 [<c0334217>] __wait_on_bit_lock+0x34/0x66
 [<c015e372>] lock_page_blocking+0x2c/0x30
 [<c015ebe2>] do_generic_mapping_read+0x29f/0x51a
 [<c0160daa>] generic_file_aio_read+0x19a/0x1c8
 [<c017f300>] do_sync_read+0xd7/0x114
 [<c017fc2a>] vfs_read+0xcf/0x158
 [<c0180090>] sys_read+0x3d/0x72
 [<c010432c>] syscall_call+0x7/0xb
 =======================
Code: 0b eb fe 8b 46 0c 48 89 46 0c 85 c0 0f 85 07 01 00 00 8b 7e 1c c7 46 1c 00 00 00 00 8d 46 14 89 45 e0 39 46 14 0f 84 d4 00 00 00 <8b> 87 18 01 00 00 e8 c0 26 14 00 c7 45 e4 00 00 00 00 8b 5e 14
EIP: [<c01f3f12>] blk_unplug_current+0x60/0x156 SS:ESP 0068:dda39d58
BUG: unable to handle kernel paging request at virtual address 6b6b6b6b
 printing eip:
6b6b6b6b
*pde = 00000000
Oops: 0000 [#2]
PREEMPT SMP
last sysfs file: /devices/platform/i2c-9191/9191-0290/temp2_input
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss evdev snd_pcm skge intel_agp snd_timer agpgart snd 8139too soundcore sk98lin i2c_i801 mii snd_page_alloc ide_cd cdrom rtc unix
CPU:    0
EIP:    0060:[<6b6b6b6b>]    Not tainted VLI
EFLAGS: 00210012   (2.6.20-mm2 #19)
EIP is at 0x6b6b6b6b
eax: dda79f38   ebx: dda79f38   ecx: 00000000   edx: 00000003
esi: 6b6b6b6b   edi: 00000001   ebp: f45f9c18   esp: f45f9bf8
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process ksmserver (pid: 20993, ti=f45f8000 task=f335b510 task.ti=f45f8000)
Stack: c011b5e0 f45f9c44 00000003 c7403f98 6b6b6b6b c7403f98 00000001 00200292
       f45f9c38 c011c3fb 00000000 f45f9c44 00000003 c7403f98 f7d71f4c f7d71f4c
       f45f9c50 c01353c3 f45f9c44 f7d71f4c 00000002 00000002 f45f9c60 c01353e0
Call Trace:
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c01053c4>] show_stack_log_lvl+0x9d/0xac
 [<c01055c0>] show_registers+0x1ed/0x34c
 [<c010583c>] die+0x11d/0x234
 [<c011a8e1>] do_page_fault+0x47c/0x55b
 [<c0336d54>] error_code+0x7c/0x84
 [<c011c3fb>] __wake_up+0x31/0x42
 [<c01353c3>] __wake_up_bit+0x2e/0x34
 [<c01353e0>] wake_up_bit+0x17/0x1b
 [<c019ecbf>] unlock_buffer+0x12/0x14
 [<c01ccad4>] do_get_write_access+0x185/0x657
 [<c01ccfc1>] journal_get_write_access+0x1b/0x2a
 [<c01c985a>] __ext3_journal_get_write_access+0x19/0x3f
 [<c01be210>] ext3_reserve_inode_write+0x34/0x68
 [<c01be26e>] ext3_mark_inode_dirty+0x2a/0x41
 [<c01c0eb7>] ext3_dirty_inode+0x6a/0x7d
 [<c019adc1>] __mark_inode_dirty+0x2a/0x16d
 [<c019243e>] touch_atime+0xc1/0xcb
 [<c015ee50>] do_generic_mapping_read+0x50d/0x51a
 [<c0160daa>] generic_file_aio_read+0x19a/0x1c8
 [<c017f300>] do_sync_read+0xd7/0x114
 [<c017fc2a>] vfs_read+0xcf/0x158
 [<c0182fa7>] kernel_read+0x36/0x48
 [<c0183085>] prepare_binprm+0xcc/0xd1
 [<c01845c3>] do_execve+0x105/0x210
 [<c0102528>] sys_execve+0x3f/0x60
 [<c010432c>] syscall_call+0x7/0xb
 =======================
Code:  Bad EIP value.
EIP: [<6b6b6b6b>] 0x6b6b6b6b SS:ESP 0068:f45f9bf8
note: ksmserver[20993] exited with preempt_count 2
BUG: sleeping function called from invalid context at /mnt/md0/devel/linux-mm/kernel/rwsem.c:20
in_atomic():1, irqs_disabled():1
no locks held by ksmserver/20993.
irq event stamp: 0
hardirqs last  enabled at (0): [<00000000>] 0x0
hardirqs last disabled at (0): [<c0121bc6>] copy_process+0x539/0x137d
softirqs last  enabled at (0): [<c0121be4>] copy_process+0x557/0x137d
softirqs last disabled at (0): [<00000000>] 0x0
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c0105a37>] show_trace+0x12/0x14
 [<c0105af9>] dump_stack+0x16/0x18
 [<c011cb6c>] __might_sleep+0xc9/0xcf
 [<c0138a7a>] down_read+0x18/0x4c
 [<c014d82d>] acct_collect+0x3b/0x146
 [<c012679a>] do_exit+0x254/0x86c
 [<c010592d>] die+0x20e/0x234
 [<c011a8e1>] do_page_fault+0x47c/0x55b
 [<c0336d54>] error_code+0x7c/0x84
 [<c011c3fb>] __wake_up+0x31/0x42
 [<c01353c3>] __wake_up_bit+0x2e/0x34
 [<c01353e0>] wake_up_bit+0x17/0x1b
 [<c019ecbf>] unlock_buffer+0x12/0x14
 [<c01ccad4>] do_get_write_access+0x185/0x657
 [<c01ccfc1>] journal_get_write_access+0x1b/0x2a
 [<c01c985a>] __ext3_journal_get_write_access+0x19/0x3f
 [<c01be210>] ext3_reserve_inode_write+0x34/0x68
 [<c01be26e>] ext3_mark_inode_dirty+0x2a/0x41
 [<c01c0eb7>] ext3_dirty_inode+0x6a/0x7d
 [<c019adc1>] __mark_inode_dirty+0x2a/0x16d
 [<c019243e>] touch_atime+0xc1/0xcb
 [<c015ee50>] do_generic_mapping_read+0x50d/0x51a
 [<c0160daa>] generic_file_aio_read+0x19a/0x1c8
 [<c017f300>] do_sync_read+0xd7/0x114
 [<c017fc2a>] vfs_read+0xcf/0x158
 [<c0182fa7>] kernel_read+0x36/0x48
 [<c0183085>] prepare_binprm+0xcc/0xd1
 [<c01845c3>] do_execve+0x105/0x210
 [<c0102528>] sys_execve+0x3f/0x60
 [<c010432c>] syscall_call+0x7/0xb
 =======================
BUG: scheduling while atomic: ksmserver/0x10000002/20993
no locks held by ksmserver/20993.
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c0105a37>] show_trace+0x12/0x14
 [<c0105af9>] dump_stack+0x16/0x18
 [<c0332ca2>] __sched_text_start+0x92/0xd6e
 [<c011e82c>] __cond_resched+0x21/0x4b
 [<c0333d65>] cond_resched+0x3c/0x47
 [<c016b671>] unmap_vmas+0x497/0x589
 [<c016e9be>] exit_mmap+0x7e/0x12a
 [<c0121603>] mmput+0x49/0xaf
 [<c0125311>] exit_mm+0xe5/0xeb
 [<c01267ed>] do_exit+0x2a7/0x86c
 [<c010592d>] die+0x20e/0x234
 [<c011a8e1>] do_page_fault+0x47c/0x55b
 [<c0336d54>] error_code+0x7c/0x84
 [<c011c3fb>] __wake_up+0x31/0x42
 [<c01353c3>] __wake_up_bit+0x2e/0x34
 [<c01353e0>] wake_up_bit+0x17/0x1b
 [<c019ecbf>] unlock_buffer+0x12/0x14
 [<c01ccad4>] do_get_write_access+0x185/0x657
 [<c01ccfc1>] journal_get_write_access+0x1b/0x2a
 [<c01c985a>] __ext3_journal_get_write_access+0x19/0x3f
 [<c01be210>] ext3_reserve_inode_write+0x34/0x68
 [<c01be26e>] ext3_mark_inode_dirty+0x2a/0x41
 [<c01c0eb7>] ext3_dirty_inode+0x6a/0x7d
 [<c019adc1>] __mark_inode_dirty+0x2a/0x16d
 [<c019243e>] touch_atime+0xc1/0xcb
 [<c015ee50>] do_generic_mapping_read+0x50d/0x51a
 [<c0160daa>] generic_file_aio_read+0x19a/0x1c8
 [<c017f300>] do_sync_read+0xd7/0x114
 [<c017fc2a>] vfs_read+0xcf/0x158
 [<c0182fa7>] kernel_read+0x36/0x48
 [<c0183085>] prepare_binprm+0xcc/0xd1
 [<c01845c3>] do_execve+0x105/0x210
 [<c0102528>] sys_execve+0x3f/0x60
 [<c010432c>] syscall_call+0x7/0xb
 =======================

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
