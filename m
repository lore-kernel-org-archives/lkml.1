Return-Path: <linux-kernel-owner+w=401wt.eu-S1759696AbZBMAY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696AbZBMAY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 19:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZBMAYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 19:24:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbZBMAYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 19:24:17 -0500
Date: Thu, 12 Feb 2009 16:24:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: second bug with 2.6.28.4 - BUG: unable to handle kernel paging
 request at 000011bbffff88f8
Message-Id: <20090212162414.4825a59e.akpm@linux-foundation.org>
In-Reply-To: <1234091050.7967.52.camel@champagne.cantina>
References: <1234091050.7967.52.camel@champagne.cantina>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Feb 2009 12:04:09 +0100
Alessandro Bono <alessandro.bono@gmail.com> wrote:

> Hi
> 
> second bug with kernel 2.6.28.4 (first titled: XFS kernel BUG at
> fs/buffer.c:470! with 2.6.28.4)
> only "particular" operation was a night of rsync from a remote server to
> a local usb ext4 disk
> attached kernel log from machine boot to bug and .config
> tell me if you need other info or test/patch to try
>
> ...
>
> kernel: [38588.659606] EXT4-fs: delayed allocation enabled
> kernel: [38588.659610] EXT4-fs: file extents enabled
> kernel: [38588.661730] EXT4-fs: mballoc enabled
> kernel: [38588.661738] EXT4-fs: mounted filesystem with ordered data mode.
> kernel: [38665.956159] BUG: unable to handle kernel paging request at 000011bbffff88f8
> kernel: [38665.956172] IP: [<ffffffff802bd1e3>] pin_to_kill+0x21/0xd6
> kernel: [38665.956188] PGD 0 
> kernel: [38665.956193] Oops: 0000 [#1] SMP 
> kernel: [38665.956199] last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
> kernel: [38665.956204] CPU 1 
> kernel: [38665.956208] Modules linked in: ext4 jbd2 crc16 usb_storage libusual af_packet binfmt_misc rfcomm bridge stp llc bnep sco l2cap acpi_cpufreq cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative sbs sbshc pci_slot ipt_LOG xt_limit ipt_addrtype xt_state xt_tcpudp xt_conntrack ip6table_filter ip6_tables ipv6 nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables ext3 jbd mbcache hp_wmi coretemp sbp2 loop arc4 ecb iwlagn snd_seq_dummy snd_hda_intel pcmcia snd_pcm_oss snd_seq_oss snd_seq_midi tpm_infineon tpm tpm_bios iwlcore btusb sdhci_pci parport_pc parport snd_rawmidi rfkill sdhci snd_mixer_oss lis3lv02d leds_hp_disk snd_seq_midi_event mac80211 mmc_core ricoh_mmc yenta_socket rsrc_nonstatic pcmcia_core bluetooth snd_pcm video output container led_class snd_seq wmi button cfg80211 battery iTCO_wdt iTCO_vendor_support psmouse serio_ra!
 w ac snd_page_al
> kernel: oc snd_hwdep snd_timer snd_seq_device snd pcspkr soundcore evdev dm_multipath xfs sd_mod crc_t10dif sg sr_mod cdrom ahci ata_piix libata ohci1394 scsi_mod ieee1394 ehci_hcd uhci_hcd usbcore e1000e dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal processor fan thermal_sys hwmon fuse
> kernel: [38665.956410] Pid: 7403, comm: kded4 Not tainted 2.6.28.4 #1
> kernel: [38665.956414] RIP: 0010:[<ffffffff802bd1e3>]  [<ffffffff802bd1e3>] pin_to_kill+0x21/0xd6
> kernel: [38665.956426] RSP: 0018:ffff880037951ee8  EFLAGS: 00010286
> kernel: [38665.956431] RAX: 000011bbffff8800 RBX: ffff8800aed59c6c RCX: 0000000000000000
> kernel: [38665.956437] RDX: ffff8800aed59c6c RSI: ffff8800aed59c6c RDI: ffffffff805dd960
> kernel: [38665.956442] RBP: ffff8800aed59c6c R08: ffff8800bf415e68 R09: 0000000000000002
> kernel: [38665.956448] R10: 00000000021deca8 R11: 0000000000000246 R12: ffff880127003380
> kernel: [38665.956453] R13: ffff880127003360 R14: 0000000000000fc6 R15: 00000000000011bb
> kernel: [38665.956459] FS:  00007f67321af6f0(0000) GS:ffff88013b803a00(0000) knlGS:0000000000000000
> kernel: [38665.956465] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> kernel: [38665.956470] CR2: 000011bbffff88f8 CR3: 000000003793d000 CR4: 00000000000006e0
> kernel: [38665.956476] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> kernel: [38665.956481] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> kernel: [38665.956487] Process kded4 (pid: 7403, threadinfo ffff880037950000, task ffff88010208a2b0)
> kernel: [38665.956492] Stack:
> kernel: [38665.956495]  ffff8800aed59c6c ffff880127003360 ffff880127003380 00000000021deca8
> kernel: [38665.956504]  0000000001f8a310 ffffffff802bd9e9 00000000000000df ffff8800bf415e40
> kernel: [38665.956513]  00000000ffffffea 00000000000011bb 00000000021deca8 0000000001f8a310
> kernel: [38665.956523] Call Trace:
> kernel: [38665.956527]  [<ffffffff802bd9e9>] ? inotify_rm_wd+0x4d/0xb6
> kernel: [38665.956536]  [<ffffffff802be0ee>] ? sys_inotify_rm_watch+0x46/0x62
> kernel: [38665.956545]  [<ffffffff8020b49b>] ? system_call_fastpath+0x16/0x1b
> kernel: [38665.956554] Code: a4 07 32 00 31 c0 5a 5b 5d c3 41 56 41 55 49 89 fd 41 54 48 c7 c7 60 d9 5d 80 55 4d 8d 65 20 53 48 89 f5 48 8b 46 30 44 8b 76 38 <48> 8b 98 f8 00 00 00 e8 44 a4 13 00 8b 83 a0 00 00 00 3d ff ff 
> kernel: [38665.956619] RIP  [<ffffffff802bd1e3>] pin_to_kill+0x21/0xd6
> kernel: [38665.956628]  RSP <ffff880037951ee8>
> kernel: [38665.956631] CR2: 000011bbffff88f8

Inotify crashed.

Some fixes have been made to inotify post-2.6.28, but afacit 2.6.28.4
doesn't differe from 2.6.28.5 (the latest version) in this regard.

