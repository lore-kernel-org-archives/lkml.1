Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbYAVNkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbYAVNkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 08:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYAVNkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 08:40:46 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:32475 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYAVNkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 08:40:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=D7vJZLQtfb8cMoz7b4lBNkSOoteQzzhMFJx5oX3vcbnYL1HixelK5GYS9Kyy7LwsjQIK6I8UtebBpGC7O/OL9cKUhV9CHssWgS+xKKdqaX+6UuL1X0edatXbgc2e4v2m2DOqrZGFlE3MstMXp5k9g9JPuJ5kaGnTX4Aqg4xJXx8=
Date: Tue, 22 Jan 2008 17:40:02 +0400
From: Alexander Shaduri <ashaduri@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at virtual address
Message-ID: <20080122174002.50f28c76@linux.localdomain>
In-Reply-To: <20080105212050.GA2434@martell.zuzino.mipt.ru>
References: <20080104213812.20268840@linux.localdomain>
	<20080105091012.GG27894@ZenIV.linux.org.uk>
	<20080105173601.75370546@linux.localdomain>
	<18303.38257.850625.70108@harpo.it.uu.se>
	<20080105184656.52b1f7d3@linux.localdomain>
	<20080105201622.GL27894@ZenIV.linux.org.uk>
	<20080106003034.15a75d4c@linux.localdomain>
	<20080105212050.GA2434@martell.zuzino.mipt.ru>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008 00:20:50 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Sun, Jan 06, 2008 at 12:30:34AM +0400, Alexander Shaduri wrote:
> > > Get a serial console?  Take another box, plug e.g. pl2303-based
> > > usb-to-serial (several bucks these days) into it, stick null-modem
> > > convertor (ditto) on its serial end and attach to ttyS0 on the
> > > victim.  console=ttyS0 on victim, something like minicom on watcher
> > > and tell it to capture log into file...
> > 
> > I will try that (as soon as I acquire the necessary parts).
> 
> netconsole should be more quick:

Sorry for late reply, but all my attempts to log via network failed - every time
only ~700 bytes were transferred, so the logs were non-informative.

Finally, I got the logging working with a serial console, using
console=tty0 console=ttyS0,9600 ignore_loglevel

Anyway, see the crash log below.

Just a few additional notes - I was trying to get rid of the problem by
trying various things, like:
* Plugging the bttv card to an alternative PCI slot.
* Swapping the bttv card with another card: I had an Avermedia 203
tv tuner card before and I tried using Avermedia EZCapture (same bttv
chipset, without a tv tuner).
* loading bttv module with no_overlay=1.
* "maxcpus=1" kernel option
* Compiling kernel git snapshot (2008-01-09) from
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git
in case it was fixed in the development tree.

None of the above helped anything.

Here's a log (2.6.23.12, no X running, Avermedia EZCapture card;
capturing for several hours, then stopping, then capturing again - crash!):

------

BUG: unable to handle kernel paging request at virtual address 968e8787
 printing eip:
