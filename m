Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbXJDHXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbXJDHXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 03:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXJDHXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 03:23:41 -0400
Received: from brick.kernel.dk ([87.55.233.238]:4844 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbXJDHXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 03:23:40 -0400
Date: Thu, 4 Oct 2007 09:25:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Don Mullis <dwm@meer.net>, linux-kernel@vger.kernel.org, drzeus@drzeus.cx
Subject: Re: 2.6.23-rc8-mm2: OOPS in mmc on boot
Message-ID: <20071004072515.GC5236@kernel.dk>
References: <1191478262.21598.5.camel@dmullis-laptop> <20071003231659.f41df5ed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003231659.f41df5ed.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03 2007, Andrew Morton wrote:
> On Wed, 03 Oct 2007 23:11:02 -0700 Don Mullis <dwm@meer.net> wrote:
> 
> > OOPS followed by a 3 minute timeout, then completion of boot.
> > Not seen if card (Kingston microSD adapter) is ejected; not seen in 2.6.23-rc8.
> > Running on a Dell XPS M1330 laptop.
> > 
> > `dmesg` reports:
> > 
> > [   13.695045] mmcblk0: mmc0:e95c SD02G 1966080KiB
> > [   13.695155]  mmcblk0: p1
> > [   13.706907] BUG: unable to handle kernel paging request at virtual address 6b6b6b7a
> > [   13.707026] printing eip: c01f09f0 *pde = 00000000
> > [   13.707174] Oops: 0000 [#1] SMP
> > [   13.707326] last sysfs file: /class/mmc_host/mmc0/mmc0:e95c/serial
> > [   13.707389] Modules linked in: mmc_block sr_mod iwl4965 cdrom serio_raw mac80211 piix sdhci pcspkr psmouse ide_core iTCO_wdt iTCO_vendor_support watchdog_core watchdog_dev cfg80211 mmc_core shpchp pci_hotplug intel_agp agpgart battery ac power_supply button evdev ata_generic ext3 jbd mbcache sg sd_mod usbhid hid ahci ata_piix libata scsi_mod ohci1394 tg3 ieee1394 ehci_hcd uhci_hcd thermal processor fan fuse
> > [   13.709649]
> > [   13.709705] Pid: 4089, comm: mmcqd Not tainted (2.6.23-rc8-mm2 #27)
> > [   13.709767] EIP: 0060:[<c01f09f0>] EFLAGS: 00010206 CPU: 0
> > [   13.709831] EIP is at blk_rq_map_sg+0xc0/0x160
> > [   13.709889] EAX: 04b6a000 EBX: c4a030e0 ECX: 04b6b000 EDX: c1000000
> > [   13.709951] ESI: 6b6b6b6a EDI: c11535d0 EBP: c4971e30 ESP: c4971df4
> > [   13.710013]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > [   13.710074] Process mmcqd (pid: 4089, ti=c4970000 task=c387b660 task.ti=c4970000)
> > [   13.710137] last branch before last exception/interrupt
> > [   13.710249]  from c0129bf8 (vprintk+0x1d8/0x340)
> > [   13.710359]  to c0129c9c (vprintk+0x27c/0x340)
> > [   13.710453] Stack: c4971e08 c013d85f c48a0440 00002000 04b6c000 c3914180 00000001 00000001
> > [   13.710920]        00001000 00000000 c4923700 01000000 c48ca3a0 c48f6d88 c48f6d88 c4971e40
> > [   13.711390]        f8c39e58 c48f6d88 c4a9f020 c4971fbc f8c396c9 c017de04 00000004 c4971e84
> > [   13.711857] Call Trace:
> > [   13.711971]  [<f8c39e58>] mmc_queue_map_sg+0x28/0xc0 [mmc_block]
> > [   13.712085]  [<f8c396c9>] mmc_blk_issue_rq+0x199/0x780 [mmc_block]
> > [   13.712193]  [<f8c3a168>] mmc_queue_thread+0x78/0xe0 [mmc_block]
> > [   13.712309]  [<c013d382>] kthread+0x42/0x70
> > [   13.712415]  [<c0104e73>] kernel_thread_helper+0x7/0x14
> > [   13.712523]  =======================
> > [   13.712584] Code: 0c 03 4f 08 8b 7f 04 01 cf 89 7d d4 8b 3b 89 f8 29 d0 c1 f8 03 69 c0 39 8e e3 38 c1 e0 0c 03 43 08 39 45 d4 74 73 90 8d 74 26 00 <8b> 46 10 8d 4e 10 89 3e 89 c2 83 e2 fe a8 01 8b 45 e4 0f 45 ca
> > [   13.715555] EIP: [<c01f09f0>] blk_rq_map_sg+0xc0/0x160 SS:ESP 0068:c4971df4
> > [   13.845668] Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1c0b1, caps: 0xa04753/0x200000
> > [   13.879914] input: SynPS/2 Synaptics TouchPad as /class/input/input7
> > [  192.162711] Adding 2731008k swap on /dev/sda7.  Priority:-1 extents:1 across:2731008k
> 
> This could be due to git-block changes (or a lack of them ;))

It looks like missing init of the sg list in mmc, does this work?

--- linux-2.6.23-rc8/drivers/mmc/card/queue.c~	2007-10-04 09:22:02.000000000 +0200
+++ linux-2.6.23-rc8/drivers/mmc/card/queue.c	2007-10-04 09:23:13.000000000 +0200
@@ -334,14 +334,18 @@ static void copy_sg(struct scatterlist *
 
 unsigned int mmc_queue_map_sg(struct mmc_queue *mq)
 {
+	struct request *rq = mq->req;
 	unsigned int sg_len;
 
-	if (!mq->bounce_buf)
-		return blk_rq_map_sg(mq->queue, mq->req, mq->sg);
+	if (!mq->bounce_buf) {
+		memset(mq->sg, 0, rq->nr_hw_segments * sizeof(struct scatterlist));
+		return blk_rq_map_sg(mq->queue, rq, mq->sg);
+	}
 
 	BUG_ON(!mq->bounce_sg);
 
-	sg_len = blk_rq_map_sg(mq->queue, mq->req, mq->bounce_sg);
+	memset(mq->bounce_sg, 0, rq->nr_hw_segments * sizeof(struct scatterlist));
+	sg_len = blk_rq_map_sg(mq->queue, rq, mq->bounce_sg);
 
 	mq->bounce_sg_len = sg_len;
 

-- 
Jens Axboe

