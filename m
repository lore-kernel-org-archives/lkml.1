Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbXJBSNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbXJBSNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbXJBSMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:12:55 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:62206 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbXJBSMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:12:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=rNAThhy07nMWdBRtXED4as3c2w+PDk6WAKZ2rn22q7vbJ3Xg47AEkWrI8gqcqQjAR9e134httEqyOvF13XI/uSpTYJQlyVRUx395/tvKzCwVytpBIr/1rcriIBJztTSp4RUr6EzbC3SnHFoawp7fEf6i/Gfuq6AEEGPeTj2RpJw=
Date: Tue, 2 Oct 2007 20:12:44 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8,
 v2.6.22.8, v2.6.21.7, v2.6.20.20
Message-ID: <20071002201244.24f2e8bd@gmail.com>
In-Reply-To: <20070930152621.GB24077@elte.hu>
References: <20070926111357.GA10655@elte.hu>
	<20070928222631.25504d68@gmail.com>
	<20070930152621.GB24077@elte.hu>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sun, 30 Sep 2007 17:26:22 +0200
Ingo Molnar <mingo@elte.hu> escribió:

> 

> 
> hm. There are no similar reports so far. Could you try to run the wine 
> program from a VGA text console (first do 'xhost +' in an xterm under X 
> and then 'export DISPLAY=:0' in the text console) and see whether 
> anything gets output to that console? Also enable nmi_watchdog=2 - which 
> could print a backtrace of the point of the hard lockup.

 Ignore the last mail there was no need to use pictures this no an oops on
boot ;)

This is the back trace
  Oct  2 17:37:13 localhost kernel: [  886.216868] BUG: unable to handle kernel NULL pointer dereference at virtual address 0000012c
