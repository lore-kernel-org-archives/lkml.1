Return-Path: <linux-kernel-owner+w=401wt.eu-S1751327AbXBUPp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbXBUPp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXBUPp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:45:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:30721 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbXBUPpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:45:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PdOSQBiuF5vcxZKOvnxgDPGUJKx5P2CIF2lKF8GlCalFdfqLuv+07oLl2B2elFq+N47gQQj6xOOQn4hiXpVZA0ByYZ+erHuy9EzN91bW+S/dsRC2I7/qMRwbER7683cF0WywqF2feyTSyeYsvIK/OghARmxAPaRutjV+1Gsnh+k=
Message-ID: <bc36a6210702210745ha025453xd75f61e3bec416b1@mail.gmail.com>
Date: Wed, 21 Feb 2007 08:45:22 -0700
From: "Andrew Robinson" <andrew.rw.robinson@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel oops in 2.6.18.3 with RAID5
In-Reply-To: <bc36a6210702201714nb18925ua8b89cd2c2ecad1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bc36a6210702200930n2d4b1f76m9fc5e5f0728f7b48@mail.gmail.com>
	 <bc36a6210702201714nb18925ua8b89cd2c2ecad1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update: I think that you can ignore this error. I am getting
segmentation faults when I attempt to rebuild the kernel. This is
exactly the same problem I had with slackware 10.1 with the 2.6.10
kernel. So I think it is a hardware issue. Memtest86 didn't show any
errors after 35 passes, so I'll have to check the CPU and motherboard.

Thanks for anyone who spent any time thinking/researching this.

