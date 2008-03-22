Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbYCVWtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbYCVWtb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 18:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbYCVWtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 18:49:24 -0400
Received: from animx.eu.org ([216.98.75.249]:57152 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbYCVWtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 18:49:22 -0400
X-Greylist: delayed 1428 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Mar 2008 18:49:21 EDT
Date: Sat, 22 Mar 2008 18:25:31 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24.3 bug in sysfs with md.
Message-ID: <20080322222531.GA12182@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was poking around with the files laying in /sys/block/md*/md/dev-*/super
and found this bug (NOTE: I attempted to read the file 2 times):

[ 5591.212764] ------------[ cut here ]------------
[ 5591.212773] kernel BUG at /usr/src/linux/dist/2.6.24.3/fs/sysfs/file.c:126!
[ 5591.212778] invalid opcode: 0000 [#1] PREEMPT SMP 
[ 5591.212784] Modules linked in: xt_mark xt_mac xt_MARK iptable_mangle isofs nls_base usbhid ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async crc_ccitt radeon drm nfsd lockd exportfs sunrpc parport_pc parport 8250_pnp snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc i2c_i801 i2c_core sg sr_mod cdrom ata_piix libata asix usbnet mii ehci_hcd uhci_hcd usbcore intel_agp agpgart iptable_nat nf_nat xt_limit ipt_LOG xt_state xt_tcpudp ipt_recent nf_conntrack_ipv4 xt_conntrack nf_conntrack ipt_REJECT iptable_filter ip_tables x_tables tun bitrev crc32 ppp_generic slhc e1000 bridge llc reiserfs ext2 raid1 dm_snapshot dm_mirror dm_mod rtc 8250 serial_core
[ 5591.212886] 
[ 5591.212891] Pid: 11834, comm: grep Not tainted (2.6.24.3 #2)
[ 5591.212895] EIP: 0060:[<c019465f>] EFLAGS: 00010212 CPU: 0
[ 5591.212905] EIP is at sysfs_read_file+0xd6/0xda
[ 5591.212909] EAX: 00000001 EBX: f7500b40 ECX: 00000000 EDX: f6d9dc6c
[ 5591.212914] ESI: 00001000 EDI: f6d9dc14 EBP: f7500b54 ESP: f183bf50
[ 5591.212918]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 5591.212923] Process grep (pid: 11834, ti=f183a000 task=f2cc7570 task.ti=f183a000)
[ 5591.212927] Stack: 00000004 0000001c 00008000 08062000 c034fb10 f6cf0ac4 f51ac380 08062000 
[ 5591.212940]        f183bfa0 00008000 c015d8ac f183bfa0 00000020 c0194589 f51ac380 fffffff7 
[ 5591.212951]        00009001 f183a000 c015dcee f183bfa0 00000000 00000000 00000000 00000004 
[ 5591.212963] Call Trace:
[ 5591.212992]  [<c015d8ac>] vfs_read+0x89/0x117
[ 5591.213007]  [<c0194589>] sysfs_read_file+0x0/0xda
[ 5591.213025]  [<c015dcee>] sys_read+0x41/0x6a
[ 5591.213046]  [<c0103402>] syscall_call+0x7/0xb
[ 5591.213076]  [<c02a0000>] igmpv3_sendpack+0x4/0xb6
[ 5591.213103]  =======================
[ 5591.213106] Code: e8 c2 79 11 00 89 f0 83 c4 18 5b 5e 5f 5d c3 b8 d0 00 00 00 e8 4f d8 fa ff 89 43 0c 85 c0 0f 85 74 ff ff ff be f4 ff ff ff eb d3 <0f> 0b eb fe 55 57 56 53 83 ec 04 89 c7 89 d5 89 0c 24 8b 74 24 
[ 5591.213172] EIP: [<c019465f>] sysfs_read_file+0xd6/0xda SS:ESP 0068:f183bf50
[ 5591.213188] ---[ end trace 800d6d1bf01f2a42 ]---
[ 5606.444691] ------------[ cut here ]------------
[ 5606.444698] kernel BUG at /usr/src/linux/dist/2.6.24.3/fs/sysfs/file.c:126!
[ 5606.444702] invalid opcode: 0000 [#2] PREEMPT SMP 
[ 5606.444706] Modules linked in: xt_mark xt_mac xt_MARK iptable_mangle isofs nls_base usbhid ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async crc_ccitt radeon drm nfsd lockd exportfs sunrpc parport_pc parport 8250_pnp snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc i2c_i801 i2c_core sg sr_mod cdrom ata_piix libata asix usbnet mii ehci_hcd uhci_hcd usbcore intel_agp agpgart iptable_nat nf_nat xt_limit ipt_LOG xt_state xt_tcpudp ipt_recent nf_conntrack_ipv4 xt_conntrack nf_conntrack ipt_REJECT iptable_filter ip_tables x_tables tun bitrev crc32 ppp_generic slhc e1000 bridge llc reiserfs ext2 raid1 dm_snapshot dm_mirror dm_mod rtc 8250 serial_core
[ 5606.444777] 
[ 5606.444780] Pid: 11835, comm: less Tainted: G      D (2.6.24.3 #2)
[ 5606.444783] EIP: 0060:[<c019465f>] EFLAGS: 00010212 CPU: 0
[ 5606.444792] EIP is at sysfs_read_file+0xd6/0xda
[ 5606.444795] EAX: 00000001 EBX: f7500480 ECX: 00000000 EDX: f6d9dc6c
[ 5606.444798] ESI: 00001000 EDI: f6d9dc14 EBP: f7500494 ESP: ec4b9f50
[ 5606.444800]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 5606.444804] Process less (pid: 11835, ti=ec4b8000 task=f6c6c030 task.ti=ec4b8000)
[ 5606.444806] Stack: 00000005 0000001b 00000040 bfb05e6c c034fb10 f6cf0ac4 f51ac080 bfb05e6c 
[ 5606.444815]        ec4b9fa0 00000040 c015d8ac ec4b9fa0 c015cc31 c0194589 f51ac080 fffffff7 
[ 5606.444823]        bfb05e6c ec4b8000 c015dcee ec4b9fa0 00000000 00000000 00000000 00000005 
[ 5606.444831] Call Trace:
[ 5606.444855]  [<c015d8ac>] vfs_read+0x89/0x117
[ 5606.444864]  [<c015cc31>] vfs_llseek+0x36/0x3c
[ 5606.444868]  [<c0194589>] sysfs_read_file+0x0/0xda
[ 5606.444881]  [<c015dcee>] sys_read+0x41/0x6a
[ 5606.444897]  [<c0103402>] syscall_call+0x7/0xb
[ 5606.444922]  [<c02a0000>] igmpv3_sendpack+0x4/0xb6
[ 5606.444945]  =======================
[ 5606.444947] Code: e8 c2 79 11 00 89 f0 83 c4 18 5b 5e 5f 5d c3 b8 d0 00 00 00 e8 4f d8 fa ff 89 43 0c 85 c0 0f 85 74 ff ff ff be f4 ff ff ff eb d3 <0f> 0b eb fe 55 57 56 53 83 ec 04 89 c7 89 d5 89 0c 24 8b 74 24 
[ 5606.444994] EIP: [<c019465f>] sysfs_read_file+0xd6/0xda SS:ESP 0068:ec4b9f50
[ 5606.445018] ---[ end trace 800d6d1bf01f2a42 ]---

.config is available on request  Kernel is stock, no vendor/local
modifications

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
