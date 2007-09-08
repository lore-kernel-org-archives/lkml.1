Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbXIHXJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbXIHXJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 19:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbXIHXI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 19:08:58 -0400
Received: from mo-p07-ob.rzone.de ([81.169.146.189]:51850 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbXIHXI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 19:08:57 -0400
Date: Sun, 9 Sep 2007 01:08:55 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: crash while playing bzflag
Message-ID: <20070908230855.GA2645@steel.home>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
Mail-Followup-To: Alex Riesen <raa.lkml@gmail.com>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20070907195611.GA3259@steel.home> <6bffcb0e0709071618j200005d3t6aa461c34201d783@mail.gmail.com> <20070908181213.GB4019@steel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070908181213.GB4019@steel.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-RZG-AUTH: z4gQVF2k5XWuW3Cculz1E31xFw==
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Riesen, Sat, Sep 08, 2007 20:12:13 +0200:
> Michal Piotrowski, Sat, Sep 08, 2007 01:18:10 +0200:
> > Hi Alex,
> > 
> > On 07/09/2007, Alex Riesen <raa.lkml@gmail.com> wrote:
> > > Kernel: v2.6.23-rc5+ (b21010ed6498391c0f359f2a89c907533fe07fec)
> > 
> > Is this a post 2.6.22 regression?
> 

Probably not. I can kill the machine on 2.6.22.6 as good as on
2.6.23-rc5. Even without anything in log: just by trying to connect to
a server with players. Will try to connect a serial console tomorrow,
err... later today.

I saw this in logs once, but the machine was running after the BUG:

Sep  9 00:46:19 steel kernel: agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
Sep  9 00:46:19 steel kernel: agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
Sep  9 00:46:19 steel kernel: agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
Sep  9 00:46:19 steel kernel: [drm] Loading R200 Microcode
Sep  9 00:46:27 steel kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000010
Sep  9 00:46:27 steel kernel:  printing eip:
Sep  9 00:46:27 steel kernel: f9c09bb2
Sep  9 00:46:27 steel kernel: *pde = 00000000
Sep  9 00:46:27 steel kernel: Oops: 0000 [#1]
Sep  9 00:46:27 steel kernel: PREEMPT SMP 
Sep  9 00:46:27 steel kernel: Modules linked in: binfmt_misc nfs radeon drm nfsd exportfs lockd sunrpc fan button firmware_class it87 hwmon_vid hwmon i2c_isa p4_clockmod speedstep_lib ipv6 sg sr_mod cdrom usb_storage snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore generic floppy snd_page_alloc e100 ide_core ehci_hcd uhci_hcd intel_agp agpgart evdev
Sep  9 00:46:27 steel kernel: CPU:    0
Sep  9 00:46:27 steel kernel: EIP:    0060:[<f9c09bb2>]    Not tainted VLI
Sep  9 00:46:27 steel kernel: EFLAGS: 00210246   (2.6.22.6 #3)
Sep  9 00:46:27 steel kernel: EIP is at radeon_irq_wait+0xdf/0x138 [radeon]
Sep  9 00:46:27 steel kernel: eax: 00000000   ebx: f6c9dc00   ecx: f4f92000   edx: 00200213
Sep  9 00:46:27 steel kernel: esi: 0000214c   edi: ffffdf23   ebp: f4f92f00   esp: f4f92ed0
Sep  9 00:46:27 steel kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Sep  9 00:46:27 steel kernel: Process bzflag (pid: 2616, ti=f4f92000 task=f4d314c0 task.ti=f4f92000)
Sep  9 00:46:27 steel kernel: Stack: f6cae800 f9c14ba8 f4f92f00 00000000 f4d314c0 c0114436 f6c9dd00 f6c9dd00 
Sep  9 00:46:27 steel kernel:        0000214c f9c09ad3 00000057 f9c14bd8 f4f92f44 f996811c 082af558 00000000 
Sep  9 00:46:27 steel kernel:        0003ddfe f4f92f34 c180e120 f4f92f40 00200246 40046457 f4bf9a80 f6c1dbb0 
Sep  9 00:46:27 steel kernel: Call Trace:
Sep  9 00:46:27 steel kernel:  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2f
Sep  9 00:46:27 steel kernel:  [show_stack_log_lvl+157/165] show_stack_log_lvl+0x9d/0xa5
Sep  9 00:46:27 steel kernel:  [show_registers+497/818] show_registers+0x1f1/0x332
Sep  9 00:46:27 steel kernel:  [die+272/529] die+0x110/0x211
Sep  9 00:46:27 steel kernel:  [do_page_fault+1061/1268] do_page_fault+0x425/0x4f4
Sep  9 00:46:27 steel kernel:  [error_code+114/120] error_code+0x72/0x78
Sep  9 00:46:27 steel kernel:  [<f996811c>] drm_ioctl+0x154/0x19c [drm]
Sep  9 00:46:27 steel kernel:  [do_ioctl+139/163] do_ioctl+0x8b/0xa3
Sep  9 00:46:27 steel kernel:  [vfs_ioctl+562/581] vfs_ioctl+0x232/0x245
Sep  9 00:46:27 steel kernel:  [sys_ioctl+49/72] sys_ioctl+0x31/0x48
Sep  9 00:46:27 steel kernel:  [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
Sep  9 00:46:27 steel kernel:  =======================
Sep  9 00:46:27 steel kernel: Code: a1 00 fe 3a c0 8d b8 84 03 00 00 8d 83 ec 00 00 00 8d 55 dc e8 91 f2 51 c6 64 a1 00 d0 3e c0 c7 00 01 00 00 00 8b 83 d4 00 00 00 <8b> 40 10 8b 80 ec 15 00 00 39 f0 73 9b a1 00 fe 3a c0 39 f8 79 
Sep  9 00:46:27 steel kernel: EIP: [<f9c09bb2>] radeon_irq_wait+0xdf/0x138 [radeon] SS:ESP 0068:f4f92ed0


