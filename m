Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZG1HHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZG1HHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 03:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZG1HHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 03:07:13 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47871 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbZG1HHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 03:07:12 -0400
Date: Tue, 28 Jul 2009 09:07:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jens Rosenboom <jens@mcbone.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops when writing to /sys/block/ram0/queue/max_sectors_kb
Message-ID: <20090728070711.GN4148@kernel.dk>
References: <1248363032.7237.48.camel@fnki-nb00130>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248363032.7237.48.camel@fnki-nb00130>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23 2009, Jens Rosenboom wrote:
> Even when writing the current value again, I get this Oops and further
> reads from that file stall.
> 
> # cat /sys/block/ram0/queue/max_sectors_kb 
> 512
> # echo 512 >/sys/block/ram0/queue/max_sectors_kb
> [Produces an Oops and connection closes]
> [After logging in again:]
> # cat /sys/block/ram0/queue/max_sectors_kb
> [hangs]
> 
> Corresponding output from dmesg:
> 
> [ 1254.984435] BUG: unable to handle kernel NULL pointer dereference at
> (null)
> [ 1254.988005] IP: [<c12a1550>] _spin_lock_irq+0x10/0x30
> [ 1254.988005] *pde = 00000000 
> [ 1254.988005] Oops: 0002 [#1] SMP 
> [ 1254.988005] last sysfs
> file: /sys/devices/virtual/block/ram0/queue/max_sectors_kb
> [ 1254.988005] Modules linked in: ipv6 af_packet usbhid hid uhci_hcd
> ohci_hcd ehci_hcd usbcore 8021q garp stp serio_raw psmouse evdev
> i2c_piix4 button container pcspkr processor i2c_core ext3 jbd mbcache
> dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid10 raid456
> raid6_pq async_xor async_memcpy async_tx xor raid1 raid0 multipath
> linear md_mod sg sr_mod cdrom ata_generic pata_acpi pata_serverworks
> megaraid libata floppy e100 mii scsi_mod cpqarray thermal fan
> [ 1254.988005] 
> [ 1254.988005] Pid: 3822, comm: bash Not tainted (2.6.31-rc4 #3)
> ProLiant DL360
> [ 1254.988005] EIP: 0060:[<c12a1550>] EFLAGS: 00010012 CPU: 0
> [ 1254.988005] EIP is at _spin_lock_irq+0x10/0x30
> [ 1254.988005] EAX: 00000100 EBX: 00000004 ECX: c379e003 EDX: 00000000
> [ 1254.988005] ESI: 00000200 EDI: f6bb0000 EBP: c3605f00 ESP: c3605f00
> [ 1254.988005]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ 1254.988005] Process bash (pid: 3822, ti=c3604000 task=f6bde800
> task.ti=c3604000)
> [ 1254.988005] Stack:
> [ 1254.988005]  c3605f1c c115d93b 00000004 c379e003 f6bb0000 f6bb0470
> c13ca238 c3605f34
> [ 1254.988005] <0> c115d9a7 c379e000 f707c7e0 c13ca1ac f69bf5c0 c3605f64
> c111408d 00000004
> [ 1254.988005] <0> 00000004 08e99408 f6976480 f69bf5d4 c13ca1ac f6bb0148
> f6976480 08e99408
> [ 1254.988005] Call Trace:
> [ 1254.988005]  [<c115d93b>] ? queue_max_sectors_store+0x5b/0x80
> [ 1254.988005]  [<c115d9a7>] ? queue_attr_store+0x47/0x70
> [ 1254.988005]  [<c111408d>] ? sysfs_write_file+0x9d/0xf0
> [ 1254.988005]  [<c10c889c>] ? vfs_write+0x9c/0x180
> [ 1254.988005]  [<c1113ff0>] ? sysfs_write_file+0x0/0xf0
> [ 1254.988005]  [<c10c8a3d>] ? sys_write+0x3d/0x70
> [ 1254.988005]  [<c1003049>] ? syscall_call+0x7/0xb
> [ 1254.988005] Code: 01 00 00 f0 66 0f c1 02 38 e0 74 06 f3 90 8a 02 eb
> f6 89 c8 5d c3 90 8d 74 26 00 55 89 c2 89 e5 fa 90 8d 74 26 00 b8 00 01
> 00 00 <f0> 66 0f c1 02 38 e0 74 06 f3 90 8a 02 eb f6 5d c3 eb 0d 90 90 
> [ 1254.988005] EIP: [<c12a1550>] _spin_lock_irq+0x10/0x30 SS:ESP
> 0068:c3605f00
> [ 1254.988005] CR2: 0000000000000000
> [ 1254.988005] ---[ end trace ee0e56d1adcbecab ]---

Looks like this will hit nonrot/merge/etc store functions after we
exposed these sysfs knobs for non-request_fn drivers too. Can you try
the below? Should fix all of them up.

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b45435..a0c340d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -575,13 +575,6 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 		return NULL;
 	}
 
-	/*
-	 * if caller didn't supply a lock, they get per-queue locking with
-	 * our embedded lock
-	 */
-	if (!lock)
-		lock = &q->__queue_lock;
-
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
 	q->unplug_fn		= generic_unplug_device;
diff --git a/block/blk-settings.c b/block/blk-settings.c
index bd582a7..8a3ea3b 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -165,6 +165,13 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	blk_set_default_limits(&q->limits);
 
 	/*
+	 * If the caller didn't supply a lock, fall back to our embedded
+	 * per-queue locks
+	 */
+	if (!q->queue_lock)
+		q->queue_lock = &q->__queue_lock;
+
+	/*
 	 * by default assume old behaviour and bounce for any highmem page
 	 */
 	blk_queue_bounce_limit(q, BLK_BOUNCE_HIGH);

-- 
Jens Axboe