c017dc67
*pde = 00000000
Oops: 0002 [#1]
PREEMPT SMP
Modules linked in: bttv video_buf ir_common compat_ioctl32 i2c_algo_bit btcx_risc tveeprom videodev v4l2_common v4l1_compat netconsole iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table snd_pcm_oss snd_mixer_oss snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_seq capability commoncap fuse nls_koi8_r nls_cp866 loop dm_mod binfmt_misc uhci_hcd it87 hwmon_vid eeprom snd_emu10k1 snd_rawmidi firmware_class snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep rtc_cmos snd rtc_core forcedeth parport_pc ide_cd ohci1394 agpgart emu10k1_gp soundcore gameport i2c_nforce2 k8temp rtc_lib parport ieee1394 hwmon cdrom thermal button sg i2c_core ohci_hcd ehci_hcd usbcore edd fan processor pata_amd
CPU:    1
EIP:    0060:[<c017dc67>]    Not tainted VLI
EFLAGS: 00210046   (2.6.23.12 #3)
EIP is at cache_alloc_refill+0x147/0x520
eax: c20eec80   ebx: ffffffff   ecx: 0000003c   edx: 968e8783
esi: 00000022   edi: f52f0000   ebp: c2131a00   esp: f6a7fc1c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process mencoder (pid: 5465, ti=f6a7e000 task=c2206550 task.ti=f6a7e000)
Stack: 00000050 00000000 c20eec88 c20eec90 c20eeca4 c03fca90 00008050 c20fc7c0
       c20e9800 c20eec80 f785bc00 00001000 0000000c 00060007 f52f001c c1b279a0
       00008050 00200286 c20fc7c0 c017dafb c1b279a0 00000000 00000000 00001000
Call Trace:
 [<c017dafb>] kmem_cache_alloc+0x6b/0x90
 [<c01a22e0>] alloc_buffer_head+0x10/0x60
 [<c01a2c28>] alloc_page_buffers+0x78/0xc0
 [<c01a2c81>] create_empty_buffers+0x11/0x90
 [<c01a3cbe>] __block_prepare_write+0x41e/0x4f0
 [<c02075e8>] start_this_handle+0x368/0x4d0
 [<c0207803>] journal_start+0xb3/0xe0
 [<c01a3db8>] block_prepare_write+0x28/0x40
 [<c01f7030>] ext3_get_block+0x0/0x100
 [<c01f872a>] ext3_prepare_write+0x4a/0x190
 [<c01f7030>] ext3_get_block+0x0/0x100
 [<c0161b29>] generic_file_buffered_write+0x289/0x6b0
 [<c03e8d16>] schedule+0x1d6/0x6c0
 [<c0126187>] check_preempt_curr_fair+0x57/0x90
 [<c0162204>] __generic_file_aio_write_nolock+0x2b4/0x530
 [<c01474ae>] futex_wait+0x23e/0x310
 [<c01624e5>] generic_file_aio_write+0x65/0xe0
 [<c0146771>] get_futex_key+0x51/0x150
 [<c01f42b0>] ext3_file_write+0x30/0xc0
 [<c01813a5>] do_sync_write+0xd5/0x120
 [<c0147af9>] do_futex+0x239/0xb20
 [<c013d1c0>] autoremove_wake_function+0x0/0x40
 [<c0136616>] __atomic_notifier_call_chain+0x26/0x50
 [<c01812d0>] do_sync_write+0x0/0x120
 [<c0181c5f>] vfs_write+0xbf/0x140
 [<c01822e1>] sys_write+0x41/0x70
 [<c0104362>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 77 10 8b 77 14 8b 44 24 38 03 57 0c 8b 34 b0 89 77 14 89 54 8d 18 41 89 4d 00 8b 44 24 1c 8b 77 10 3b 70 38 72 c4 8b 17 8b 47 04 <89> 42 04 89 10 83 7f 14 ff c7 07 00 01 10 00 c7 47 04 00 02 20
EIP: [<c017dc67>] cache_alloc_refill+0x147/0x520 SS:ESP 0068:f6a7fc1c
note: mencoder[5465] exited with preempt_count 1
bttv0: timeout: drop=3 irq=1002400/1002400, risc=350dc3c4, bits: HSYNC OFLOW
bttv0: reset, reinitialize
bttv0: PLL: 28636363 => 35468950 . ok
bttv0: timeout: drop=12 irq=1002413/1002413, risc=35a10a8c, bits: OFLOW
bttv0: reset, reinitialize
bttv0: PLL: 28636363 => 35468950 . ok
bttv0: timeout: drop=22 irq=1002425/1002425, risc=35a111a4, bits: OFLOW
bttv0: reset, reinitialize
bttv0: PLL: 28636363 => 35468950 . ok
bttv0: timeout: drop=33 irq=1002438/1002438, risc=3544ced4, bits: HSYNC OFLOW
bttv0: reset, reinitialize


