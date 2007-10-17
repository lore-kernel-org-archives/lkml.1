Return-Path: <linux-kernel-owner+w=401wt.eu-S935643AbXJQUwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935643AbXJQUwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757655AbXJQUw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:52:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45245 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbXJQUw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:52:28 -0400
Date: Wed, 17 Oct 2007 22:51:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071017205139.GA32469@elte.hu>
References: <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <alpine.LFD.0.999.0710171244330.26902@woody.linux-foundation.org> <20071017195659.GD15552@kernel.dk> <20071017200638.GE15552@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017200638.GE15552@kernel.dk>
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

> --- a/block/ll_rw_blk.c
> +++ b/block/ll_rw_blk.c
> @@ -631,7 +631,7 @@ void blk_queue_max_phys_segments(struct request_queue *q,
>  		printk("%s: set to minimum %d\n", __FUNCTION__, max_segments);
>  	}
>  
> -	q->max_phys_segments = max_segments;
> +	q->max_phys_segments = max_segments - 1;

this one crashes too, if added ontop of all the other fixes so far.

	Ingo

[   34.711185] EXT3-fs: mounted filesystem with ordered data mode.
[   34.716991] VFS: Mounted root (ext3 filesystem) readonly.
[   34.722712] Freeing unused kernel memory: 372k freed
[   36.112742] BUG: unable to handle kernel paging request at virtual address 7c8b1000
[   36.120246] printing eip: 784e9490 *pde = 00dda027 *pte = 048b1000 
[   36.126486] Oops: 0000 [#1] DEBUG_PAGEALLOC
[   36.130645] 
[   36.132119] Pid: 0, comm: swapper Not tainted (2.6.23 #15)
[   36.137579] EIP: 0060:[<784e9490>] EFLAGS: 00010006 CPU: 0
[   36.143043] EIP is at ata_qc_issue+0xd0/0x340
[   36.147371] EAX: 3f896000 EBX: 7c8b1000 ECX: 00000008 EDX: 00000008
[   36.153610] ESI: 7c86de80 EDI: 7c8b0f80 EBP: 7b54007c ESP: 78a13e28
[   36.159851]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   36.165223] Process swapper (pid: 0, ti=78a12000 task=789753e0 task.ti=78a12000)
[   36.172416] Stack: 7c8b1000 7b540000 7b540000 00000000 7c8b0ff0 7b54007c 7c86de80 7b5417a4 
[   36.180735]        784c24a0 784ef62e 784f2183 7b52de98 7c86de80 7b540000 7b5417a4 7c86de80 
[   36.189055]        7b540000 7b524004 784f2270 784ef310 784c24a0 7c86de80 00000206 7b524004 
[   36.197374] Call Trace:
[   36.199975]  [<784c24a0>] scsi_done+0x0/0x20
[   36.204221]  [<784ef62e>] ata_scsi_translate+0xbe/0x140
[   36.209420]  [<784f2183>] ata_scsi_queuecmd+0x33/0x200
[   36.214533]  [<784f2270>] ata_scsi_queuecmd+0x120/0x200
[   36.219733]  [<784ef310>] ata_scsi_rw_xlat+0x0/0x220
[   36.224672]  [<784c24a0>] scsi_done+0x0/0x20
[   36.228918]  [<784c2d22>] scsi_dispatch_cmd+0x152/0x290
[   36.234118]  [<78135c67>] trace_hardirqs_on+0x67/0xb0
[   36.239145]  [<784c8c4e>] scsi_request_fn+0x1be/0x370
[   36.244171]  [<78408096>] blk_run_queue+0x36/0x80
[   36.248850]  [<784c7530>] scsi_next_command+0x30/0x50
[   36.253877]  [<784c76bb>] scsi_end_request+0xab/0xe0
[   36.258817]  [<784c83c9>] scsi_io_completion+0xa9/0x3d0
[   36.264016]  [<78135c67>] trace_hardirqs_on+0x67/0xb0
[   36.269043]  [<78405125>] blk_done_softirq+0x45/0x80
[   36.273983]  [<78405153>] blk_done_softirq+0x73/0x80
[   36.278922]  [<7811d4c3>] __do_softirq+0x53/0xb0
[   36.283515]  [<7811d588>] do_softirq+0x68/0x70
[   36.287935]  [<78105351>] do_IRQ+0x51/0x90
[   36.292008]  [<78135c9c>] trace_hardirqs_on+0x9c/0xb0
[   36.297034]  [<7810388e>] common_interrupt+0x2e/0x40
[   36.301974]  [<78100c55>] cpu_idle+0x35/0x60
[   36.306220]  [<78a14b35>] start_kernel+0x265/0x300
[   36.310987]  [<78a14380>] unknown_bootoption+0x0/0x1e0
[   36.316100]  =======================
[   36.319653] Code: 84 d9 01 00 00 7e 32 31 d2 89 f6 8b 1c 24 83 c2 01 8b 03 2b 05 f8 ec d7 78 c1 f8 05 c1 e0 0c 03 43 04 89 43 08 83 c3 10 89 1c 24 <8b> 03 a8 01 0f 85 58 02 00 00 39 ca 75 d2 f0 83 44 24 00 00 85 
[   36.338458] EIP: [<784e9490>] ata_qc_issue+0xd0/0x340 SS:ESP 0068:78a13e28
[   36.345305] Kernel panic - not syncing: Fatal exception in interrupt
