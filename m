Return-Path: <linux-kernel-owner+w=401wt.eu-S1761268AbYDSC0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268AbYDSC0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 22:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759774AbYDSC0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 22:26:06 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:32980 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760937AbYDSC0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 22:26:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=dgu2NkROQJ1RAn4JkMAzF6i71Q7PR1UD3Hjhkb3t2JeCNsuVKv4lpiNpFDIL89QnoURoh+3q1gX/afvntgv8YSScV+WLoSKU2NSQ24GV/8Wi0moBijx3O3Q0oQ1GePLGTBNRSeVHsscfrGuBNwXj/6OG3yjI92KmDC6LlAk6nME=
Date: Fri, 18 Apr 2008 22:25:59 -0400
From: Joseph Fannin <jfannin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1
Message-ID: <20080419022559.GB3503@nineveh.local>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 01:47:57AM -0700, Andrew Morton wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1/

I've been seeing the following backtrace since (I think)
2.6.25-rc8-mm2.

I'm sending multiple reports vs. 2.6.25-mm1, so I'm putting the dmesg
and .config on a server:

http://home.columbus.rr.com/jfannin3/dmesg.txt
http://home.columbus.rr.com/jfannin3/config-2.6.25-mm1.txt

[  842.795144] hm, dftrace overflow: 265 changes (0 total) in 428 usecs
[  842.795182] ------------[ cut here ]------------
[  842.795192] WARNING: at kernel/trace/ftrace.c:658 ftraced+0x1a4/0x1b0()
[  842.795200] Modules linked in: af_packet rfcomm l2cap bluetooth ppdev ipv6 cpufreq_conservative cpufreq_stats cpufreq_userspace cpufreq_powersave video output wmi pci_slot container dock sbs sbshcbattery iptable_filter ip_tables x_tables ext2 ac lp loop snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_mpu401_uart snd_seq_dummy snd_seq_oss snd_seq_midi psmouse snd_rawmidi serio_raw snd_seq_midi_event snd_seq button i2c_viapro snd_timer snd_seq_device pcspkr i2c_core snd snd_page_alloc via686a shpchp pci_hotplug parport_pc parport via_agp agpgart soundcore evdev sg sr_mod cdrom sd_mod 8139cp aic7xxx scsi_transport_spi scsi_mod 8139too mii uhci_hcd usbcore raid10 raid456 async_xor async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal processor fan fuse ext4dev mbcache jbd2 crc16
[  842.795470] Pid: 13, comm: ftraced Tainted: G        W 2.6.25-mm1 #7
[  842.795497]  [<c0130fa9>] warn_on_slowpath+0x59/0x80
[  842.795541]  [<c013244f>] ? vprintk+0x33f/0x4a0
[  842.795589]  [<c0155216>] ? trace_hardirqs_on_caller+0x16/0x150
[  842.795622]  [<c0354eb0>] ? __mutex_lock_common+0x2b0/0x3c0
[  842.795667]  [<c0155216>] ? trace_hardirqs_on_caller+0x16/0x150
[  842.795688]  [<c015535b>] ? trace_hardirqs_on+0xb/0x10
[  842.795709]  [<c017e4d0>] ? __ftrace_update_code+0x0/0x110
[  842.795730]  [<c017e9f0>] ? ftraced+0x0/0x1b0
[  842.795746]  [<c01325d0>] ? printk+0x20/0x30
[  842.795764]  [<c017e9f0>] ? ftraced+0x0/0x1b0
[  842.795780]  [<c017eb94>] ftraced+0x1a4/0x1b0
[  842.795807]  [<c0146527>] kthread+0x47/0x80
[  842.795836]  [<c01464e0>] ? kthread+0x0/0x80
[  842.795855]  [<c0104d9b>] kernel_thread_helper+0x7/0x10
[  842.795890]  =======================
[  842.795899] ---[ end trace 4eaa2a86a8e2da22 ]---

--
Joseph Fannin
jfannin@gmail.com

