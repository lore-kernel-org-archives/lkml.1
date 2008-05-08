Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbYEHSwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbYEHSwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760178AbYEHSw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:52:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:60958 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbYEHSwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:52:23 -0400
Date: Thu, 8 May 2008 20:52:21 +0200
From: Jan Kara <jack@suse.cz>
To: Yan Seiner <yan@seiner.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kenrel oops
Message-ID: <20080508185221.GA4090@atrey.karlin.mff.cuni.cz>
References: <4814DBFA.2070901@seiner.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4814DBFA.2070901@seiner.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I just had this kernel oops.  Approximately 5 mintes later, the machine 
> hard-locked.  Can anyone give me some guidance on where to look?
  Any chance of reproducing this without the NVidia module? It looks
like filp->f_op->flush contained an invalid pointer (although
ffff81007e3d1300 doesn't look completely insane but more like a pointer
to data than to a function). Weren't you playing with rmmod before this
happened?
 
> Apr 27 12:05:19 selene kernel: Unable to handle kernel paging request at 
> ffff81007e3d1300 RIP:
> Apr 27 12:05:19 selene kernel:  [<ffff81007e3d1300>]
> Apr 27 12:05:19 selene kernel: PGD 8063 PUD a063 PMD 800000007e2001e3
> Apr 27 12:05:19 selene kernel: Oops: 0011 [1] SMP
> Apr 27 12:05:19 selene kernel: CPU 1
> Apr 27 12:05:19 selene kernel: Modules linked in: nls_iso8859_1 
> nls_cp437 vfat fat usb_storage tcp_diag inet_diag nvidia(P) xt_m
> ultiport iptable_filter ip_tables x_tables nfsd auth_rpcgss exportfs 
> ppdev lp ac battery autofs4 tun cpufreq_ondemand cpufreq_us
> erspace cpufreq_conservative cpufreq_powersave cpufreq_stats freq_table 
> nfs lockd nfs_acl sunrpc bonding fuse loop firewire_sbp2
> dvb_pll or51132 firmware_class cx88_dvb cx88_vp3054_i2c videobuf_dvb 
> dvb_core tuner tea5767 tda8290 tuner_simple mt20xx tea5761
> cx88_alsa cx8802 snd_usb_audio cx8800 cx88xx snd_usb_lib ir_common 
> i2c_algo_bit snd_seq_dummy tveeprom snd_hda_intel serio_raw
> snd_seq_oss videodev parport_pc parport snd_seq_midi snd_seq_midi_event 
> psmouse pcspkr v4l1_compat compat_ioctl32 v4l2_common sn
> d_pcm_oss snd_mixer_oss snd_seq k8temp videobuf_dma_sg videobuf_core 
> btcx_risc snd_pcm usblp snd_timer snd_page_alloc snd_rawmid
> i snd_seq_device shpchp snd_hwdep pci_hotplug snd soundcore i2c_nforce2 
> i2c_core button joydev evdev ext3 jbd mbcache raid456 as
> yn
> Apr 27 12:05:19 selene kernel: _xor async_memcpy async_tx xor raid1 
> raid0 md_mod osst st sd_mod sata_nv usbhid hid ata_generic l
> ibata floppy firewire_ohci firewire_core crc_itu_t aic79xx 
> scsi_transport_spi scsi_mod forcedeth generic amd74xx ide_core ehci_h
> cd ohci_hcd thermal processor fan
> Apr 27 12:05:19 selene kernel: Pid: 32309, comm: configure_head. 
> Tainted: P        2.6.24-1-amd64 #1
> Apr 27 12:05:19 selene kernel: RIP: 0010:[<ffff81007e3d1300>]  
> [<ffff81007e3d1300>]
> Apr 27 12:05:19 selene kernel: RSP: 0018:ffff81007ada3ec0  EFLAGS: 00010286
> Apr 27 12:05:19 selene kernel: RAX: ffff81007e3d1300 RBX: 
> ffff810026ec0050 RCX: ffff81007df37980
> Apr 27 12:05:19 selene kernel: RDX: 0000000000000008 RSI: 
> ffff81007195ac80 RDI: ffff810026ec0050
> Apr 27 12:05:19 selene kernel: RBP: ffff81007195ac80 R08: 
> ffff81003b4403f0 R09: ffff810001018700
> Apr 27 12:05:19 selene kernel: R10: ffff810076d9c858 R11: 
> ffffffff802ea95d R12: 0000000000001018
> Apr 27 12:05:19 selene kernel: R13: ffff8100049344c0 R14: 
> 0000000000000200 R15: 0000000000000008
> Apr 27 12:05:19 selene kernel: FS:  00002b9d5dd5fdc0(0000) 
> GS:ffff81007df98ac0(0000) knlGS:00000000f7e4d6b0
> Apr 27 12:05:19 selene kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
> 000000008005003b
> Apr 27 12:05:19 selene kernel: CR2: ffff81007e3d1300 CR3: 
> 0000000000201000 CR4: 00000000000006e0
> Apr 27 12:05:19 selene kernel: DR0: 0000000000000000 DR1: 
> 0000000000000000 DR2: 0000000000000000
> Apr 27 12:05:19 selene kernel: DR3: 0000000000000000 DR6: 
> 00000000ffff0ff0 DR7: 0000000000000400
> Apr 27 12:05:19 selene kernel: Process configure_head. (pid: 32309, 
> threadinfo ffff81007ada2000, task ffff81007706c000)
> Apr 27 12:05:19 selene kernel: Stack:  ffffffff8029680d ffff81007195ac80 
> 1ffff020056f3c8f 0000000000001018
> Apr 27 12:05:19 selene kernel:  ffffffff802377a0 ffff810074155140 
> 0000000000000001 ffff81007706c000
> Apr 27 12:05:19 selene kernel:  0000000000000000 0000000000000000 
> 00000000006dae08 0000000000000000
> Apr 27 12:05:19 selene kernel: Call Trace:
> Apr 27 12:05:19 selene kernel:  [<ffffffff8029680d>] filp_close+0x37/0x65
> Apr 27 12:05:19 selene kernel:  [<ffffffff802377a0>] 
> put_files_struct+0x66/0xc4
> Apr 27 12:05:19 selene kernel:  [<ffffffff80238a6a>] do_exit+0x278/0x789
> Apr 27 12:05:19 selene kernel:  [<ffffffff80238ffa>] sys_exit_group+0x0/0xe
> Apr 27 12:05:19 selene kernel:  [<ffffffff8020be2e>] system_call+0x7e/0x83
> Apr 27 12:05:19 selene kernel:
> Apr 27 12:05:19 selene kernel:
> Apr 27 12:05:19 selene kernel: Code: b8 75 ac 7e 00 81 ff ff a8 74 69 7e 
> 00 81 ff ff 60 00 00 00
> Apr 27 12:05:19 selene kernel: RIP  [<ffff81007e3d1300>]
> Apr 27 12:05:19 selene kernel:  RSP <ffff81007ada3ec0>
> Apr 27 12:05:19 selene kernel: CR2: ffff81007e3d1300
> Apr 27 12:05:19 selene kernel: ---[ end trace d1960b80aa7bb270 ]---
> Apr 27 12:05:19 selene kernel: Fixing recursive fault but reboot is needed!

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
