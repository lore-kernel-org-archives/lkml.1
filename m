Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913Ab0AaPP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0AaPP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 10:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153Ab0AaPP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 10:15:28 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:33717 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab0AaPP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 10:15:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=iyODC/EdvyYN7hEDspajoBlewJPhJrLxIqQplMOM1NJFPVqgFM99Dbih62IR0OXXZz
         zrYlfVyaYvc9eWOCmxtHxtgEJhO4skzqjmJY//ZZ5RL7I4mhEYCN2RjXkpuDn0+T0I06
         mSd0OmGnsmpzQ0CMaWVPAzZ3adRt6BeeITqHY=
MIME-Version: 1.0
Date: Sun, 31 Jan 2010 22:15:26 +0700
Message-ID: <5d75f4611001310715o55674116n436e13e3a5437fc4@mail.gmail.com>
Subject: kernel BUG at fs/dcache.c:670!
From: BuraphaLinux Server <buraphalinuxserver@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

Is this really a kernel problem, or did I do something stupid?  This
is an x86_64 kernel but a 32bit userland.

/usr is an LV with this from 'df -h':

Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/blsvg-usr
                      7.9G  3.9G  3.7G  52% /usr

vg blsvg has about 385g free

I used:
lvcreate --version
  LVM version:     2.02.60(1) (2010-01-23)
  Library version: 1.02.43 (2010-01-23)
  Driver version:  4.15.0

I ran this command:

lvcreate -s -n usrsnap -L 2G /dev/blsvg/usr

And I got this result (sorry for any bad line wrapping; I have to use
links to post via gmail):

[  140.239839] BUG: Dentry ffff880074502d40{i=5ff7b,n=hald-addon-acpi} still in
use (1) [unmount of ext3 dm-1]
[  140.240137] ------------[ cut here ]------------
[  140.240240] kernel BUG at fs/dcache.c:670!
[  140.240317] invalid opcode: 0000 [#1] SMP
[  140.240457] last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host3/target3:0:0/3:0:0:0/block/sda/uevent
[  140.240583] CPU 0
[  140.240686] Modules linked in: af_packet nf_conntrack_ftp
ipt_REJECT xt_limit xt_TCPMSS xt_DSCP xt_state xt_tcpudp iptable_raw
iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 iptable_filter ip_tables x_tables ip_set tg3 libphy
dm_snapshot dm_mod snd_hda_codec_analog rtc_cmos rtc_core
rtc_lib snd_hda_intel 8250_pnp 8250 serial_core snd_hda_codec thermal
snd_pcm snd_timer snd parport_pc parport soundcore processor i2c_i801
sg iTCO_wdt rng_core snd_page_alloc button evdev
[  140.242592] Pid: 2673, comm: lvm Not tainted 2.6.32.7 #1 OptiPlex 330

[  140.242713] RIP: 0010:[<ffffffff810cb143>]  [<ffffffff810cb143>]
shrink_dcache_for_umount_subtree+0x2b3/0x2c0
[  140.242876] RSP: 0018:ffff88007b4f7d08  EFLAGS: 00010296
[  140.242956] RAX: 0000000000000075 RBX: ffff88007cb42c90 RCX:
00000000ffffffff[  140.243044] RDX: ffff880001800000 RSI:
0000000000000046 RDI: ffffffff81766d50[  140.243131] RBP:
ffff88007b4f7d38 R08: 0000000000000000 R09: 0000000000000006[
140.243216] R10: 0000000000000000 R11: 0000000000000001 R12:
ffff880074502d40[  140.243299] R13: ffff880074502da0 R14:
0000000000000029 R15: ffff88007ce87380[  140.243383] FS:
0000000000000000(0000) GS:ffff880001800000(0063)
knlGS:0000000009734830
[  140.243505] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  140.243586] CR2: 00000000f7784000 CR3: 000000007bcbc000 CR4:
00000000000006f0[  140.243670] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000[  140.243755] DR3:
0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400[
140.243839] Process lvm (pid: 2673, threadinfo ffff88007b4f6000, task
ffff88007ed05810)
[  140.243960] Stack:
[  140.244035]  ffff88007b591260 ffffffff811a9ddd ffff88007b591000
ffffffff814b9060
[  140.244216] <0> ffff88007c82a2f8 ffff88007c82a240 ffff88007b4f7d58
ffffffff810cb181
[  140.244491] <0> 0000000000000082 ffff88007b591000 ffff88007b4f7d78
ffffffff810ba15a
[  140.244834] Call Trace:
[  140.244911]  [<ffffffff811a9ddd>] ? __down_read_trylock+0x3d/0x60
[  140.244994]  [<ffffffff810cb181>] shrink_dcache_for_umount+0x31/0x60
[  140.245084]  [<ffffffff810ba15a>] generic_shutdown_super+0x1a/0x100
[  140.245170]  [<ffffffff810ba26c>] kill_block_super+0x2c/0x50
[  140.245251]  [<ffffffff810ba36b>] deactivate_locked_super+0x5b/0x80
[  140.245335]  [<ffffffff810e492a>] thaw_bdev+0xda/0x120
[  140.245421]  [<ffffffffa0130943>] dm_resume+0xe3/0x150 [dm_mod]
[  140.245504]  [<ffffffffa0135da0>] ? dev_suspend+0x0/0x230 [dm_mod]
[  140.245587]  [<ffffffffa0135f61>] dev_suspend+0x1c1/0x230 [dm_mod]
[  140.245671]  [<ffffffffa0136b02>] ctl_ioctl+0x1d2/0x240 [dm_mod]
[  140.245752]  [<ffffffff810c0c7c>] ? path_put+0x2c/0x40
[  140.245835]  [<ffffffffa0136b9d>] dm_compat_ctl_ioctl+0xd/0x20 [dm_mod]
[  140.245919]  [<ffffffff810f9ffd>] compat_sys_ioctl+0xcd/0x500
[  140.246006]  [<ffffffff81031e94>] sysenter_dispatch+0x7/0x2b
[  140.246090] Code: 08 49 8b 44 24 10 48 85 c0 74 04 48 8b 50 40 48
8d 86 60 02 00 00 48 c7 c7 a0 fe 59 81 4c 89 e6 48 89 04 24 31 c0 e8
2b f2 3b 00 <0f> 0b eb fe 0f 0b eb fe 0f 1f 44 00 00 55 48 89 e5 53 48
89 fb
[  140.248307] RIP  [<ffffffff810cb143>]
shrink_dcache_for_umount_subtree+0x2b3/0x2c0
[  140.248460]  RSP <ffff88007b4f7d08>
[  140.248536] ---[ end trace fef4e429dbea3b0d ]---
