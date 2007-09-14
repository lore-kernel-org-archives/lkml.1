Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbXINLGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbXINLGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 07:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbXINLGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 07:06:15 -0400
Received: from brick.kernel.dk ([87.55.233.238]:12560 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352AbXINLGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 07:06:14 -0400
Date: Fri, 14 Sep 2007 13:06:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Osterlund <petero2@telia.com>
Subject: Re: 2.6.23-rc4-mm1: git-block.patch broke pktcdvd
Message-ID: <20070914110606.GJ25592@kernel.dk>
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <46E5A6D1.3050704@free.fr> <46E9BEB1.3060504@free.fr> <20070914093358.GB25592@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070914093358.GB25592@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14 2007, Jens Axboe wrote:
> On Fri, Sep 14 2007, Laurent Riffard wrote:
> > Le 10.09.2007 22:19, Laurent Riffard a écrit :
> > > Le 01.09.2007 06:58, Andrew Morton a écrit :
> > >> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/
> > > [...]
> > > 
> > > Jens,
> > > 
> > > git-block.patch broke pktcdvd, I've got an Oops while syncing:
> > > 
> > >>  [  713.014888] pktcdvd: Fixed packets, 16 blocks, Mode-1 disc
> > >>  [  713.021844] pktcdvd: write speed 2770kB/s
> > >>  [  718.401761] pktcdvd: 4595774kB available on disc
> > >>  [  721.175644] UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'LinuxUDF', timestamp 2006/10/08 21:17 (1078)
> > >>  [  721.213784] mount used greatest stack depth: 460 bytes left
> > >>  [  752.634402] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
> > >>  [  752.635711] printing eip: c017b69e *pde = 00000000 
> > >>  [  752.636983] Oops: 0002 [#1] PREEMPT 
> > >>  [  752.638240] last sysfs file: /devices/pci0000:00/0000:00:0d.0/modalias
> > >>  [  752.639477] Modules linked in: udf binfmt_misc pktcdvd radeon drm lp nls_iso8859_1 nls_cp850 vfat fat reiser4 lzo_decompress lzo_compress eeprom w83781d hwmon_vid snd_ens1371 gameport snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm sg firewire_ohci firewire_core sr_mod cdrom crc_itu_t snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd 8250_pnp i2c_viapro via_agp floppy ohci1394 soundcore 8250 serial_core ata_generic uhci_hcd agpgart ne2k_pci 8390 ieee1394 snd_page_alloc rtc pcspkr via686a usbcore parport_pc parport evdev reiserfs sd_mod pata_via libata scsi_mod dm_mirror dm_mod
> > >>  [  752.645759] 
> > >>  [  752.646990] Pid: 3403, comm: pktcdvd0 Not tainted (2.6.23-rc4-mm1 #50)
> > >>  [  752.648256] EIP: 0060:[__bio_add_page+212/355] EFLAGS: 00010246 CPU: 0
> > >>  [  752.649515] EIP is at __bio_add_page+0xd4/0x163
> > >>  [  752.650750] EAX: 00000000 EBX: 00000000 ECX: c26ca400 EDX: 00000000
> > >>  [  752.651984] ESI: cba3cf48 EDI: c1174be0 EBP: cb01cef4 ESP: cb01cee4
> > >>  [  752.653219]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> > >>  [  752.654446] Process pktcdvd0 (pid: 3403, ti=cb01c000 task=c1b9cdb0 task.ti=cb01c000)
> > >>  [  752.654526] Stack: c26ca400 cba3cf48 c1174be0 00000001 cb01cf10 c017b763 00000800 00000800 
> > >>  [  752.655908]        00000040 cba3cf48 cb06e120 cb01cfd0 e1d94044 00000800 00000004 cb09b8a0 
> > >>  [  752.657297]        c1853ce0 00000000 00000800 00000001 00000000 00000000 00000000 00000000 
> > >>  [  752.658695] Call Trace:
> > >>  [  752.661126]  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2f
> > >>  [  752.662383]  [show_stack_log_lvl+155/163] show_stack_log_lvl+0x9b/0xa3
> > >>  [  752.663626]  [show_registers+160/482] show_registers+0xa0/0x1e2
> > >>  [  752.664868]  [die+261/567] die+0x105/0x237
> > >>  [  752.666072]  [do_page_fault+1127/1349] do_page_fault+0x467/0x545
> > >>  [  752.667274]  [error_code+106/112] error_code+0x6a/0x70
> > >>  [  752.668477]  [bio_add_page+54/61] bio_add_page+0x36/0x3d
> > >>  [  752.669669]  [<e1d94044>] kcdrwd+0x5a5/0x9ba [pktcdvd]
> > >>  [  752.670856]  [kthread+57/97] kthread+0x39/0x61
> > >>  [  752.672024]  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
> > >>  [  752.673197]  =======================
> > >>  [  752.674336] Code: ba 01 00 00 00 8b 4d f0 8b 46 18 66 3b 81 50 01 00 00 73 da 66 8b 46 1a 66 3b 81 52 01 00 00 73 cd 0f 
> > >> b7 46 14 6b d8 0c 03 5e 2c <89> 3b 8b 45 08 89 43 04 8b 4d 0c 89 4b 08 8b 45 f0 8b 78 68 85 
> > >>  [  752.677879] EIP: [__bio_add_page+212/355] __bio_add_page+0xd4/0x163 SS:ESP 0068:cb01cee4
> > 
> > I dig through git-block.patch and the culprit seems to be commit
> > c94f1c4ac87862675c8d70941973bc3a69aff5d8 "bio: use memset() in
> > bio_init()".
> > 
> > Maybe the real bug is a bad bio initialization in pktcdvd driver,
> > which is revealed by this commit ?
> 
> At least pktcdvd doesn't expect bio->bi_io_vec[] to be cleared, that's
> why it's oopsing now. I'll revert this bit for now, thanks for the
> report.

Rethinking this, I think bio_init() is doing the right thing, only
pktcdvd seems to rely on it preserving some members. So I'd rather fixup
pktcdvd instead.

Does this work for you?

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index fadbfd8..98343a1 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1142,16 +1142,20 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 	 * Schedule reads for missing parts of the packet.
 	 */
 	for (f = 0; f < pkt->frames; f++) {
+		struct bio_vec *vec;
+
 		int p, offset;
 		if (written[f])
 			continue;
 		bio = pkt->r_bios[f];
+		vec = bio->bi_io_vec;
 		bio_init(bio);
 		bio->bi_max_vecs = 1;
 		bio->bi_sector = pkt->sector + f * (CD_FRAMESIZE >> 9);
 		bio->bi_bdev = pd->bdev;
 		bio->bi_end_io = pkt_end_io_read;
 		bio->bi_private = pkt;
+		bio->bi_io_vec = vec;
 
 		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
 		offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
@@ -1448,6 +1452,7 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 	pkt->w_bio->bi_bdev = pd->bdev;
 	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
 	pkt->w_bio->bi_private = pkt;
+	pkt->w_bio->bi_io_vec = bvec;
 	for (f = 0; f < pkt->frames; f++)
 		if (!bio_add_page(pkt->w_bio, bvec[f].bv_page, CD_FRAMESIZE, bvec[f].bv_offset))
 			BUG();

-- 
Jens Axboe

