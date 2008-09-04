Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbYIDKPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbYIDKPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 06:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYIDKPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 06:15:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44908 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbYIDKPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 06:15:10 -0400
Date: Thu, 4 Sep 2008 12:14:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ftrace: stack trace add indexes
Message-ID: <20080904101446.GB25428@elte.hu>
References: <alpine.DEB.1.10.0808291628530.4293@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808291628530.4293@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> This patch adds indexes into the stack that the functions in the stack 
> dump were found at. As an added bonus, I also added a diff to show 
> which function is the most notorious consumer of the stack.
> 
> The output now looks like this:
> 
> # cat /debug/tracing/stack_trace 
>         Depth   Size      Location    (48 entries)
>         -----   ----      --------
>   0)     2476     212   blk_recount_segments+0x39/0x59
>   1)     2264      12   bio_phys_segments+0x16/0x1d
>   2)     2252      20   blk_rq_bio_prep+0x23/0xaf
>   3)     2232      12   init_request_from_bio+0x74/0x77
>   4)     2220      56   __make_request+0x294/0x331
>   5)     2164     136   generic_make_request+0x34f/0x37d
>   6)     2028      56   submit_bio+0xe7/0xef
>   7)     1972      28   submit_bh+0xd1/0xf0
>   8)     1944     112   block_read_full_page+0x299/0x2a9
>   9)     1832       8   blkdev_readpage+0x14/0x16
>  10)     1824      28   read_cache_page_async+0x7e/0x109
>  11)     1796      16   read_cache_page+0x11/0x49
>  12)     1780      32   read_dev_sector+0x3c/0x72
>  13)     1748      48   read_lba+0x4d/0xaa
>  14)     1700     168   efi_partition+0x85/0x61b
>  15)     1532      72   rescan_partitions+0x10e/0x266
>  16)     1460      40   do_open+0x1c7/0x24e
>  17)     1420     292   __blkdev_get+0x79/0x84
>  18)     1128      12   blkdev_get+0x12/0x14
>  19)     1116      20   register_disk+0xd1/0x11e
>  20)     1096      28   add_disk+0x34/0x90
>  21)     1068      52   sd_probe+0x2b1/0x366
>  22)     1016      20   driver_probe_device+0xa5/0x120
>  23)      996       8   __device_attach+0xd/0xf
>  24)      988      32   bus_for_each_drv+0x3e/0x68
>  25)      956      24   device_attach+0x56/0x6c
>  26)      932      16   bus_attach_device+0x26/0x4d
>  27)      916      64   device_add+0x380/0x4b4
>  28)      852      28   scsi_sysfs_add_sdev+0xa1/0x1c9
>  29)      824     160   scsi_probe_and_add_lun+0x919/0xa2a
>  30)      664      36   __scsi_add_device+0x88/0xae
>  31)      628      44   ata_scsi_scan_host+0x9e/0x21c
>  32)      584      28   ata_host_register+0x1cb/0x1db
>  33)      556      24   ata_host_activate+0x98/0xb5
>  34)      532     192   ahci_init_one+0x9bd/0x9e9
>  35)      340      20   pci_device_probe+0x3e/0x5e
>  36)      320      20   driver_probe_device+0xa5/0x120
>  37)      300      20   __driver_attach+0x3f/0x5e
>  38)      280      36   bus_for_each_dev+0x40/0x62
>  39)      244      12   driver_attach+0x19/0x1b
>  40)      232      28   bus_add_driver+0x9c/0x1af
>  41)      204      28   driver_register+0x76/0xd2
>  42)      176      20   __pci_register_driver+0x44/0x71
>  43)      156       8   ahci_init+0x14/0x16
>  44)      148     100   _stext+0x42/0x122
>  45)       48      20   kernel_init+0x175/0x1dc
>  46)       28      28   kernel_thread_helper+0x7/0x10
> 
> 
> The first column is simply an index starting from the inner most 
> function and counting down to the outer most.
> 
> The next column is the location that the function was found on the 
> stack.
> 
> The next column is the size of the stack for that function.

applied to tip/tracing/stack-tracer, thanks Steve.

Very nice and useful output!

i'm wondering about another detail - are 'imprecise' entries properly 
excluded, if CONFIG_FRAME_POINTERS=y? In the regular oops printout they 
are included with a question mark on that line (this is a cool feature 
the stack printout code learned recently) - but for the stack footprint 
tracer it's probably a distraction.

	Ingo
