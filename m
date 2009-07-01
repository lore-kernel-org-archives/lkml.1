Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZGAUav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZGAUav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZGAUan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:30:43 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:64664 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbZGAUal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:30:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TCe4++PyLVCUyXzpaPjB01cgOAtfJqQX3fWJyBTsCBjbv40cVFINBCCAnqLvMddBpd
         t/mKEFfGK1q+QATPVEcZ6x7MiZuJMWEb/UpKrgUg7Y0uzwnLKTA2h9K6BjuUpcCY7OGt
         k3r+yQrflQgwmY7SkSvOWvJfp/06cMih3wvuk=
MIME-Version: 1.0
In-Reply-To: <20090630091640.GB5873@cr0.nay.redhat.com>
References: <a5d9929e0906270807s4c0ef74ap2296dce4c790ea9a@mail.gmail.com> 
	<2375c9f90906281908k7aa089a3v932dd368d572194b@mail.gmail.com> 
	<a5d9929e0906290153g305427c6j37f96db060cb4738@mail.gmail.com> 
	<20090629091508.GA6308@cr0.nay.redhat.com> <a5d9929e0906290330s704d5848nb36ce2d37dc9124b@mail.gmail.com> 
	<20090630091640.GB5873@cr0.nay.redhat.com>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Wed, 1 Jul 2009 21:30:23 +0100
Message-ID: <a5d9929e0907011330u3b5f45a4l667b27e5cd22e22f@mail.gmail.com>
Subject: Re: Crashes during boot on 2.6.30 / 2.6.31-rc, random programs
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again

Looks like this just opened the lid on some other limits. I just hit
another thing, which hadn't shown up before i made the changes, but
looks like its just another limit thats too low. This one is harder to
reproduce tho.

