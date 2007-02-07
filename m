Return-Path: <linux-kernel-owner+w=401wt.eu-S1422716AbXBGTpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422716AbXBGTpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422720AbXBGTpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:45:24 -0500
Received: from mail.gmx.net ([213.165.64.20]:36011 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1422716AbXBGTpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:45:23 -0500
X-Provags-ID: V01U2FsdGVkX18Ny74DJPkNmxEM60iduhSvLFFL53HSPJRUedgXwS
	iv/g==
From: Frank Hartmann <soundart@gmx.net>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.6.19.1 Oops while doing Disk IO + playing sound
In-Reply-To: <20070207091841.GE24590@atrey.karlin.mff.cuni.cz> (Jan Kara's
	message of "Wed, 7 Feb 2007 10:18:41 +0100")
References: <877ivr6t0k.fsf@fantasio.hh.de>
	<20070207091841.GE24590@atrey.karlin.mff.cuni.cz>
Date: Wed, 07 Feb 2007 20:45:26 +0100
Message-ID: <87wt2thhux.fsf@fantasio.hh.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   Hi,
>
>   Has this bug got fixed? Are you still able to reproduce the problem with 2.6.20?

Hi Jan,

you are the first to react on my message. I did not try 2.6.20 uptonow.  

What I did in the meantime:

Switched to 2.6.19.2

I run extensivly memtest+ and started something called smrtctl which
should give more information on my harddisk status. Everything looks
ok.

>From what I read on linux-kernel I came to the conclusion,
that it might be benifical not using PREMPT. So I changed kernel configuration.

Yesterday I had:


Feb  6 22:35:44 fantasio kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000029
Feb  6 22:35:44 fantasio kernel:  printing eip:
Feb  6 22:35:44 fantasio kernel: e0c3b737
Feb  6 22:35:44 fantasio kernel: *pde = 00000000
Feb  6 22:35:44 fantasio kernel: Oops: 0000 [#1]
Feb  6 22:35:44 fantasio kernel: Modules linked in: ext2 cbc blkcipher binfmt_misc bnep rfcomm l2cap nfs nfsd exportfs lockd sunrpc ip_nat_irc ip_nat_ftp ip_conntrack_irc ip_conntrack_ftp xt_state ipt_REJECT i
pt_LOG iptable_mangle iptable_filter iptable_nat ip_nat ip_tables ip_conntrack bridge llc cryptoloop loop sha256 aes it87 hwmon_vid i2c_isa i2c_core md5 ipv6 af_packet radeon drm dm_crypt dm_mod snd_via82xx sn
d_ac97_codec snd_ac97_bus snd_pcm_oss snd_mixer_oss analog 8250_pnp 8250 serial_core snd_pcm snd_timer snd_page_alloc snd_mpu401_uart gameport snd_rawmidi rtc snd soundcore prism54 via_agp agpgart firmware_cla
ss evdev sd_mod ext3 jbd mbcache raid1 raid0 multipath linear md_mod ide_cd cdrom ide_disk usbhid usb_storage via_rhine mii via82cxxx ide_core ehci_hcd sym53c8xx scsi_transport_spi uhci_hcd usbcore scsi_mod un
ix
Feb  6 22:35:44 fantasio kernel: CPU:    0
Feb  6 22:35:44 fantasio kernel: EIP:    0060:[pg0+546215735/1070253056]    Not tainted VLI
Feb  6 22:35:44 fantasio kernel: EFLAGS: 00010213   (2.6.19.2 #1)
Feb  6 22:35:44 fantasio kernel: EIP is at journal_grab_journal_head+0x2/0x14 [jbd]
Feb  6 22:35:44 fantasio kernel: eax: 00000029   ebx: 00000029   ecx: 00000029   edx: 00000000
Feb  6 22:35:44 fantasio kernel: esi: c10d2580   edi: 00000000   ebp: c1feb6ec   esp: df9fde00
Feb  6 22:35:44 fantasio kernel: ds: 007b   es: 007b   ss: 0068
Feb  6 22:35:44 fantasio kernel: Process kswapd0 (pid: 132, ti=df9fc000 task=dffca590 task.ti=df9fc000)
Feb  6 22:35:44 fantasio kernel: Stack: e0c375ca 00000246 c1feb720 c24c532c c1186ac0 00000001 e0c6930d 000000d0 
Feb  6 22:35:44 fantasio kernel:        00000001 c02aed00 c012f883 c10d2580 c24c532c c01344b1 df9fdf1c c0117e5d 
Feb  6 22:35:44 fantasio kernel:        df9fdf80 00000020 00000000 00000000 00000020 00000001 00000001 00000000 
Feb  6 22:35:44 fantasio kernel: Call Trace:
Feb  6 22:35:44 fantasio kernel:  [pg0+546198986/1070253056] journal_try_to_free_buffers+0x5e/0xf9 [jbd]
Feb  6 22:35:44 fantasio kernel:  [pg0+546403085/1070253056] ext3_releasepage+0x0/0x72 [ext3]
Feb  6 22:35:44 fantasio kernel:  [try_to_release_page+52/70] try_to_release_page+0x34/0x46
Feb  6 22:35:44 fantasio kernel:  [shrink_inactive_list+1096/1677] shrink_inactive_list+0x448/0x68d
Feb  6 22:35:44 fantasio kernel:  [tasklet_action+55/87] tasklet_action+0x37/0x57
Feb  6 22:35:44 fantasio kernel:  [__pagevec_release+21/29] __pagevec_release+0x15/0x1d
Feb  6 22:35:45 fantasio kernel:  [shrink_active_list+726/734] shrink_active_list+0x2d6/0x2de
Feb  6 22:35:45 fantasio kernel:  [shrink_zone+180/213] shrink_zone+0xb4/0xd5
Feb  6 22:35:45 fantasio kernel:  [kswapd+623/886] kswapd+0x26f/0x376
Feb  6 22:35:45 fantasio kernel:  [autoremove_wake_function+0/53] autoremove_wake_function+0x0/0x35
Feb  6 22:35:45 fantasio kernel:  [kswapd+0/886] kswapd+0x0/0x376
Feb  6 22:35:45 fantasio kernel:  [kthread+173/216] kthread+0xad/0xd8
Feb  6 22:35:45 fantasio kernel:  [kthread+0/216] kthread+0x0/0xd8
Feb  6 22:35:45 fantasio kernel:  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
Feb  6 22:35:45 fantasio kernel:  =======================

It happened probably while I was running

408  dd if=/dev/urandom of=crypt.img bs=1M count=20000

The file seems to be more or less complete and the process modified the file later:

ls -l crypt.img 
-rw-r--r-- 1 frank frank 20970175708 Feb  6 22:46 crypt.img

So i do not know if it is related. 



Today I had three complete system freezes(keyboard dead,mouse dead, no
magic sysreq), but no Oops while doing:

losetup /dev/loop1 /home/frank/tmp/crypt.img
cryptsetup -y create mycryprt /dev/loop1
mkfs.ext3 /dev/mapper/mycryprt              <-- FREEZE at 'writing superblocks' 

I will start using 2.6.20 soon.

many thanks
  Frank

