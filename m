Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYJMKja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYJMKja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYJMKjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:39:21 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:56385 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804AbYJMKjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:39:20 -0400
X-Greylist: delayed 685 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2008 06:39:19 EDT
From: Philip Martin <philip@codematters.co.uk>
To: Greg KH <greg@kroah.com>
Cc: Nix <nix@esperi.org.uk>, linux-kernel@vger.kernel.org,
       Peter Osterlund <petero2@telia.com>
Subject: Re: pktcdvd -> sysfs warning with 2.6.27
References: <87vdvyngni.fsf@hades.wkstn.nix>
	<20081012181700.GA21072@kroah.com>
Date: Mon, 13 Oct 2008 11:27:50 +0100
In-Reply-To: <20081012181700.GA21072@kroah.com> (Greg KH's message of "Sun, 12
	Oct 2008 11:17:00 -0700")
Message-ID: <87myh8dc2h.fsf@debian2.home.lan>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Cloudmark-Analysis: v=1.0 c=1 a=1z5u3U6xEFEA:10 a=5D0bYxygq7UA:10 a=Yqdj2FtDgMk1lYbZ6z0A:9 a=VdonHCuphntEWxxCv6AA:7 a=s6BfnSn7KQkj72CeYmaEVJ0pyhkA:4 a=mJMriH8CDpcA:10 a=SKpDKCWXRSQA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Sun, Oct 12, 2008 at 01:26:25PM +0100, Nix wrote:
>> At the very end of my startup scripts, I say
>> 
>> pktsetup cdrw /dev/cdrw
>> 
>> to get the stuff in /etc/pktcdvd set up right.
>> 
>> As of 2.6.27 this has started complaining:
>> 
>> pktcdvd: writer pktcdvd0 mapped to hde
>> ------------[ cut here ]------------
>> WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x2f/0x3b()
>> sysfs: duplicate filename '254:0' can not be created
>> Modules linked in:
>> Pid: 1306, comm: pktsetup Not tainted 2.6.27-dirty #1
>>  [<c011ac1c>] warn_slowpath+0x50/0x71
>>  [<c0245c17>] ? ida_get_new_above+0xdc/0x17d
>>  [<c0245a8a>] ? idr_get_empty_slot+0x142/0x1f3
>>  [<c0245c17>] ? ida_get_new_above+0xdc/0x17d
>>  [<c01a1738>] ? sysfs_ilookup_test+0x0/0x16
>>  [<c01a1919>] ? sysfs_find_dirent+0x1b/0x2c
>>  [<c01a1aba>] sysfs_add_one+0x2f/0x3b
>>  [<c01a26f6>] sysfs_do_create_link+0xb1/0x106
>>  [<c01a276b>] sysfs_create_link+0xf/0x14
>>  [<c02749d2>] device_add+0x134/0x455
>>  [<c0274d0a>] device_register+0x17/0x1a
>>  [<c0274d8d>] device_create_vargs+0x80/0xa3
>>  [<c0274dd0>] device_create+0x20/0x24
>>  [<c028208f>] pkt_setup_dev+0x2ed/0x429
>>  [<c0282251>] pkt_ctl_ioctl+0x86/0x18c
>>  [<c0170c09>] vfs_ioctl+0x55/0x6e
>>  [<c0185801>] ? block_truncate_page+0xa9/0x1e0
>>  [<c0170e58>] do_vfs_ioctl+0x236/0x249
>>  [<c0170e9c>] sys_ioctl+0x31/0x4d
>>  [<c0102c8d>] sysenter_do_call+0x12/0x25
>>  [<c0185801>] ? block_truncate_page+0xa9/0x1e0
>>  =======================
>> ---[ end trace 1cdd10ab78ee5bc6 ]---
>> 
>> For the life of me I can't see where pkt_sysfs_dev_new() is being called
>> more than once: indeed, from the trace above GCC has inlined it into
>> pkt_setup_dev() as a static function called from only one place...
>
> Perhaps some other kernel code is registering with that same major/minor
> number, making it already present in sysfs.  Where does that sysfs file
> link to before you load your driver?

I've just got a similar message from 2.6.27 but involving vcs1.  I
didn't get this with 2.6.26.6 and I've booted 2.6.27 a few times and
only seen it once:

WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x33/0x3a()
sysfs: duplicate filename 'vcs1' can not be created
Modules linked in: xt_tcpudp nfs nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs 
ppdev lp ac battery xt_state ipt_MASQUERADE ipv6 ipt_LOG iptable_mangle iptable_
filter iptable_nat ip_tables nf_nat x_tables nf_conntrack_ipv4 nf_conntrack tun 
dm_crypt crypto_blkcipher coretemp it87 hwmon_vid loop snd_hda_intel snd_pcm_oss
 snd_mixer_oss snd_pcm snd_timer sg iTCO_wdt snd serio_raw i2c_i801 sr_mod i2c_c
ore parport_pc soundcore psmouse intel_agp parport button pcspkr snd_page_alloc 
cdrom evdev ext3 jbd mbcache dm_mirror dm_log dm_snapshot dm_mod usbhid hid sd_m
od ata_piix libata r8169 ehci_hcd uhci_hcd thermal processor fan thermal_sys
Pid: 3841, comm: getty Not tainted 2.6.27 #1

Call Trace:
 [<ffffffff802347d0>] warn_slowpath+0xb4/0xdc
 [<ffffffff802284dc>] source_load+0x2a/0x58
 [<ffffffff802f85c9>] __next_cpu+0x19/0x26
 [<ffffffff802fd7de>] string+0x34/0x93
 [<ffffffff802fdb59>] vsnprintf+0x31c/0x5be
 [<ffffffff802f8c33>] idr_get_empty_slot+0x164/0x243
 [<ffffffff802f8e08>] ida_get_new_above+0xf6/0x182
 [<ffffffff80292ead>] find_inode+0x28/0x6d
 [<ffffffff802c4a10>] sysfs_ilookup_test+0x0/0xf
 [<ffffffff802c4c45>] sysfs_find_dirent+0x1b/0x2f
 [<ffffffff802c4d22>] sysfs_add_one+0x33/0x3a
 [<ffffffff802c521e>] create_dir+0x4f/0x7c
 [<ffffffff802c5280>] sysfs_create_dir+0x35/0x4a
 [<ffffffff802f983e>] kobject_get+0x12/0x17
 [<ffffffff802f9977>] kobject_add_internal+0xcf/0x18a
 [<ffffffff802f9f53>] kobject_add+0x74/0x7c
 [<ffffffffa009e9bc>] journal_stop+0x176/0x182 [jbd]
 [<ffffffffa00b1adf>] ext3_ordered_write_end+0xfc/0x112 [ext3]
 [<ffffffff802f983e>] kobject_get+0x12/0x17
 [<ffffffff80364174>] get_device+0x17/0x1f
 [<ffffffff8036479e>] device_add+0x9e/0x5cc
 [<ffffffff802f9637>] kobject_init_internal+0x12/0x2c
 [<ffffffff802f96af>] kobject_init+0x41/0x69
 [<ffffffff80364d76>] device_create_vargs+0x98/0xc4
 [<ffffffff80364ddc>] device_create+0x3a/0x42
 [<ffffffff802295c6>] __wake_up+0x38/0x4f
 [<ffffffff8034d38d>] tty_ldisc_setup+0x63/0x6a
 [<ffffffff80347a29>] init_dev+0x390/0x4a9
 [<ffffffff8035542b>] vc_allocate+0x10/0x13f
 [<ffffffff8034fc55>] vcs_make_sysfs+0x2d/0x5b
 [<ffffffff803555ed>] con_open+0x93/0xa0
 [<ffffffff803498fb>] tty_open+0x1ae/0x32d
 [<ffffffff80284aee>] chrdev_open+0x131/0x15b
 [<ffffffff802849bd>] chrdev_open+0x0/0x15b
 [<ffffffff80280c06>] __dentry_open+0x13c/0x246
 [<ffffffff8028bda7>] do_filp_open+0x38a/0x6d3
 [<ffffffff8022947f>] need_resched+0x1e/0x28
 [<ffffffff80294a27>] alloc_fd+0xb5/0xf9
 [<ffffffff80280a06>] do_sys_open+0x48/0xcc
 [<ffffffff8020bfab>] system_call_fastpath+0x16/0x1b