Jun 30 21:35:03 hightech kernel: BUG: MAX_LOCKDEP_CHAINS too low!
Jun 30 21:35:03 hightech kernel: turning off the locking correctness validator.
Jun 30 21:35:03 hightech kernel: Pid: 9379, comm: qemu-kvm Not tainted
2.6.30-wl #3
Jun 30 21:35:03 hightech kernel: Call Trace:
Jun 30 21:35:03 hightech kernel: [<c07da76f>] ? printk+0x22/0x3b
Jun 30 21:35:03 hightech kernel: [<c04638f5>] __lock_acquire+0x583/0xb05
Jun 30 21:35:03 hightech kernel: [<c046a107>] ? __module_text_address+0x20/0x6d
Jun 30 21:35:03 hightech kernel: [<c0463f2e>] lock_acquire+0xb7/0xeb
Jun 30 21:35:03 hightech kernel: [<c05cf959>] ? get_hash_bucket+0x3a/0x55
Jun 30 21:35:03 hightech kernel: [<c05cf959>] ? get_hash_bucket+0x3a/0x55
Jun 30 21:35:03 hightech kernel: [<c07dd75f>] _spin_lock_irqsave+0x45/0x89
Jun 30 21:35:03 hightech kernel: [<c05cf959>] ? get_hash_bucket+0x3a/0x55
Jun 30 21:35:03 hightech kernel: [<c05cf959>] get_hash_bucket+0x3a/0x55
Jun 30 21:35:03 hightech kernel: [<c05d09e8>] add_dma_entry+0x1f/0x4f
Jun 30 21:35:03 hightech kernel: [<c05d0c66>] debug_dma_map_sg+0xe1/0x147
Jun 30 21:35:03 hightech kernel: [<c0695a19>] ata_qc_issue+0x1c0/0x254
Jun 30 21:35:03 hightech kernel: [<c069bf44>] __ata_scsi_queuecmd+0x16a/0x1c8
Jun 30 21:35:03 hightech kernel: [<c067a37e>] ? scsi_done+0x0/0x32
Jun 30 21:35:03 hightech kernel: [<c069b9b1>] ? ata_scsi_rw_xlat+0x0/0x207
Jun 30 21:35:03 hightech kernel: [<c069c05b>] ata_scsi_queuecmd+0x55/0x95
Jun 30 21:35:03 hightech kernel: [<c067a37e>] ? scsi_done+0x0/0x32
Jun 30 21:35:03 hightech kernel: [<c067a627>] scsi_dispatch_cmd+0x187/0x207
Jun 30 21:35:03 hightech kernel: [<c068044c>] scsi_request_fn+0x33d/0x480
Jun 30 21:35:03 hightech kernel: [<c0445a1e>] ? del_timer+0x54/0x6e
Jun 30 21:35:03 hightech kernel: [<c05aefbe>] __generic_unplug_device+0x3e/0x53
Jun 30 21:35:03 hightech kernel: [<c05af00a>] blk_start_queueing+0x37/0x4a
Jun 30 21:35:03 hightech kernel: [<c05bcc7e>] cfq_insert_request+0x46f/0x498
Jun 30 21:35:03 hightech kernel: [<c05ad43b>] ? __rcu_read_unlock+0x0/0x3d
Jun 30 21:35:03 hightech kernel: [<c05ac60d>] elv_insert+0x12f/0x1d0
Jun 30 21:35:03 hightech kernel: [<c05ac763>] __elv_add_request+0xb5/0xce
Jun 30 21:35:03 hightech kernel: [<c05ad465>] ? __rcu_read_unlock+0x2a/0x3d
Jun 30 21:35:03 hightech kernel: [<c05ad533>] ? drive_stat_acct+0xbb/0xd3
Jun 30 21:35:03 hightech kernel: [<c05af6b3>] __make_request+0x33b/0x3c1
Jun 30 21:35:03 hightech kernel: [<c04cd85c>] ? check_valid_pointer+0x2c/0x6c
Jun 30 21:35:03 hightech kernel: [<c046249e>] ? mark_lock+0x29/0x1f3
Jun 30 21:35:03 hightech kernel: [<c04cf83a>] ? kmem_cache_alloc+0xc2/0x150
Jun 30 21:35:03 hightech kernel: [<c05ade19>] generic_make_request+0x2fd/0x351
Jun 30 21:35:03 hightech kernel: [<c05ade19>] ? generic_make_request+0x2fd/0x351
Jun 30 21:35:03 hightech kernel: [<c04a8b4e>] ? mempool_alloc+0x5b/0x105
Jun 30 21:35:03 hightech kernel: [<c04626ba>] ? mark_held_locks+0x52/0x7c
Jun 30 21:35:03 hightech kernel: [<c05adf2d>] submit_bio+0xc0/0xd9
Jun 30 21:35:03 hightech kernel: [<c04fd28d>] ? bio_alloc_bioset+0x35/0xd5
Jun 30 21:35:03 hightech kernel: [<c04f845c>] submit_bh+0xea/0x11b
Jun 30 21:35:03 hightech kernel: [<c04fae00>]
__block_write_full_page+0x218/0x2f0
Jun 30 21:35:03 hightech kernel: [<c054427d>] ?
ext4_normal_get_block_write+0x0/0x76
Jun 30 21:35:03 hightech kernel: [<c04fb5ea>] ? end_buffer_async_write+0x0/0x140
Jun 30 21:35:03 hightech kernel: [<c04fb5ea>] ? end_buffer_async_write+0x0/0x140
Jun 30 21:35:03 hightech kernel: [<c04faf4c>]
block_write_full_page_endio+0x74/0xda
Jun 30 21:35:03 hightech kernel: [<c04fb5ea>] ? end_buffer_async_write+0x0/0x140
Jun 30 21:35:03 hightech kernel: [<c054427d>] ?
ext4_normal_get_block_write+0x0/0x76
Jun 30 21:35:03 hightech kernel: [<c04fafd4>] block_write_full_page+0x22/0x38
Jun 30 21:35:03 hightech kernel: [<c04fb5ea>] ? end_buffer_async_write+0x0/0x140
Jun 30 21:35:03 hightech kernel: [<c0543390>] ext4_da_writepage+0x1aa/0x1da
Jun 30 21:35:03 hightech kernel: [<c054315b>] mpage_da_submit_io+0x9b/0xf0
Jun 30 21:35:03 hightech kernel: [<c0545f40>] ext4_da_writepages+0x2c2/0x445
Jun 30 21:35:03 hightech kernel: [<c04ad194>] do_writepages+0x32/0x58
Jun 30 21:35:03 hightech kernel: [<c04a739b>]
__filemap_fdatawrite_range+0x73/0x8c
Jun 30 21:35:03 hightech kernel: [<c04a7c81>] filemap_fdatawrite_range+0x2b/0x44
Jun 30 21:35:03 hightech kernel: [<c04a7e9e>] sync_page_range+0x7f/0xf5
Jun 30 21:35:03 hightech kernel: [<c04629d3>] ? trace_hardirqs_on+0x19/0x2c
Jun 30 21:35:03 hightech kernel: [<c04a7fd1>] generic_file_aio_write+0xbd/0xe1
Jun 30 21:35:03 hightech kernel: [<c053da09>] ext4_file_write+0xc2/0x149
Jun 30 21:35:03 hightech kernel: [<c04d7cf2>] do_sync_write+0xbe/0x10a
Jun 30 21:35:03 hightech kernel: [<c046249e>] ? mark_lock+0x29/0x1f3
Jun 30 21:35:03 hightech kernel: [<c0451586>] ?
autoremove_wake_function+0x0/0x55
Jun 30 21:35:03 hightech kernel: [<c04d920e>] ? __rcu_read_unlock+0x0/0x3d
Jun 30 21:35:03 hightech kernel: [<c058377a>] ?
security_file_permission+0x23/0x36
Jun 30 21:35:03 hightech kernel: [<c04d7eed>] ? rw_verify_area+0xa5/0xd8
Jun 30 21:35:03 hightech kernel: [<c04d7c34>] ? do_sync_write+0x0/0x10a
Jun 30 21:35:03 hightech kernel: [<c04d837f>] vfs_write+0x9f/0x10f
Jun 30 21:35:03 hightech kernel: [<c04d8459>] sys_pwrite64+0x6a/0x93
Jun 30 21:35:03 hightech kernel: [<c04037f3>] sysenter_do_call+0x12/0x38


