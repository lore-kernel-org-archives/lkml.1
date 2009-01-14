Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbZANVCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbZANVCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbZANVB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:01:58 -0500
Received: from sov-mail-b0012.gradwell.net ([193.84.87.36]:47470 "EHLO
	sov-mail-b0012.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136AbZANVB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:01:56 -0500
Date: Wed, 14 Jan 2009 21:01:43 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.27 BUG at fs/inode.c:263 with ext4
Message-ID: <20090114210143.39e27168@lithium.local.net>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been testing ext4 with some spare disks, tonight I created an ext4fs on a USB 60GB hard disk, and backed up my /home partition onto it with rsync. 

After umounting the device, and switching off the USB connection I got the following in my /var/log/messages. 

What would this suggest? I'd be happy to supply further information if required.

Regards,
Alex

Jan 14 20:14:19 lithium EXT4 FS on sda1, internal journal
Jan 14 20:14:19 lithium EXT4-fs: delayed allocation enabled
Jan 14 20:14:19 lithium EXT4-fs: file extents enabled
Jan 14 20:14:19 lithium EXT4-fs: mballoc enabled
Jan 14 20:14:19 lithium EXT4-fs: mounted filesystem with ordered data mode.
Jan 14 20:47:32 lithium EXT4-fs: mballoc: 9053696 blocks 72969 reqs (53856 success)
Jan 14 20:47:32 lithium EXT4-fs: mballoc: 23317 extents scanned, 5142 goal hits, 17233 2^N hits, 0 breaks, 0 lost
Jan 14 20:47:32 lithium EXT4-fs: mballoc: 1537 generated and it took 45287170
Jan 14 20:47:32 lithium EXT4-fs: mballoc: 4994032 preallocated, 1321049 discarded
Jan 14 20:50:00 lithium usb 1-3.4.3: USB disconnect, address 9
Jan 14 20:50:00 lithium ------------[ cut here ]------------
Jan 14 20:50:00 lithium kernel BUG at fs/inode.c:263!
Jan 14 20:50:00 lithium invalid opcode: 0000 [#1] PREEMPT SMP 
Jan 14 20:50:00 lithium Modules linked in: vmnet vmblock vmci vmmon ipv6 ipt_LOG xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack xt_multiport iptable_filter ip_tables x_tables snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ppdev parport_pc lp parport ide_scsi arc4 ecb crypto_blkcipher b43 pcmcia snd_intel8x0 snd_ac97_codec mac80211 b44 cfg80211 ac97_bus nvidia(P) snd_pcm yenta_socket mii snd_timer rtc rsrc_nonstatic ssb snd video pcspkr pcmcia_core snd_page_alloc backlight i2c_core output rng_core thermal button ac battery processor intel_agp agpgart joydev dcdbas tg3 libphy e1000 nfs lockd sunrpc raid10 raid1 raid0 md_mod dm_snapshot dm_mirror dm_log dm_mod sbp2 ohci1394 ieee1394 sl811_hcd usbhid ff_memless ohci_hcd uhci_hcd usb_storage ehci_hcd usbcore lpfc scsi_transport_fc megaraid_mbox megaraid_mm aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx atp870u dc395x sim710 53c700 qla1280 dmx3191d sym53c8xx qlogicfas408 gdth aha1740 initio BusLogic aic7xxx aic79xx scsi_transport_spi sg videobuf_core scsi_wait_scan [last unloaded: aoe]
Jan 14 20:50:00 lithium 
Jan 14 20:50:00 lithium Pid: 10905, comm: udevd Tainted: P          (2.6.27-gentoo-r7 #1)
Jan 14 20:50:00 lithium EIP: 0060:[<c016b5b0>] EFLAGS: 00010286 CPU: 0
Jan 14 20:50:00 lithium EIP is at clear_inode+0x11/0xb3
Jan 14 20:50:00 lithium EAX: f2ef393c EBX: f2ef383c ECX: e0fca000 EDX: f2ef383c
Jan 14 20:50:00 lithium ESI: f2ef383c EDI: 00000000 EBP: e0fca000 ESP: e0fcaf38
Jan 14 20:50:00 lithium DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jan 14 20:50:00 lithium Process udevd (pid: 10905, ti=e0fca000 task=f2d37b30 task.ti=e0fca000)
Jan 14 20:50:00 lithium Stack: c0157c55 c016b6e3 f2ef383c f5de2e14 c016ae1d f2ef383c c0163a44 f781b280 
Jan 14 20:50:00 lithium f5de0d14 0c60e59f 00000010 d155d047 00000010 00000000 00000000 00000000 
Jan 14 20:50:00 lithium caa1b380 f591dc50 b7e5c3d0 f2d37b30 caa1b3b4 c0112ace 00000000 00000004 
Jan 14 20:50:00 lithium Call Trace:
Jan 14 20:50:00 lithium [<c0157c55>] shmem_delete_inode+0x0/0xae
Jan 14 20:50:00 lithium [<c016b6e3>] generic_delete_inode+0x91/0xf9
Jan 14 20:50:00 lithium [<c016ae1d>] iput+0x48/0x4a
Jan 14 20:50:00 lithium [<c0163a44>] do_unlinkat+0xb0/0x11f
Jan 14 20:50:00 lithium [<c0112ace>] do_page_fault+0x23c/0x54a
Jan 14 20:50:00 lithium [<c0102cb1>] sysenter_do_call+0x12/0x25
Jan 14 20:50:00 lithium =======================
Jan 14 20:50:00 lithium Code: 11 b8 80 ed 50 c0 e8 70 87 23 00 89 d8 e8 62 fb ff ff 5a 89 f0 5b 5e 5f 5d c3 53 89 c3 e8 6a e3 00 00 83 bb e8 00 00 00 00 74 04 <0f> 0b eb fe 8b 83 54 01 00 00 a8 20 75 04 0f 0b eb fe a8 40 74 
Jan 14 20:50:00 lithium EIP: [<c016b5b0>] clear_inode+0x11/0xb3 SS:ESP 0068:e0fcaf38
Jan 14 20:50:00 lithium ---[ end trace 7c79a1ffceea0861 ]---

-- 
http://www.munted.org.uk

Fearsome grindings.
