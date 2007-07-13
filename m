Return-Path: <linux-kernel-owner+w=401wt.eu-S935519AbXGMQut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935519AbXGMQut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 12:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935371AbXGMQuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 12:50:20 -0400
Received: from brick.kernel.dk ([80.160.20.94]:29876 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934830AbXGMQuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 12:50:18 -0400
Date: Fri, 13 Jul 2007 18:50:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Patrick McHardy <kaber@trash.net>, neilb@suse.de,
       nfs@lists.sourceforge.net,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: nfsd oops in current -git
Message-ID: <20070713165001.GV5328@kernel.dk>
References: <469780BB.3070206@trash.net> <4697A7EC.6050006@redhat.com> <20070713163337.GT5328@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713163337.GT5328@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13 2007, Jens Axboe wrote:
> On Fri, Jul 13 2007, Chuck Ebbert wrote:
> > On 07/13/2007 09:40 AM, Patrick McHardy wrote:
> > > I get this oops with current -git:
> > > 
> > > [ 3437.018862] PGD 9acab067 PUD 9acaa067 PMD 0
> > > [ 3437.018870] CPU 1
> > > [ 3437.018872] Modules linked in: nfsd exportfs ppdev lp nfs lockd
> > > nfs_acl sunrpc deflate zlib_deflate zlib_inflate twofish twofish_common
> > > camellia serpent blowfish des cbc ecb blkcipher aes xcbc sha256
> > > crypto_null af_key rfcomm l2cap fuse nfnetlink_queue nfnetlink_log
> > > nf_conntrack_netlink nf_nat nf_conntrack_ipv6 nf_conntrack_ipv4
> > > nf_conntrack nfnetlink ip6_tables ip_tables x_tables hangcheck_timer
> > > cpufreq_ondemand powernow_k8 freq_table video backlight thermal
> > > processor fan ide_generic ide_disk ide_cd cdrom generic hci_usb
> > > bluetooth usbhid hid snd_via82xx snd_seq_dummy snd_seq_oss
> > > snd_via82xx_modem snd_ac97_codec ac97_bus snd_seq_midi
> > > snd_seq_midi_event snd_pcm_oss snd_mixer_oss snd_mpu401 snd_pcm
> > > snd_mpu401_uart snd_seq snd_timer snd_rawmidi snd_seq_device parport_pc
> > > snd psmouse parport via82cxxx serio_raw i2c_viapro evdev ehci_hcd sky2
> > > snd_page_alloc uhci_hcd ide_core soundcore pcspkr
> > > [ 3437.018923] Pid: 4432, comm: nfsd Not tainted 2.6.22 #5
> > > [ 3437.018926] RIP: 0010:[<ffffffff81054eff>]  [<ffffffff81054eff>]
> > > put_page+0x4/0xb3
> > > [ 3437.018932] RSP: 0018:ffff8101335f5c40  EFLAGS: 00010203
> > > [ 3437.018935] RAX: 0000000000000000 RBX: ffff810133576000 RCX:
> > > ffff8100a0fa5ab8
> > > [ 3437.018938] RDX: ffff810003754428 RSI: ffff8100a0fa5868 RDI:
> > > 0000000000000000
> > > [ 3437.018942] RBP: ffff810003754428 R08: ffff8100a1b7c5d8 R09:
> > > ffff8101335f5c10
> > > [ 3437.018946] R10: ffff810003739a78 R11: ffff81009ec61d40 R12:
> > > ffff810133576570
> > > [ 3437.018950] R13: ffff8100a0fa5868 R14: 0000000000001000 R15:
> > > ffff810133576168
> > > [ 3437.018954] FS:  00002ad8e9fab6f0(0000) GS:ffff81013fc72e40(0000)
> > > knlGS:00000000f7e426c0
> > > [ 3437.018957] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > [ 3437.018959] CR2: 0000000000000000 CR3: 000000009a91a000 CR4:
> > > 00000000000006e0
> > > [ 3437.018963] Process nfsd (pid: 4432, threadinfo ffff8101335f4000,
> > > task ffff81013f969040)
> > > [ 3437.018965] Stack:  ffff810133576000 ffff810003754428
> > > ffff810133576570 ffffffff8830e001
> > > [ 3437.018973]  ffff810003747500 ffff8100a0fa5868 ffff8100a0fa5800
> > > ffff8101335f5d80
> > > [ 3437.018978]  0000000000000000 0000000000000000 ffffffff8122c440
> > > ffffffff810892ac
> > > [ 3437.018982] Call Trace:
> > > [ 3437.019002]  [<ffffffff8830e001>] :nfsd:nfsd_splice_actor+0x71/0xea
> > > [ 3437.019010]  [<ffffffff810892ac>] __splice_from_pipe+0x58/0x1bf
> > > [ 3437.019023]  [<ffffffff8830df90>] :nfsd:nfsd_splice_actor+0x0/0xea
> > > [ 3437.019040]  [<ffffffff8830d326>]
> > > :nfsd:nfsd_direct_splice_actor+0x10/0x12
> > > [ 3437.019044]  [<ffffffff81088efc>] splice_direct_to_actor+0xfd/0x19d
> > > [ 3437.019058]  [<ffffffff8830d316>] :nfsd:nfsd_direct_splice_actor+0x0/0x12
> > > [ 3437.019076]  [<ffffffff8830d1f4>] :nfsd:nfsd_vfs_read+0x22b/0x34d
> > > [ 3437.019098]  [<ffffffff8830d715>] :nfsd:nfsd_read+0xa7/0xc4
> > > [ 3437.019117]  [<ffffffff88314539>] :nfsd:nfsd3_proc_read+0x117/0x15a
> > > [ 3437.019133]  [<ffffffff8830924d>] :nfsd:nfsd_dispatch+0xdd/0x19e
> > > [ 3437.019156]  [<ffffffff88280194>] :sunrpc:svc_process+0x3f3/0x703
> > > [ 3437.019164]  [<ffffffff81212423>] __lock_text_start+0x23/0x7e
> > > [ 3437.019180]  [<ffffffff88309817>] :nfsd:nfsd+0x193/0x2b0
> > > [ 3437.019188]  [<ffffffff8100a9c8>] child_rip+0xa/0x12
> > > [ 3437.019207]  [<ffffffff88309684>] :nfsd:nfsd+0x0/0x2b0
> > > [ 3437.019212]  [<ffffffff8100a9be>] child_rip+0x0/0x12
> > 
> > Does Jens's patch fix it?
> > 
> > http://marc.info/?l=linux-netdev&m=118432481101579&q=raw
> 
> Probably not, that's for another bug. I'll try and see if I can take a
> look tonight.

Patrick, does this work?

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 8604e35..945b1ce 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -879,6 +879,7 @@ nfsd_vfs_read(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 			.u.data		= rqstp,
 		};
 
+		rqstp->rq_resused = 1;
 		host_err = splice_direct_to_actor(file, &sd, nfsd_direct_splice_actor);
 	} else {
 		oldfs = get_fs();

-- 
Jens Axboe

