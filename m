Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbXJQUGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbXJQUGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760676AbXJQUFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:05:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53891 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762376AbXJQUFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:05:49 -0400
Date: Wed, 17 Oct 2007 22:05:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071017200539.GA23018@elte.hu>
References: <20071017172158.GH15552@kernel.dk> <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <20071017194944.GB15552@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017194944.GB15552@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> Ingo, if you care, can you test this one as well?

hm, it still crashes - find the log below.

	Ingo

[   34.653682] EXT3-fs: mounted filesystem with ordered data mode.
[   34.659487] VFS: Mounted root (ext3 filesystem) readonly.
[   34.665208] Freeing unused kernel memory: 372k freed
[   35.809988] BUG: unable to handle kernel paging request at virtual address 7c8d3000
[   35.817483] printing eip: 784e9480 *pde = 00dda027 *pte = 048d3000 
[   35.823723] Oops: 0000 [#1] DEBUG_PAGEALLOC
[   35.827883] 
[   35.829357] Pid: 47, comm: rc.sysinit Not tainted (2.6.23 #14)
[   35.835162] EIP: 0060:[<784e9480>] EFLAGS: 00010006 CPU: 0
[   35.840626] EIP is at ata_qc_issue+0xd0/0x340
[   35.844954] EAX: 3fd79000 EBX: 7c8d3000 ECX: 00000020 EDX: 00000020
[   35.851194] ESI: 7c8a1a80 EDI: 7c8d2e00 EBP: 7b54007c ESP: 7c8b3d5c
[   35.857434]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   35.862807] Process rc.sysinit (pid: 47, ti=7c8b2000 task=7c86d000 task.ti=7c8b2000)
[   35.870346] Stack: 7c8d3000 7b540000 7b540000 00000000 7c8d2ff0 7b54007c 7c8a1a80 7b5417a4 
[   35.878665]        784c2490 784ef61e 784f2173 7b52de98 7c8a1a80 7b540000 7b5417a4 7c8a1a80 
[   35.886985]        7b540000 7b524004 784f2260 784ef300 784c2490 7c8a1a80 00000216 7b524004 
[   35.895304] Call Trace:
[   35.897905]  [<784c2490>] scsi_done+0x0/0x20
[   35.902151]  [<784ef61e>] ata_scsi_translate+0xbe/0x140
[   35.907350]  [<784f2173>] ata_scsi_queuecmd+0x33/0x200
[   35.912463]  [<784f2260>] ata_scsi_queuecmd+0x120/0x200
[   35.917663]  [<784ef300>] ata_scsi_rw_xlat+0x0/0x220
[   35.922602]  [<784c2490>] scsi_done+0x0/0x20
[   35.926849]  [<784c2d12>] scsi_dispatch_cmd+0x152/0x290
[   35.932049]  [<78135c9c>] trace_hardirqs_on+0x9c/0xb0
[   35.937075]  [<784c8c3e>] scsi_request_fn+0x1be/0x370
[   35.942102]  [<78120f02>] del_timer+0x62/0x70
[   35.946434]  [<784072d5>] __generic_unplug_device+0x25/0x30
[   35.951981]  [<784075a5>] generic_unplug_device+0x15/0x30
[   35.957354]  [<78404e00>] blk_backing_dev_unplug+0x0/0x10
[   35.962726]  [<78404e0c>] blk_backing_dev_unplug+0xc/0x10
[   35.968100]  [<78180a9d>] block_sync_page+0x2d/0x40
[   35.972952]  [<78144dc9>] sync_page+0x29/0x40
[   35.977286]  [<7876f5dc>] __wait_on_bit_lock+0x3c/0x70
[   35.982399]  [<78144da0>] sync_page+0x0/0x40
[   35.986645]  [<78144d82>] __lock_page+0x52/0x60
[   35.991152]  [<7812adb0>] wake_bit_function+0x0/0x60
[   35.996092]  [<78144f60>] find_lock_page+0x60/0xa0
[   36.000858]  [<781473b9>] filemap_fault+0x269/0x3b0
[   36.005711]  [<78150b7f>] __do_fault+0x4f/0x3e0
[   36.010217]  [<78147150>] filemap_fault+0x0/0x3b0
[   36.014897]  [<78152640>] handle_mm_fault+0xf0/0x6c0
[   36.019837]  [<7810fd5c>] do_page_fault+0x21c/0x670
[   36.024689]  [<7812e6fd>] down_read_trylock+0x4d/0x60
[   36.029716]  [<7810fdbb>] do_page_fault+0x27b/0x670
[   36.034568]  [<7810fb40>] do_page_fault+0x0/0x670
[   36.039248]  [<787710ea>] error_code+0x6a/0x70
[   36.043669]  =======================
[   36.047221] Code: 84 d9 01 00 00 7e 32 31 d2 89 f6 8b 1c 24 83 c2 01 8b 03 2b 05 f8 ec d7 78 c1 f8 05 c1 e0 0c 03 43 04 89 43 08 83 c3 10 89 1c 24 <8b> 03 a8 01 0f 85 58 02 00 00 39 ca 75 d2 f0 83 44 24 00 00 85 
[   36.066027] EIP: [<784e9480>] ata_qc_issue+0xd0/0x340 SS:ESP 0068:7c8b3d5c
[  100.077701] BUG: spinlock lockup on CPU#0, scsi_eh_0/32, 7b52de98
[  100.083667]  [<78414b9b>] _raw_spin_lock+0x13b/0x140
[  100.088605]  [<784c6610>] scsi_error_handler+0x0/0x4f0
