Return-Path: <linux-kernel-owner+w=401wt.eu-S1758423AbZCUT2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbZCUT2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbZCUT0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:26:23 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:40961 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644AbZCUT0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:26:22 -0400
Subject: Re: [Announce] 2.6.29-rc8-rt2
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: nando@ccrma.Stanford.EDU, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1237662372.3574.2.camel@localhost.localdomain>
References: <1235437021.4462.25.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902241120320.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241729590.3523@localhost.localdomain>
	 <1235513895.3816.11.camel@localhost.localdomain>
	 <1235595160.9252.49.camel@localhost.localdomain>
	 <1235619922.31774.17.camel@localhost.localdomain>
	 <1236984825.10748.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903140845430.29264@localhost.localdomain>
	 <1237661053.3196.10.camel@localhost.localdomain>
	 <20090321184904.GA19352@elte.hu>
	 <1237662372.3574.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 12:27:04 -0700
Message-Id: <1237663624.3200.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-21 at 12:06 -0700, Fernando Lopez-Lezcano wrote:
> On Sat, 2009-03-21 at 19:49 +0100, Ingo Molnar wrote:
> > * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> > 
> > > Mar 21 10:47:43 localhost kernel: kernel tried to execute NX-protected
> > > page - exploit attempt? (uid: 0)
> > > Mar 21 10:47:43 localhost kernel: BUG: unable to handle kernel paging
> > > request at f6400800
> > 
> > kernel tried to execute some really weird address, probably via a 
> > function pointer.
> 
> Strangely enough rc8-rt1 boots (almost). _Exact_ same build with the
> exception of the change from rt1 -> rt2. 
> 
> Haldaemon does not start on boot (fails), if I login as root and start
> the haldaemon service manually it starts. And then things seem to work
> fine (I'm writing this email from that machine). Still investigating...

First problem was due to old firmware for the iwl3945 hardware. I
updated to the latest and hal started fine (this is on fc9). 

Now another one related to xorg/drm...
Oh well...
-- Fernando



Mar 21 12:17:51 localhost kernel: ------------[ cut here ]------------
Mar 21 12:17:51 localhost kernel: kernel BUG at
drivers/gpu/drm/drm_fops.c:146!
Mar 21 12:17:51 localhost kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
Mar 21 12:17:51 localhost kernel: last sysfs
file: /sys/devices/pci0000:00/0000:00:02.0/drm/card0/dri_library_name
Mar 21 12:17:51 localhost kernel: Modules linked in: i915 drm
i2c_algo_bit bridge stp bnep rfcomm l2cap sunrpc ip6t_REJECT
nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 cpufreq_ondemand
acpi_cpufreq dm_multipath snd_hda_codec_analog snd_hda_intel
snd_hda_codec snd_hwdep thinkpad_acpi snd_seq_dummy snd_seq_oss
snd_seq_midi_event hwmon snd_seq sdhci_pci arc4 snd_seq_device sdhci
pcspkr joydev mmc_core snd_pcm_oss ecb i2c_i801 yenta_socket
snd_mixer_oss rsrc_nonstatic ricoh_mmc ohci1394 iTCO_wdt
iTCO_vendor_support i2c_core iwl3945 snd_pcm video snd_timer snd rfkill
output soundcore e1000e mac80211 btusb snd_page_alloc lib80211 bluetooth
cfg80211 ata_generic pata_acpi uhci_hcd ohci_hcd ehci_hcd [last
unloaded: microcode]
Mar 21 12:17:51 localhost kernel:
Mar 21 12:17:51 localhost kernel: Pid: 2809, comm: Xorg Not tainted
(2.6.29-0.2.rt1.1.rc8.fc9.ccrma.i686.rtPAE #1) 6463CTO
Mar 21 12:17:51 localhost kernel: EIP: 0060:[<f85a7471>] EFLAGS:
00013216 CPU: 0
Mar 21 12:17:51 localhost kernel: EIP is at drm_open+0x442/0x48d [drm]
Mar 21 12:17:51 localhost kernel: EAX: f59339a4 EBX: f45a582c ECX:
f4584564 EDX: f45a5800
Mar 21 12:17:51 localhost kernel: ESI: 00000000 EDI: f45a582c EBP:
f4570e64 ESP: f4570e40
Mar 21 12:17:51 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033
SS: 0068 preempt:00000001
Mar 21 12:17:51 localhost kernel: Process Xorg (pid: 2809, ti=f4570000
task=f44e6d70 task.ti=f4570000)
Mar 21 12:17:51 localhost kernel: Stack:
Mar 21 12:17:51 localhost kernel: f4955e00 f4584564 f45a5800 f5883400
00000000 f45ca394 ffffffed f85b2338
Mar 21 12:17:51 localhost kernel: f4955e00 f4570e7c f85a6fe4 f4584564
00000000 f45433c0 f45433c0 f4570ea0
Mar 21 12:17:51 localhost kernel: c04ae3bd f4955e00 f4584564 00000000
00000000 f4955e00 00000000 f4584564
Mar 21 12:17:51 localhost kernel: Call Trace:
Mar 21 12:17:51 localhost kernel: [<f85a6fe4>] ? drm_stub_open+0xa5/0xf0
[drm]
Mar 21 12:17:51 localhost kernel: [<c04ae3bd>] ? chrdev_open+0x112/0x129
Mar 21 12:17:51 localhost kernel: [<c04aa8a5>] ? __dentry_open
+0x146/0x23a
Mar 21 12:17:51 localhost kernel: [<c04aaa33>] ? nameidata_to_filp
+0x2c/0x43
Mar 21 12:17:51 localhost kernel: [<c04ae2ab>] ? chrdev_open+0x0/0x129
Mar 21 12:17:51 localhost kernel: [<c04b489c>] ? do_filp_open
+0x35d/0x677
Mar 21 12:17:51 localhost kernel: [<c0456d82>] ? rt_spin_lock_fastlock
+0x27/0x5e
Mar 21 12:17:51 localhost kernel: [<c0456d82>] ? rt_spin_lock_fastlock
+0x27/0x5e
Mar 21 12:17:51 localhost kernel: [<c04aa68b>] ? do_sys_open+0x42/0xb7
Mar 21 12:17:51 localhost kernel: [<c04aa742>] ? sys_open+0x1e/0x26
Mar 21 12:17:51 localhost kernel: [<c0408720>] ? sysenter_do_call
+0x12/0x28
Mar 21 12:17:51 localhost kernel: Code: 83 c3 2c 89 d8 e8 a5 ea 13 c8 8b
4d e8 83 79 04 01 75 2e 8b 55 e4 8b 82 d4 02 00 00 85 c0 74 0f 8b 4d e0
3b 81 e0 00 00 00 74 16 <0f> 0b eb fe 8b 55 e0 8b 4d e4 8b 82 e0 00 00
00 89 81 d4 02 00 
Mar 21 12:17:51 localhost kernel: EIP: [<f85a7471>] drm_open+0x442/0x48d
[drm] SS:ESP 0068:f4570e40
Mar 21 12:17:51 localhost kernel: ---[ end trace ebf0ba7e33809de9 ]---



