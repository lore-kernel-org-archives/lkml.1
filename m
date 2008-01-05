Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbYAENgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbYAENgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 08:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbYAENgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 08:36:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:30585 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbYAENgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 08:36:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=FoBAqzJjGrlI4P1gj/z4YssLAzVp0LkpzJxOu2YGz+u3evF+lUCono5nqp1YBpwPUQM3RYcXIFQpOk6WrTXrbgZ3p/UcNwrCN4LRAGqAzRGLk9yNkzlWNrvrzK+JBgZ/pPDd19U0Io7nOSmZBbRUwT9yO+S0mbTGb+aBLoErkZ4=
Date: Sat, 5 Jan 2008 17:36:01 +0400
From: Alexander Shaduri <ashaduri@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at virtual address
Message-ID: <20080105173601.75370546@linux.localdomain>
In-Reply-To: <20080105091012.GG27894@ZenIV.linux.org.uk>
References: <20080104213812.20268840@linux.localdomain>
	<20080105091012.GG27894@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008 09:10:12 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> and we have q->page == 0x48464443.  Seeing how we assign that sucker, that
> smells like we've got a page on quicklist with {0x43, 0x44, 0x46, 0x48}
> in its first 4 bytes.  Instead of having address of the next page stored
> in there...
> 
> Do other oopsen of the same kind give the same value?

I've got another oops here with a different value. This time a bttv message
preceded it. Note that the oops happened shortly *after* I stopped capturing
(watching the tv through mplayer).

Output of dmesg:

bttv0: OCERR @ 375e2014,bits: HSYNC OFLOW FDSR OCERR*
(two pages of the same message here)

bttv0: OCERR @ 375e2014,bits: HSYNC OFLOW FDSR OCERR*
bttv0: OCERR @ 375e2014,bits: HSYNC OFLOW FBUS FDSR OCERR*
BUG: unable to handle kernel paging request at virtual address 23232323
 printing eip:
