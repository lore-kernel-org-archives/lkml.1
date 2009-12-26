Return-Path: <linux-kernel-owner+w=401wt.eu-S1753038AbZLZONb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbZLZONb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 09:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZLZONa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 09:13:30 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:57036 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZLZON3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 09:13:29 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: linux-kernel@vger.kernel.org
Subject: 2.6.33-rc2 allergic to amanda?
Date: Sat, 26 Dec 2009 09:13:04 -0500
User-Agent: KMail/1.12.3 (Linux/2.6.32.2; KDE/4.3.3; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <200912260913.04124.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;
I rebooted to 2.6.33-rc2 at about 00:20 this morning and went to bed.  It had 
run ok for a few hours earlier in the day.

When I got up there was an oops written to every open terminal, then kmail 
locked up, and htop said there was a session of lsof eating 100% of cpu #0, 
and it wasn't killable.  So I gave the reboot command to one of the shells, 
which hung after walling that the system was going down for a reboot,  a few 
ctl-alt-del's later it was stuck on stopping lm_sensors, so I eventually 
tapped the reset button & chose 2.6.32.2 to reboot to.  Much recovering of 
jourrnals etc later, its looking normal.

I have pix of the walled message, and of the htop screen if needed.  Here 
is the log snippet of that period from the time amanda is started by cron.
-----------------------------
Dec 26 01:15:01 coyote xinetd[2637]: START: amanda pid=5984 from=::ffff:192.168.71.3
Dec 26 01:15:31 coyote xinetd[2637]: EXIT: amanda status=0 pid=5984 duration=30(sec)
Dec 26 01:15:32 coyote xinetd[2637]: START: amanda pid=6143 from=::ffff:192.168.71.3
Dec 26 01:18:27 coyote kernel: [ 3571.040326] ------------[ cut here ]------------
Dec 26 01:18:27 coyote kernel: [ 3571.040332] kernel BUG at fs/ext4/inode.c:1063!
Dec 26 01:18:27 coyote kernel: [ 3571.040335] invalid opcode: 0000 [#1] PREEMPT SMP 
Dec 26 01:18:27 coyote kernel: [ 3571.040339] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/ATK0110:00/hwmon/hwmon0/in3_input
Dec 26 01:18:27 coyote kernel: [ 3571.040342] Modules linked in: nls_utf8 cifs radeon ttm drm_kms_helper drm agpgart nfsd lockd nfs_acl auth_rpcgss exportfs rfcomm sco 
bnep l2cap autofs4 sunrpc ipv6 or51132 snd_usb_audio snd_usb_lib cx88_dvb snd_emu10k1_synth cx88_vp3054_i2c snd_emux_synth videobuf_dvb snd_seq_virmidi 
snd_seq_midi_emul dvb_core tuner_simple tuner_types tda9887 tda8290 snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss tuner 
snd_seq_midi_event snd_seq cx8800 cx8802 snd_pcm_oss snd_mixer_oss snd_pcm cx88xx snd_seq_device i2c_algo_bit snd_timer ftdi_sio tveeprom snd_page_alloc 
snd_util_mem snd_hwdep v4l2_common snd videodev v4l1_compat firewire_ohci btcx_risc btusb firewire_core usbserial rtc_cmos videobuf_dma_sg rtc_core joydev 
i2c_nforce2 sr_mod soundcore bluetooth videobuf_core asus_atk0110 rtc_lib pcspkr evdev cdrom k10temp hwmon button crc_itu_t sg rfkill usblp sd_mod ext3 jbd uhci_hcd 
ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Dec 26 01:18:27 coyote kernel: [ 3571.040397] 
Dec 26 01:18:27 coyote kernel: [ 3571.040401] Pid: 6382, comm: taper Not tainted 2.6.33-rc2 #2 M2N-SLI DELUXE/System Product Name
Dec 26 01:18:27 coyote kernel: [ 3571.040404] EIP: 0060:[<c10c9d91>] EFLAGS: 00010297 CPU: 2
Dec 26 01:18:27 coyote kernel: [ 3571.040411] EIP is at ext4_get_blocks+0x1e6/0x328
Dec 26 01:18:27 coyote kernel: [ 3571.040413] EAX: 00000001 EBX: 00000008 ECX: f6e81ac4 EDX: c3e20000
Dec 26 01:18:27 coyote kernel: [ 3571.040416] ESI: 00000002 EDI: 00000034 EBP: f6e81a18 ESP: f6e819ec
Dec 26 01:18:27 coyote kernel: [ 3571.040418]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Dec 26 01:18:27 coyote kernel: [ 3571.040421] Process taper (pid: 6382, ti=f6e81000 task=f758c3c0 task.ti=f6e81000)
Dec 26 01:18:27 coyote kernel: [ 3571.040423] Stack:
Dec 26 01:18:27 coyote kernel: [ 3571.040424]  c3e20088 f7241000 c3e20000 c3e20078 f6e81ac5 c3e20234 f68bc400 000017fb
Dec 26 01:18:27 coyote kernel: [ 3571.040429] <0> 00000040 0000000c f6e81ac4 f6e81b08 c10ca1aa 000007cc 00000000 00000040
Dec 26 01:18:27 coyote kernel: [ 3571.040434] <0> f6e81ac4 0000000d f6e81c70 0000000e 000007cc 00000000 f7241000 00000000
Dec 26 01:18:27 coyote kernel: [ 3571.040440] Call Trace:
Dec 26 01:18:27 coyote kernel: [ 3571.040444]  [<c10ca1aa>] ? mpage_da_map_blocks+0xa2/0x6f6
Dec 26 01:18:27 coyote kernel: [ 3571.040450]  [<c10648c7>] ? __set_page_dirty_nobuffers+0xdb/0xe8
Dec 26 01:18:27 coyote kernel: [ 3571.040453]  [<c105eede>] ? unlock_page+0x3e/0x41
Dec 26 01:18:27 coyote kernel: [ 3571.040456]  [<c10c8fe3>] ? ext4_writepage+0xed/0x2a1
Dec 26 01:18:27 coyote kernel: [ 3571.040460]  [<c111c059>] ? radix_tree_gang_lookup_tag_slot+0x76/0x95
Dec 26 01:18:27 coyote kernel: [ 3571.040464]  [<c105e9e8>] ? find_get_pages_tag+0xb6/0xe9
Dec 26 01:18:27 coyote kernel: [ 3571.040467]  [<c10caea5>] ? mpage_add_bh_to_extent+0x9d/0xb7
Dec 26 01:18:27 coyote kernel: [ 3571.040471]  [<c10cafcc>] ? __mpage_da_writepage+0x10d/0x153
Dec 26 01:18:27 coyote kernel: [ 3571.040474]  [<c1063ea1>] ? write_cache_pages+0x158/0x214
Dec 26 01:18:27 coyote kernel: [ 3571.040477]  [<c10caebf>] ? __mpage_da_writepage+0x0/0x153
Dec 26 01:18:27 coyote kernel: [ 3571.040481]  [<c10cac51>] ? ext4_da_writepages+0x453/0x60a
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c10ca7fe>] ? ext4_da_writepages+0x0/0x60a
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c1063fa0>] ? do_writepages+0x1c/0x28
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c109d28b>] ? writeback_single_inode+0xce/0x287
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c109dd0a>] ? writeback_inodes_wb+0x321/0x3e8
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c109df54>] ? writeback_inodes_wbc+0xf/0x11
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c106453f>] ? balance_dirty_pages_ratelimited_nr+0x155/0x2b0
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c10a251a>] ? generic_write_end+0x6d/0x77
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c105e683>] ? generic_file_buffered_write+0x16a/0x1b1
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c105fde8>] ? __generic_file_aio_write+0x3ba/0x3f2
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c105fe72>] ? generic_file_aio_write+0x52/0x93
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c10c4d3a>] ? ext4_file_write+0x8f/0x99
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c10862a8>] ? do_sync_write+0x89/0xc7
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c10fc5be>] ? security_file_permission+0xf/0x11
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c108621f>] ? do_sync_write+0x0/0xc7
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c1086ac9>] ? vfs_write+0x8a/0x113
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c1086beb>] ? sys_write+0x3b/0x60
Dec 26 01:18:27 coyote kernel: [ 3571.040484]  [<c1002853>] ? sysenter_do_call+0x12/0x22
Dec 26 01:18:27 coyote kernel: [ 3571.040484] Code: e8 6c ee ff ff 8b 55 dc 89 c3 8b 82 28 02 00 00 39 c3 76 04 0f 0b eb fe 31 f6 29 d8 74 48 8b 55 dc 8b b2 2c 02 00 00 
39 f0 7d 04 <0f> 0b eb fe 29 f0 89 c2 89 c1 8b 45 ec ff 35 80 1a 36 c1 c1 f9 
Dec 26 01:18:27 coyote kernel: [ 3571.040484] EIP: [<c10c9d91>] ext4_get_blocks+0x1e6/0x328 SS:ESP 0068:f6e819ec
Dec 26 01:18:27 coyote kernel: [ 3571.040596] ---[ end trace 8084987bc31fe9d1 ]---
Dec 26 01:18:27 coyote kernel: [ 3571.040602] note: taper[6382] exited with preempt_count 1
Dec 26 01:20:02 coyote xinetd[2637]: EXIT: amanda status=0 pid=6143 duration=270(sec)
Dec 26 01:20:03 coyote xinetd[2637]: START: amanda pid=6448 from=::ffff:192.168.71.3
Dec 26 01:20:33 coyote xinetd[2637]: EXIT: amanda status=0 pid=6448 duration=30(sec)
Dec 26 01:20:45 coyote xinetd[2637]: START: amanda pid=6494 from=::ffff:192.168.71.3
Dec 26 01:21:15 coyote xinetd[2637]: EXIT: amanda status=0 pid=6494 duration=30(sec)
Dec 26 01:21:15 coyote xinetd[2637]: START: amanda pid=6517 from=::ffff:192.168.71.3
Dec 26 01:51:55 coyote ntpd[2647]: synchronized to 72.52.190.26, stratum 2
Dec 26 02:07:46 coyote xinetd[2637]: EXIT: amanda status=0 pid=6517 duration=2791(sec)
Dec 26 02:07:58 coyote xinetd[2637]: START: amanda pid=7439 from=::ffff:192.168.71.3
Dec 26 02:24:24 coyote ntpd[2647]: synchronized to 69.63.177.217, stratum 2
Dec 26 02:39:59 coyote xinetd[2637]: EXIT: amanda status=0 pid=7439 duration=1921(sec)
Dec 26 02:40:13 coyote xinetd[2637]: START: amanda pid=3593 from=::ffff:192.168.71.3
Dec 26 02:40:43 coyote xinetd[2637]: EXIT: amanda status=0 pid=3593 duration=30(sec)
Dec 26 02:40:58 coyote xinetd[2637]: START: amanda pid=3632 from=::ffff:192.168.71.3
Dec 26 02:41:28 coyote xinetd[2637]: EXIT: amanda status=0 pid=3632 duration=30(sec)
Dec 26 02:41:28 coyote xinetd[2637]: START: amanda pid=3654 from=::ffff:192.168.71.3
Dec 26 02:42:28 coyote xinetd[2637]: EXIT: amanda status=0 pid=3654 duration=60(sec)
Dec 26 02:42:35 coyote xinetd[2637]: START: amanda pid=3703 from=::ffff:192.168.71.3
Dec 26 02:43:05 coyote xinetd[2637]: EXIT: amanda status=0 pid=3703 duration=30(sec)
Dec 26 03:21:42 coyote ntpd[2647]: synchronized to 209.167.68.100, stratum 2
Dec 26 04:19:46 coyote ntpd[2647]: synchronized to 69.63.177.217, stratum 2
Dec 26 06:29:45 coyote ntpd[2647]: synchronized to 209.167.68.100, stratum 2
Dec 26 08:06:12 coyote ntpd[2647]: synchronized to 69.63.177.217, stratum 2
Dec 26 08:31:37 coyote kernel: [29561.848143] [drm] Resetting GPU
Dec 26 08:31:38 coyote dnsmasq[3191]: exiting on receipt of SIGTERM
Dec 26 08:31:38 coyote smartd[3317]: smartd received signal 15: Terminated
Dec 26 08:31:38 coyote smartd[3317]: smartd is exiting (exit status 0)
Dec 26 08:31:38 coyote avahi-daemon[2946]: Got SIGTERM, quitting.
Dec 26 08:31:38 coyote avahi-daemon[2946]: Leaving mDNS multicast group on interface eth0.IPv4 with address 192.168.71.3.
Dec 26 08:31:44 coyote mountd[2695]: Caught signal 15, un-registering and exiting.
Dec 26 08:31:44 coyote kernel: [29568.814363] nfsd: last server has exited, flushing export cache
Dec 26 08:31:45 coyote nmbd[2902]: [2009/12/26 08:31:45,  0] nmbd/nmbd.c:terminate(68)
Dec 26 08:31:45 coyote nmbd[2902]:   Got SIGTERM: going down...
Dec 26 08:31:48 coyote xinetd[2637]: Exiting...
Dec 26 08:32:17 coyote init: rc6 main process (11562) killed by TERM signal
Dec 26 08:32:46 coyote init: rc6 main process (11926) killed by TERM signal
Dec 26 08:36:49 coyote kernel: imklog 3.22.1, log source = /proc/kmsg started.
----------------------------
The walled oopsen however, was complaining about the asus_atk0110 module for
lm_sensors.  That pix is still in the camera if its needed.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)

People love high ideals, but they got to be about 33-percent plausible.
		-- The Best of Will Rogers
