Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbZFHH2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbZFHH2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZFHH2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:28:19 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:45665 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbZFHH2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ilsrDjRRFFSLQwCMtnUSdj2ADedcVtCzrMv4VNBYMC3//cgg1unO8mOGBevMfUxpZB
         TLboGD/RMjMUVy0Mi1XzHTBCmybBAUgoPsJkxBBzg03+HR080fr4PILzBKzOPRZllgKs
         DDBxgsL2csqIkbrEFoLSPKQmcloScRQjFrVP4=
MIME-Version: 1.0
Date: Mon, 8 Jun 2009 09:28:18 +0200
Message-ID: <38b2ab8a0906080028h7a0e3ba2i80a98dcee67b5662@mail.gmail.com>
Subject: BUG: unable to handle kernel NULL pointer dereference at NULL while 
	resuming
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I've been hit by this bug while resuming my system (after a suspend to
disk), see the trace below.

The weird thing is that it looks that the wrong kernel was used to
resume the system. Before suspending I was using a 2.6.29 kernel I
compiled my self and the trace is taking about a
2.6.27.23-78.2.50.fc9.x86_64 kernel which is a kernel provided by
fedora.

Kernel failure message 1:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000088
IP: [<ffffffff8104996c>] lock_timer_base+0x11/0x4a
PGD 568ae067 PUD 73ca0067 PMD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in: ext2 vfat fat usb_storage nfsd lockd nfs_acl
auth_rpcgss exportfs sunrpc ip6t_REJECT xt_tcpudp nf_conntrack_ipv6
xt_state nf_conntrack ip6table_filter ip6_tables x_tables
cpufreq_ondemand acpi_cpufreq freq_table dm_mirror dm_log dm_multipath
scsi_dh dm_mod ipv6 kvm_intel kvm snd_seq_dummy snd_hda_intel
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss
snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_hwdep snd ppdev
parport_pc parport ftdi_sio i2c_i801 sr_mod firewire_ohci usbserial
i2c_core firewire_core cdrom pata_jmicron sky2 soundcore joydev
iTCO_wdt iTCO_vendor_support pcspkr crc_itu_t sg ata_piix pata_acpi
ata_generic libata sd_mod scsi_mod crc_t10dif ext3 jbd mbcache
uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Pid: 4311, comm: screen Tainted: G   M
2.6.27.23-78.2.50.fc9.x86_64 #1 P5K-VM
RIP: 0010:[<ffffffff8104996c>]  [<ffffffff8104996c>] lock_timer_base+0x11/0x4a
RSP: 0018:ffff88003b0d9cc8  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000060 RCX: 0000000000000003
RDX: 0000000000000000 RSI: ffff88003b0d9d00 RDI: 0000000000000060
RBP: ffff88003b0d9ce8 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000010246 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000060 R14: ffff88003b0d9d00 R15: ffff8800230f8240
FS:  00007fb8acc646f0(0000) GS:ffffffff8165d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000088 CR3: 000000001e40f000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process screen (pid: 4311, threadinfo ffff88003b0d8000, task ffff880042de2dc0)
Stack:  0000000000000060 00000000ffffffff 0000000000000000 ffff88003b096800
 ffff88003b0d9d18 ffffffff810499c0 ffff88003b0d9d08 ffffffff810310f3
 0000000000000060 0000000000000000 ffff88003b0d9d38 ffffffff81049a1c
Call Trace:
 [<ffffffff810499c0>] try_to_del_timer_sync+0x1b/0x63
 [<ffffffff810310f3>] ? need_resched+0x1e/0x28
 [<ffffffff81049a1c>] del_timer_sync+0x14/0x20
 [<ffffffffa014c1a6>] ftdi_close+0xda/0x106 [ftdi_sio]
 [<ffffffff810310f3>] ? need_resched+0x1e/0x28
 [<ffffffff812c0706>] ? _cond_resched+0x9/0x38
 [<ffffffffa0126b8b>] serial_close+0xa3/0x140 [usbserial]
 [<ffffffff811b5778>] release_dev+0x1e1/0x4e3
 [<ffffffff81053af2>] ? remove_wait_queue+0x2f/0x39
 [<ffffffff812c20c4>] ? _spin_unlock_irqrestore+0x27/0x3e
 [<ffffffff81032fe6>] ? __wake_up+0x43/0x4f
 [<ffffffff811b5b8d>] tty_release+0x19/0x25
 [<ffffffff810bfb6f>] __fput+0xca/0x16d
 [<ffffffff810bfc27>] fput+0x15/0x17
 [<ffffffff810bd0cd>] filp_close+0x67/0x72
 [<ffffffff810bd185>] sys_close+0xad/0xf0
 [<ffffffff8101027a>] system_call_fastpath+0x16/0x1b


Code: 49 89 fd 78 03 4d 89 e5 48 83 c4 38 4c 89 e8 5b 41 5c 41 5d 41
5e 41 5f c9 c3 55 48 89 e5 41 56 49 89 f6 41 55 49 89 fd 41 54 53 <49>
8b 5d 28 49 89 dc 49 83 e4 fe 74 28 4c 89 e7 e8 4e 88 27 00
RIP  [<ffffffff8104996c>] lock_timer_base+0x11/0x4a
 RSP <ffff88003b0d9cc8>
CR2: 0000000000000088

-- 
Francis
