Return-Path: <linux-kernel-owner+w=401wt.eu-S1762197AbXFGO1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762197AbXFGO1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbXFGO1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:27:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:18432 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbXFGO1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:27:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=mySJpA98S1Er+x+TzR2hLsi/NfHjhAQf15t+veQLrzrp/iGIvC8PcoQvBSz4Cu3PWY14CVGO/txNW+33Y8q/s8UrA/+tAe0o6qashWJQzFeeGjAM2UkKzdXkgF6uWkMsjJv3Uzw9I6vFxNnZ3etMtGfAaswAB95r2xZPQwYxGpc=
Message-ID: <4bacf17f0706070727x3714fe68n19d0fa59a4dacc79@mail.gmail.com>
Date: Thu, 7 Jun 2007 16:27:06 +0200
From: "=?ISO-8859-2?Q?Marcin_=A6lusarz?=" <marcin.slusarz@gmail.com>
To: mchehab@infradead.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: bttv on 2.6.21.3: possible circular locking dependency detected
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[  170.012538]
[  170.012540] =======================================================
[  170.012545] [ INFO: possible circular locking dependency detected ]
[  170.012547] 2.6.21.3 #1
[  170.012549] -------------------------------------------------------
[  170.012551] tvtime/6727 is trying to acquire lock:
[  170.012554]  (&mm->mmap_sem){----}, at: [<ffffffff88053cf4>]
videobuf_dma_init_user+0xd4/0x180 [video_buf]
[  170.012564]
[  170.012565] but task is already holding lock:
[  170.012567]  (&q->lock#2){--..}, at: [<ffffffff80267399>] mutex_lock+0x9/0x10
[  170.012575]
[  170.012576] which lock already depends on the new lock.
[  170.012577]
[  170.012579]
[  170.012579] the existing dependency chain (in reverse order) is:
[  170.012581]
[  170.012582] -> #1 (&q->lock#2){--..}:
[  170.012585]        [<ffffffff802a6922>] __lock_acquire+0xc82/0xf30
[  170.012593]        [<ffffffff8805e86f>] bttv_do_ioctl+0x152f/0x2460 [bttv]
[  170.012608]        [<ffffffff80267399>] mutex_lock+0x9/0x10
[  170.012615]        [<ffffffff802a6c58>] lock_acquire+0x88/0xc0
[  170.012621]        [<ffffffff80267399>] mutex_lock+0x9/0x10
[  170.012627]        [<ffffffff802671dc>] __mutex_lock_slowpath+0xec/0x2a0
[  170.012634]        [<ffffffff80207131>] check_poison_obj+0x31/0x1f0
[  170.012640]        [<ffffffff802c979b>] kmem_cache_zalloc+0x8b/0xe0
[  170.012647]        [<ffffffff80267399>] mutex_lock+0x9/0x10
[  170.012653]        [<ffffffff880528bc>]
videobuf_mmap_mapper+0x1c/0x290 [video_buf]
[  170.012662]        [<ffffffff8805bfcb>] bttv_mmap+0x5b/0x60 [bttv]
[  170.012673]        [<ffffffff8020dc83>] do_mmap_pgoff+0x4e3/0x800
[  170.012679]        [<ffffffff8026921b>] _spin_unlock_irq+0x2b/0x60
[  170.012685]        [<ffffffff8022455b>] sys_mmap+0x9b/0x130
[  170.012691]        [<ffffffff8025f71e>] system_call+0x7e/0x83
[  170.012697]        [<ffffffffffffffff>] 0xffffffffffffffff
[  170.012727]
[  170.012728] -> #0 (&mm->mmap_sem){----}:
[  170.012731]        [<ffffffff802a67de>] __lock_acquire+0xb3e/0xf30
[  170.012737]        [<ffffffff88053cf4>]
videobuf_dma_init_user+0xd4/0x180 [video_buf]
[  170.012745]        [<ffffffff802a6c58>] lock_acquire+0x88/0xc0
[  170.012751]        [<ffffffff88053cf4>]
videobuf_dma_init_user+0xd4/0x180 [video_buf]
[  170.012760]        [<ffffffff802a1098>] down_read+0x28/0x40
[  170.012765]        [<ffffffff88053cf4>]
videobuf_dma_init_user+0xd4/0x180 [video_buf]
[  170.012774]        [<ffffffff802a572b>] trace_hardirqs_on+0x14b/0x180
[  170.012780]        [<ffffffff880540bc>] videobuf_iolock+0x9c/0x100
[video_buf]
[  170.012788]        [<ffffffff8805bece>]
bttv_prepare_buffer+0x2ae/0x310 [bttv]
[  170.012800]        [<ffffffff8805bf62>] buffer_prepare+0x32/0x40 [bttv]
[  170.012811]        [<ffffffff80267399>] mutex_lock+0x9/0x10
[  170.012818]        [<ffffffff880548ca>] videobuf_qbuf+0x2ea/0x3a0 [video_buf]
[  170.012826]        [<ffffffff8805e8ab>] bttv_do_ioctl+0x156b/0x2460 [bttv]
[  170.012838]        [<ffffffff802a6b39>] __lock_acquire+0xe99/0xf30
[  170.012844]        [<ffffffff80209225>] __handle_mm_fault+0xb45/0xb80
[  170.012850]        [<ffffffff80222b4a>] __up_read+0x2a/0xa0
[  170.012856]        [<ffffffff8802ec09>] video_usercopy+0x189/0x250 [videodev]
[  170.012865]        [<ffffffff8805d340>] bttv_do_ioctl+0x0/0x2460 [bttv]
[  170.012877]        [<ffffffff8026b8cb>] do_page_fault+0x4bb/0x8f0
[  170.012883]        [<ffffffff8023136a>] __up_write+0xfa/0x110
[  170.012889]        [<ffffffff802691b5>] _spin_unlock_irqrestore+0x45/0x80
[  170.012895]        [<ffffffff8805c0af>] bttv_ioctl+0x6f/0x80 [bttv]
[  170.012907]        [<ffffffff80242ebb>] do_ioctl+0x6b/0xa0
[  170.012913]        [<ffffffff8023124b>] vfs_ioctl+0x2ab/0x2d0
[  170.012919]        [<ffffffff8024de1a>] sys_ioctl+0x4a/0x80
[  170.012925]        [<ffffffff8025f71e>] system_call+0x7e/0x83
[  170.012931]        [<ffffffffffffffff>] 0xffffffffffffffff
[  170.012937]
[  170.012938] other info that might help us debug this:
[  170.012939]
[  170.012941] 1 lock held by tvtime/6727:
[  170.012943]  #0:  (&q->lock#2){--..}, at: [<ffffffff80267399>]
mutex_lock+0x9/0x10
[  170.012950]
[  170.012950] stack backtrace:
[  170.012952]
[  170.012953] Call Trace:
[  170.012957]  [<ffffffff802a47a6>] print_circular_bug_tail+0x76/0x90
[  170.012962]  [<ffffffff802a67de>] __lock_acquire+0xb3e/0xf30
[  170.012969]  [<ffffffff88053cf4>]
:video_buf:videobuf_dma_init_user+0xd4/0x180
[  170.012974]  [<ffffffff802a6c58>] lock_acquire+0x88/0xc0
[  170.012979]  [<ffffffff88053cf4>]
:video_buf:videobuf_dma_init_user+0xd4/0x180
[  170.012984]  [<ffffffff802a1098>] down_read+0x28/0x40
[  170.012989]  [<ffffffff88053cf4>]
:video_buf:videobuf_dma_init_user+0xd4/0x180
[  170.012993]  [<ffffffff802a572b>] trace_hardirqs_on+0x14b/0x180
[  170.013000]  [<ffffffff880540bc>] :video_buf:videobuf_iolock+0x9c/0x100
[  170.013010]  [<ffffffff8805bece>] :bttv:bttv_prepare_buffer+0x2ae/0x310
[  170.013021]  [<ffffffff8805bf62>] :bttv:buffer_prepare+0x32/0x40
[  170.013025]  [<ffffffff80267399>] mutex_lock+0x9/0x10
[  170.013030]  [<ffffffff880548ca>] :video_buf:videobuf_qbuf+0x2ea/0x3a0
[  170.013041]  [<ffffffff8805e8ab>] :bttv:bttv_do_ioctl+0x156b/0x2460
[  170.013045]  [<ffffffff802a6b39>] __lock_acquire+0xe99/0xf30
[  170.013049]  [<ffffffff80209225>] __handle_mm_fault+0xb45/0xb80
[  170.013054]  [<ffffffff80222b4a>] __up_read+0x2a/0xa0
[  170.013060]  [<ffffffff8802ec09>] :videodev:video_usercopy+0x189/0x250
[  170.013069]  [<ffffffff8805d340>] :bttv:bttv_do_ioctl+0x0/0x2460
[  170.013075]  [<ffffffff8026b8cb>] do_page_fault+0x4bb/0x8f0
[  170.013079]  [<ffffffff8023136a>] __up_write+0xfa/0x110
[  170.013082]  [<ffffffff802691b5>] _spin_unlock_irqrestore+0x45/0x80
[  170.013093]  [<ffffffff8805c0af>] :bttv:bttv_ioctl+0x6f/0x80
[  170.013097]  [<ffffffff80242ebb>] do_ioctl+0x6b/0xa0
[  170.013101]  [<ffffffff8023124b>] vfs_ioctl+0x2ab/0x2d0
[  170.013105]  [<ffffffff8024de1a>] sys_ioctl+0x4a/0x80
[  170.013110]  [<ffffffff8025f71e>] system_call+0x7e/0x83
[  170.013113]
