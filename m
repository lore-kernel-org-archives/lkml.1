Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbXFVASu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbXFVASu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 20:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbXFVASn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 20:18:43 -0400
Received: from esuna.co.uk ([83.223.102.198]:33178 "EHLO mail.esuna.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751199AbXFVASm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 20:18:42 -0400
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2007 20:18:42 EDT
Message-ID: <467B12CA.5060405@esuna.co.uk>
Date: Fri, 22 Jun 2007 01:07:38 +0100
From: "Jay L. T. Cornwall" <jay@esuna.co.uk>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc5: pdflush oops under heavy disk load
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel version: 2.6.22-rc5 (confirmed also on 2.6.20)
Kernel config : Ubuntu 7.04 default (SMP)

Relevant hardware:
  Asus P5K (Intel P35 chipset)
  Core 2 Duo E6600 2.4GHz
  Western Digital 10KRPM 150GB HDD on JMicron 20360/20363 AHCI

Netconsoled dump:

[  724.350222] general protection fault: 0000 [1] SMP
[  724.350413] CPU 1
[  724.350520] Modules linked in: usb_storage libusual netconsole
binfmt_misc rfcomm l2cap bluetooth ppdev capability commoncap
acpi_cpufreq cpufreq_stats cpufreq_userspace cpufreq_ondemand
cpufreq_conservative cpufreq_powersave freq_table video container
battery dock asus_acpi ac sbs button af_packet nls_utf8 ntfs w83627ehf
i2c_isa parport_pc lp parport fuse mt2060 snd_hda_intel snd_pcm_oss
snd_mixer_oss snd_pcm cx22702 snd_seq_dummy snd_seq_oss dvb_usb_dib0700
dib7000m dib7000p dvb_usb cx88_dvb cx88_vp3054_i2c snd_seq_midi
snd_rawmidi video_buf_dvb dvb_core ipv6 snd_seq_midi_event snd_seq
snd_timer dvb_pll cx8800 cx8802 cx88xx sr_mod ir_common snd_seq_device
cdrom i2c_algo_bit dib3000mc dibx000_common tveeprom atl1 usbhid psmouse
videodev compat_ioctl32 hid mii i2c_core v4l2_common v4l1_compat
btcx_risc video_buf serio_raw snd soundcore pcspkr shpchp pci_hotplug
snd_page_alloc intel_agp tsdev evdev ext3 jbd mbcache sg sd_mod
pata_jmicron ata_generic ata_piix ahci libata scsi_mod ehci_hcd generic
uhci_hcd usbcore thermal processor fan
[  724.355028] Pid: 199, comm: pdflush Not tainted 2.6.22-rc5-edge #1
[  724.355125] RIP: 0010:[<ffffffff880f1b44>]  [<ffffffff880f1b44>]
:ext3:walk_page_buffers+0x34/0x90
[  724.355305] RSP: 0018:ffff8101322e7bb0  EFLAGS: 00010202
[  724.355394] RAX: 0000000000000000 RBX: 000000009d8145bd RCX:
0000000000001000
[  724.355491] RDX: 000000009d8145bd RSI: 908553557cc5eb6f RDI:
ffff81012e1052a0
[  724.355587] RBP: 000000003b028b7a R08: 0000000000000000 R09:
ffffffff880f1ba0
[  724.355684] R10: 0000000000000000 R11: 0000000000000001 R12:
000000009d8145bd
[  724.355780] R13: 908553557cc5eb6f R14: ffff8100369a5200 R15:
0000000000000000
[  724.357278] FS:  0000000000000000(0000) GS:ffff81013b07cac0(0000)
knlGS:0000000000000000
[  724.357410] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  724.357501] CR2: 00002b776e178000 CR3: 000000013a245000 CR4:
00000000000006e0
[  724.357598] Process pdflush (pid: 199, threadinfo ffff8101322e6000,
task ffff81013b15aaa0)
[  724.357730] Stack:  ffffffff880f1ba0 0000000000001000
ffff81012e1052a0 ffff81013de27c38
[  724.358031]  ffff81012e1052a0 000000002e1052a0 ffff8100369a5200
ffff8101322e7e50
[  724.358292]  000000000000000e ffffffff880f4fca ffff81012e545b08
0000000000000003
[  724.358489] Call Trace:
[  724.358638]  [<ffffffff880f1ba0>] :ext3:bget_one+0x0/0x10
[  724.358742]  [<ffffffff880f4fca>] :ext3:ext3_ordered_writepage+0xea/0x190
[  724.358846]  [<ffffffff8027413a>] __writepage+0xa/0x30
[  724.358937]  [<ffffffff80274744>] write_cache_pages+0x224/0x350
[  724.359030]  [<ffffffff80274130>] __writepage+0x0/0x30
[  724.359147]  [<ffffffff802748cb>] do_writepages+0x2b/0x40
[  724.359239]  [<ffffffff802b8046>] __writeback_single_inode+0xa6/0x3e0
[  724.359348]  [<ffffffff802b8796>] sync_sb_inodes+0x1f6/0x2f0
[  724.359445]  [<ffffffff802b8d2f>] writeback_inodes+0xbf/0x100
[  724.359542]  [<ffffffff80274de9>] background_writeout+0xa9/0xe0
[  724.359648]  [<ffffffff802752f0>] pdflush+0x0/0x220
[  724.359739]  [<ffffffff80275430>] pdflush+0x140/0x220
[  724.359829]  [<ffffffff80274d40>] background_writeout+0x0/0xe0
[  724.359927]  [<ffffffff8024ac7b>] kthread+0x4b/0x80
[  724.360018]  [<ffffffff8020aca8>] child_rip+0xa/0x12
[  724.360120]  [<ffffffff8024ac30>] kthread+0x0/0x80
[  724.360208]  [<ffffffff8020ac9e>] child_rip+0x0/0x12
[  724.360298]
[  724.360369]
[  724.360370] Code: 4c 8b 6e 08 41 8d 1c 14 76 39 89 d8 44 29 e0 3b 44
24 08 73
[  724.361260] RIP  [<ffffffff880f1b44>] :ext3:walk_page_buffers+0x34/0x90
[  724.361395]  RSP <ffff8101322e7bb0>

The system runs stably under light load. Heavy disk writes, here induced
by 200Mbit scp's onto the drive, cause the oops within a minute or two.
It's entirely reproducible and appears to give the same trace each time.

I'll have a go at digging up the root of this problem, but anyone with
more experience is welcome to pitch in!

-- 
Jay L. T. Cornwall, http://www.esuna.co.uk/~jay/
PhD Student
Imperial College London