Oct  2 17:37:13 localhost kernel: [  886.216874]  printing eip:
Oct  2 17:37:13 localhost kernel: [  886.216876] f9374d0c
Oct  2 17:37:13 localhost kernel: [  886.216877] *pde = 00000000
Oct  2 17:37:13 localhost kernel: [  886.216880] Oops: 0002 [#1]
Oct  2 17:37:13 localhost kernel: [  886.216881] PREEMPT SMP 
Oct  2 17:37:13 localhost kernel: [  886.216884] Modules linked in: nls_cp850 isofs udf nls_utf8 ntfs binfmt_misc rfcomm l2cap bluetooth ipt_ULOG x_tables jfs ipv6 dm_crypt af_packet kvm_amd kvm fuse w83627ehf hwmon_vid i2c_dev lp snd_mpu401 snd_mpu401_uart snd_hda_intel snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_pcm snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer nvidia(P) snd_seq_device usbhid i2c_ali15x3 i2c_ali1535 8250_pnp usblp ff_memless uli526x snd i2c_core 8250 serial_core button ali_agp parport_pc parport k8temp hwmon pcspkr evdev rtc snd_page_alloc rt2500 soundcore sg floppy sr_mod raid10 cdrom sd_mod ehci_hcd ohci_hcd ata_generic usbcore raid456 async_xor async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal processor fan unix dm_mod
Oct  2 17:37:13 localhost kernel: [  886.216933] CPU:    0
Oct  2 17:37:13 localhost kernel: [  886.216934] EIP:    0060:[<f9374d0c>]    Tainted: P        VLI
Oct  2 17:37:13 localhost kernel: [  886.216935] EFLAGS: 00010246   (2.6.23-rc9-cfs-v22-dirty #82)
Oct  2 17:37:13 localhost kernel: [  886.217129] EIP is at os_set_mlock_capability+0xc/0x30 [nvidia]
Oct  2 17:37:13 localhost kernel: [  886.217131] eax: 00000000   ebx: 00000000   ecx: 00000050   edx: 00000202
Oct  2 17:37:13 localhost kernel: [  886.217134] esi: f74c3000   edi: f749cc00   ebp: df4b3ff0   esp: d319bed4
Oct  2 17:37:13 localhost kernel: [  886.217136] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Oct  2 17:37:13 localhost kernel: [  886.217139] Process spirographx (pid: 5512, ti=d319b000 task=c45da540 task.ti=d319b000)
Oct  2 17:37:13 localhost kernel: [  886.217141] Stack: f909cd35 f909ed92 f9655740 e1d42c00 f6ca5bc0 f90a0c26 df4b2000 0000005b 
Oct  2 17:37:13 localhost kernel: [  886.217146]        0000000c f909da32 f9655740 e1d42c00 0000005b f6ca5bc0 f6ca5bc0 0000005b 
Oct  2 17:37:13 localhost kernel: [  886.217151]        f9655740 f9370e98 df4b2000 f9655740 e1d42c00 0000005b f6ca5bc0 00000000 
Oct  2 17:37:13 localhost kernel: [  886.217157] Call Trace:
Oct  2 17:37:13 localhost kernel: [  886.217164]  [<f909cd35>] _nv002553rm+0x5/0x10 [nvidia]
Oct  2 17:37:13 localhost kernel: [  886.217259]  [<f909ed92>] rm_write_watch_init+0x3b/0x54 [nvidia]
Oct  2 17:37:13 localhost kernel: [  886.217365]  [<f90a0c26>] _nv002642rm+0x416/0x5e9 [nvidia]
Oct  2 17:37:13 localhost kernel: [  886.217469]  [<f909da32>] rm_ioctl+0x3e/0x6d [nvidia]
Oct  2 17:37:13 localhost kernel: [  886.217578]  [<f9370e98>] nv_kern_ioctl+0xf8/0x3c0 [nvidia]
Oct  2 17:37:13 localhost kernel: [  886.217732]  [<f9371198>] nv_kern_unlocked_ioctl+0x18/0x20 [nvidia]
Oct  2 17:37:13 localhost kernel: [  886.217866]  [<f9371180>] nv_kern_unlocked_ioctl+0x0/0x20 [nvidia]
Oct  2 17:37:13 localhost kernel: [  886.217989]  [do_ioctl+43/144] do_ioctl+0x2b/0x90
Oct  2 17:37:13 localhost kernel: [  886.217994]  [remove_vma+57/80] remove_vma+0x39/0x50
Oct  2 17:37:13 localhost kernel: [  886.218010]  [vfs_ioctl+92/656] vfs_ioctl+0x5c/0x290
Oct  2 17:37:13 localhost kernel: [  886.218022]  [sys_ioctl+114/144] sys_ioctl+0x72/0x90
Oct  2 17:37:13 localhost kernel: [  886.218032]  [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
Oct  2 17:37:13 localhost kernel: [  886.218060]  =======================
Oct  2 17:37:13 localhost kernel: [  886.218061] Code: bb 86 da c6 31 c0 c3 90 8d b4 26 00 00 00 00 64 a1 00 f0 3e c0 8b 80 dc 00 00 00 c3 8d 76 00 64 a1 00 f0 3e c0 8b 80 8c 04 00 00 <c7> 80 2c 01 00 00 ff ff ff ff 64 a1 00 f0 3e c0 81 88 ac 01 00 
Oct  2 17:37:13 localhost kernel: [  886.218083] EIP: [<f9374d0c>]
os_set_mlock_capability+0xc/0x30 [nvidia] SS:ESP 0068:d319bed4


> 
> but in general there's nothing scheduler-specific about screensavers or 
> wine - but it could be related to 3D mode of the chip (hence related to 
> the nvidia module) - do you get a similar lockup if you try to run 
> 'glxgears'?

 In fact the backtrace was obtained trying to run glxgears


> 
> 	Ingo

 Alejandro


-- 
Nunca discutas con un idiota. Al final te hacen rebajarte a su nivel y entonces
te acaban ganando debido a su mayor experiencia.