c011d6f8
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in: ppp_generic slhc iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table snd_pcm_oss snd_mixer_oss snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_seq capability commoncap fuse nls_koi8_r nls_cp866 loop dm_mod binfmt_misc uhci_hcd it87 hwmon_vid eeprom nvidia(P) tuner tvaudio snd_emu10k1 bttv snd_rawmidi snd_ac97_codec video_buf firmware_class ir_common ac97_bus snd_pcm snd_seq_device compat_ioctl32 i2c_algo_bit snd_timer snd_page_alloc emu10k1_gp snd_util_mem btcx_risc tveeprom videodev gameport ohci1394 ieee1394 ide_cd snd_hwdep snd v4l2_common v4l1_compat agpgart soundcore i2c_nforce2 thermal button rtc_cmos rtc_core rtc_lib forcedeth k8temp i2c_core hwmon cdrom sg ohci_hcd ehci_hcd usbcore edd fan processor pata_amd
CPU:    0
EIP:    0060:[<c011d6f8>]    Tainted: P        VLI
EFLAGS: 00010202   (2.6.23.12 #1)
EIP is at pgd_alloc+0x28/0x80
eax: c0564101   ebx: 23232323   ecx: f79a5bc0   edx: c2011148
esi: 00000001   edi: ec539544   ebp: 01200011   esp: f5cd9efc
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process amdpwrmon (pid: 5578, ti=f5cd8000 task=f7a14aa0 task.ti=f5cd8000)
Stack: ec539380 f79a5d84 c0126ec6 f5891200 c01277c2 f73ca080 c1dfc40c 4636c065
       f5cd9f1c 00000286 f6edb640 f5cd9fb8 bfb59498 00000000 f6edb550 f6edb550
       ec539380 f04b9264 c04f4c30 000060ae f79a5bc0 ec539380 f5cd9fb8 01200011
Call Trace:
 [<c0126ec6>] mm_init+0xb6/0xe0
 [<c01277c2>] copy_process+0x762/0x1240
 [<c0128526>] do_fork+0x76/0x230
 [<c01885ec>] do_pipe+0x7c/0xf0
 [<c01022c2>] sys_clone+0x32/0x40
 [<c0104362>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 74 26 00 56 53 89 e0 25 00 e0 ff ff ff 40 14 64 8b 15 84 30 56 c0 b8 48 41 56 c0 01 c2 8b 1a 85 db 0f 95 c0 0f b6 f0 85 f6 74 0d <8b> 03 89 02 c7 03 00 00 00 00 ff 4a 04 89 e0 25 00 e0 ff ff ff
EIP: [<c011d6f8>] pgd_alloc+0x28/0x80 SS:ESP 0068:f5cd9efc
note: amdpwrmon[5578] exited with preempt_count 1
BUG: unable to handle kernel paging request at virtual address 23232323
 printing eip:
c011d6f8
*pde = 00000000
Oops: 0000 [#2]
PREEMPT SMP
Modules linked in: ppp_generic slhc iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table snd_pcm_oss snd_mixer_oss snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_seq capability commoncap fuse nls_koi8_r nls_cp866 loop dm_mod binfmt_misc uhci_hcd it87 hwmon_vid eeprom nvidia(P) tuner tvaudio snd_emu10k1 bttv snd_rawmidi snd_ac97_codec video_buf firmware_class ir_common ac97_bus snd_pcm snd_seq_device compat_ioctl32 i2c_algo_bit snd_timer snd_page_alloc emu10k1_gp snd_util_mem btcx_risc tveeprom videodev gameport ohci1394 ieee1394 ide_cd snd_hwdep snd v4l2_common v4l1_compat agpgart soundcore i2c_nforce2 thermal button rtc_cmos rtc_core rtc_lib forcedeth k8temp i2c_core hwmon cdrom sg ohci_hcd ehci_hcd usbcore edd fan processor pata_amd
CPU:    0
EIP:    0060:[<c011d6f8>]    Tainted: P      D VLI
EFLAGS: 00010202   (2.6.23.12 #1)
EIP is at pgd_alloc+0x28/0x80
eax: c0564101   ebx: 23232323   ecx: f03a32c0   edx: c2011148
esi: 00000001   edi: fffffff4   ebp: f739c6c0   esp: dace3f5c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process master (pid: 24800, ti=dace2000 task=ee93aaa0 task.ti=dace2000)
Stack: f03a36c0 db9e0000 c0126ec6 efdb25c0 c01859df f7e6a000 00000011 efdb25c0
       db9e0000 f739c6c0 efdb25c0 c0186f36 8000e310 80010c80 db9e0000 db9e0000
       b7bf0ff4 dace2000 c010260f dace3fb8 80010be0 00000000 c0104362 80010be0
Call Trace:
 [<c0126ec6>] mm_init+0xb6/0xe0
 [<c01859df>] bprm_mm_init+0x1f/0x170
 [<c0186f36>] do_execve+0x66/0x1e0
 [<c010260f>] sys_execve+0x2f/0x80
 [<c0104362>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 74 26 00 56 53 89 e0 25 00 e0 ff ff ff 40 14 64 8b 15 84 30 56 c0 b8 48 41 56 c0 01 c2 8b 1a 85 db 0f 95 c0 0f b6 f0 85 f6 74 0d <8b> 03 89 02 c7 03 00 00 00 00 ff 4a 04 89 e0 25 00 e0 ff ff ff
EIP: [<c011d6f8>] pgd_alloc+0x28/0x80 SS:ESP 0068:dace3f5c
note: master[24800] exited with preempt_count 1
BUG: unable to handle kernel paging request at virtual address 23232323
 printing eip:
c011d6f8
*pde = 00000000
Oops: 0000 [#3]
PREEMPT SMP
Modules linked in: ppp_generic slhc iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table snd_pcm_oss snd_mixer_oss snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_seq capability commoncap fuse nls_koi8_r nls_cp866 loop dm_mod binfmt_misc uhci_hcd it87 hwmon_vid eeprom nvidia(P) tuner tvaudio snd_emu10k1 bttv snd_rawmidi snd_ac97_codec video_buf firmware_class ir_common ac97_bus snd_pcm snd_seq_device compat_ioctl32 i2c_algo_bit snd_timer snd_page_alloc emu10k1_gp snd_util_mem btcx_risc tveeprom videodev gameport ohci1394 ieee1394 ide_cd snd_hwdep snd v4l2_common v4l1_compat agpgart soundcore i2c_nforce2 thermal button rtc_cmos rtc_core rtc_lib forcedeth k8temp i2c_core hwmon cdrom sg ohci_hcd ehci_hcd usbcore edd fan processor pata_amd
CPU:    0
EIP:    0060:[<c011d6f8>]    Tainted: P      D VLI
EFLAGS: 00010202   (2.6.23.12 #1)
EIP is at pgd_alloc+0x28/0x80
eax: c0564101   ebx: 23232323   ecx: f790a740   edx: c2011148
esi: 00000001   edi: f7970cc4   ebp: 01200011   esp: f6febefc
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process syslogd (pid: 4928, ti=f6fea000 task=f71b5000 task.ti=f6fea000)
Stack: f7970b00 f790a904 c0126ec6 f04d0200 c01277c2 cad72000 c017fce5 dd0888c0
       00000000 00000286 ed5750f0 f6febfb8 bfb65ce8 00000000 ed575000 ed575000
       f7970b00 f04b9924 c04f4c30 000060e1 f790a740 f7970b00 f6febfb8 01200011
Call Trace:
 [<c0126ec6>] mm_init+0xb6/0xe0
 [<c01277c2>] copy_process+0x762/0x1240
 [<c017fce5>] nameidata_to_filp+0x35/0x40
 [<c0128526>] do_fork+0x76/0x230
 [<c0180fbc>] vfs_llseek+0x3c/0x50
 [<c01022c2>] sys_clone+0x32/0x40
 [<c0104362>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 74 26 00 56 53 89 e0 25 00 e0 ff ff ff 40 14 64 8b 15 84 30 56 c0 b8 48 41 56 c0 01 c2 8b 1a 85 db 0f 95 c0 0f b6 f0 85 f6 74 0d <8b> 03 89 02 c7 03 00 00 00 00 ff 4a 04 89 e0 25 00 e0 ff ff ff
EIP: [<c011d6f8>] pgd_alloc+0x28/0x80 SS:ESP 0068:f6febefc
note: syslogd[4928] exited with preempt_count 1


Thanks,
Alexander