Now the whole call trace is showing up (so the other limits were
raised correctly).

Im going to go through the source and raise this limit as well, but as
i said above, this one is harder to trigger, so it may take a couple
of days to see it again.

The first problem was indeed just the tip of the iceberg. Perphaps a
more comprehensive change of all the related limits is in order? (I do
not know if such change has already happened or not, if so, please
point me in the right direction.)

Again,
Thank you very much for your time,
Joao Correia
Centro de Informatica
Universidade da Beira Interior
Portugal

On Tue, Jun 30, 2009 at 10:16 AM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
> On Mon, Jun 29, 2009 at 11:30:41AM +0100, Joao Correia wrote:
>>Hello
>>
>>The system seemed to happily ignore all the sysctl.conf changes and
>>all echo VALUE >  /proc/sys/kernel/max_lock_depth
>
>
> Ouch, mistake! max_lock_depth is for rt_mutex... :)
>
>>
>>So i dug a little on the source and changed
>>
>>include/linux/sched.h
>>
>># define MAX_LOCK_DEPTH 48UL
>>
>>to
>>
>># define MAX_LOCK_DEPTH 96UL
>>
>>and im getting no more errors. Of course, now its probably radioactive
>>and about to blow up, but at least it's not complaining anymore :).
>
> Yeah, this is right.
>
> Let's Cc: Peter to see if he would like to change this number...
>
> Peter?
>