On 2/20/07, Andrew Robinson <andrew.rw.robinson@gmail.com> wrote:
> Here is the full dmesg log of the crash:
>
> iret exception: 0000 [#1]
> SMP
> Modules linked in: ppdev lp button ac battery ipv6 dm_snapshot
> dm_mirror dm_mod loop tsdev rtc psmouse parport_pc parport floppy
> serio_raw pcspkr i2c_nforce2 snd_intel8x0 snd_ac97_codec snd_
> ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc shpchp
> pci_hotplug i2c_core nvidia_agp agpgart evdev ext3 jbd mbcache raid456
> md_mod xor ide_cd cdrom ide_disk sd_mod generic 8139too
> amd74xx ide_core sata_sil 8139cp mii sata_nv libata scsi_mod forcedeth
> ehci_hcd ohci_hcd usbcore thermal processor fan
> CPU:    0
> EIP:    0060:[<de95b0cb>]    Not tainted VLI
> EFLAGS: 00000216   (2.6.18-3-686 #1)
> EIP is at copy_data+0xff/0x14b [raid456]
> eax: ddcce000   ebx: 00001000   ecx: 0000000f   edx: c1f71000
> esi: ddccefc4   edi: c1f71fc4   ebp: 00000000   esp: dd261e4c
> ds: 007b   es: 007b   ss: 0068
> Process md0_raid5 (pid: 1115, ti=dd260000 task=dd0ed550 task.ti=dd260000)
> Stack: c1f71000 ddb55460 c1e377a0 00000000 ddcce000 00001000 c1f71000 00000000
>        00000000 00000000 00000000 dd20c388 c1e377a0 dd20c354 de95d96d 0c649510
>        00000000 c0116d0a 06323c4f 00000000 dd20c384 00000000 c13c52e0 0000e000
> Call Trace:
>  [<de95d96d>] handle_stripe+0x10da/0x2075 [raid456]
>  [<c0116d0a>] find_busiest_group+0x177/0x46a
>  [<c011669e>] __wake_up+0x2a/0x3d
>  [<de95a72c>] __release_stripe+0x10c/0x110 [raid456]
>  [<de95a751>] release_stripe+0x21/0x2e [raid456]
>  [<de95ea15>] raid5d+0x10d/0x132 [raid456]
>  [<de92d769>] md_thread+0xd7/0xed [md_mod]
>  [<c012d961>] autoremove_wake_function+0x0/0x2d
>  [<de92d692>] md_thread+0x0/0xed [md_mod]
>  [<c012d893>] kthread+0xc2/0xef
>  [<c012d7d1>] kthread+0x0/0xef
>  [<c0101005>] kernel_thread_helper+0x5/0xb
> Code: 8d 04 2f 01 4c 24 18 83 7c 24 0c 00 8b 54 24 18 8d 34 32 89 34
> 24 74 09 89 d9 89 c7 c1 e9 02 eb 0a 8b 3c 24 89 d9 89 c6 c1 e9 02 <f3>
> a5 89 d9 83 e1 03 74 02 f3 a4 8b 44 24 18 ba 03 00
>  00 00 e8
> EIP: [<de95b0cb>] copy_data+0xff/0x14b [raid456] SS:ESP 0068:dd261e4c
>  <6>note: md0_raid5[1115] exited with preempt_count 1
>
> I was having instability with this machine before (slackware 10.1 with
> 2.6.10 kernel) while compiling code (especially the kernel). I just
> rebuilt is as a debian box. It never died in the raid array code
> before though, just in gcc.
>
> I have tested the machine's ram with memtest86 (3 passes) and will
> more thoroughly check it tonight. Besides bad RAM, does anyone have
> any other ideas on what may be causing the issue?
>
>
> On 2/20/07, Andrew Robinson wrote:
> > I can't seem to find sufficient information on what may have caused an
> > oops. I am running a debian machine using kernel 2.6.18.3. Here is
> > detailed information on the system:
> >
> > debian etch
> > CPU: AMD athlon 2100+
> > kernel package: linux-image-2.6.18-3-686
> > raid5 array: 3 active, 1 spare on md0
> > raid fs: ext3
> > raid is physically across 2 on-board NVidia SATA ports and 2 ports
> > from a SATA controller card
> >
> > I am at work, and this was a home computer. This is what I got from
> > syslog when in SSH before it died:
> >
> > bserver kernel: iret exception: 0000 [#1]
> > bserver kernel: SMP
> > bserver kernel: CPU:    0
> > bserver kernel: EIP is at copy_data+0xff/0x14b [raid456]
> > bserver kernel: eax: ddcce000   ebx: 00001000   ecx: 0000000f   edx: c1f71000
> > bserver kernel: esi: ddccefc4   edi: c1f71fc4   ebp: 00000000   esp: dd261e4c
> > bserver kernel: ds: 007b   es: 007b   ss: 0068
> > bserver kernel: Process md0_raid5 (pid: 1115, ti=dd260000
> > task=dd0ed550 task.ti=dd260000)
> > bserver kernel: Stack: c1f71000 ddb55460 c1e377a0 00000000 ddcce000
> > 00001000 c1f71000 00000000
> > bserver kernel:        00000000 00000000 00000000 dd20c388 c1e377a0
> > dd20c354 de95d96d 0c649510
> > bserver kernel:        00000000 c0116d0a 06323c4f 00000000 dd20c384
> > 00000000 c13c52e0 0000e000
> > bserver kernel: Call Trace:
> > bserver kernel: Code: 8d 04 2f 01 4c 24 18 83 7c 24 0c 00 8b 54 24 18
> > 8d 34 32 89 34 24 74 09 89 d9 89 c7 c1 e9 02 eb 0a 8b 3c 24 89 d9 89
> > c6 c1 e9 02 <f3> a5 89 d9 83 e1 03 74 02 f3 a4 8b 44 24 18 ba 03 00 00
> > 00 e8
> > bserver kernel: EIP: [<de95b0cb>] copy_data+0xff/0x14b [raid456]
> > SS:ESP 0068:dd261e4c
> >
> > The only similar message chain that I could find was about 2.6.19 and
> > they recommended disabling preempting, but debian's 2.6.18.3 already
> > has that disabled by default.
> >
> > Any ideas?
> >
> > Thanks,
> > Andrew
> >
>
