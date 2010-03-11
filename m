Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab0CKTqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 14:46:20 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:48215 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737Ab0CKTqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 14:46:19 -0500
Message-ID: <4B994888.8020007@msgid.tls.msk.ru>
Date: Thu, 11 Mar 2010 22:46:16 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-aio@kvack.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: aio: compat_ioctl issue?
References: <4B956E5B.9020302@msgid.tls.msk.ru>	<x497hpm8p69.fsf@segfault.boston.devel.redhat.com>	<4B957122.4060007@msgid.tls.msk.ru>	<x49mxyi78ob.fsf@segfault.boston.devel.redhat.com>	<4B957AF3.6040801@msgid.tls.msk.ru>	<4B957D20.4010904@msgid.tls.msk.ru> <x49wrxij11s.fsf@segfault.boston.devel.redhat.com> <4B994022.6030703@msgid.tls.msk.ru>
In-Reply-To: <4B994022.6030703@msgid.tls.msk.ru>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev ?????:
> Jeff Moyer wrote:
> []
>> Yeah, whoops.  I built the libaio test harness using -m32 and this patch
>> works for me.  Would you mind giving it a try?
> 
> It appears to work here so far.  I did not run massive i/o test suite
> but it now passes basic multiple kernel unpacking in parallel tests
> (before it didnt' even recognize the partition table).
> 
> So the patch - at least basically - works.

It looks like the conclusion was preliminary a bit.
I tested the wrong kvm binary which does not have
aio support...

And when running real thing it crashes.   I tested it
on 2.6.32 (trivial corrections to the patch required).

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff810c0e57>] generic_segment_checks+0x17/0xd0
PGD 18afe0067 PUD 18ace1067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/input/mice/uevent
CPU 0
Modules linked in: powernow_k8 rfcomm hidp l2cap bluetooth rfkill autofs4 nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc tun ipv6 bridge stp llc quota_v2 quota_tree ext4 jbd2 crc16 md_mod asus_atk0110 thermal r8169 processor thermal_sys floppy mii psmouse edac_core shpchp pci_hotplug i2c_piix4 sg evdev radeon ttm drm_kms_helper drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect fbcon font bitblit softcursor fb saa7134_alsa kvm_amd kvm k8temp hwmon button tuner_simple tuner_types tea5767 tuner saa7134 ir_common v4l2_common videodev v4l1_compat v4l2_compat_ioctl32 videobuf_dma_sg videobuf_core tveeprom i2c_core lp parport_pc parport usb_storage ehci_hcd uhci_hcd snd_mixer_oss snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore
snd_page_alloc sr_mod cdrom ext3 jbd mbcache pata_atiixp ohci_hcd ahci libata usbhid hid usbcore nls_base sd_mod scsi_mod
Pid: 5135, comm: kvm Not tainted 2.6.32-amd64 #2.6.32.9 System Product Name
RIP: 0010:[<ffffffff810c0e57>]  [<ffffffff810c0e57>] generic_segment_checks+0x17/0xd0
RSP: 0000:ffff88018ac6bd80  EFLAGS: 00010202
RAX: ffff88018aebcf00 RBX: ffff88018ac6bdf0 RCX: 0000000000000001
RDX: ffff88018ac6be20 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff88018ac6be20 R08: ffffffffffffffea R09: ffff88018aebcf30
R10: 0000000000000000 R11: 0000000000000010 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88018ad3d2c0
FS:  0000000000000000(0000) GS:ffff880028200000(0063) knlGS:00000000f6fc9b70
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000000000008 CR3: 000000018af4e000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kvm (pid: 5135, threadinfo ffff88018ac6a000, task ffff88018aefb040)
Stack:
 ffff88018aebce80 ffff88018aebce80 ffffffff810c36b5 00000010813f8b00
<0> ffff88018aebcf00 0000000000013ad8 ffff88018ac6bfd8 ffff88018aefb040
<0> ffffffff813f7700 ffff88018aefb040 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff810c36b5>] ? generic_file_aio_read+0x55/0x620
 [<ffffffff810f8696>] ? cache_alloc_refill+0x96/0x5d0
 [<ffffffff810c3660>] ? generic_file_aio_read+0x0/0x620
 [<ffffffff81139a6c>] ? aio_rw_vect_retry+0x7c/0x210
 [<ffffffff8113b252>] ? aio_run_iocb+0x82/0x150
 [<ffffffff8113bb8f>] ? do_io_submit+0x2bf/0x640
 [<ffffffff81038672>] ? ia32_sysret+0x0/0x5
Code: 82 c0 6c 3f 81 c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 45 31 d2 48 89 d5 53 48 89 f3 48 8b 36 48 85 f6 0f 84 84 00 00 00 <4c> 8b 57 08 4d 85 d2 0f 88 8c 00 00 00 48 8b 07 65 4c 8b 04 25
RIP  [<ffffffff810c0e57>] generic_segment_checks+0x17/0xd0
 RSP <ffff88018ac6bd80>
CR2: 0000000000000008
---[ end trace 3abdd573ab9bce13 ]---

I'm recompiling 2.6.33 now.  There, patch applied cleanly.

/mjt
