Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZDVOXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZDVOXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZDVOXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 10:23:05 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:48348 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073AbZDVOXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 10:23:03 -0400
Message-ID: <49EF2882.1020306@opengridcomputing.com>
Date: Wed, 22 Apr 2009 09:24:02 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Wolfram Strepp <wstrepp@gmx.de>
Subject: Re: [BUG] rbtree bug with mmotm 2009-04-14-17-24
References: <20090421184223.GP19637@balbir.in.ibm.com> <49EE42CC.7070002@opengridcomputing.com> <20090422131703.GO4593@kernel.dk>
In-Reply-To: <20090422131703.GO4593@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Apr 21 2009, Steve Wise wrote:
>   
>> Balbir Singh wrote:
>>     
>>> Hi, Andrew,
>>>
>>> I did a quick check on lkml to see if someone reported this issue
>>> already, I could not find any reports. I am beginning to see several
>>> of these on my machine. I saw recent refactoring of rbtrees, I've
>>> cc'ed Wolfram Strepp.
>>>
>>>   
>>>       
>> I see a similar crash (null ptr deref in rb_erase()) booting up  
>> 2.6.30-rc2/x86_64/centos 5.3 distro.
>>     
>
> Plain 2.6.30-rc2? Please also post the oops, thanks!
>
>   

No there are a few patches applied that are heading upstream, but one is 
in the NFS RDMA server which isn't loaded yet and the rest are in 
iw_cxgb3 (iwarp driver) which also hasn't loaded at the time we crash.  

NOTE:  Out of 4 power cycles, one booted up ok, 3 hit the crash.



Here's the OOPS:

Starting udev: BUG: unable to handle kernel NULL pointer dereference at 
0000000000000010
IP: [<ffffffff80341faf>] __rb_rotate_left+0x7/0x5b
PGD 12c4f6067 PUD 12c486067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/class/sound/controlC0/dev
CPU 0
Modules linked in: snd_hda_codec_intelhdmi snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event 
snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd 
button sr_mod cdrom i2c_i801 rtc_cmos serio_raw rtc_core cxgb3 sg r8169 
floppy soundcore mii shpchp i2c_core rtc_lib snd_page_alloc pcspkr 
dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ata_piix 
libata sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd
Pid: 2364, comm: vol_id Not tainted 2.6.30-rc2-stevo #1 P5E-VM HDMI
RIP: 0010:[<ffffffff80341faf>]  [<ffffffff80341faf>] 
__rb_rotate_left+0x7/0x5b
RSP: 0018:ffff88012bdb9990  EFLAGS: 00010086
RAX: ffff88012b663ac0 RBX: ffff88012b663ac0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88012d479a30 RDI: ffff88012b663ac0
RBP: ffff88012b663ac0 R08: ffff88012b663ac0 R09: 0000000000000000
R10: ffff88012d547808 R11: 0000000000000200 R12: ffff88012b663ac0
R13: 0000000000000000 R14: ffff88012d479a30 R15: 0000000000000000
FS:  00000000006e3880(0063) GS:ffff88002804b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000010 CR3: 000000012acd8000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process vol_id (pid: 2364, threadinfo ffff88012bdb8000, task 
ffff88012e102240)
Stack:
 ffffffff80342110 ffff88012b663a90 ffff88012b663ac0 ffff88012d479a00
 ffff88012d479a30 ffff88012d53c158 ffffffff8033a676 ffff88012d479a00
 ffff88012b663ac0 ffff88012b663c10 0000000000000000 ffff88012b663a90
Call Trace:
 [<ffffffff80342110>] ? rb_insert_color+0xb2/0xda
 [<ffffffff8033a676>] ? cfq_prio_tree_add+0x9d/0xa8
 [<ffffffff8033b668>] ? cfq_add_rq_rb+0xcb/0xde
 [<ffffffff8033b716>] ? cfq_insert_request+0x5b/0x390
 [<ffffffff8032fb2c>] ? elv_insert+0x112/0x1c0
 [<ffffffff80332790>] ? __make_request+0x3cf/0x40b
 [<ffffffff80331036>] ? generic_make_request+0x277/0x311
 [<ffffffff803323ba>] ? submit_bio+0xae/0xb5
 [<ffffffff802c2c2f>] ? submit_bh+0xd9/0xf9
 [<ffffffff802c579c>] ? block_read_full_page+0x247/0x264
 [<ffffffff802c8c99>] ? blkdev_get_block+0x0/0x47
 [<ffffffff80281447>] ? __do_page_cache_readahead+0x144/0x178
 [<ffffffff80281638>] ? ondemand_readahead+0x13a/0x149
 [<ffffffff8027b2d8>] ? generic_file_aio_read+0x219/0x539
 [<ffffffff802a6986>] ? do_sync_read+0xc9/0x10c
 [<ffffffff8024a4ae>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff8028ca6c>] ? handle_mm_fault+0x32f/0x6f1
 [<ffffffff802a70a9>] ? vfs_read+0xaa/0x133
 [<ffffffff802a742a>] ? sys_read+0x45/0x6e
 [<ffffffff8020b96b>] ? system_call_fastpath+0x16/0x1b
Code: 00 31 c0 eb 19 ff c0 48 89 ee 48 c7 c7 88 a5 cd 80 89 43 08 e8 29 
66 17 00 b8 01 00 00 00 5a 5b 5d c3 90 90 48 8b 4f 08 4c 8b 07 <48> 8b 
51 10 49 83 e0 fc 48 85 d2 48 89 57 08 74 0c 48 8b 02 83
RIP  [<ffffffff80341faf>] __rb_rotate_left+0x7/0x5b
 RSP <ffff88012bdb9990>
CR2: 0000000000000010
---[ end trace c900f92beb0e53d4 ]---


