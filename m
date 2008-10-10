Return-Path: <linux-kernel-owner+w=401wt.eu-S1763763AbYJJUky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763763AbYJJUky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760916AbYJJUkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:40:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759200AbYJJUko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:40:44 -0400
Date: Fri, 10 Oct 2008 22:40:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [bug] latest -git boot hang
Message-ID: <20081010204015.GA15668@elte.hu>
References: <20081010203043.GA11798@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010203043.GA11798@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> with latest -git (f6bccf6), -tip testing on one of my test-boxes found 
> a boot hang.
> 
> It just hangs during fsck, "Checking filesystems", so i suspect the 
> block IO changes.

bisection ongoing. Current bisection window:

nr of bisection commits: 128
----------------------------
ad3316b: block: Find bio sector offset given idx and offset
b02739b: block: gendisk integrity wrapper
ad7fce9: block: Switch blk_integrity_compare from bdev to gendisk
0c032ab: block: Fix double put in blk_integrity_unregister
74aa8c2: block: Introduce integrity data ownership flag
b04accc: block: revert part of d7533ad0e132f92e75c1b2eb7c26387b25a583c1
8deaf72: bio.h: Remove unused conditional code
d00e29f: block: remove end_{queued|dequeued}_request()
99cd338: block: change elevator to use __blk_end_request()
7afb3a6: gdrom: change to use __blk_end_request()
2a9df50: memstick: change to use __blk_end_request()
8316982: virtio_blk: change to use __blk_end_request()
0497b34: blktrace: use BLKTRACE_BDEV_SIZE as the name size for setup structure
ef9e3fa: block: add lld busy state exporting interface
336c3d8: block: Fix blk_start_queueing() to not kick a stopped queue
c0ddffa: include blktrace_api.h in headers_install
e3ba9ae: block: reserve some tags just for sync IO
f7d7b7a: block: as/cfq ssd idle check update
8bff7c6: libata: set queue SSD flag for SSD devices
a68bbdd: block: add queue flag for SSD/non-rotational devices
9e49184: floppy: support arbitrary first-sector numbers
061837b: drivers/block: Use DIV_ROUND_UP
905bd78: cciss: Fix cciss SCSI rescan code to better notice device changes
79eb014: fix an example of scatterlists handling in DMA-API.txt
4ee5eaf: block: add a queue flag for request stacking support
82124d6: block: add request submission interface
32fab44: block: add request update interface
e3335de: block: blk_cleanup_queue() should call blk_sync_queue()
9246b5f: block: Expand Xen blkfront for > 16 xvd
9c02f2b: block: cleanup some of the integrity stuff in blkdev.h
7ba1fba: block: use rq complete marking in blk_abort_request()
581d4e2: block: add fault injection mechanism for faking request timeouts
0a0d96b: block: add bio_kmalloc()
3e6053d: block: adjust blkdev_issue_discard for swap
4677735: sg: remove unnecessary blk_rq_unmap_user
0b6cb26: sg: remove sg_read_xfer
c3919af: sg: remove sg_write_xfer
626710c: sg: incorporate sg_build_direct into sg_start_req
44c7b0e: sg: remove __sg_start_req
fd1c1de: sg: remove b_malloc_len in sg_scatter_hold struct
7e56cb0: sg: remove SG_ALLOW_DIO_CODE define
a91a3a2: sg: rename sg_cmd_done sg_rq_end_io
224cb3e: dm: Call blk_abort_queue on failed paths
11914a5: block: Add interface to abort queued requests
242f9dc: block: unify request timeout handling
608aeef: Call flush_disk() after detecting an online resize.
56ade44: Added flush_disk to factor out common buffer cache flushing code.
f98a8ca: SCSI sd driver calls revalidate_disk wrapper.
9bc3ffb: Check for device resize when rescanning partitions
c3279d1: Adjust block device size after an online resize of a disk.
0c002c2: Wrapper for lower-level revalidate_disk routines.
243294d: block: fix duplicate headers for /proc/partitions
fad7f01: sg: set dxferp to NULL for READ with the older SG interface
8188276: block: make blk_rq_map_user take a NULL user-space buffer
839e96a: block: update comment on end_request()
55dc7db: init: DEBUG_BLOCK_EXT_DEVT requires explicit root= param
2bbedcb: block: don't test for partition size in bdget_disk() and blk_lookup_devt()
759f8ca: Change default value of CONFIG_DEBUG_BLOCK_EXT_DEVT to 'n'
aeb3d3a: block: kmalloc args reversed, small function definition fixes
01cfcdd: sg: use blk_rq_aligned helper function
8790407: block: add blk_rq_aligned helper function
4d8ab62: bio: convert bio_copy_kern to use bio_copy_user
10db10d: sg: convert the indirect IO path to use the block layer
6e5a30c: sg: convert the direct IO path to use the block layer
10865df: sg: convert the non-data path to use the block layer
152e283: block: introduce struct rq_map_data to use reserved pages
a3bce90: block: add gfp_mask argument to blk_rq_map_user and blk_rq_map_user_iov
45333d5: cfq-iosched: fix queue depth detection
6054016: block: don't use bio_has_data() in the completion path
ab780f1: block: inherit CPU completion on bio->rq and rq->rq merges
c7c22e4: block: add support for IO CPU affinity
18887ad: block: make kblockd_schedule_work() take the queue as parameter
b646fc5: block: split softirq handling into blk-softirq.c
0835da6: block: use linux/uaccess.h in elevator.c instead of asm variant
3e1a7ff: block: allow disk to have extended device number
689d6fa: block: replace @ext_minors with GENHD_FL_EXT_DEVT
540eed5: block: make partition array dynamic
074a7ac: block: move stats from disk to part0
eddb2e2: block: kill GENHD_FL_FAIL and use part0->make_it_fail
0762b8b: block: always set bdev->bd_part
4c46501: block: move holder_dir from disk to part0
b7db995: block: move policy from disk to part0
e561052: block: unify sysfs size node handling
548b10e: block: move __dev from disk to part0
80795ae: block: move capacity from disk to part0
b5d0b9d: block: introduce partition 0
ed9e198: block: implement and use {disk|part}_to_dev()
870d665: block: implement CONFIG_DEBUG_BLOCK_EXT_DEVT
f615b48: sd/ide-disk: apply extended minors to sd and ide
1f01429: block: adjust formatting for large minors and add ext_range sysfs attr
bcce3de: block: implement extended dev numbers
c995905: block: fix diskstats access
e71bf0d: block: fix disk->part[] dereferencing race
f331c02: block: don't depend on consecutive minor space
cf771cb: block: make variable and argument names more consistent
310a2c1: block: misc updates
88e3412: block: update add_partition() error handling
ec2cded: block: allow deleting zero length partition
def4e38: block: use class_dev_iterator instead of class_for_each_device()
2ac3cee: block: don't grab block_class_lock unnecessarily
ac65ece: block: fix partition info printouts
5a3ceb8: driver-core: use klist for class device list and implement iterator
a1ed5b0: klist: don't iterate over deleted entries
710027a: Add some block/ source files to the kernel-api docbook. Fix kernel-doc notation in them as needed. Fix changed function parameter names. Fix typos/spellos. In comments, change REQ_SPECIAL to REQ_TYPE_SPECIAL and REQ_BLOCK_PC to REQ_TYPE_BLOCK_PC.
5b99c2f: block: make bi_phys_segments an unsigned int instead of short
960e739: block: raid fixups for removal of bi_hw_segments
5df97b9: drop vmerge accounting
b8b3e16: block: drop virtual merging accounting
6a421c1: block: update documentation for deadline fifo_batch tunable
4fb72f7: deadline-iosched: non-functional fixes
63de428: deadline-iosched: allow non-sequential batching
766ca44: virtio_blk: use a wrapper function to access io context information of IO requests
1a8e2bd: Kill REQ_TYPE_FLUSH
e17fc0a: Allow elevators to sort/merge discard requests
d30a260: Add BLKDISCARD ioctl to allow userspace to discard sectors
2ebca85: Use WRITE_BARRIER in blkdev_issue_flush(), not (1<<BIO_RW_BARRIER)
35ba8f7: blktrace: simplify flags handling in __blk_add_trace
27b29e8: blktrace: support discard requests
fdc5397: Support 'discard sectors' operation.
eae9acd: Support 'discard sectors' operation in translation layer support core
8c540a9: Let the block device know when sectors can be discarded
fb2dce8: Add 'discard' request handling
d628eae: Fix up comments about matching flags between bio and rq
3614407: highmem: use bio_has_data() in the bounce path
051cc39: block: use bio_has_data() in the IO completion path
a9c701e: block: use bio_has_data() to check for data carrying bio
7a67f63: block: add bio_has_data() to detect whether a bio carries data or not
35e396c: SG_IO block filter whitelist missing MMC SET READ AHEAD command

so definitely block IO related it appears.

	Ingo
