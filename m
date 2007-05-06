Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbXEFTx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbXEFTx1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 15:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbXEFTx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 15:53:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:59270 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755210AbXEFTxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 15:53:25 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1/CXJ8j7hnCAG5kCi2bZkKYVfd6BYjxopM4alBFQx
	UF2wB/f1A/xQFo
From: Marc Dietrich <marvin24@gmx.de>
To: Florin Iucha <florin@iucha.net>
Subject: Re: REGRESSION: cannot change file access permissions on files NFS-mounted
Date: Sun, 6 May 2007 21:53:09 +0200
User-Agent: KMail/1.9.5
References: <20070505154037.GA5459@iucha.net>
In-Reply-To: <20070505154037.GA5459@iucha.net>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705062153.10476.marvin24@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Am Samstag, 5. Mai 2007 17:40 schrieben Sie:
> Hello,
>
> This morning I updated the kernel on my workstation to the current git
> tree (62ea6d80211ecc88ef516927ecebf64cb505be3f).   Upon reboot, I
> cannot change file access permissions of files in a directory that is
> nfs mounted (using NFS4):
>
>    $ chmod 0600 $path
>    chmod: Changing permissions of `$path': Input/output error
>
> In the kernel log I am getting these gems:
>
>    [  275.990233] decode_attr_group: reply buffer overflowed in line
>    2678.<4>decode
>    _attr_group: reply buffer overflowed in line
>    2678.<4>decode_attr_group: reply bu
>    ffer overflowed in line 2678.<4>decode_attr_group: reply buffer
>    overflowed in li
>    ne 2678.<4>decode_attr_group: reply buffer overflowed in line
>    2678.<4>decode_att
>    r_group: reply buffer overflowed in line 2678.
>
> The server is Linux running Debian testing with the kernel updated to
> 2.6.20-1-686 from
> (http://ftp.us.debian.org/debian/pool/main/l/linux-2.6/linux-image-2.6.20-1
>-686_2.6.20-3_i386.deb)
>
> Kernel 2.6.21 works fine on the client.

I have the same problem with 2.6.21-mm1. Server is openSUSE 10.2.
Additionally, unmounting gives the the ops below. I'm using autofs with the 
following mount options: rw,noatime,nodiratime.

BUG: unable to handle kernel NULL pointer dereference at virtual address 
00000030
 printing eip:
dcfbac13
*pde = 00000000
Oops: 0000 [#1]
Modules linked in: w83781d hwmon_vid hwmon analog joydev snd_pcm_oss 
snd_mixer_oss snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi 
snd_seq_midi_event snd_seq_midi_emul snd_seq nfs lockd nfs_acl sunrpc ipv6 
button battery ac reiser4 loop cdc_ether usbnet tuner 8250_pnp 8250 
serial_core snd_emu10k1 bttv snd_rawmidi snd_ac97_codec video_buf ac97_bus 
firmware_class snd_pcm ir_common snd_seq_device snd_timer compat_ioctl32 
i2c_algo_bit snd_page_alloc btcx_risc snd_util_mem tveeprom videodev 
snd_hwdep v4l2_common emu10k1_gp i2c_piix4 snd v4l1_compat gameport soundcore 
i2c_core uhci_hcd 8139too mii usbcore intel_agp agpgart parport_pc lp parport 
reiserfs edd fan sr_mod cdrom sg ata_piix libata thermal processor sd_mod 
scsi_mod
CPU:    0
EIP:    0060:[<dcfbac13>]    Not tainted VLI
EFLAGS: 00210246   (2.6.21-mm1 #1)
EIP is at nfs_update_inode+0xd3/0x710 [nfs]
eax: 00000000   ebx: 000081a4   ecx: cb020584   edx: 00008000
esi: 00000a6b   edi: c6389e60   ebp: c22128b0   esp: cbfa1dd8
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process umount (pid: 26110, ti=cbfa0000 task=d0ce40f0 task.ti=cbfa0000)
Stack: cb020608 cb0205ec cb020584 00200246 00000000 00000002 00000000 dcfbc74c
       cb020584 cb020400 c22128b0 002b9834 00000000 00000002 dcfbc74c cb020584
       c22128b0 cb0205ec cb020584 dcfbc75a c2212800 00000000 c3403b20 dcfcbb9d
Call Trace:
 [<dcfbc74c>] nfs_post_op_update_inode+0x1c/0x50 [nfs]
 [<dcfbc74c>] nfs_post_op_update_inode+0x1c/0x50 [nfs]
 [<dcfbc75a>] nfs_post_op_update_inode+0x2a/0x50 [nfs]
 [<dcfcbb9d>] nfs4_proc_delegreturn+0x16d/0x170 [nfs]
 [<dcfd73e8>] nfs_do_return_delegation+0x18/0x30 [nfs]
 [<dcfb9319>] nfs_dentry_iput+0x29/0x70 [nfs]
 [<c0186882>] shrink_dcache_for_umount_subtree+0x82/0x220
 [<c0187a89>] shrink_dcache_for_umount+0x39/0x50
 [<c0176ad8>] generic_shutdown_super+0x18/0xf0
 [<c0176cb8>] deactivate_super+0x78/0xa0
 [<c0176bec>] kill_anon_super+0xc/0x40
 [<dcfbd28f>] nfs_kill_super+0xf/0x20 [nfs]
 [<c0176cbd>] deactivate_super+0x7d/0xa0
 [<c018c1a0>] sys_umount+0x50/0x290
 [<c0132fb7>] up_read+0x17/0x30
 [<c0104084>] restore_nocheck+0x12/0x15
 [<c013a825>] trace_hardirqs_on+0xc5/0x170
 [<c018c3f5>] sys_oldumount+0x15/0x20
 [<c010403c>] syscall_call+0x7/0xb
 =======================
Code: e8 33 fd ff ff b8 8c ff ff ff 83 c4 3c 5b 5e 5f 5d c3 8d b6 00 00 00 00 
8b 4c 24 20 8b 81 24 01 00 00 8b b8 9c 02 00 00 8b 40 38 <3b> 48 30 0f 84 6e 
04 00 00 8b 54 24 24 8b 85 8c 00 00 00 89 82
EIP: [<dcfbac13>] nfs_update_inode+0xd3/0x710 [nfs] SS:ESP 0068:cbfa1dd8


Marc

