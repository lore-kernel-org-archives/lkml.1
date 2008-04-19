Return-Path: <linux-kernel-owner+w=401wt.eu-S1761897AbYDSDOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761897AbYDSDOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 23:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbYDSDN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 23:13:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755012AbYDSDNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 23:13:55 -0400
Date: Fri, 18 Apr 2008 20:08:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Fannin <jfannin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-mm1
Message-Id: <20080418200827.592f95ec.akpm@linux-foundation.org>
In-Reply-To: <20080419022559.GB3503@nineveh.local>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	<20080419022559.GB3503@nineveh.local>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 22:25:59 -0400 Joseph Fannin <jfannin@gmail.com> wrote:

> On Fri, Apr 18, 2008 at 01:47:57AM -0700, Andrew Morton wrote:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1/
> 
> I've been seeing the following backtrace since (I think)
> 2.6.25-rc8-mm2.
> 
> I'm sending multiple reports vs. 2.6.25-mm1, so I'm putting the dmesg
> and .config on a server:
> 
> http://home.columbus.rr.com/jfannin3/dmesg.txt
> http://home.columbus.rr.com/jfannin3/config-2.6.25-mm1.txt

Thanks.

> [  400.781246] WARNING: at arch/x86/mm/ioremap.c:158 __ioremap_caller+0x27d/0x2e0()

I don't think I've seen that one before.

> [  406.935080] sysfs: duplicate filename '189:0' can not be created

Seen plenty of them - I think Greg today dropped the offending patch(es).

[  451.915553] sysfs: duplicate filename 'pcspkr' can not be created

Yup.  Maybe the above droppage will make this go away, I'm not sure.

> [  842.795144] hm, dftrace overflow: 265 changes (0 total) in 428 usecs
> [  842.795182] ------------[ cut here ]------------
> [  842.795192] WARNING: at kernel/trace/ftrace.c:658 ftraced+0x1a4/0x1b0()
> [  842.795200] Modules linked in: af_packet rfcomm l2cap bluetooth ppdev ipv6 cpufreq_conservative cpufreq_stats cpufreq_userspace cpufreq_powersave video output wmi pci_slot container dock sbs sbshcbattery iptable_filter ip_tables x_tables ext2 ac lp loop snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi psmouse snd_rawmidi serio_raw snd_seq_midi_event snd_seq button i2c_viapro snd_timer snd_seq_device pcspkr i2c_core snd snd_page_alloc via686a shpchp pci_hotplug parport_pc parport via_agp agpgart soundcore evdev sg sr_mod cdrom sd_mod 8139cp aic7xxx scsi_transport_spi scsi_mod 8139too mii uhci_hcd usbcore raid10 raid456 async_xor async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal processor fan fuse ext4dev mbcache jbd2 crc16
> [  842.795470] Pid: 13, comm: ftraced Tainted: G        W 2.6.25-mm1 #7
> [  842.795497]  [<c0130fa9>] warn_on_slowpath+0x59/0x80
> [  842.795541]  [<c013244f>] ? vprintk+0x33f/0x4a0
> [  842.795589]  [<c0155216>] ? trace_hardirqs_on_caller+0x16/0x150
> [  842.795622]  [<c0354eb0>] ? __mutex_lock_common+0x2b0/0x3c0
> [  842.795667]  [<c0155216>] ? trace_hardirqs_on_caller+0x16/0x150
> [  842.795688]  [<c015535b>] ? trace_hardirqs_on+0xb/0x10
> [  842.795709]  [<c017e4d0>] ? __ftrace_update_code+0x0/0x110
> [  842.795730]  [<c017e9f0>] ? ftraced+0x0/0x1b0
> [  842.795746]  [<c01325d0>] ? printk+0x20/0x30
> [  842.795764]  [<c017e9f0>] ? ftraced+0x0/0x1b0
> [  842.795780]  [<c017eb94>] ftraced+0x1a4/0x1b0
> [  842.795807]  [<c0146527>] kthread+0x47/0x80
> [  842.795836]  [<c01464e0>] ? kthread+0x0/0x80
> [  842.795855]  [<c0104d9b>] kernel_thread_helper+0x7/0x10
> [  842.795890]  =======================
> [  842.795899] ---[ end trace 4eaa2a86a8e2da22 ]---

I haven't seen that one before.
