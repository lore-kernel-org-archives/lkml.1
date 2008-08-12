Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYHLPfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYHLPfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYHLPfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:35:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:9115 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYHLPfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:35:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cuofJpMYtQklxE5o5FkFvdVOgRg2PS6CDbAN1iIhcYg6CPnXjew8onc2GcrHab4Zw/
         Or2pnGSrHhn3DsSfZJGaBkOEbqk5ez8KJ4y6D/C1FQrZ4a8hrhb+ooJK8aMVO3nGcli9
         uhvYmqKVLIQkG/Gqfq2eVOOJ2wT3nJIojmKbY=
Message-ID: <6f31812b0808120834g2778067bg16b6fcf6d5811f@mail.gmail.com>
Date: Tue, 12 Aug 2008 21:04:59 +0530
From: "jay kumar" <jaykumarks@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: BUGS: tty subsystems @ 2.6.27-rc2-next-20080811
In-Reply-To: <6f31812b0808120817y7f7e02caka732354330567ba1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6f31812b0808120817y7f7e02caka732354330567ba1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same bugs are reproducible in aug 12 next also.

On Tue, Aug 12, 2008 at 8:47 PM, jay kumar <jaykumarks@gmail.com> wrote:
> Observed two bugs mainly while starting/closing terminals
>
> Steps to reproduce
> I am tried it two times and it reproduced for me,
> 1. Open the gnome-terminal
> 2. Open xterm
> 3. Close gnome-terminal (system hangs (sometime) with bug1 (dmesg
> info) captured using serial console)
> 4. If system does not hang then close the opened xterm which generate
> the bug2 listed at the end. config attached.
>
> Tested Kernel:
> Commit :
> commit 299be36648adc14e4627173d00c18b11d08e5ecd
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Mon Aug 11 16:30:46 2008 +1000
>
>
> BUG1:
> ------------------
>
> [  202.172947] returning<1>BUG: unable to handle kernel paging request at 6b6b63
> [  212.257668] IP: [<c02cea1a>] do_tty_hangup+0xda/0x440
> [  212.262770] *pde = 00000000
> [  212.265678] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [  212.270270] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.5/modalias
> [  212.277143] Modules linked in: i915 drm binfmt_misc rfcomm l2cap bluetooth pe
> [  212.313429]
> [  212.314929] Pid: 6123, comm: gnome-terminal Not tainted (2.6.27-rc2-next-200)
> [  212.322842] EIP: 0060:[<c02cea1a>] EFLAGS: 00010246 CPU: 1
> [  212.328328] EIP is at do_tty_hangup+0xda/0x440
> [  212.332772] EAX: 6b6b6b6b EBX: 00000292 ECX: 00000000 EDX: 00000001
> [  212.339039] ESI: ffffffff EDI: f39b49b0 EBP: e6661ea0 ESP: e6661e78
> [  212.345304]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  212.350703] Process gnome-terminal (pid: 6123, ti=e6660000 task=e648b0c0 tas)
> [  212.358788] Stack: 00000000 f39b4a14 00000000 00000000 f39b49c4 00000001 000
> [  212.367298]        f39b49b0 f4c0b4e0 e6661ea8 c02ced8d e6661ebc c02d548e 000
> [  212.375825]        f39b4180 e6661f40 c02cf70c 00000031 00000000 c1f09660 000
> [  212.384361] Call Trace:
> [  212.387008]  [<c02ced8d>] ? tty_vhangup+0xd/0x10
> [  212.391676]  [<c02d548e>] ? pty_close+0xfe/0x140
> [  212.396341]  [<c02cf70c>] ? release_dev+0x13c/0x500
> [  212.401263]  [<c02878ef>] ? _raw_spin_lock+0x3f/0x150
> [  212.406366]  [<c012bc65>] ? finish_task_switch+0x55/0xf0
> [  212.411731]  [<c012bc10>] ? finish_task_switch+0x0/0xf0
> [  212.417001]  [<c0153eea>] ? print_lock_contention_bug+0x1a/0xe0
> [  212.422973]  [<c02cfae2>] ? tty_release+0x12/0x20
> [  212.427722]  [<c01a9c2d>] ? __fput+0xbd/0x1b0
> [  212.432125]  [<c01aa009>] ? fput+0x19/0x20
> [  212.436277]  [<c01a6ce9>] ? filp_close+0x49/0x70
> [  212.440948]  [<c01a81bb>] ? sys_close+0x6b/0xb0
> [  212.445532]  [<c0103d7b>] ? sysenter_do_call+0x12/0x3f
> [  212.450725]  =======================
> [  212.454302] Code: e0 3d 60 f1 2c c0 89 5d e0 75 dd 89 da 31 c9 b8 ff ff ff f
> [  212.474515] EIP: [<c02cea1a>] do_tty_hangup+0xda/0x440 SS:ESP 0068:e6661e78
> [  212.481540] ---[ end trace ab90b2f1563c3236 ]---
> [  212.486792] bad magic number for tty struct (136:0) in release_dev
> ----------------------------------------------------------------------------------
> [ 1024.692625] returning<1>BUG: unable to handle kernel paging request
> at 6b6b6b6b
> [ 1028.694147] IP: [<c02cd39d>] check_tty_count+0x1d/0xb0
> [ 1028.699327] *pde = 00000000
> [ 1028.702226] Oops: 0000 [#6] SMP DEBUG_PAGEALLOC
> [ 1028.706819] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.5/modalias
> [ 1028.713690] Modules linked in: i915 drm binfmt_misc rfcomm l2cap
> bluetooth ppdev acpi_cpufreq video output sbs sbshc conte
> [ 1028.749957]
> [ 1028.751458] Pid: 6292, comm: gnome-terminal Tainted: G      D
> (2.6.27-rc2-next-20080811 #18)
> [ 1028.760063] EIP: 0060:[<c02cd39d>] EFLAGS: 00210292 CPU: 1
> [ 1028.765550] EIP is at check_tty_count+0x1d/0xb0
> [ 1028.770081] EAX: 6b6b6b6b EBX: f39b51e0 ECX: 0000e101 EDX: 00000000
> [ 1028.776345] ESI: f39b6240 EDI: c04fd151 EBP: e67bfe70 ESP: e67bfe50
> [ 1028.782610]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ 1028.788009] Process gnome-terminal (pid: 6292, ti=e67be000
> task=ebb4e180 task.ti=e67be000)
> [ 1028.796092] Stack: 00000001 00200246 e67bfe64 c02877b6 c055f4e0
> f39b51e0 f39b6240 f39b6240
> [ 1028.804618]        e67bfea0 c02ce99b c0155a0b e67bfe94 00200246
> 00000000 e7a21270 f39b6240
> [ 1028.813138]        f4c0b4e0 f39b51e0 f39b6240 f4c0b4e0 e67bfea8
> c02ced8d e67bfebc c02d548e
> [ 1028.821656] Call Trace:
> [ 1028.824298]  [<c02877b6>] ? _raw_spin_unlock+0x46/0x80
> [ 1028.829487]  [<c02ce99b>] ? do_tty_hangup+0x5b/0x440
> [ 1028.834505]  [<c0155a0b>] ? trace_hardirqs_on+0xb/0x10
> [ 1028.839694]  [<c02ced8d>] ? tty_vhangup+0xd/0x10
> [ 1028.844358]  [<c02d548e>] ? pty_close+0xfe/0x140
> [ 1028.849018]  [<c02cf70c>] ? release_dev+0x13c/0x500
> [ 1028.853951]  [<c02878ef>] ? _raw_spin_lock+0x3f/0x150
> [ 1028.859046]  [<c012bc65>] ? finish_task_switch+0x55/0xf0
> [ 1028.864402]  [<c012bc10>] ? finish_task_switch+0x0/0xf0
> [ 1028.869679]  [<c02cfae2>] ? tty_release+0x12/0x20
> [ 1028.874436]  [<c01a9c2d>] ? __fput+0xbd/0x1b0
> [ 1028.878840]  [<c01aa009>] ? fput+0x19/0x20
> [ 1028.882981]  [<c01a6ce9>] ? filp_close+0x49/0x70
> [ 1028.887644]  [<c01a81bb>] ? sys_close+0x6b/0xb0
> [ 1028.892229]  [<c0103d7b>] ? sysenter_do_call+0x12/0x3f
> [ 1028.897410]  =======================
> [ 1028.900990] Code: c0 83 c4 04 5b 5f 5d c3 8d b6 00 00 00 00 55 89
> e5 57 89 d7 56 89 c6 53 b8 00 08 58 c0 83 ec 14 e8 99 f
> [ 1028.921164] EIP: [<c02cd39d>] check_tty_count+0x1d/0xb0 SS:ESP 0068:e67bfe50
> [ 1028.928276] ---[ end trace ab90b2f1563c3236 ]---
>
>
>
>
> BUG2:(very nasty looking bug)
> ---------------
>
> [  303.043543] returning<1>BUG: unable to handle kernel paging request
> at 6b6b6b83
> [  314.569191] IP: [<c02d52be>] pty_flush_buffer+0x1e/0x80
> [  314.574456] *pde = 00000000
> [  314.577366] Oops: 0000 [#2] SMP DEBUG_PAGEALLOC
> [  314.581966] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.5/modalias
> [  314.588839] Modules linked in: i915 drm binfmt_misc rfcomm l2cap
> bluetooth ppdev acpi_cpufreq video output sbs sbshc container battery
> iptable_filter ip_tables x_tables ac parport_pc lp parport serio_raw
> pcspkr pata_marvell psmouse iTCO_wdt iTCO_vendor_support ata_generic
> shpchp pci_hotplug button intel_agp agpgart ipv6 evdev uhci_hcd
> ehci_hcd usbcore ext3 jbd thermal processor fan thermal_sys fuse
> [  314.625083]
> [  314.626584] Pid: 6241, comm: xterm Tainted: G      D
> (2.6.27-rc2-next-20080811 #18)
> [  314.634409] EIP: 0060:[<c02d52be>] EFLAGS: 00210282 CPU: 1
> [  314.639896] EIP is at pty_flush_buffer+0x1e/0x80
> [  314.644515] EAX: 6b6b6b6b EBX: f43ef2a0 ECX: f43ef2a0 EDX: c02d52a0
> [  314.650780] ESI: f43ef2a0 EDI: f43eda10 EBP: e6787ed8 ESP: e6787ec4
> [  314.657046]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  314.662447] Process xterm (pid: 6241, ti=e6786000 task=eb8ca080
> task.ti=e6786000)
> [  314.669750] Stack: e6787ed4 c02d3ed8 f43ef2a0 00000000 00000001
> e6787ee0 c02d2ea3 e6787ef8
> [  314.678297]        c02d32a9 f43ef2b4 f43ef2a0 e677ce00 f43ef2a0
> e6787f10 c02d3cea 00000001
> [  314.686841]        c02d3bf0 e677ce00 f43ef2a0 e6787f58 c02d003e
> 00000001 c1f54000 e6787f44
> [  314.695379] Call Trace:
> [  314.698023]  [<c02d3ed8>] ? tty_ldisc_try+0x38/0x50BUG
> kmalloc-2048: Poison overwritten
> [  314.702954]  [<c02d2ea3>] ? tty_driver_flush_buffer+0x13/0x20
> [  314.708753]  [<c02d32a9>] ? tty_perform_flush+0x79/0xa0
> [  314.714021]  [<c02d3cea>] ? n_tty_ioctl+0xfa/0x210
> [  314.718857]  [<c02d3bf0>] ? n_tty_ioctl+0x0/0x210
> [  314.723617]  [<c02d003e>] ? tty_ioctl+0xae/0x800
> [  314.728278]  [<c01c02da>] ? mntput_no_expire+0x1a/0x100
> [  314.733547]  [<c02cff90>] ? tty_ioctl+0x0/0x800
> [  314.738132]  [<c01b5258>] ? vfs_ioctl+0x28/0x80
> [  314.742718]  [<c01b551a>] ? do_vfs_ioctl+0x26a/0x2b0
> [  314.747727]  [<c01aa009>] ? fput+0x19/0x20
> [  314.751868]  [<c01a6ce9>] ? filp_close+0x49/0x70
> [  314.756532]  [<c01b55b3>] ? sys_ioctl+0x53/0x70
> [  314.761109]  [<c0103d7b>] ? sysenter_do_call+0x12/0x3f
> [  314.766291]  =======================
> [  314.769871] Code: 00 00 00 81 48 08 b0 00 00 00 5d c3 90 55 89 e5
> 83 ec 14 89 75 f8 89 c6 89 5d f4 89 7d fc 8b b8 ec 00 00 00 85 ff 74
> 17 8b 47 14 <8b> 50 18 85 d2 74 04 89 f8 ff d2 f6 87 e4 00 00 00 08 75
> 0e 8b
> [  314.790108] EIP: [<c02d52be>] pty_flush_buffer+0x1e/0x80 SS:ESP 0068:e6787ec4
> [  314.797313] ---[ end trace ab90b2f1563c3236 ]---
> [  314.802981] BUG: unable to handle kernel paging request at 6b6b6b6b
> [  314.809277] IP: [<c01216f8>] __wake_up_common+0x18/0x70
> [  314.814522] *pde = 00000000
> [  314.817425] Oops: 0000 [#3] SMP DEBUG_PAGEALLOC
> [  314.822010] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.5/modalias
> [  314.828882] Modules linked in: i915 drm binfmt_misc rfcomm l2cap
> bluetooth ppdev acpi_cpufreq video output sbs sbshc container battery
> iptable_filter ip_tables x_tables ac parport_pc lp parport serio_raw
> pcspkr pata_marvell psmouse iTCO_wdt iTCO_vendor_support ata_generic
> shpchp pci_hotplug button intel_agp agpgart ipv6 evdev uhci_hcd
> ehci_hcd usbcore ext3 jbd thermal processor fan thermal_sys fuse
> [  314.864997]
> [  314.866496] Pid: 6241, comm: xterm Tainted: G      D
> (2.6.27-rc2-next-20080811 #18)
> [  314.874322] EIP: 0060:[<c01216f8>] EFLAGS: 00210016 CPU: 1
> [  314.879808] EIP is at __wake_up_common+0x18/0x70
> [  314.884428] EAX: f43edbd0 EBX: 6b6b6b5f ECX: 00000001 EDX: 00000001
> [  314.890693] ESI: 00000001 EDI: 00200286 EBP: e6787c78 ESP: e6787c5c
> [  314.896958]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [  314.902351] Process xterm (pid: 6241, ti=e6786000 task=eb8ca080
> task.ti=e6786000)
> [  314.909655] Stack: c040cca3 00000001 00000001 c01231ab f43edbb0
> 00000001 00200286 e6787c98
> [  314.918167]        c01231c7 00000000 00000000 00000001 f43ef2a0
> f43eda10 f4c0b4e0 e6787cac
> [  314.926677]        c02d543b 00000000 e677ce00 f43ef2a0 e6787d30
> c02cf70c 00200246 c037d790
> [  314.935188] Call Trace:
> [  314.937831]  [<c040cca3>] ? _spin_lock_irqsave+0x73/0x90
> [  314.943197]  [<c01231ab>] ? __wake_up+0x1b/0x50
> [  314.947771]  [<c01231c7>] ? __wake_up+0x37/0x50BUG kmalloc-2048:
> Poison overwritten
> [  314.952340]  [<c02d543b>] ? pty_close+0xab/0x140
> [  314.957002]  [<c02cf70c>] ? release_dev+0x13c/0x500
> [  314.961925]  [<c037d790>] ? sock_destroy_inode+0x10/0x20
> [  314.967280]  [<c0155a0b>] ? trace_hardirqs_on+0xb/0x10
> [  314.972455]  [<c01ba033>] ? __d_free+0x23/0x30
> [  314.976936]  [<c02878ef>] ? _raw_spin_lock+0x3f/0x150
> [  314.982040]  [<c01ba033>] ? __d_free+0x23/0x30
> [  314.986521]  [<c02cfae2>] ? tty_release+0x12/0x20
> [  314.991263]  [<c01a9c2d>] ? __fput+0xbd/0x1b0
> [  314.995656]  [<c01aa009>] ? fput+0x19/0x20
> [  314.999783]  [<c01a6ce9>] ? filp_close+0x49/0x70
> [  315.004436]  [<c013352b>] ? put_files_struct+0x9b/0xb0
> [  315.009618]  [<c0133582>] ? exit_files+0x42/0x60
> [  315.014264]  [<c0134ad5>] ? do_exit+0x1a5/0x8c0
> [  315.018841]  [<c0283904>] ? trace_hardirqs_on_thunk+0xc/0x10
> [  315.024533]  [<c013253b>] ? printk+0x1b/0x20
> [  315.028842]  [<c013152a>] ? print_oops_end_marker+0x2a/0x30
> [  315.034458]  [<c040d261>] ? oops_end+0xb1/0xc0
> [  315.038947]  [<c0105970>] ? die+0x50/0x70
> [  315.043003]  [<c040f019>] ? do_page_fault+0x279/0x780
> [  315.048107]  [<c040eda0>] ? do_page_fault+0x0/0x780
> [  315.053014]  [<c040cff2>] ? error_code+0x72/0x80
> [  315.057677]  [<c02d52a0>] ? pty_flush_buffer+0x0/0x80
> [  315.062763]  [<c02d52be>] ? pty_flush_buffer+0x1e/0x80
> [  315.067946]  [<c02d3ed8>] ? tty_ldisc_try+0x38/0x50
> [  315.072860]  [<c02d2ea3>] ? tty_driver_flush_buffer+0x13/0x20
> [  315.078649]  [<c02d32a9>] ? tty_perform_flush+0x79/0xa0
> [  315.083909]  [<c02d3cea>] ? n_tty_ioctl+0xfa/0x210
> [  315.088737]  [<c02d3bf0>] ? n_tty_ioctl+0x0/0x210
> [  315.093486]  [<c02d003e>] ? tty_ioctl+0xae/0x800
> [  315.098132]  [<c01c02da>] ? mntput_no_expire+0x1a/0x100
> [  315.103392]  [<c02cff90>] ? tty_ioctl+0x0/0x800
> [  315.107960]  [<c01b5258>] ? vfs_ioctl+0x28/0x80
> [  315.112536]  [<c01b551a>] ? do_vfs_ioctl+0x26a/0x2b0
> [  315.117536]  [<c01aa009>] ? fput+0x19/0x20
> [  315.121678]  [<c01a6ce9>] ? filp_close+0x49/0x70
> [  315.126339]  [<c01b55b3>] ? sys_ioctl+0x53/0x70
> [  315.130908]  [<c0103d7b>] ? sysenter_do_call+0x12/0x3f
> [  315.136090]  =======================
> [  315.139660] Code: 28 11 77 2c eb ca 8d b6 00 00 00 00 8d bc 27 00
> 00 00 00 55 89 e5 57 56 53 83 ec 10 89 55 ec 89 4d e8 8b 58 20 83 c0
> 20 83 eb 0c <8b> 53 0c 89 45 f0 8d 43 0c 3b 45 f0 74 3c 8d 72 f4 eb 0a
> 90 8d
> [  315.159690] EIP: [<c01216f8>] __wake_up_common+0x18/0x70 SS:ESP 0068:e6787c5c
> [  315.166866] ---[ end trace ab90b2f1563c3236 ]---
> [  315.171487] Fixing recursive fault but reboot is needed!
> [  387.926287] user = xterm
> [  387.928836] returning<3>=============================================================================
> [  394.808003] BUG kmalloc-2048: Poison overwritten
> [  394.808003] -----------------------------------------------------------------------------
> [  394.808003]
> [  394.808003] INFO: 0xf43edae4-0xf43edbbf. First byte 0x6f instead of 0x6b
> [  394.808003] INFO: Allocated in alloc_tty_struct+0x12/0x20 age=48177
> cpu=0 pid=6241
> [  394.808003] INFO: Freed in release_one_tty+0xbb/0x110 age=20060
> cpu=1 pid=6242
> [  394.808003] INFO: Slab 0xc1c3fa60 objects=15 used=10 fp=0xf43eda10
> flags=0x400020c3
> [  394.808003] INFO: Object 0xf43eda10 @offset=23056 fp=0xf43ee240
> [  394.808003] ne if Red Hat released a version of Linux, and after it
> was deployed, customers no
> [  394.808003] Bytes b4 0xf43eda00:  2f 16 00 00 22 b0 ff ff 5a 5a 5a
> 5a 5a 5a 5a 5a /..."???ZZZZZZZZ
> [  394.808003]   Object 0xf43eda10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.808003]   Object 0xf43eda20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.808003]   Object 0xf43eda30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.808003]   Object 0xf43eda40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.808003]   Object 0xf43eda50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.808003]   Object 0xf43eda60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.808003]   Object 0xf43eda70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.808003]   Object 0xf43eda80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.808003]   Object 0xf43eda90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.808003]   Object 0xf43edaa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.958013]   Object 0xf43edab0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.967321]   Object 0xf43edac0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edad0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edae0:  6b 6b 6b 6b 6f 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkokkkkkkkkkkk
> [  394.968013]   Object 0xf43edaf0:  6b 6b 6b 6b 63 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkckkkkkkkkkkk
> [  394.968013]   Object 0xf43edb00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edb10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edb20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edb30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edb40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edb50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edb60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edb70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edb80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edb90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edba0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edbb0:  6b 6c 6b 6b 6b 6b 6b 6b 01 00 00
> 00 80 a0 8c eb klkkkkkk.......
> [  394.968013]   Object 0xf43edbc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edbd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edbe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edbf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edc00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edc10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edc20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edc30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edc40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edc50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edc60:  6b 6b 6b 6b 6b 6b 6b ne if Red
> Hat released a version of Linux, and after it was deployed, customers
> no6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edc70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edc80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edc90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edca0:  6b 6b 6b 6b 6b 6b 6b ne if Red
> Hat released a version of Linux, and after it was deployed, customers
> no6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edcb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edcc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edcd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edce0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edcf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edd00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edd10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edd20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edd30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edd40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edd50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edd60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edd70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968013]   Object 0xf43edd80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edd90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edda0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43eddb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43eddc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43eddd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edde0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43eddf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ede00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ede10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ede20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ede30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ede40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ede50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ede60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ede70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ede80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ede90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edea0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edeb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edec0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43eded0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edee0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edef0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edf00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edf10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edf20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edf30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edf40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edf50:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edf60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edf70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edf80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edf90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edfa0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edfb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edfc0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edfd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edfe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43edff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee010:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee040:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee050:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee080:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee090:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee0a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee0b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee0c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee0d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee0e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee0f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee100:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee110:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee120:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee130:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee140:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee150:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee160:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee170:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee180:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee1a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee1b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee1c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee1d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee1e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee1f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [  394.968014]   Object 0xf43ee200:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk?
> [  394.968014]  Redzone 0xf43ee210:  bb bb bb bb
>              ????
> [  394.968014]  Padding 0xf43ee238:  5a 5a 5a 5a 5a 5a 5a 5a
>              ZZZZZZZZ
> [  394.968014] Pid: 6018, comm: compiz.real Tainted: G      D
> 2.6.27-rc2-next-20080811 #18
> [  394.968014]  [<c01a20b9>] print_trailer+0xa9/0xf0
> [  394.968014]  [<c01a219b>] check_bytes_and_report+0x9b/0xc0
> [  394.968014]  [<c01a25ce>] check_object+0x19e/0x1e0
> [  394.968014]  [<c01a33c1>] __slab_alloc+0x491/0x530
> [  394.968014]  [<c015324b>] ? trace_hardirqs_off+0xb/0x10
> [  394.968014]  [<c01a47e5>] __kmalloc_track_caller+0x115/0x120
> [  394.968014]  [<c0380f25>] ? sock_alloc_send_skb+0x165/0x1c0
> [  394.968014]  [<c0380f25>] ? sock_alloc_send_skb+0x165/0x1c0
> [  394.968014]  [<c03852ed>] __alloc_skb+0x4d/0x110
> [  394.968014]  [<c0380f25>] sock_alloc_send_skb+0x165/0x1c0
> [  394.968014]  [<c03ed0ac>] unix_stream_sendmsg+0x21c/0x320
> [  394.968014]  [<c037df55>] sock_aio_write+0x105/0x120
> [  394.968014]  [<c01b681b>] ? core_sys_select+0x28b/0x370
> [  394.968014]  [<c01a87c1>] do_sync_readv_writev+0xb1/0xf0
> [  394.968014]  [<c0145850>] ? autoremove_wake_function+0x0ne if Red
> Hat released a version of Linux, and after it was deployed, customers
> no/0x40
> [  394.968014]  [<c0283d5b>] ? copy_from_user+0x4b/0x80
> [  394.968014]  [<c024b4bf>] ? security_file_permission+0xf/0x20
> [  394.968014]  [<c01a8a77>] ? rw_verify_area+0x57/0xc0
> [  394.968014]  [<c01a8f4c>] do_readv_writev+0x9c/0x1d0
> [  394.968014]  [<c037de50>] ? sock_aio_write+0x0/0x120
> [  394.968014]  [<c024b4bf>] ? security_file_permission+0xf/0x20
> [  394.968014]  [<c01a90bf>] vfs_writev+0x3f/0x60
> [  394.968014]  [<c01a954d>] sys_writev+0x3d/0xa0
> [  394.968014]  [<c0103d7b>] sysenter_do_call+0x12/0x3f
> [  394.968014]  =======================
> [  394.968014] FIX kmalloc-2048: Restoring 0xf43edae4-0xf43edbbf=0x6b
> [  394.968014]
> [  394.968014] FIX kmalloc-2048: Marking all objects used
>
>
>
>
>
> Config info:
> ---------------------------------
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.27-rc2
> # Mon Aug 11 19:55:58 2008
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> # CONFIG_X86_64 is not set
> CONFIG_X86=y
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> # CONFIG_GENERIC_LOCKBREAK is not set
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_FAST_CMPXCHG_LOCAL=y
> CONFIG_MMU=y
> CONFIG_ZONE_DMA=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> # CONFIG_GENERIC_GPIO is not set
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> # CONFIG_RWSEM_GENERIC_SPINLOCK is not set
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> # CONFIG_ARCH_HAS_ILOG2_U32 is not set
> # CONFIG_ARCH_HAS_ILOG2_U64 is not set
> CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> # CONFIG_GENERIC_TIME_VSYSCALL is not set
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> # CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> # CONFIG_ZONE_DMA32 is not set
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_AOUT=y
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_X86_SMP=y
> CONFIG_X86_32_SMP=y
> CONFIG_X86_HT=y
> CONFIG_X86_BIOS_REBOOT=y
> CONFIG_X86_TRAMPOLINE=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
>
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_LOCK_KERNEL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_LOCALVERSION=""
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_BSD_PROCESS_ACCT=y
> CONFIG_BSD_PROCESS_ACCT_V3=y
> CONFIG_TASKSTATS=y
> # CONFIG_TASK_DELAY_ACCT is not set
> CONFIG_TASK_XACCT=y
> CONFIG_TASK_IO_ACCOUNTING=y
> CONFIG_AUDIT=y
> CONFIG_AUDITSYSCALL=y
> CONFIG_AUDIT_TREE=y
> # CONFIG_IKCONFIG is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_CGROUPS=y
> # CONFIG_CGROUP_DEBUG is not set
> CONFIG_CGROUP_NS=y
> CONFIG_CGROUP_DEVICE=y
> CONFIG_CPUSETS=y
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_GROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> CONFIG_RT_GROUP_SCHED=y
> # CONFIG_USER_SCHED is not set
> CONFIG_CGROUP_SCHED=y
> CONFIG_CGROUP_CPUACCT=y
> CONFIG_RESOURCE_COUNTERS=y
> CONFIG_MM_OWNER=y
> CONFIG_CGROUP_MEM_RES_CTLR=y
> CONFIG_SYSFS_DEPRECATED=y
> CONFIG_SYSFS_DEPRECATED_V2=y
> CONFIG_PROC_PID_CPUSET=y
> CONFIG_RELAY=y
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> CONFIG_IPC_NS=y
> # CONFIG_USER_NS is not set
> # CONFIG_PID_NS is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_EMBEDDED=y
> CONFIG_UID16=y
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_SYSCTL_SYSCALL_CHECK=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> # CONFIG_KALLSYMS_EXTRA_PASS is not set
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_COMPAT_BRK=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_ANON_INODES=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLOB is not set
> CONFIG_PROFILING=y
> # CONFIG_MARKERS is not set
> CONFIG_OPROFILE=m
> CONFIG_HAVE_OPROFILE=y
> CONFIG_KPROBES=y
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_KRETPROBES=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> # CONFIG_HAVE_ARCH_TRACEHOOK is not set
> # CONFIG_HAVE_DMA_ATTRS is not set
> CONFIG_USE_GENERIC_SMP_HELPERS=y
> # CONFIG_HAVE_CLK is not set
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> # CONFIG_TINY_SHMEM is not set
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> CONFIG_MODULE_FORCE_LOAD=y
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODULE_FORCE_UNLOAD is not set
> CONFIG_MODVERSIONS=y
> CONFIG_MODULE_SRCVERSION_ALL=y
> CONFIG_KMOD=y
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_LBD=y
> CONFIG_BLK_DEV_IO_TRACE=y
> # CONFIG_LSF is not set
> # CONFIG_BLK_DEV_BSG is not set
> # CONFIG_BLK_DEV_INTEGRITY is not set
>
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_AS=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_DEFAULT_AS is not set
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_PREEMPT_NOTIFIERS=y
> CONFIG_CLASSIC_RCU=y
>
> #
> # Processor type and features
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_SMP=y
> CONFIG_X86_FIND_SMP_CONFIG=y
> CONFIG_X86_MPPARSE=y
> CONFIG_X86_PC=y
> # CONFIG_X86_ELAN is not set
> # CONFIG_X86_VOYAGER is not set
> # CONFIG_X86_GENERICARCH is not set
> # CONFIG_X86_VSMP is not set
> # CONFIG_X86_RDC321X is not set
> CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
> CONFIG_PARAVIRT_GUEST=y
> CONFIG_XEN_SAVE_RESTORE=y
> CONFIG_VMI=y
> CONFIG_KVM_CLOCK=y
> CONFIG_KVM_GUEST=y
> # CONFIG_LGUEST_GUEST is not set
> CONFIG_PARAVIRT=y
> CONFIG_PARAVIRT_CLOCK=y
> # CONFIG_PARAVIRT_DEBUG is not set
> # CONFIG_MEMTEST is not set
> # CONFIG_M386 is not set
> # CONFIG_M486 is not set
> CONFIG_M586=y
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP2 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MPSC is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_GENERIC_CPU is not set
> CONFIG_X86_GENERIC=y
> CONFIG_X86_CPU=y
> CONFIG_X86_CMPXCHG=y
> CONFIG_X86_L1_CACHE_SHIFT=7
> CONFIG_X86_XADD=y
> CONFIG_X86_PPRO_FENCE=y
> CONFIG_X86_F00F_BUG=y
> CONFIG_X86_WP_WORKS_OK=y
> CONFIG_X86_INVLPG=y
> CONFIG_X86_BSWAP=y
> CONFIG_X86_POPAD_OK=y
> CONFIG_X86_ALIGNMENT_16=y
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=4
> CONFIG_HPET_TIMER=y
> CONFIG_DMI=y
> # CONFIG_IOMMU_HELPER is not set
> CONFIG_NR_CPUS=8
> CONFIG_SCHED_SMT=y
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_MCE is not set
> CONFIG_VM86=y
> # CONFIG_TOSHIBA is not set
> # CONFIG_I8K is not set
> CONFIG_X86_REBOOTFIXUPS=y
> CONFIG_MICROCODE=m
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_X86_MSR=m
> CONFIG_X86_CPUID=m
> # CONFIG_NOHIGHMEM is not set
> CONFIG_HIGHMEM4G=y
> # CONFIG_HIGHMEM64G is not set
> CONFIG_VMSPLIT_3G=y
> # CONFIG_VMSPLIT_3G_OPT is not set
> # CONFIG_VMSPLIT_2G is not set
> # CONFIG_VMSPLIT_2G_OPT is not set
> # CONFIG_VMSPLIT_1G is not set
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_DISCONTIGMEM_MANUAL is not set
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPARSEMEM_STATIC=y
> # CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_RESOURCES_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_MMU_NOTIFIER=y
> CONFIG_HIGHPTE=y
> CONFIG_MATH_EMULATION=y
> CONFIG_MTRR=y
> # CONFIG_MTRR_SANITIZER is not set
> CONFIG_X86_PAT=y
> CONFIG_EFI=y
> CONFIG_IRQBALANCE=y
> CONFIG_SECCOMP=y
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> CONFIG_SCHED_HRTICK=y
> CONFIG_KEXEC=y
> CONFIG_CRASH_DUMP=y
> CONFIG_KEXEC_JUMP=y
> CONFIG_PHYSICAL_START=0x100000
> CONFIG_RELOCATABLE=y
> CONFIG_PHYSICAL_ALIGN=0x100000
> CONFIG_HOTPLUG_CPU=y
> # CONFIG_COMPAT_VDSO is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
>
> #
> # Power management options
> #
> CONFIG_PM=y
> CONFIG_PM_DEBUG=y
> # CONFIG_PM_VERBOSE is not set
> CONFIG_CAN_PM_TRACE=y
> CONFIG_PM_TRACE=y
> CONFIG_PM_TRACE_RTC=y
> CONFIG_PM_SLEEP_SMP=y
> CONFIG_PM_SLEEP=y
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_HIBERNATION=y
> CONFIG_PM_STD_PARTITION=""
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> CONFIG_ACPI_PROCFS=y
> CONFIG_ACPI_PROCFS_POWER=y
> CONFIG_ACPI_SYSFS_POWER=y
> CONFIG_ACPI_PROC_EVENT=y
> CONFIG_ACPI_AC=m
> CONFIG_ACPI_BATTERY=m
> CONFIG_ACPI_BUTTON=m
> CONFIG_ACPI_VIDEO=m
> CONFIG_ACPI_FAN=m
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_BAY=m
> CONFIG_ACPI_PROCESSOR=m
> CONFIG_ACPI_HOTPLUG_CPU=y
> CONFIG_ACPI_THERMAL=m
> CONFIG_ACPI_WMI=y
> CONFIG_ACPI_ASUS=m
> # CONFIG_ACPI_PANASONIC is not set
> CONFIG_ACPI_TOSHIBA=m
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ACPI_BLACKLIST_YEAR=2000
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_EC=y
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=m
> CONFIG_ACPI_SBS=m
> CONFIG_X86_APM_BOOT=y
> CONFIG_APM=m
> # CONFIG_APM_IGNORE_USER_SUSPEND is not set
> # CONFIG_APM_DO_ENABLE is not set
> # CONFIG_APM_CPU_IDLE is not set
> # CONFIG_APM_DISPLAY_BLANK is not set
> # CONFIG_APM_ALLOW_INTS is not set
> # CONFIG_APM_REAL_MODE_POWER_OFF is not set
>
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> CONFIG_CPU_FREQ_DEBUG=y
> CONFIG_CPU_FREQ_STAT=y
> CONFIG_CPU_FREQ_STAT_DETAILS=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
>
> #
> # CPUFreq processor drivers
> #
> CONFIG_X86_ACPI_CPUFREQ=m
> # CONFIG_X86_POWERNOW_K6 is not set
> # CONFIG_X86_POWERNOW_K7 is not set
> # CONFIG_X86_POWERNOW_K8 is not set
> CONFIG_X86_GX_SUSPMOD=y
> CONFIG_X86_SPEEDSTEP_CENTRINO=y
> CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
> CONFIG_X86_SPEEDSTEP_ICH=y
> CONFIG_X86_SPEEDSTEP_SMI=y
> CONFIG_X86_P4_CLOCKMOD=y
> # CONFIG_X86_CPUFREQ_NFORCE2 is not set
> CONFIG_X86_LONGRUN=m
> # CONFIG_X86_LONGHAUL is not set
> # CONFIG_X86_E_POWERSAVER is not set
>
> #
> # shared options
> #
> # CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
> CONFIG_X86_SPEEDSTEP_LIB=y
> CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
>
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> # CONFIG_PCI_GOOLPC is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCIEPORTBUS=y
> CONFIG_HOTPLUG_PCI_PCIE=m
> CONFIG_PCIEAER=y
> CONFIG_PCIEASPM=y
> CONFIG_PCIEASPM_DEBUG=y
> CONFIG_ARCH_SUPPORTS_MSI=y
> CONFIG_PCI_MSI=y
> CONFIG_PCI_LEGACY=y
> # CONFIG_PCI_DEBUG is not set
> CONFIG_HT_IRQ=y
> CONFIG_ISA_DMA_API=y
> CONFIG_ISA=y
> CONFIG_EISA=y
> CONFIG_EISA_VLB_PRIMING=y
> CONFIG_EISA_PCI_EISA=y
> CONFIG_EISA_VIRTUAL_ROOT=y
> CONFIG_EISA_NAMES=y
> CONFIG_MCA=y
> CONFIG_MCA_LEGACY=y
> # CONFIG_MCA_PROC_FS is not set
> CONFIG_SCx200=m
> CONFIG_SCx200HR_TIMER=m
> # CONFIG_OLPC is not set
> CONFIG_K8_NB=y
> CONFIG_PCCARD=m
> # CONFIG_PCMCIA_DEBUG is not set
> CONFIG_PCMCIA=m
> CONFIG_PCMCIA_LOAD_CIS=y
> CONFIG_PCMCIA_IOCTL=y
> CONFIG_CARDBUS=y
>
> #
> # PC-card bridges
> #
> CONFIG_YENTA=m
> CONFIG_YENTA_O2=y
> CONFIG_YENTA_RICOH=y
> CONFIG_YENTA_TI=y
> CONFIG_YENTA_ENE_TUNE=y
> CONFIG_YENTA_TOSHIBA=y
> CONFIG_PD6729=m
> CONFIG_I82092=m
> CONFIG_I82365=m
> CONFIG_TCIC=m
> CONFIG_PCMCIA_PROBE=y
> CONFIG_PCCARD_NONSTATIC=m
> CONFIG_HOTPLUG_PCI=m
> CONFIG_HOTPLUG_PCI_FAKE=m
> CONFIG_HOTPLUG_PCI_COMPAQ=m
> CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
> CONFIG_HOTPLUG_PCI_IBM=m
> CONFIG_HOTPLUG_PCI_ACPI=m
> CONFIG_HOTPLUG_PCI_ACPI_IBM=m
> CONFIG_HOTPLUG_PCI_CPCI=y
> CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
> CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
> CONFIG_HOTPLUG_PCI_SHPC=m
>
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_BINFMT_AOUT=m
> CONFIG_BINFMT_MISC=m
> CONFIG_NET=y
>
> #
> # Networking options
> #
> CONFIG_PACKET=m
> CONFIG_PACKET_MMAP=y
> CONFIG_UNIX=y
> CONFIG_XFRM=y
> CONFIG_XFRM_USER=m
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> CONFIG_XFRM_STATISTICS=y
> CONFIG_XFRM_IPCOMP=m
> CONFIG_NET_KEY=m
> # CONFIG_NET_KEY_MIGRATE is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> CONFIG_IP_ADVANCED_ROUTER=y
> CONFIG_ASK_IP_FIB_HASH=y
> # CONFIG_IP_FIB_TRIE is not set
> CONFIG_IP_FIB_HASH=y
> CONFIG_IP_MULTIPLE_TABLES=y
> CONFIG_IP_ROUTE_MULTIPATH=y
> CONFIG_IP_ROUTE_VERBOSE=y
> # CONFIG_IP_PNP is not set
> CONFIG_NET_IPIP=m
> CONFIG_NET_IPGRE=m
> CONFIG_NET_IPGRE_BROADCAST=y
> CONFIG_IP_MROUTE=y
> CONFIG_IP_PIMSM_V1=y
> CONFIG_IP_PIMSM_V2=y
> # CONFIG_ARPD is not set
> CONFIG_SYN_COOKIES=y
> CONFIG_INET_AH=m
> CONFIG_INET_ESP=m
> CONFIG_INET_IPCOMP=m
> CONFIG_INET_XFRM_TUNNEL=m
> CONFIG_INET_TUNNEL=m
> CONFIG_INET_XFRM_MODE_TRANSPORT=m
> CONFIG_INET_XFRM_MODE_TUNNEL=m
> CONFIG_INET_XFRM_MODE_BEET=m
> CONFIG_INET_LRO=y
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> CONFIG_TCP_CONG_ADVANCED=y
> CONFIG_TCP_CONG_BIC=m
> CONFIG_TCP_CONG_CUBIC=m
> CONFIG_TCP_CONG_WESTWOOD=m
> CONFIG_TCP_CONG_HTCP=m
> CONFIG_TCP_CONG_HSTCP=m
> CONFIG_TCP_CONG_HYBLA=m
> CONFIG_TCP_CONG_VEGAS=m
> CONFIG_TCP_CONG_SCALABLE=m
> CONFIG_TCP_CONG_LP=m
> CONFIG_TCP_CONG_VENO=m
> CONFIG_TCP_CONG_YEAH=m
> CONFIG_TCP_CONG_ILLINOIS=m
> # CONFIG_DEFAULT_BIC is not set
> # CONFIG_DEFAULT_CUBIC is not set
> # CONFIG_DEFAULT_HTCP is not set
> # CONFIG_DEFAULT_VEGAS is not set
> # CONFIG_DEFAULT_WESTWOOD is not set
> CONFIG_DEFAULT_RENO=y
> CONFIG_DEFAULT_TCP_CONG="reno"
> CONFIG_TCP_MD5SIG=y
> CONFIG_IP_VS=m
> # CONFIG_IP_VS_DEBUG is not set
> CONFIG_IP_VS_TAB_BITS=12
>
> #
> # IPVS transport protocol load balancing support
> #
> CONFIG_IP_VS_PROTO_TCP=y
> CONFIG_IP_VS_PROTO_UDP=y
> CONFIG_IP_VS_PROTO_ESP=y
> CONFIG_IP_VS_PROTO_AH=y
>
> #
> # IPVS scheduler
> #
> CONFIG_IP_VS_RR=m
> CONFIG_IP_VS_WRR=m
> CONFIG_IP_VS_LC=m
> CONFIG_IP_VS_WLC=m
> CONFIG_IP_VS_LBLC=m
> CONFIG_IP_VS_LBLCR=m
> CONFIG_IP_VS_DH=m
> CONFIG_IP_VS_SH=m
> CONFIG_IP_VS_SED=m
> CONFIG_IP_VS_NQ=m
>
> #
> # IPVS application helper
> #
> CONFIG_IP_VS_FTP=m
> CONFIG_IPV6=m
> CONFIG_IPV6_PRIVACY=y
> # CONFIG_IPV6_ROUTER_PREF is not set
> # CONFIG_IPV6_OPTIMISTIC_DAD is not set
> CONFIG_INET6_AH=m
> CONFIG_INET6_ESP=m
> CONFIG_INET6_IPCOMP=m
> # CONFIG_IPV6_MIP6 is not set
> CONFIG_INET6_XFRM_TUNNEL=m
> CONFIG_INET6_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_TRANSPORT=m
> CONFIG_INET6_XFRM_MODE_TUNNEL=m
> CONFIG_INET6_XFRM_MODE_BEET=m
> CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
> CONFIG_IPV6_SIT=m
> CONFIG_IPV6_NDISC_NODETYPE=y
> CONFIG_IPV6_TUNNEL=m
> # CONFIG_IPV6_MULTIPLE_TABLES is not set
> CONFIG_IPV6_MROUTE=y
> # CONFIG_IPV6_PIMSM_V2 is not set
> # CONFIG_NETLABEL is not set
> CONFIG_NETWORK_SECMARK=y
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=y
> CONFIG_BRIDGE_NETFILTER=y
>
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=m
> CONFIG_NETFILTER_NETLINK_QUEUE=m
> CONFIG_NETFILTER_NETLINK_LOG=m
> CONFIG_NF_CONNTRACK=m
> CONFIG_NF_CT_ACCT=y
> CONFIG_NF_CONNTRACK_MARK=y
> CONFIG_NF_CONNTRACK_SECMARK=y
> CONFIG_NF_CONNTRACK_EVENTS=y
> CONFIG_NF_CT_PROTO_DCCP=m
> CONFIG_NF_CT_PROTO_GRE=m
> CONFIG_NF_CT_PROTO_SCTP=m
> CONFIG_NF_CT_PROTO_UDPLITE=m
> CONFIG_NF_CONNTRACK_AMANDA=m
> CONFIG_NF_CONNTRACK_FTP=m
> CONFIG_NF_CONNTRACK_H323=m
> CONFIG_NF_CONNTRACK_IRC=m
> CONFIG_NF_CONNTRACK_NETBIOS_NS=m
> CONFIG_NF_CONNTRACK_PPTP=m
> # CONFIG_NF_CONNTRACK_SANE is not set
> CONFIG_NF_CONNTRACK_SIP=m
> CONFIG_NF_CONNTRACK_TFTP=m
> CONFIG_NF_CT_NETLINK=m
> CONFIG_NETFILTER_XTABLES=m
> CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
> CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
> CONFIG_NETFILTER_XT_TARGET_DSCP=m
> CONFIG_NETFILTER_XT_TARGET_MARK=m
> CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
> CONFIG_NETFILTER_XT_TARGET_NFLOG=m
> CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
> # CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
> CONFIG_NETFILTER_XT_TARGET_TRACE=m
> CONFIG_NETFILTER_XT_TARGET_SECMARK=m
> CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
> CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
> CONFIG_NETFILTER_XT_MATCH_COMMENT=m
> CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
> CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
> CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
> CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
> CONFIG_NETFILTER_XT_MATCH_DCCP=m
> CONFIG_NETFILTER_XT_MATCH_DSCP=m
> CONFIG_NETFILTER_XT_MATCH_ESP=m
> CONFIG_NETFILTER_XT_MATCH_HELPER=m
> # CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
> CONFIG_NETFILTER_XT_MATCH_LENGTH=m
> CONFIG_NETFILTER_XT_MATCH_LIMIT=m
> CONFIG_NETFILTER_XT_MATCH_MAC=m
> CONFIG_NETFILTER_XT_MATCH_MARK=m
> # CONFIG_NETFILTER_XT_MATCH_OWNER is not set
> CONFIG_NETFILTER_XT_MATCH_POLICY=m
> CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
> CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
> CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
> CONFIG_NETFILTER_XT_MATCH_QUOTA=m
> # CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
> CONFIG_NETFILTER_XT_MATCH_REALM=m
> CONFIG_NETFILTER_XT_MATCH_SCTP=m
> CONFIG_NETFILTER_XT_MATCH_STATE=m
> CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
> CONFIG_NETFILTER_XT_MATCH_STRING=m
> CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
> CONFIG_NETFILTER_XT_MATCH_TIME=m
> CONFIG_NETFILTER_XT_MATCH_U32=m
> CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
>
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_CONNTRACK_IPV4=m
> CONFIG_NF_CONNTRACK_PROC_COMPAT=y
> CONFIG_IP_NF_QUEUE=m
> CONFIG_IP_NF_IPTABLES=m
> CONFIG_IP_NF_MATCH_RECENT=m
> CONFIG_IP_NF_MATCH_ECN=m
> CONFIG_IP_NF_MATCH_AH=m
> CONFIG_IP_NF_MATCH_TTL=m
> CONFIG_IP_NF_MATCH_ADDRTYPE=m
> CONFIG_IP_NF_FILTER=m
> CONFIG_IP_NF_TARGET_REJECT=m
> CONFIG_IP_NF_TARGET_LOG=m
> CONFIG_IP_NF_TARGET_ULOG=m
> CONFIG_NF_NAT=m
> CONFIG_NF_NAT_NEEDED=y
> CONFIG_IP_NF_TARGET_MASQUERADE=m
> CONFIG_IP_NF_TARGET_REDIRECT=m
> CONFIG_IP_NF_TARGET_NETMAP=m
> CONFIG_NF_NAT_SNMP_BASIC=m
> CONFIG_NF_NAT_PROTO_DCCP=m
> CONFIG_NF_NAT_PROTO_GRE=m
> CONFIG_NF_NAT_PROTO_UDPLITE=m
> CONFIG_NF_NAT_PROTO_SCTP=m
> CONFIG_NF_NAT_FTP=m
> CONFIG_NF_NAT_IRC=m
> CONFIG_NF_NAT_TFTP=m
> CONFIG_NF_NAT_AMANDA=m
> CONFIG_NF_NAT_PPTP=m
> CONFIG_NF_NAT_H323=m
> CONFIG_NF_NAT_SIP=m
> CONFIG_IP_NF_MANGLE=m
> CONFIG_IP_NF_TARGET_ECN=m
> CONFIG_IP_NF_TARGET_TTL=m
> CONFIG_IP_NF_TARGET_CLUSTERIP=m
> CONFIG_IP_NF_RAW=m
> # CONFIG_IP_NF_SECURITY is not set
> CONFIG_IP_NF_ARPTABLES=m
> CONFIG_IP_NF_ARPFILTER=m
> CONFIG_IP_NF_ARP_MANGLE=m
>
> #
> # IPv6: Netfilter Configuration
> #
> CONFIG_NF_CONNTRACK_IPV6=m
> CONFIG_IP6_NF_QUEUE=m
> CONFIG_IP6_NF_IPTABLES=m
> CONFIG_IP6_NF_MATCH_RT=m
> CONFIG_IP6_NF_MATCH_OPTS=m
> CONFIG_IP6_NF_MATCH_FRAG=m
> CONFIG_IP6_NF_MATCH_HL=m
> CONFIG_IP6_NF_MATCH_IPV6HEADER=m
> CONFIG_IP6_NF_MATCH_AH=m
> CONFIG_IP6_NF_MATCH_MH=m
> CONFIG_IP6_NF_MATCH_EUI64=m
> CONFIG_IP6_NF_FILTER=m
> CONFIG_IP6_NF_TARGET_LOG=m
> CONFIG_IP6_NF_TARGET_REJECT=m
> CONFIG_IP6_NF_MANGLE=m
> CONFIG_IP6_NF_TARGET_HL=m
> CONFIG_IP6_NF_RAW=m
> # CONFIG_IP6_NF_SECURITY is not set
>
> #
> # DECnet: Netfilter Configuration
> #
> CONFIG_DECNET_NF_GRABULATOR=m
>
> #
> # Bridge: Netfilter Configuration
> #
> CONFIG_BRIDGE_NF_EBTABLES=m
> CONFIG_BRIDGE_EBT_BROUTE=m
> CONFIG_BRIDGE_EBT_T_FILTER=m
> CONFIG_BRIDGE_EBT_T_NAT=m
> CONFIG_BRIDGE_EBT_802_3=m
> CONFIG_BRIDGE_EBT_AMONG=m
> CONFIG_BRIDGE_EBT_ARP=m
> CONFIG_BRIDGE_EBT_IP=m
> CONFIG_BRIDGE_EBT_IP6=m
> CONFIG_BRIDGE_EBT_LIMIT=m
> CONFIG_BRIDGE_EBT_MARK=m
> CONFIG_BRIDGE_EBT_PKTTYPE=m
> CONFIG_BRIDGE_EBT_STP=m
> CONFIG_BRIDGE_EBT_VLAN=m
> CONFIG_BRIDGE_EBT_ARPREPLY=m
> CONFIG_BRIDGE_EBT_DNAT=m
> CONFIG_BRIDGE_EBT_MARK_T=m
> CONFIG_BRIDGE_EBT_REDIRECT=m
> CONFIG_BRIDGE_EBT_SNAT=m
> CONFIG_BRIDGE_EBT_LOG=m
> CONFIG_BRIDGE_EBT_ULOG=m
> # CONFIG_BRIDGE_EBT_NFLOG is not set
> CONFIG_IP_DCCP=m
> CONFIG_INET_DCCP_DIAG=m
> CONFIG_IP_DCCP_ACKVEC=y
>
> #
> # DCCP CCIDs Configuration (EXPERIMENTAL)
> #
> CONFIG_IP_DCCP_CCID2=m
> # CONFIG_IP_DCCP_CCID2_DEBUG is not set
> CONFIG_IP_DCCP_CCID3=m
> # CONFIG_IP_DCCP_CCID3_DEBUG is not set
> CONFIG_IP_DCCP_CCID3_RTO=100
> CONFIG_IP_DCCP_TFRC_LIB=m
>
> #
> # DCCP Kernel Hacking
> #
> # CONFIG_IP_DCCP_DEBUG is not set
> CONFIG_NET_DCCPPROBE=m
> CONFIG_IP_SCTP=m
> # CONFIG_SCTP_DBG_MSG is not set
> # CONFIG_SCTP_DBG_OBJCNT is not set
> # CONFIG_SCTP_HMAC_NONE is not set
> # CONFIG_SCTP_HMAC_SHA1 is not set
> CONFIG_SCTP_HMAC_MD5=y
> CONFIG_TIPC=m
> # CONFIG_TIPC_ADVANCED is not set
> # CONFIG_TIPC_DEBUG is not set
> CONFIG_ATM=y
> CONFIG_ATM_CLIP=y
> # CONFIG_ATM_CLIP_NO_ICMP is not set
> CONFIG_ATM_LANE=m
> CONFIG_ATM_MPOA=m
> CONFIG_ATM_BR2684=m
> # CONFIG_ATM_BR2684_IPFILTER is not set
> CONFIG_STP=m
> CONFIG_BRIDGE=m
> CONFIG_VLAN_8021Q=m
> # CONFIG_VLAN_8021Q_GVRP is not set
> CONFIG_DECNET=m
> # CONFIG_DECNET_ROUTER is not set
> CONFIG_LLC=y
> CONFIG_LLC2=m
> CONFIG_IPX=m
> # CONFIG_IPX_INTERN is not set
> CONFIG_ATALK=m
> CONFIG_DEV_APPLETALK=m
> CONFIG_LTPC=m
> CONFIG_COPS=m
> CONFIG_COPS_DAYNA=y
> CONFIG_COPS_TANGENT=y
> CONFIG_IPDDP=m
> CONFIG_IPDDP_ENCAP=y
> CONFIG_IPDDP_DECAP=y
> CONFIG_X25=m
> CONFIG_LAPB=m
> CONFIG_ECONET=m
> CONFIG_ECONET_AUNUDP=y
> CONFIG_ECONET_NATIVE=y
> CONFIG_WAN_ROUTER=m
> # CONFIG_NET_SCHED is not set
> CONFIG_NET_CLS_ROUTE=y
>
> #
> # Network testing
> #
> CONFIG_NET_PKTGEN=m
> CONFIG_NET_TCPPROBE=m
> CONFIG_HAMRADIO=y
>
> #
> # Packet Radio protocols
> #
> CONFIG_AX25=m
> # CONFIG_AX25_DAMA_SLAVE is not set
> CONFIG_NETROM=m
> CONFIG_ROSE=m
>
> #
> # AX.25 network device drivers
> #
> CONFIG_MKISS=m
> CONFIG_6PACK=m
> CONFIG_BPQETHER=m
> CONFIG_SCC=m
> # CONFIG_SCC_DELAY is not set
> # CONFIG_SCC_TRXECHO is not set
> CONFIG_BAYCOM_SER_FDX=m
> CONFIG_BAYCOM_SER_HDX=m
> CONFIG_BAYCOM_PAR=m
> CONFIG_BAYCOM_EPP=m
> CONFIG_YAM=m
> # CONFIG_CAN is not set
> CONFIG_IRDA=m
>
> #
> # IrDA protocols
> #
> CONFIG_IRLAN=m
> CONFIG_IRNET=m
> CONFIG_IRCOMM=m
> CONFIG_IRDA_ULTRA=y
>
> #
> # IrDA options
> #
> CONFIG_IRDA_CACHE_LAST_LSAP=y
> CONFIG_IRDA_FAST_RR=y
> CONFIG_IRDA_DEBUG=y
>
> #
> # Infrared-port device drivers
> #
>
> #
> # SIR device drivers
> #
> CONFIG_IRTTY_SIR=m
>
> #
> # Dongle support
> #
> CONFIG_DONGLE=y
> CONFIG_ESI_DONGLE=m
> CONFIG_ACTISYS_DONGLE=m
> CONFIG_TEKRAM_DONGLE=m
> # CONFIG_TOIM3232_DONGLE is not set
> CONFIG_LITELINK_DONGLE=m
> CONFIG_MA600_DONGLE=m
> CONFIG_GIRBIL_DONGLE=m
> CONFIG_MCP2120_DONGLE=m
> CONFIG_OLD_BELKIN_DONGLE=m
> CONFIG_ACT200L_DONGLE=m
> CONFIG_KINGSUN_DONGLE=m
> CONFIG_KSDAZZLE_DONGLE=m
> CONFIG_KS959_DONGLE=m
>
> #
> # FIR device drivers
> #
> CONFIG_USB_IRDA=m
> CONFIG_SIGMATEL_FIR=m
> CONFIG_NSC_FIR=m
> CONFIG_WINBOND_FIR=m
> CONFIG_TOSHIBA_FIR=m
> CONFIG_SMC_IRCC_FIR=m
> CONFIG_ALI_FIR=m
> CONFIG_VLSI_FIR=m
> CONFIG_VIA_FIR=m
> CONFIG_MCS_FIR=m
> CONFIG_BT=m
> CONFIG_BT_L2CAP=m
> CONFIG_BT_SCO=m
> CONFIG_BT_RFCOMM=m
> CONFIG_BT_RFCOMM_TTY=y
> CONFIG_BT_BNEP=m
> CONFIG_BT_BNEP_MC_FILTER=y
> CONFIG_BT_BNEP_PROTO_FILTER=y
> CONFIG_BT_HIDP=m
>
> #
> # Bluetooth device drivers
> #
> CONFIG_BT_HCIUSB=m
> CONFIG_BT_HCIUSB_SCO=y
> CONFIG_BT_HCIBTSDIO=m
> CONFIG_BT_HCIUART=m
> CONFIG_BT_HCIUART_H4=y
> CONFIG_BT_HCIUART_BCSP=y
> CONFIG_BT_HCIUART_LL=y
> CONFIG_BT_HCIBCM203X=m
> CONFIG_BT_HCIBPA10X=m
> CONFIG_BT_HCIBFUSB=m
> CONFIG_BT_HCIDTL1=m
> CONFIG_BT_HCIBT3C=m
> CONFIG_BT_HCIBLUECARD=m
> CONFIG_BT_HCIBTUART=m
> CONFIG_BT_HCIVHCI=m
> CONFIG_AF_RXRPC=m
> # CONFIG_AF_RXRPC_DEBUG is not set
> CONFIG_RXKAD=m
> CONFIG_FIB_RULES=y
>
> #
> # Wireless
> #
> CONFIG_CFG80211=m
> CONFIG_NL80211=y
> CONFIG_WIRELESS_EXT=y
> # CONFIG_WIRELESS_EXT_SYSFS is not set
> CONFIG_MAC80211=m
>
> #
> # Rate control algorithm selection
> #
> CONFIG_MAC80211_RC_PID=y
> CONFIG_MAC80211_RC_DEFAULT_PID=y
> CONFIG_MAC80211_RC_DEFAULT="pid"
> # CONFIG_MAC80211_MESH is not set
> CONFIG_MAC80211_LEDS=y
> CONFIG_MAC80211_DEBUGFS=y
> CONFIG_MAC80211_DEBUG_MENU=y
> # CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
> # CONFIG_MAC80211_NOINLINE is not set
> # CONFIG_MAC80211_VERBOSE_DEBUG is not set
> # CONFIG_MAC80211_HT_DEBUG is not set
> # CONFIG_MAC80211_TKIP_DEBUG is not set
> # CONFIG_MAC80211_IBSS_DEBUG is not set
> # CONFIG_MAC80211_VERBOSE_PS_DEBUG is not set
> # CONFIG_MAC80211_LOWTX_FRAME_DUMP is not set
> # CONFIG_MAC80211_DEBUG_COUNTERS is not set
> # CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG is not set
> CONFIG_IEEE80211=m
> # CONFIG_IEEE80211_DEBUG is not set
> CONFIG_IEEE80211_CRYPT_WEP=m
> CONFIG_IEEE80211_CRYPT_CCMP=m
> CONFIG_IEEE80211_CRYPT_TKIP=m
> CONFIG_RFKILL=m
> CONFIG_RFKILL_INPUT=m
> CONFIG_RFKILL_LEDS=y
> CONFIG_NET_9P=m
> CONFIG_NET_9P_VIRTIO=m
> # CONFIG_NET_9P_DEBUG is not set
>
> #
> # Device Drivers
> #
>
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> CONFIG_CONNECTOR=m
> CONFIG_MTD=m
> # CONFIG_MTD_DEBUG is not set
> CONFIG_MTD_CONCAT=m
> CONFIG_MTD_PARTITIONS=y
> CONFIG_MTD_REDBOOT_PARTS=m
> CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
> # CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
> # CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
> # CONFIG_MTD_AR7_PARTS is not set
>
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_CHAR=m
> CONFIG_HAVE_MTD_OTP=y
> CONFIG_MTD_BLKDEVS=m
> CONFIG_MTD_BLOCK=m
> CONFIG_MTD_BLOCK_RO=m
> CONFIG_FTL=m
> CONFIG_NFTL=m
> CONFIG_NFTL_RW=y
> CONFIG_INFTL=m
> CONFIG_RFD_FTL=m
> CONFIG_SSFDC=m
> CONFIG_MTD_OOPS=m
>
> #
> # RAM/ROM/Flash chip drivers
> #
> CONFIG_MTD_CFI=m
> CONFIG_MTD_JEDECPROBE=m
> CONFIG_MTD_GEN_PROBE=m
> # CONFIG_MTD_CFI_ADV_OPTIONS is not set
> CONFIG_MTD_MAP_BANK_WIDTH_1=y
> CONFIG_MTD_MAP_BANK_WIDTH_2=y
> CONFIG_MTD_MAP_BANK_WIDTH_4=y
> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
> CONFIG_MTD_CFI_I1=y
> CONFIG_MTD_CFI_I2=y
> # CONFIG_MTD_CFI_I4 is not set
> # CONFIG_MTD_CFI_I8 is not set
> CONFIG_MTD_CFI_INTELEXT=m
> CONFIG_MTD_CFI_AMDSTD=m
> CONFIG_MTD_CFI_STAA=m
> CONFIG_MTD_CFI_UTIL=m
> CONFIG_MTD_RAM=m
> CONFIG_MTD_ROM=m
> CONFIG_MTD_ABSENT=m
>
> #
> # Mapping drivers for chip access
> #
> CONFIG_MTD_COMPLEX_MAPPINGS=y
> CONFIG_MTD_PHYSMAP=m
> CONFIG_MTD_PHYSMAP_START=0x8000000
> CONFIG_MTD_PHYSMAP_LEN=0x4000000
> CONFIG_MTD_PHYSMAP_BANKWIDTH=2
> CONFIG_MTD_SC520CDP=m
> CONFIG_MTD_NETSC520=m
> CONFIG_MTD_TS5500=m
> CONFIG_MTD_SBC_GXX=m
> CONFIG_MTD_SCx200_DOCFLASH=m
> CONFIG_MTD_AMD76XROM=m
> CONFIG_MTD_ICHXROM=m
> CONFIG_MTD_ESB2ROM=m
> CONFIG_MTD_CK804XROM=m
> CONFIG_MTD_SCB2_FLASH=m
> CONFIG_MTD_NETtel=m
> CONFIG_MTD_DILNETPC=m
> CONFIG_MTD_DILNETPC_BOOTSIZE=0x80000
> CONFIG_MTD_L440GX=m
> CONFIG_MTD_PCI=m
> CONFIG_MTD_INTEL_VR_NOR=m
> CONFIG_MTD_PLATRAM=m
>
> #
> # Self-contained MTD device drivers
> #
> CONFIG_MTD_PMC551=m
> # CONFIG_MTD_PMC551_BUGFIX is not set
> # CONFIG_MTD_PMC551_DEBUG is not set
> CONFIG_MTD_DATAFLASH=m
> CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
> CONFIG_MTD_DATAFLASH_OTP=y
> CONFIG_MTD_M25P80=m
> CONFIG_M25PXX_USE_FAST_READ=y
> CONFIG_MTD_SLRAM=m
> CONFIG_MTD_PHRAM=m
> CONFIG_MTD_MTDRAM=m
> CONFIG_MTDRAM_TOTAL_SIZE=4096
> CONFIG_MTDRAM_ERASE_SIZE=128
> CONFIG_MTD_BLOCK2MTD=m
>
> #
> # Disk-On-Chip Device Drivers
> #
> CONFIG_MTD_DOC2000=m
> CONFIG_MTD_DOC2001=m
> CONFIG_MTD_DOC2001PLUS=m
> CONFIG_MTD_DOCPROBE=m
> CONFIG_MTD_DOCECC=m
> # CONFIG_MTD_DOCPROBE_ADVANCED is not set
> CONFIG_MTD_DOCPROBE_ADDRESS=0
> CONFIG_MTD_NAND=m
> # CONFIG_MTD_NAND_VERIFY_WRITE is not set
> # CONFIG_MTD_NAND_ECC_SMC is not set
> # CONFIG_MTD_NAND_MUSEUM_IDS is not set
> CONFIG_MTD_NAND_IDS=m
> CONFIG_MTD_NAND_DISKONCHIP=m
> # CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
> CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
> # CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
> CONFIG_MTD_NAND_CAFE=m
> CONFIG_MTD_NAND_CS553X=m
> CONFIG_MTD_NAND_NANDSIM=m
> CONFIG_MTD_NAND_PLATFORM=m
> CONFIG_MTD_ALAUDA=m
> CONFIG_MTD_ONENAND=m
> CONFIG_MTD_ONENAND_VERIFY_WRITE=y
> # CONFIG_MTD_ONENAND_OTP is not set
> CONFIG_MTD_ONENAND_2X_PROGRAM=y
> CONFIG_MTD_ONENAND_SIM=m
>
> #
> # UBI - Unsorted block images
> #
> CONFIG_MTD_UBI=m
> CONFIG_MTD_UBI_WL_THRESHOLD=4096
> CONFIG_MTD_UBI_BEB_RESERVE=1
> CONFIG_MTD_UBI_GLUEBI=y
>
> #
> # UBI debugging options
> #
> # CONFIG_MTD_UBI_DEBUG is not set
> CONFIG_PARPORT=m
> CONFIG_PARPORT_PC=m
> CONFIG_PARPORT_SERIAL=m
> CONFIG_PARPORT_PC_FIFO=y
> # CONFIG_PARPORT_PC_SUPERIO is not set
> CONFIG_PARPORT_PC_PCMCIA=m
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=m
> CONFIG_PARPORT_1284=y
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG is not set
>
> #
> # Protocols
> #
> CONFIG_ISAPNP=y
> CONFIG_PNPBIOS=y
> CONFIG_PNPBIOS_PROC_FS=y
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_FD=m
> CONFIG_BLK_DEV_XD=m
> CONFIG_PARIDE=m
>
> #
> # Parallel IDE high-level drivers
> #
> CONFIG_PARIDE_PD=m
> CONFIG_PARIDE_PCD=m
> CONFIG_PARIDE_PF=m
> CONFIG_PARIDE_PT=m
> CONFIG_PARIDE_PG=m
>
> #
> # Parallel IDE protocol modules
> #
> CONFIG_PARIDE_ATEN=m
> CONFIG_PARIDE_BPCK=m
> CONFIG_PARIDE_BPCK6=m
> CONFIG_PARIDE_COMM=m
> CONFIG_PARIDE_DSTR=m
> CONFIG_PARIDE_FIT2=m
> CONFIG_PARIDE_FIT3=m
> CONFIG_PARIDE_EPAT=m
> # CONFIG_PARIDE_EPATC8 is not set
> CONFIG_PARIDE_EPIA=m
> CONFIG_PARIDE_FRIQ=m
> CONFIG_PARIDE_FRPW=m
> CONFIG_PARIDE_KBIC=m
> CONFIG_PARIDE_KTTI=m
> CONFIG_PARIDE_ON20=m
> CONFIG_PARIDE_ON26=m
> CONFIG_BLK_CPQ_DA=m
> CONFIG_BLK_CPQ_CISS_DA=m
> CONFIG_CISS_SCSI_TAPE=y
> CONFIG_BLK_DEV_DAC960=m
> CONFIG_BLK_DEV_UMEM=m
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=m
> CONFIG_BLK_DEV_CRYPTOLOOP=m
> CONFIG_BLK_DEV_NBD=m
> CONFIG_BLK_DEV_SX8=m
> # CONFIG_BLK_DEV_UB is not set
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=65536
> # CONFIG_BLK_DEV_XIP is not set
> CONFIG_CDROM_PKTCDVD=m
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> # CONFIG_CDROM_PKTCDVD_WCACHE is not set
> CONFIG_ATA_OVER_ETH=m
> CONFIG_VIRTIO_BLK=m
> # CONFIG_BLK_DEV_HD is not set
> CONFIG_MISC_DEVICES=y
> CONFIG_IBM_ASM=m
> CONFIG_PHANTOM=m
> CONFIG_EEPROM_93CX6=m
> CONFIG_SGI_IOC4=m
> CONFIG_TIFM_CORE=m
> CONFIG_TIFM_7XX1=m
> # CONFIG_ACER_WMI is not set
> CONFIG_ASUS_LAPTOP=m
> CONFIG_FUJITSU_LAPTOP=m
> # CONFIG_FUJITSU_LAPTOP_DEBUG is not set
> # CONFIG_TC1100_WMI is not set
> # CONFIG_HP_WMI is not set
> CONFIG_MSI_LAPTOP=m
> # CONFIG_COMPAL_LAPTOP is not set
> CONFIG_SONY_LAPTOP=m
> CONFIG_SONYPI_COMPAT=y
> CONFIG_THINKPAD_ACPI=m
> # CONFIG_THINKPAD_ACPI_DEBUG is not set
> CONFIG_THINKPAD_ACPI_BAY=y
> CONFIG_THINKPAD_ACPI_VIDEO=y
> # CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
> # CONFIG_INTEL_MENLOW is not set
> # CONFIG_EEEPC_LAPTOP is not set
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_HP_ILO is not set
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=y
> CONFIG_BLK_DEV_IDE=m
>
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_TIMINGS=y
> CONFIG_IDE_ATAPI=y
> CONFIG_BLK_DEV_IDE_SATA=y
> CONFIG_BLK_DEV_IDEDISK=m
> # CONFIG_BLK_DEV_IDECS is not set
> CONFIG_BLK_DEV_DELKIN=m
> CONFIG_BLK_DEV_IDECD=m
> CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
> CONFIG_BLK_DEV_IDETAPE=m
> CONFIG_BLK_DEV_IDEFLOPPY=m
> CONFIG_BLK_DEV_IDESCSI=m
> CONFIG_BLK_DEV_IDEACPI=y
> # CONFIG_IDE_TASK_IOCTL is not set
> CONFIG_IDE_PROC_FS=y
>
> #
> # IDE chipset support/bugfixes
> #
> CONFIG_IDE_GENERIC=m
> CONFIG_BLK_DEV_PLATFORM=m
> CONFIG_BLK_DEV_CMD640=m
> # CONFIG_BLK_DEV_CMD640_ENHANCED is not set
> CONFIG_BLK_DEV_IDEPNP=m
> CONFIG_BLK_DEV_IDEDMA_SFF=y
>
> #
> # PCI IDE chipsets support
> #
> CONFIG_BLK_DEV_IDEPCI=y
> # CONFIG_BLK_DEV_OFFBOARD is not set
> # CONFIG_BLK_DEV_GENERIC is not set
> CONFIG_BLK_DEV_OPTI621=m
> # CONFIG_BLK_DEV_RZ1000 is not set
> CONFIG_BLK_DEV_IDEDMA_PCI=y
> CONFIG_BLK_DEV_AEC62XX=m
> CONFIG_BLK_DEV_ALI15X3=m
> # CONFIG_BLK_DEV_AMD74XX is not set
> CONFIG_BLK_DEV_ATIIXP=m
> CONFIG_BLK_DEV_CMD64X=m
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_CS5520 is not set
> CONFIG_BLK_DEV_CS5530=m
> CONFIG_BLK_DEV_CS5535=m
> CONFIG_BLK_DEV_HPT366=m
> # CONFIG_BLK_DEV_JMICRON is not set
> CONFIG_BLK_DEV_SC1200=m
> # CONFIG_BLK_DEV_PIIX is not set
> # CONFIG_BLK_DEV_IT8213 is not set
> # CONFIG_BLK_DEV_IT821X is not set
> CONFIG_BLK_DEV_NS87415=m
> CONFIG_BLK_DEV_PDC202XX_OLD=m
> # CONFIG_BLK_DEV_PDC202XX_NEW is not set
> # CONFIG_BLK_DEV_SVWKS is not set
> # CONFIG_BLK_DEV_SIIMAGE is not set
> # CONFIG_BLK_DEV_SIS5513 is not set
> # CONFIG_BLK_DEV_SLC90E66 is not set
> CONFIG_BLK_DEV_TRM290=m
> # CONFIG_BLK_DEV_VIA82CXXX is not set
> CONFIG_BLK_DEV_TC86C001=m
>
> #
> # Other IDE chipsets support
> #
>
> #
> # Note: most of these also require special kernel boot parameters
> #
> CONFIG_BLK_DEV_4DRIVES=m
> CONFIG_BLK_DEV_ALI14XX=m
> CONFIG_BLK_DEV_DTC2278=m
> CONFIG_BLK_DEV_HT6560B=m
> CONFIG_BLK_DEV_QD65XX=m
> CONFIG_BLK_DEV_UMC8672=m
> CONFIG_BLK_DEV_IDEDMA=y
>
> #
> # SCSI device support
> #
> CONFIG_RAID_ATTRS=m
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=m
> CONFIG_SCSI_NETLINK=y
> CONFIG_SCSI_PROC_FS=y
>
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> CONFIG_CHR_DEV_OSST=m
> CONFIG_BLK_DEV_SR=y
> # CONFIG_BLK_DEV_SR_VENDOR is not set
> CONFIG_CHR_DEV_SG=y
> CONFIG_CHR_DEV_SCH=m
>
> #
> # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
> #
> CONFIG_SCSI_MULTI_LUN=y
> CONFIG_SCSI_CONSTANTS=y
> CONFIG_SCSI_LOGGING=y
> CONFIG_SCSI_SCAN_ASYNC=y
> CONFIG_SCSI_WAIT_SCAN=m
>
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=m
> CONFIG_SCSI_FC_ATTRS=m
> CONFIG_SCSI_FC_TGT_ATTRS=y
> CONFIG_SCSI_ISCSI_ATTRS=m
> CONFIG_SCSI_SAS_ATTRS=m
> CONFIG_SCSI_SAS_LIBSAS=m
> CONFIG_SCSI_SAS_ATA=y
> CONFIG_SCSI_SAS_HOST_SMP=y
> # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
> CONFIG_SCSI_SRP_ATTRS=m
> CONFIG_SCSI_SRP_TGT_ATTRS=y
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ISCSI_TCP=m
> CONFIG_BLK_DEV_3W_XXXX_RAID=m
> CONFIG_SCSI_3W_9XXX=m
> CONFIG_SCSI_7000FASST=m
> CONFIG_SCSI_ACARD=m
> CONFIG_SCSI_AHA152X=m
> CONFIG_SCSI_AHA1542=m
> CONFIG_SCSI_AHA1740=m
> CONFIG_SCSI_AACRAID=m
> CONFIG_SCSI_AIC7XXX=m
> CONFIG_AIC7XXX_CMDS_PER_DEVICE=8
> CONFIG_AIC7XXX_RESET_DELAY_MS=15000
> CONFIG_AIC7XXX_DEBUG_ENABLE=y
> CONFIG_AIC7XXX_DEBUG_MASK=0
> CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
> # CONFIG_SCSI_AIC7XXX_OLD is not set
> CONFIG_SCSI_AIC79XX=m
> CONFIG_AIC79XX_CMDS_PER_DEVICE=32
> CONFIG_AIC79XX_RESET_DELAY_MS=15000
> CONFIG_AIC79XX_DEBUG_ENABLE=y
> CONFIG_AIC79XX_DEBUG_MASK=0
> CONFIG_AIC79XX_REG_PRETTY_PRINT=y
> CONFIG_SCSI_AIC94XX=m
> # CONFIG_AIC94XX_DEBUG is not set
> CONFIG_SCSI_DPT_I2O=m
> CONFIG_SCSI_ADVANSYS=m
> CONFIG_SCSI_IN2000=m
> CONFIG_SCSI_ARCMSR=m
> CONFIG_SCSI_ARCMSR_AER=y
> CONFIG_MEGARAID_NEWGEN=y
> CONFIG_MEGARAID_MM=m
> CONFIG_MEGARAID_MAILBOX=m
> CONFIG_MEGARAID_LEGACY=m
> CONFIG_MEGARAID_SAS=m
> CONFIG_SCSI_HPTIOP=m
> CONFIG_SCSI_BUSLOGIC=m
> # CONFIG_SCSI_FLASHPOINT is not set
> CONFIG_SCSI_DMX3191D=m
> CONFIG_SCSI_DTC3280=m
> CONFIG_SCSI_EATA=m
> CONFIG_SCSI_EATA_TAGGED_QUEUE=y
> CONFIG_SCSI_EATA_LINKED_COMMANDS=y
> CONFIG_SCSI_EATA_MAX_TAGS=16
> CONFIG_SCSI_FUTURE_DOMAIN=m
> CONFIG_SCSI_FD_MCS=m
> CONFIG_SCSI_GDTH=y
> CONFIG_SCSI_GENERIC_NCR5380=m
> CONFIG_SCSI_GENERIC_NCR5380_MMIO=m
> CONFIG_SCSI_GENERIC_NCR53C400=y
> CONFIG_SCSI_IBMMCA=m
> CONFIG_IBMMCA_SCSI_ORDER_STANDARD=y
> # CONFIG_IBMMCA_SCSI_DEV_RESET is not set
> CONFIG_SCSI_IPS=m
> CONFIG_SCSI_INITIO=m
> CONFIG_SCSI_INIA100=m
> CONFIG_SCSI_PPA=m
> CONFIG_SCSI_IMM=m
> # CONFIG_SCSI_IZIP_EPP16 is not set
> # CONFIG_SCSI_IZIP_SLOW_CTR is not set
> # CONFIG_SCSI_MVSAS is not set
> CONFIG_SCSI_NCR53C406A=m
> CONFIG_SCSI_NCR_D700=m
> CONFIG_SCSI_STEX=m
> CONFIG_SCSI_SYM53C8XX_2=m
> CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
> CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
> CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
> CONFIG_SCSI_SYM53C8XX_MMIO=y
> CONFIG_SCSI_IPR=m
> # CONFIG_SCSI_IPR_TRACE is not set
> # CONFIG_SCSI_IPR_DUMP is not set
> CONFIG_SCSI_NCR_Q720=m
> CONFIG_SCSI_NCR53C8XX_DEFAULT_TAGS=8
> CONFIG_SCSI_NCR53C8XX_MAX_TAGS=4
> CONFIG_SCSI_NCR53C8XX_SYNC=5
> # CONFIG_SCSI_PAS16 is not set
> # CONFIG_SCSI_QLOGIC_FAS is not set
> # CONFIG_SCSI_QLOGIC_1280 is not set
> # CONFIG_SCSI_QLA_FC is not set
> # CONFIG_SCSI_QLA_ISCSI is not set
> CONFIG_SCSI_LPFC=m
> CONFIG_SCSI_SIM710=m
> # CONFIG_SCSI_SYM53C416 is not set
> # CONFIG_SCSI_DC395x is not set
> # CONFIG_SCSI_DC390T is not set
> CONFIG_SCSI_T128=m
> CONFIG_SCSI_U14_34F=m
> CONFIG_SCSI_U14_34F_TAGGED_QUEUE=y
> CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
> CONFIG_SCSI_U14_34F_MAX_TAGS=8
> CONFIG_SCSI_ULTRASTOR=m
> CONFIG_SCSI_NSP32=m
> CONFIG_SCSI_DEBUG=m
> CONFIG_SCSI_SRP=m
> CONFIG_SCSI_LOWLEVEL_PCMCIA=y
> CONFIG_PCMCIA_AHA152X=m
> CONFIG_PCMCIA_FDOMAIN=m
> CONFIG_PCMCIA_NINJA_SCSI=m
> CONFIG_PCMCIA_QLOGIC=m
> CONFIG_PCMCIA_SYM53C500=m
> # CONFIG_SCSI_DH is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_PMP=y
> CONFIG_SATA_AHCI=y
> CONFIG_SATA_SIL24=m
> CONFIG_ATA_SFF=y
> CONFIG_SATA_SVW=m
> CONFIG_ATA_PIIX=y
> CONFIG_SATA_MV=y
> # CONFIG_SATA_NV is not set
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> CONFIG_SATA_PROMISE=y
> CONFIG_SATA_SX4=y
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> # CONFIG_SATA_INIC162X is not set
> CONFIG_PATA_ACPI=y
> # CONFIG_PATA_ALI is not set
> # CONFIG_PATA_AMD is not set
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CS5535 is not set
> CONFIG_PATA_CS5536=m
> # CONFIG_PATA_CYPRESS is not set
> CONFIG_PATA_EFAR=m
> CONFIG_ATA_GENERIC=m
> CONFIG_PATA_HPT366=m
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> CONFIG_PATA_HPT3X3=m
> # CONFIG_PATA_HPT3X3_DMA is not set
> # CONFIG_PATA_ISAPNP is not set
> CONFIG_PATA_IT821X=m
> CONFIG_PATA_IT8213=m
> CONFIG_PATA_JMICRON=m
> # CONFIG_PATA_LEGACY is not set
> CONFIG_PATA_TRIFLEX=m
> CONFIG_PATA_MARVELL=m
> CONFIG_PATA_MPIIX=m
> CONFIG_PATA_OLDPIIX=m
> CONFIG_PATA_NETCELL=m
> # CONFIG_PATA_NINJA32 is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_NS87415 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_OPTIDMA is not set
> CONFIG_PATA_PCMCIA=m
> # CONFIG_PATA_PDC_OLD is not set
> CONFIG_PATA_QDI=m
> # CONFIG_PATA_RADISYS is not set
> CONFIG_PATA_RZ1000=m
> # CONFIG_PATA_SC1200 is not set
> CONFIG_PATA_SERVERWORKS=m
> CONFIG_PATA_PDC2027X=m
> CONFIG_PATA_SIL680=m
> CONFIG_PATA_SIS=m
> CONFIG_PATA_VIA=m
> CONFIG_PATA_WINBOND=m
> # CONFIG_PATA_WINBOND_VLB is not set
> CONFIG_PATA_PLATFORM=m
> CONFIG_PATA_SCH=y
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=m
> CONFIG_MD_LINEAR=m
> CONFIG_MD_RAID0=m
> CONFIG_MD_RAID1=m
> CONFIG_MD_RAID10=m
> CONFIG_MD_RAID456=m
> CONFIG_MD_RAID5_RESHAPE=y
> CONFIG_MD_MULTIPATH=m
> CONFIG_MD_FAULTY=m
> CONFIG_BLK_DEV_DM=m
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_CRYPT=m
> CONFIG_DM_SNAPSHOT=m
> CONFIG_DM_MIRROR=m
> CONFIG_DM_ZERO=m
> CONFIG_DM_MULTIPATH=m
> # CONFIG_DM_DELAY is not set
> CONFIG_DM_UEVENT=y
> CONFIG_FUSION=y
> CONFIG_FUSION_SPI=m
> CONFIG_FUSION_FC=m
> CONFIG_FUSION_SAS=m
> CONFIG_FUSION_MAX_SGE=128
> CONFIG_FUSION_CTL=m
> CONFIG_FUSION_LAN=m
> CONFIG_FUSION_LOGGING=y
>
> #
> # IEEE 1394 (FireWire) support
> #
>
> #
> # Enable only one of the two stacks, unless you know what you are doing
> #
> # CONFIG_FIREWIRE is not set
> CONFIG_IEEE1394=m
> CONFIG_IEEE1394_OHCI1394=m
> CONFIG_IEEE1394_PCILYNX=m
> CONFIG_IEEE1394_SBP2=m
> # CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
> CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
> CONFIG_IEEE1394_ETH1394=m
> CONFIG_IEEE1394_RAWIO=m
> CONFIG_IEEE1394_VIDEO1394=m
> CONFIG_IEEE1394_DV1394=m
> # CONFIG_IEEE1394_VERBOSEDEBUG is not set
> CONFIG_I2O=m
> CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
> CONFIG_I2O_EXT_ADAPTEC=y
> CONFIG_I2O_CONFIG=m
> CONFIG_I2O_CONFIG_OLD_IOCTL=y
> CONFIG_I2O_BUS=m
> CONFIG_I2O_BLOCK=m
> CONFIG_I2O_SCSI=m
> CONFIG_I2O_PROC=m
> CONFIG_MACINTOSH_DRIVERS=y
> CONFIG_MAC_EMUMOUSEBTN=y
> CONFIG_NETDEVICES=y
> CONFIG_DUMMY=y
> CONFIG_BONDING=m
> CONFIG_MACVLAN=m
> CONFIG_EQUALIZER=m
> CONFIG_TUN=m
> CONFIG_VETH=m
> CONFIG_NET_SB1000=m
> CONFIG_ARCNET=m
> CONFIG_ARCNET_1201=m
> CONFIG_ARCNET_1051=m
> CONFIG_ARCNET_RAW=m
> CONFIG_ARCNET_CAP=m
> CONFIG_ARCNET_COM90xx=m
> CONFIG_ARCNET_COM90xxIO=m
> CONFIG_ARCNET_RIM_I=m
> CONFIG_ARCNET_COM20020=m
> CONFIG_ARCNET_COM20020_ISA=m
> CONFIG_ARCNET_COM20020_PCI=m
> CONFIG_PHYLIB=m
>
> #
> # MII PHY device drivers
> #
> CONFIG_MARVELL_PHY=m
> CONFIG_DAVICOM_PHY=m
> CONFIG_QSEMI_PHY=m
> CONFIG_LXT_PHY=m
> CONFIG_CICADA_PHY=m
> CONFIG_VITESSE_PHY=m
> CONFIG_SMSC_PHY=m
> CONFIG_BROADCOM_PHY=m
> CONFIG_ICPLUS_PHY=m
> # CONFIG_REALTEK_PHY is not set
> CONFIG_MDIO_BITBANG=m
> CONFIG_NET_ETHERNET=y
> CONFIG_MII=y
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> # CONFIG_NET_VENDOR_3COM is not set
> # CONFIG_LANCE is not set
> # CONFIG_NET_VENDOR_SMC is not set
> # CONFIG_ENC28J60 is not set
> # CONFIG_NET_VENDOR_RACAL is not set
> CONFIG_NET_TULIP=y
> CONFIG_DE2104X=m
> CONFIG_TULIP=m
> # CONFIG_TULIP_MWI is not set
> # CONFIG_TULIP_MMIO is not set
> # CONFIG_TULIP_NAPI is not set
> CONFIG_DE4X5=m
> CONFIG_WINBOND_840=m
> CONFIG_DM9102=m
> CONFIG_ULI526X=m
> CONFIG_PCMCIA_XIRCOM=m
> CONFIG_AT1700=m
> CONFIG_DEPCA=m
> CONFIG_HP100=m
> CONFIG_NET_ISA=y
> CONFIG_E2100=m
> CONFIG_EWRK3=m
> CONFIG_EEXPRESS=m
> CONFIG_EEXPRESS_PRO=m
> CONFIG_HPLAN_PLUS=m
> CONFIG_HPLAN=m
> CONFIG_LP486E=m
> CONFIG_ETH16I=m
> CONFIG_NE2000=m
> CONFIG_ZNET=m
> CONFIG_SEEQ8005=m
> CONFIG_NE2_MCA=m
> CONFIG_IBMLANA=m
> # CONFIG_IBM_NEW_EMAC_ZMII is not set
> # CONFIG_IBM_NEW_EMAC_RGMII is not set
> # CONFIG_IBM_NEW_EMAC_TAH is not set
> # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
> CONFIG_NET_PCI=y
> CONFIG_PCNET32=m
> CONFIG_AMD8111_ETH=m
> CONFIG_ADAPTEC_STARFIRE=m
> CONFIG_AC3200=m
> CONFIG_APRICOT=m
> CONFIG_B44=m
> CONFIG_B44_PCI_AUTOSELECT=y
> CONFIG_B44_PCICORE_AUTOSELECT=y
> CONFIG_B44_PCI=y
> CONFIG_FORCEDETH=m
> # CONFIG_FORCEDETH_NAPI is not set
> CONFIG_CS89x0=m
> CONFIG_EEPRO100=m
> CONFIG_E100=y
> # CONFIG_LNE390 is not set
> # CONFIG_FEALNX is not set
> # CONFIG_NATSEMI is not set
> CONFIG_NE2K_PCI=m
> CONFIG_NE3210=m
> CONFIG_ES3210=m
> CONFIG_8139CP=m
> CONFIG_8139TOO=m
> CONFIG_8139TOO_PIO=y
> # CONFIG_8139TOO_TUNE_TWISTER is not set
> CONFIG_8139TOO_8129=y
> # CONFIG_8139_OLD_RX_RESET is not set
> # CONFIG_R6040 is not set
> CONFIG_SIS900=m
> CONFIG_EPIC100=m
> CONFIG_SUNDANCE=m
> # CONFIG_SUNDANCE_MMIO is not set
> CONFIG_TLAN=m
> CONFIG_VIA_RHINE=m
> CONFIG_VIA_RHINE_MMIO=y
> CONFIG_SC92031=m
> CONFIG_NET_POCKET=y
> CONFIG_ATP=m
> CONFIG_DE600=m
> CONFIG_DE620=m
> CONFIG_NETDEV_1000=y
> CONFIG_ACENIC=m
> # CONFIG_ACENIC_OMIT_TIGON_I is not set
> CONFIG_DL2K=m
> CONFIG_E1000=m
> # CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
> CONFIG_E1000E=y
> CONFIG_IP1000=m
> CONFIG_IGB=y
> CONFIG_IGB_LRO=y
> CONFIG_NS83820=m
> CONFIG_HAMACHI=m
> CONFIG_YELLOWFIN=m
> CONFIG_R8169=y
> CONFIG_R8169_VLAN=y
> CONFIG_SIS190=m
> CONFIG_SKGE=m
> # CONFIG_SKGE_DEBUG is not set
> CONFIG_SKY2=m
> # CONFIG_SKY2_DEBUG is not set
> CONFIG_VIA_VELOCITY=m
> CONFIG_TIGON3=m
> CONFIG_BNX2=m
> CONFIG_QLA3XXX=m
> CONFIG_ATL1=m
> # CONFIG_ATL1E is not set
> CONFIG_NETDEV_10000=y
> CONFIG_CHELSIO_T1=m
> CONFIG_CHELSIO_T1_1G=y
> CONFIG_CHELSIO_T3=m
> CONFIG_IXGBE=m
> CONFIG_IXGB=m
> CONFIG_S2IO=m
> CONFIG_MYRI10GE=m
> CONFIG_NETXEN_NIC=m
> CONFIG_NIU=m
> CONFIG_MLX4_CORE=m
> CONFIG_MLX4_DEBUG=y
> CONFIG_TEHUTI=m
> # CONFIG_BNX2X is not set
> # CONFIG_SFC is not set
> CONFIG_TR=y
> CONFIG_IBMTR=m
> CONFIG_IBMOL=m
> CONFIG_IBMLS=m
> CONFIG_3C359=m
> CONFIG_TMS380TR=m
> CONFIG_TMSPCI=m
> CONFIG_SKISA=m
> CONFIG_PROTEON=m
> CONFIG_ABYSS=m
> CONFIG_MADGEMC=m
> CONFIG_SMCTR=m
>
> #
> # Wireless LAN
> #
> CONFIG_WLAN_PRE80211=y
> # CONFIG_STRIP is not set
> CONFIG_ARLAN=m
> CONFIG_WAVELAN=m
> CONFIG_PCMCIA_WAVELAN=m
> CONFIG_PCMCIA_NETWAVE=m
> CONFIG_WLAN_80211=y
> CONFIG_PCMCIA_RAYCS=m
> CONFIG_IPW2100=m
> CONFIG_IPW2100_MONITOR=y
> # CONFIG_IPW2100_DEBUG is not set
> CONFIG_IPW2200=m
> CONFIG_IPW2200_MONITOR=y
> CONFIG_IPW2200_RADIOTAP=y
> CONFIG_IPW2200_PROMISCUOUS=y
> CONFIG_IPW2200_QOS=y
> # CONFIG_IPW2200_DEBUG is not set
> CONFIG_LIBERTAS=m
> CONFIG_LIBERTAS_USB=m
> CONFIG_LIBERTAS_CS=m
> CONFIG_LIBERTAS_SDIO=m
> # CONFIG_LIBERTAS_DEBUG is not set
> CONFIG_AIRO=m
> CONFIG_HERMES=m
> # CONFIG_PLX_HERMES is not set
> # CONFIG_TMD_HERMES is not set
> # CONFIG_NORTEL_HERMES is not set
> # CONFIG_PCI_HERMES is not set
> CONFIG_PCMCIA_HERMES=m
> CONFIG_PCMCIA_SPECTRUM=m
> CONFIG_ATMEL=m
> CONFIG_PCI_ATMEL=m
> CONFIG_PCMCIA_ATMEL=m
> CONFIG_AIRO_CS=m
> CONFIG_PCMCIA_WL3501=m
> CONFIG_PRISM54=m
> CONFIG_USB_ZD1201=m
> # CONFIG_USB_NET_RNDIS_WLAN is not set
> # CONFIG_RTL8180 is not set
> CONFIG_RTL8187=m
> CONFIG_ADM8211=m
> # CONFIG_MAC80211_HWSIM is not set
> CONFIG_P54_COMMON=m
> CONFIG_P54_USB=m
> CONFIG_P54_PCI=m
> # CONFIG_ATH5K is not set
> # CONFIG_ATH9K is not set
> # CONFIG_IWLCORE is not set
> # CONFIG_IWLWIFI_LEDS is not set
> # CONFIG_IWLAGN is not set
> # CONFIG_IWL3945 is not set
> CONFIG_HOSTAP=m
> CONFIG_HOSTAP_FIRMWARE=y
> CONFIG_HOSTAP_FIRMWARE_NVRAM=y
> CONFIG_HOSTAP_PLX=m
> CONFIG_HOSTAP_PCI=m
> CONFIG_HOSTAP_CS=m
> CONFIG_B43=m
> CONFIG_B43_PCI_AUTOSELECT=y
> CONFIG_B43_PCICORE_AUTOSELECT=y
> # CONFIG_B43_PCMCIA is not set
> CONFIG_B43_LEDS=y
> CONFIG_B43_RFKILL=y
> CONFIG_B43_DEBUG=y
> # CONFIG_B43_FORCE_PIO is not set
> CONFIG_B43LEGACY=m
> CONFIG_B43LEGACY_PCI_AUTOSELECT=y
> CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
> CONFIG_B43LEGACY_LEDS=y
> CONFIG_B43LEGACY_RFKILL=y
> CONFIG_B43LEGACY_DEBUG=y
> CONFIG_B43LEGACY_DMA=y
> CONFIG_B43LEGACY_PIO=y
> CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
> # CONFIG_B43LEGACY_DMA_MODE is not set
> # CONFIG_B43LEGACY_PIO_MODE is not set
> CONFIG_ZD1211RW=m
> # CONFIG_ZD1211RW_DEBUG is not set
> CONFIG_RT2X00=m
> CONFIG_RT2X00_LIB=m
> CONFIG_RT2X00_LIB_PCI=m
> CONFIG_RT2X00_LIB_USB=m
> CONFIG_RT2X00_LIB_FIRMWARE=y
> CONFIG_RT2X00_LIB_RFKILL=y
> CONFIG_RT2400PCI=m
> CONFIG_RT2400PCI_RFKILL=y
> # CONFIG_RT2400PCI_LEDS is not set
> CONFIG_RT2500PCI=m
> CONFIG_RT2500PCI_RFKILL=y
> # CONFIG_RT2500PCI_LEDS is not set
> CONFIG_RT61PCI=m
> CONFIG_RT61PCI_RFKILL=y
> # CONFIG_RT61PCI_LEDS is not set
> CONFIG_RT2500USB=m
> # CONFIG_RT2500USB_LEDS is not set
> CONFIG_RT73USB=m
> # CONFIG_RT73USB_LEDS is not set
> # CONFIG_RT2X00_LIB_DEBUGFS is not set
> # CONFIG_RT2X00_DEBUG is not set
>
> #
> # USB Network Adapters
> #
> CONFIG_USB_CATC=m
> CONFIG_USB_KAWETH=m
> CONFIG_USB_PEGASUS=m
> CONFIG_USB_RTL8150=m
> CONFIG_USB_USBNET=m
> CONFIG_USB_NET_AX8817X=m
> # CONFIG_USB_HSO is not set
> CONFIG_USB_NET_CDCETHER=m
> CONFIG_USB_NET_DM9601=m
> CONFIG_USB_NET_GL620A=m
> CONFIG_USB_NET_NET1080=m
> CONFIG_USB_NET_PLUSB=m
> CONFIG_USB_NET_MCS7830=m
> CONFIG_USB_NET_RNDIS_HOST=m
> CONFIG_USB_NET_CDC_SUBSET=m
> CONFIG_USB_ALI_M5632=y
> CONFIG_USB_AN2720=y
> CONFIG_USB_BELKIN=y
> CONFIG_USB_ARMLINUX=y
> CONFIG_USB_EPSON2888=y
> CONFIG_USB_KC2190=y
> # CONFIG_USB_NET_ZAURUS is not set
> CONFIG_NET_PCMCIA=y
> CONFIG_PCMCIA_3C589=m
> CONFIG_PCMCIA_3C574=m
> CONFIG_PCMCIA_FMVJ18X=m
> CONFIG_PCMCIA_PCNET=m
> CONFIG_PCMCIA_NMCLAN=m
> CONFIG_PCMCIA_SMC91C92=m
> CONFIG_PCMCIA_XIRC2PS=m
> CONFIG_PCMCIA_AXNET=m
> CONFIG_ARCNET_COM20020_CS=m
> CONFIG_PCMCIA_IBMTR=m
> CONFIG_WAN=y
> CONFIG_HOSTESS_SV11=m
> CONFIG_COSA=m
> CONFIG_LANMEDIA=m
> CONFIG_SEALEVEL_4021=m
> CONFIG_HDLC=m
> CONFIG_HDLC_RAW=m
> CONFIG_HDLC_RAW_ETH=m
> CONFIG_HDLC_CISCO=m
> CONFIG_HDLC_FR=m
> CONFIG_HDLC_PPP=m
> CONFIG_HDLC_X25=m
> CONFIG_PCI200SYN=m
> CONFIG_WANXL=m
> CONFIG_PC300=m
> CONFIG_PC300_MLPPP=y
>
> #
> # Cyclades-PC300 MLPPP support is disabled.
> #
>
> #
> # Refer to the file README.mlppp, provided by PC300 package.
> #
> # CONFIG_PC300TOO is not set
> CONFIG_N2=m
> CONFIG_C101=m
> CONFIG_FARSYNC=m
> CONFIG_DSCC4=m
> CONFIG_DSCC4_PCISYNC=y
> CONFIG_DSCC4_PCI_RST=y
> CONFIG_DLCI=m
> CONFIG_DLCI_MAX=8
> CONFIG_SDLA=m
> CONFIG_WAN_ROUTER_DRIVERS=m
> CONFIG_CYCLADES_SYNC=m
> CONFIG_CYCLOMX_X25=y
> CONFIG_LAPBETHER=m
> CONFIG_X25_ASY=m
> CONFIG_SBNI=m
> # CONFIG_SBNI_MULTILINE is not set
> CONFIG_ATM_DRIVERS=y
> # CONFIG_ATM_DUMMY is not set
> CONFIG_ATM_TCP=m
> CONFIG_ATM_LANAI=m
> CONFIG_ATM_ENI=m
> # CONFIG_ATM_ENI_DEBUG is not set
> # CONFIG_ATM_ENI_TUNE_BURST is not set
> CONFIG_ATM_FIRESTREAM=m
> CONFIG_ATM_ZATM=m
> # CONFIG_ATM_ZATM_DEBUG is not set
> CONFIG_ATM_NICSTAR=m
> # CONFIG_ATM_NICSTAR_USE_SUNI is not set
> # CONFIG_ATM_NICSTAR_USE_IDT77105 is not set
> CONFIG_ATM_IDT77252=m
> # CONFIG_ATM_IDT77252_DEBUG is not set
> # CONFIG_ATM_IDT77252_RCV_ALL is not set
> CONFIG_ATM_IDT77252_USE_SUNI=y
> CONFIG_ATM_AMBASSADOR=m
> # CONFIG_ATM_AMBASSADOR_DEBUG is not set
> CONFIG_ATM_HORIZON=m
> # CONFIG_ATM_HORIZON_DEBUG is not set
> CONFIG_ATM_IA=m
> # CONFIG_ATM_IA_DEBUG is not set
> # CONFIG_ATM_FORE200E is not set
> CONFIG_ATM_HE=m
> CONFIG_ATM_HE_USE_SUNI=y
> CONFIG_FDDI=y
> CONFIG_DEFXX=m
> # CONFIG_DEFXX_MMIO is not set
> CONFIG_SKFP=m
> CONFIG_HIPPI=y
> CONFIG_ROADRUNNER=m
> # CONFIG_ROADRUNNER_LARGE_RINGS is not set
> CONFIG_PLIP=m
> CONFIG_PPP=m
> CONFIG_PPP_MULTILINK=y
> CONFIG_PPP_FILTER=y
> CONFIG_PPP_ASYNC=m
> CONFIG_PPP_SYNC_TTY=m
> CONFIG_PPP_DEFLATE=m
> CONFIG_PPP_BSDCOMP=m
> CONFIG_PPP_MPPE=m
> CONFIG_PPPOE=m
> CONFIG_PPPOATM=m
> CONFIG_PPPOL2TP=m
> CONFIG_SLIP=m
> CONFIG_SLIP_COMPRESSED=y
> CONFIG_SLHC=m
> CONFIG_SLIP_SMART=y
> CONFIG_SLIP_MODE_SLIP6=y
> CONFIG_NET_FC=y
> CONFIG_NETCONSOLE=m
> CONFIG_NETCONSOLE_DYNAMIC=y
> CONFIG_NETPOLL=y
> # CONFIG_NETPOLL_TRAP is not set
> CONFIG_NET_POLL_CONTROLLER=y
> CONFIG_VIRTIO_NET=m
> # CONFIG_ISDN is not set
> CONFIG_PHONE=m
> CONFIG_PHONE_IXJ=m
> CONFIG_PHONE_IXJ_PCMCIA=m
>
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=m
> CONFIG_INPUT_POLLDEV=m
>
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> CONFIG_INPUT_JOYDEV=m
> CONFIG_INPUT_EVDEV=m
> CONFIG_INPUT_EVBUG=m
>
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ATKBD=y
> CONFIG_KEYBOARD_SUNKBD=m
> CONFIG_KEYBOARD_LKKBD=m
> CONFIG_KEYBOARD_XTKBD=m
> CONFIG_KEYBOARD_NEWTON=m
> CONFIG_KEYBOARD_STOWAWAY=m
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=m
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> CONFIG_MOUSE_SERIAL=m
> CONFIG_MOUSE_APPLETOUCH=m
> # CONFIG_MOUSE_BCM5974 is not set
> CONFIG_MOUSE_INPORT=m
> # CONFIG_MOUSE_ATIXL is not set
> CONFIG_MOUSE_LOGIBM=m
> CONFIG_MOUSE_PC110PAD=m
> CONFIG_MOUSE_VSXXXAA=m
> CONFIG_INPUT_JOYSTICK=y
> CONFIG_JOYSTICK_ANALOG=m
> CONFIG_JOYSTICK_A3D=m
> CONFIG_JOYSTICK_ADI=m
> CONFIG_JOYSTICK_COBRA=m
> CONFIG_JOYSTICK_GF2K=m
> CONFIG_JOYSTICK_GRIP=m
> CONFIG_JOYSTICK_GRIP_MP=m
> CONFIG_JOYSTICK_GUILLEMOT=m
> CONFIG_JOYSTICK_INTERACT=m
> CONFIG_JOYSTICK_SIDEWINDER=m
> CONFIG_JOYSTICK_TMDC=m
> CONFIG_JOYSTICK_IFORCE=m
> CONFIG_JOYSTICK_IFORCE_USB=y
> CONFIG_JOYSTICK_IFORCE_232=y
> CONFIG_JOYSTICK_WARRIOR=m
> CONFIG_JOYSTICK_MAGELLAN=m
> CONFIG_JOYSTICK_SPACEORB=m
> CONFIG_JOYSTICK_SPACEBALL=m
> CONFIG_JOYSTICK_STINGER=m
> CONFIG_JOYSTICK_TWIDJOY=m
> # CONFIG_JOYSTICK_ZHENHUA is not set
> CONFIG_JOYSTICK_DB9=m
> CONFIG_JOYSTICK_GAMECON=m
> CONFIG_JOYSTICK_TURBOGRAFX=m
> CONFIG_JOYSTICK_JOYDUMP=m
> CONFIG_JOYSTICK_XPAD=m
> CONFIG_JOYSTICK_XPAD_FF=y
> CONFIG_JOYSTICK_XPAD_LEDS=y
> CONFIG_INPUT_TABLET=y
> CONFIG_TABLET_USB_ACECAD=m
> CONFIG_TABLET_USB_AIPTEK=m
> CONFIG_TABLET_USB_GTCO=m
> CONFIG_TABLET_USB_KBTAB=m
> CONFIG_TABLET_USB_WACOM=m
> CONFIG_INPUT_TOUCHSCREEN=y
> CONFIG_TOUCHSCREEN_ADS7846=m
> CONFIG_TOUCHSCREEN_FUJITSU=m
> CONFIG_TOUCHSCREEN_GUNZE=m
> CONFIG_TOUCHSCREEN_ELO=m
> CONFIG_TOUCHSCREEN_MTOUCH=m
> # CONFIG_TOUCHSCREEN_INEXIO is not set
> CONFIG_TOUCHSCREEN_MK712=m
> # CONFIG_TOUCHSCREEN_HTCPEN is not set
> CONFIG_TOUCHSCREEN_PENMOUNT=m
> CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
> CONFIG_TOUCHSCREEN_TOUCHWIN=m
> CONFIG_TOUCHSCREEN_UCB1400=m
> # CONFIG_TOUCHSCREEN_WM97XX is not set
> CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
> CONFIG_TOUCHSCREEN_USB_EGALAX=y
> CONFIG_TOUCHSCREEN_USB_PANJIT=y
> CONFIG_TOUCHSCREEN_USB_3M=y
> CONFIG_TOUCHSCREEN_USB_ITM=y
> CONFIG_TOUCHSCREEN_USB_ETURBO=y
> CONFIG_TOUCHSCREEN_USB_GUNZE=y
> CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
> CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
> CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
> CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
> CONFIG_TOUCHSCREEN_USB_GOTOP=y
> # CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_PCSPKR=m
> # CONFIG_INPUT_APANEL is not set
> CONFIG_INPUT_WISTRON_BTNS=m
> CONFIG_INPUT_ATLAS_BTNS=m
> CONFIG_INPUT_ATI_REMOTE=m
> CONFIG_INPUT_ATI_REMOTE2=m
> CONFIG_INPUT_KEYSPAN_REMOTE=m
> CONFIG_INPUT_POWERMATE=m
> CONFIG_INPUT_YEALINK=m
> # CONFIG_INPUT_CM109 is not set
> CONFIG_INPUT_UINPUT=m
>
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=m
> CONFIG_SERIO_CT82C710=m
> CONFIG_SERIO_PARKBD=m
> CONFIG_SERIO_PCIPS2=m
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=m
> CONFIG_GAMEPORT=m
> CONFIG_GAMEPORT_NS558=m
> CONFIG_GAMEPORT_L4=m
> CONFIG_GAMEPORT_EMU10K1=m
> CONFIG_GAMEPORT_FM801=m
>
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_DEVKMEM=y
> CONFIG_SERIAL_NONSTANDARD=y
> # CONFIG_COMPUTONE is not set
> CONFIG_ROCKETPORT=m
> CONFIG_CYCLADES=m
> # CONFIG_CYZ_INTR is not set
> CONFIG_DIGIEPCA=m
> # CONFIG_ESPSERIAL is not set
> # CONFIG_MOXA_INTELLIO is not set
> # CONFIG_MOXA_SMARTIO is not set
> # CONFIG_ISI is not set
> CONFIG_SYNCLINK=m
> CONFIG_SYNCLINKMP=m
> CONFIG_SYNCLINK_GT=m
> CONFIG_N_HDLC=m
> # CONFIG_RISCOM8 is not set
> CONFIG_SPECIALIX=m
> CONFIG_SX=m
> # CONFIG_RIO is not set
> CONFIG_STALDRV=y
> # CONFIG_NOZOMI is not set
>
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CS=m
> CONFIG_SERIAL_8250_NR_UARTS=48
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> CONFIG_SERIAL_8250_FOURPORT=m
> CONFIG_SERIAL_8250_ACCENT=m
> CONFIG_SERIAL_8250_BOCA=m
> CONFIG_SERIAL_8250_EXAR_ST16C554=m
> CONFIG_SERIAL_8250_HUB6=m
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> CONFIG_SERIAL_8250_RSA=y
> CONFIG_SERIAL_8250_MCA=m
>
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_CONSOLE_POLL=y
> CONFIG_SERIAL_JSM=m
> CONFIG_UNIX98_PTYS=y
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> CONFIG_PRINTER=m
> # CONFIG_LP_CONSOLE is not set
> CONFIG_PPDEV=m
> CONFIG_HVC_DRIVER=y
> # CONFIG_VIRTIO_CONSOLE is not set
> CONFIG_IPMI_HANDLER=m
> # CONFIG_IPMI_PANIC_EVENT is not set
> CONFIG_IPMI_DEVICE_INTERFACE=m
> CONFIG_IPMI_SI=m
> CONFIG_IPMI_WATCHDOG=m
> CONFIG_IPMI_POWEROFF=m
> CONFIG_HW_RANDOM=y
> CONFIG_HW_RANDOM_INTEL=m
> CONFIG_HW_RANDOM_AMD=m
> CONFIG_HW_RANDOM_GEODE=m
> CONFIG_HW_RANDOM_VIA=m
> # CONFIG_HW_RANDOM_VIRTIO is not set
> CONFIG_NVRAM=m
> CONFIG_DTLK=m
> CONFIG_R3964=m
> CONFIG_APPLICOM=m
> CONFIG_SONYPI=m
>
> #
> # PCMCIA character devices
> #
> CONFIG_SYNCLINK_CS=m
> CONFIG_CARDMAN_4000=m
> CONFIG_CARDMAN_4040=m
> # CONFIG_IPWIRELESS is not set
> CONFIG_MWAVE=m
> CONFIG_SCx200_GPIO=m
> CONFIG_PC8736x_GPIO=m
> CONFIG_NSC_GPIO=m
> CONFIG_CS5535_GPIO=m
> CONFIG_RAW_DRIVER=m
> CONFIG_MAX_RAW_DEVS=256
> CONFIG_HPET=y
> CONFIG_HPET_MMAP=y
> CONFIG_HANGCHECK_TIMER=m
> CONFIG_TCG_TPM=m
> CONFIG_TCG_TIS=m
> CONFIG_TCG_NSC=m
> CONFIG_TCG_ATMEL=m
> CONFIG_TCG_INFINEON=m
> CONFIG_TELCLOCK=m
> CONFIG_DEVPORT=y
> CONFIG_I2C=m
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_CHARDEV=m
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_ALGOBIT=m
> CONFIG_I2C_ALGOPCA=m
>
> #
> # I2C Hardware Bus support
> #
>
> #
> # PC SMBus host controller drivers
> #
> CONFIG_I2C_ALI1535=m
> CONFIG_I2C_ALI1563=m
> CONFIG_I2C_ALI15X3=m
> CONFIG_I2C_AMD756=m
> CONFIG_I2C_AMD756_S4882=m
> CONFIG_I2C_AMD8111=m
> CONFIG_I2C_I801=m
> # CONFIG_I2C_ISCH is not set
> CONFIG_I2C_PIIX4=m
> CONFIG_I2C_NFORCE2=m
> # CONFIG_I2C_NFORCE2_S4985 is not set
> CONFIG_I2C_SIS5595=m
> CONFIG_I2C_SIS630=m
> CONFIG_I2C_SIS96X=m
> CONFIG_I2C_VIA=m
> CONFIG_I2C_VIAPRO=m
>
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_OCORES=m
> CONFIG_I2C_SIMTEC=m
>
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_PARPORT=m
> CONFIG_I2C_PARPORT_LIGHT=m
> CONFIG_I2C_TAOS_EVM=m
> CONFIG_I2C_TINY_USB=m
>
> #
> # Graphics adapter I2C/DDC channel drivers
> #
> CONFIG_I2C_VOODOO3=m
>
> #
> # Other I2C/SMBus bus drivers
> #
> CONFIG_I2C_PCA_ISA=m
> # CONFIG_I2C_PCA_PLATFORM is not set
> CONFIG_I2C_STUB=m
> CONFIG_SCx200_I2C=m
> CONFIG_SCx200_I2C_SCL=12
> CONFIG_SCx200_I2C_SDA=13
> CONFIG_SCx200_ACB=m
>
> #
> # Miscellaneous I2C Chip support
> #
> CONFIG_DS1682=m
> # CONFIG_AT24 is not set
> CONFIG_SENSORS_EEPROM=m
> CONFIG_SENSORS_PCF8574=m
> # CONFIG_PCF8575 is not set
> # CONFIG_SENSORS_PCA9539 is not set
> CONFIG_SENSORS_PCF8591=m
> CONFIG_SENSORS_MAX6875=m
> CONFIG_SENSORS_TSL2550=m
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_I2C_DEBUG_CHIP is not set
> CONFIG_SPI=y
> # CONFIG_SPI_DEBUG is not set
> CONFIG_SPI_MASTER=y
>
> #
> # SPI Master Controller Drivers
> #
> CONFIG_SPI_BITBANG=m
> CONFIG_SPI_BUTTERFLY=m
> CONFIG_SPI_LM70_LLP=m
>
> #
> # SPI Protocol Masters
> #
> CONFIG_SPI_AT25=m
> CONFIG_SPI_SPIDEV=m
> CONFIG_SPI_TLE62X0=m
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> # CONFIG_GPIOLIB is not set
> CONFIG_W1=m
> CONFIG_W1_CON=y
>
> #
> # 1-wire Bus Masters
> #
> CONFIG_W1_MASTER_MATROX=m
> CONFIG_W1_MASTER_DS2490=m
> CONFIG_W1_MASTER_DS2482=m
>
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=m
> CONFIG_W1_SLAVE_SMEM=m
> CONFIG_W1_SLAVE_DS2433=m
> # CONFIG_W1_SLAVE_DS2433_CRC is not set
> CONFIG_W1_SLAVE_DS2760=m
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> CONFIG_PDA_POWER=m
> CONFIG_BATTERY_DS2760=m
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=m
> CONFIG_SENSORS_ABITUGURU=m
> CONFIG_SENSORS_ABITUGURU3=m
> # CONFIG_SENSORS_AD7414 is not set
> CONFIG_SENSORS_AD7418=m
> CONFIG_SENSORS_ADM1021=m
> CONFIG_SENSORS_ADM1025=m
> CONFIG_SENSORS_ADM1026=m
> CONFIG_SENSORS_ADM1029=m
> CONFIG_SENSORS_ADM1031=m
> CONFIG_SENSORS_ADM9240=m
> CONFIG_SENSORS_ADT7470=m
> # CONFIG_SENSORS_ADT7473 is not set
> CONFIG_SENSORS_K8TEMP=m
> CONFIG_SENSORS_ASB100=m
> CONFIG_SENSORS_ATXP1=m
> CONFIG_SENSORS_DS1621=m
> CONFIG_SENSORS_I5K_AMB=m
> CONFIG_SENSORS_F71805F=m
> CONFIG_SENSORS_F71882FG=m
> CONFIG_SENSORS_F75375S=m
> CONFIG_SENSORS_FSCHER=m
> CONFIG_SENSORS_FSCPOS=m
> CONFIG_SENSORS_FSCHMD=m
> CONFIG_SENSORS_GL518SM=m
> CONFIG_SENSORS_GL520SM=m
> CONFIG_SENSORS_CORETEMP=m
> # CONFIG_SENSORS_IBMAEM is not set
> CONFIG_SENSORS_IBMPEX=m
> CONFIG_SENSORS_IT87=m
> CONFIG_SENSORS_LM63=m
> CONFIG_SENSORS_LM70=m
> CONFIG_SENSORS_LM75=m
> CONFIG_SENSORS_LM77=m
> CONFIG_SENSORS_LM78=m
> CONFIG_SENSORS_LM80=m
> CONFIG_SENSORS_LM83=m
> CONFIG_SENSORS_LM85=m
> CONFIG_SENSORS_LM87=m
> CONFIG_SENSORS_LM90=m
> CONFIG_SENSORS_LM92=m
> CONFIG_SENSORS_LM93=m
> CONFIG_SENSORS_MAX1619=m
> CONFIG_SENSORS_MAX6650=m
> CONFIG_SENSORS_PC87360=m
> CONFIG_SENSORS_PC87427=m
> CONFIG_SENSORS_SIS5595=m
> CONFIG_SENSORS_DME1737=m
> CONFIG_SENSORS_SMSC47M1=m
> CONFIG_SENSORS_SMSC47M192=m
> CONFIG_SENSORS_SMSC47B397=m
> # CONFIG_SENSORS_ADS7828 is not set
> CONFIG_SENSORS_THMC50=m
> CONFIG_SENSORS_VIA686A=m
> CONFIG_SENSORS_VT1211=m
> CONFIG_SENSORS_VT8231=m
> CONFIG_SENSORS_W83781D=m
> CONFIG_SENSORS_W83791D=m
> CONFIG_SENSORS_W83792D=m
> CONFIG_SENSORS_W83793=m
> CONFIG_SENSORS_W83L785TS=m
> # CONFIG_SENSORS_W83L786NG is not set
> CONFIG_SENSORS_W83627HF=m
> CONFIG_SENSORS_W83627EHF=m
> CONFIG_SENSORS_HDAPS=m
> CONFIG_SENSORS_APPLESMC=m
> # CONFIG_HWMON_DEBUG_CHIP is not set
> CONFIG_THERMAL=m
> # CONFIG_THERMAL_HWMON is not set
> CONFIG_WATCHDOG=y
> # CONFIG_WATCHDOG_NOWAYOUT is not set
>
> #
> # Watchdog Device Drivers
> #
> CONFIG_SOFT_WATCHDOG=m
> CONFIG_ACQUIRE_WDT=m
> CONFIG_ADVANTECH_WDT=m
> CONFIG_ALIM1535_WDT=m
> CONFIG_ALIM7101_WDT=m
> CONFIG_SC520_WDT=m
> CONFIG_EUROTECH_WDT=m
> CONFIG_IB700_WDT=m
> CONFIG_IBMASR=m
> CONFIG_WAFER_WDT=m
> CONFIG_I6300ESB_WDT=m
> CONFIG_ITCO_WDT=m
> CONFIG_ITCO_VENDOR_SUPPORT=y
> CONFIG_IT8712F_WDT=m
> # CONFIG_HP_WATCHDOG is not set
> CONFIG_SC1200_WDT=m
> CONFIG_SCx200_WDT=m
> CONFIG_PC87413_WDT=m
> CONFIG_60XX_WDT=m
> CONFIG_SBC8360_WDT=m
> CONFIG_SBC7240_WDT=m
> CONFIG_CPU5_WDT=m
> CONFIG_SMSC37B787_WDT=m
> CONFIG_W83627HF_WDT=m
> CONFIG_W83697HF_WDT=m
> CONFIG_W83877F_WDT=m
> CONFIG_W83977F_WDT=m
> CONFIG_MACHZ_WDT=m
> CONFIG_SBC_EPX_C3_WATCHDOG=m
>
> #
> # ISA-based Watchdog Cards
> #
> CONFIG_PCWATCHDOG=m
> CONFIG_MIXCOMWD=m
> CONFIG_WDT=m
> CONFIG_WDT_501=y
>
> #
> # PCI-based Watchdog Cards
> #
> CONFIG_PCIPCWATCHDOG=m
> CONFIG_WDTPCI=m
> CONFIG_WDT_501_PCI=y
>
> #
> # USB-based Watchdog Cards
> #
> CONFIG_USBPCWATCHDOG=m
>
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB_POSSIBLE=y
> CONFIG_SSB=m
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> CONFIG_SSB_B43_PCI_BRIDGE=y
> CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
> # CONFIG_SSB_PCMCIAHOST is not set
> # CONFIG_SSB_SILENT is not set
> CONFIG_SSB_DEBUG=y
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> CONFIG_SSB_DRIVER_PCICORE=y
>
> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_CORE is not set
> CONFIG_MFD_SM501=m
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_MFD_TMIO is not set
>
> #
> # Multimedia devices
> #
>
> #
> # Multimedia core support
> #
> CONFIG_VIDEO_DEV=m
> CONFIG_VIDEO_V4L2_COMMON=m
> CONFIG_VIDEO_ALLOW_V4L1=y
> CONFIG_VIDEO_V4L1_COMPAT=y
> CONFIG_DVB_CORE=m
> CONFIG_VIDEO_MEDIA=m
>
> #
> # Multimedia drivers
> #
> CONFIG_VIDEO_SAA7146=m
> CONFIG_VIDEO_SAA7146_VV=m
> # CONFIG_MEDIA_ATTACH is not set
> CONFIG_MEDIA_TUNER=m
> # CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
> CONFIG_MEDIA_TUNER_SIMPLE=m
> CONFIG_MEDIA_TUNER_TDA8290=m
> CONFIG_MEDIA_TUNER_TDA827X=m
> CONFIG_MEDIA_TUNER_TDA18271=m
> CONFIG_MEDIA_TUNER_TDA9887=m
> CONFIG_MEDIA_TUNER_TEA5761=m
> CONFIG_MEDIA_TUNER_TEA5767=m
> CONFIG_MEDIA_TUNER_MT20XX=m
> CONFIG_MEDIA_TUNER_MT2060=m
> CONFIG_MEDIA_TUNER_MT2266=m
> CONFIG_MEDIA_TUNER_MT2131=m
> CONFIG_MEDIA_TUNER_QT1010=m
> CONFIG_MEDIA_TUNER_XC2028=m
> CONFIG_MEDIA_TUNER_XC5000=m
> CONFIG_MEDIA_TUNER_MXL5005S=m
> CONFIG_VIDEO_V4L2=m
> CONFIG_VIDEO_V4L1=m
> CONFIG_VIDEOBUF_GEN=m
> CONFIG_VIDEOBUF_DMA_SG=m
> CONFIG_VIDEOBUF_VMALLOC=m
> CONFIG_VIDEOBUF_DVB=m
> CONFIG_VIDEO_BTCX=m
> CONFIG_VIDEO_IR=m
> CONFIG_VIDEO_TVEEPROM=m
> CONFIG_VIDEO_TUNER=m
> CONFIG_VIDEO_CAPTURE_DRIVERS=y
> # CONFIG_VIDEO_ADV_DEBUG is not set
> # CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set
> CONFIG_VIDEO_IR_I2C=m
>
> #
> # Encoders/decoders and other helper chips
> #
>
> #
> # Audio decoders
> #
> CONFIG_VIDEO_TVAUDIO=m
> CONFIG_VIDEO_TDA7432=m
> CONFIG_VIDEO_TDA9840=m
> CONFIG_VIDEO_TDA9875=m
> CONFIG_VIDEO_TEA6415C=m
> CONFIG_VIDEO_TEA6420=m
> CONFIG_VIDEO_MSP3400=m
> # CONFIG_VIDEO_CS5345 is not set
> CONFIG_VIDEO_CS53L32A=m
> CONFIG_VIDEO_M52790=m
> CONFIG_VIDEO_TLV320AIC23B=m
> CONFIG_VIDEO_WM8775=m
> CONFIG_VIDEO_WM8739=m
> CONFIG_VIDEO_VP27SMPX=m
>
> #
> # Video decoders
> #
> CONFIG_VIDEO_BT819=m
> CONFIG_VIDEO_BT856=m
> CONFIG_VIDEO_BT866=m
> CONFIG_VIDEO_KS0127=m
> CONFIG_VIDEO_OV7670=m
> CONFIG_VIDEO_TCM825X=m
> CONFIG_VIDEO_SAA7110=m
> CONFIG_VIDEO_SAA7111=m
> CONFIG_VIDEO_SAA7114=m
> CONFIG_VIDEO_SAA711X=m
> CONFIG_VIDEO_SAA717X=m
> CONFIG_VIDEO_SAA7191=m
> CONFIG_VIDEO_TVP5150=m
> CONFIG_VIDEO_VPX3220=m
>
> #
> # Video and audio decoders
> #
> CONFIG_VIDEO_CX25840=m
>
> #
> # MPEG video encoders
> #
> CONFIG_VIDEO_CX2341X=m
>
> #
> # Video encoders
> #
> CONFIG_VIDEO_SAA7127=m
> CONFIG_VIDEO_SAA7185=m
> CONFIG_VIDEO_ADV7170=m
> CONFIG_VIDEO_ADV7175=m
>
> #
> # Video improvement chips
> #
> CONFIG_VIDEO_UPD64031A=m
> CONFIG_VIDEO_UPD64083=m
> CONFIG_VIDEO_VIVI=m
> CONFIG_VIDEO_BT848=m
> CONFIG_VIDEO_BT848_DVB=y
> CONFIG_VIDEO_SAA6588=m
> CONFIG_VIDEO_PMS=m
> CONFIG_VIDEO_BWQCAM=m
> CONFIG_VIDEO_CQCAM=m
> CONFIG_VIDEO_W9966=m
> CONFIG_VIDEO_CPIA=m
> CONFIG_VIDEO_CPIA_PP=m
> CONFIG_VIDEO_CPIA_USB=m
> CONFIG_VIDEO_CPIA2=m
> CONFIG_VIDEO_SAA5246A=m
> CONFIG_VIDEO_SAA5249=m
> CONFIG_TUNER_3036=m
> CONFIG_VIDEO_STRADIS=m
> CONFIG_VIDEO_ZORAN=m
> CONFIG_VIDEO_ZORAN_DC30=m
> CONFIG_VIDEO_ZORAN_ZR36060=m
> CONFIG_VIDEO_ZORAN_BUZ=m
> CONFIG_VIDEO_ZORAN_DC10=m
> CONFIG_VIDEO_ZORAN_LML33=m
> CONFIG_VIDEO_ZORAN_LML33R10=m
> CONFIG_VIDEO_ZORAN_AVS6EYES=m
> CONFIG_VIDEO_MEYE=m
> CONFIG_VIDEO_SAA7134=m
> CONFIG_VIDEO_SAA7134_DVB=m
> # CONFIG_VIDEO_MXB is not set
> # CONFIG_VIDEO_DPC is not set
> CONFIG_VIDEO_HEXIUM_ORION=m
> CONFIG_VIDEO_HEXIUM_GEMINI=m
> CONFIG_VIDEO_CX88=m
> CONFIG_VIDEO_CX88_BLACKBIRD=m
> CONFIG_VIDEO_CX88_DVB=m
> CONFIG_VIDEO_CX88_VP3054=m
> CONFIG_VIDEO_CX23885=m
> # CONFIG_VIDEO_AU0828 is not set
> CONFIG_VIDEO_IVTV=m
> CONFIG_VIDEO_FB_IVTV=m
> # CONFIG_VIDEO_CX18 is not set
> CONFIG_VIDEO_CAFE_CCIC=m
> # CONFIG_SOC_CAMERA is not set
> CONFIG_V4L_USB_DRIVERS=y
> # CONFIG_USB_VIDEO_CLASS is not set
> # CONFIG_USB_GSPCA is not set
> CONFIG_VIDEO_PVRUSB2=m
> CONFIG_VIDEO_PVRUSB2_SYSFS=y
> CONFIG_VIDEO_PVRUSB2_DVB=y
> # CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
> CONFIG_VIDEO_EM28XX=m
> # CONFIG_VIDEO_EM28XX_DVB is not set
> CONFIG_VIDEO_USBVISION=m
> CONFIG_VIDEO_USBVIDEO=m
> CONFIG_USB_VICAM=m
> CONFIG_USB_IBMCAM=m
> CONFIG_USB_KONICAWC=m
> CONFIG_USB_QUICKCAM_MESSENGER=m
> CONFIG_USB_ET61X251=m
> CONFIG_VIDEO_OVCAMCHIP=m
> CONFIG_USB_W9968CF=m
> # CONFIG_USB_OV511 is not set
> CONFIG_USB_SE401=m
> CONFIG_USB_SN9C102=m
> CONFIG_USB_STV680=m
> CONFIG_USB_ZC0301=m
> CONFIG_USB_PWC=m
> # CONFIG_USB_PWC_DEBUG is not set
> CONFIG_USB_ZR364XX=m
> # CONFIG_USB_STKWEBCAM is not set
> # CONFIG_USB_S2255 is not set
> CONFIG_RADIO_ADAPTERS=y
> CONFIG_RADIO_CADET=m
> CONFIG_RADIO_RTRACK=m
> CONFIG_RADIO_RTRACK2=m
> CONFIG_RADIO_AZTECH=m
> CONFIG_RADIO_GEMTEK=m
> CONFIG_RADIO_GEMTEK_PCI=m
> CONFIG_RADIO_MAXIRADIO=m
> CONFIG_RADIO_MAESTRO=m
> CONFIG_RADIO_SF16FMI=m
> CONFIG_RADIO_SF16FMR2=m
> CONFIG_RADIO_TERRATEC=m
> CONFIG_RADIO_TRUST=m
> CONFIG_RADIO_TYPHOON=m
> # CONFIG_RADIO_TYPHOON_PROC_FS is not set
> CONFIG_RADIO_ZOLTRIX=m
> CONFIG_USB_DSBR=m
> # CONFIG_USB_SI470X is not set
> CONFIG_DVB_CAPTURE_DRIVERS=y
>
> #
> # Supported SAA7146 based PCI Adapters
> #
> CONFIG_TTPCI_EEPROM=m
> CONFIG_DVB_AV7110=m
> CONFIG_DVB_AV7110_OSD=y
> # CONFIG_DVB_BUDGET_CORE is not set
>
> #
> # Supported USB Adapters
> #
> CONFIG_DVB_USB=m
> # CONFIG_DVB_USB_DEBUG is not set
> CONFIG_DVB_USB_A800=m
> CONFIG_DVB_USB_DIBUSB_MB=m
> CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
> CONFIG_DVB_USB_DIBUSB_MC=m
> CONFIG_DVB_USB_DIB0700=m
> CONFIG_DVB_USB_UMT_010=m
> CONFIG_DVB_USB_CXUSB=m
> CONFIG_DVB_USB_M920X=m
> CONFIG_DVB_USB_GL861=m
> CONFIG_DVB_USB_AU6610=m
> CONFIG_DVB_USB_DIGITV=m
> CONFIG_DVB_USB_VP7045=m
> CONFIG_DVB_USB_VP702X=m
> CONFIG_DVB_USB_GP8PSK=m
> CONFIG_DVB_USB_NOVA_T_USB2=m
> CONFIG_DVB_USB_TTUSB2=m
> CONFIG_DVB_USB_DTT200U=m
> CONFIG_DVB_USB_OPERA1=m
> CONFIG_DVB_USB_AF9005=m
> CONFIG_DVB_USB_AF9005_REMOTE=m
> # CONFIG_DVB_USB_DW2102 is not set
> # CONFIG_DVB_USB_ANYSEE is not set
> CONFIG_DVB_TTUSB_BUDGET=m
> CONFIG_DVB_TTUSB_DEC=m
> CONFIG_DVB_CINERGYT2=m
> CONFIG_DVB_CINERGYT2_TUNING=y
> CONFIG_DVB_CINERGYT2_STREAM_URB_COUNT=32
> CONFIG_DVB_CINERGYT2_STREAM_BUF_SIZE=512
> CONFIG_DVB_CINERGYT2_QUERY_INTERVAL=250
> CONFIG_DVB_CINERGYT2_ENABLE_RC_INPUT_DEVICE=y
> CONFIG_DVB_CINERGYT2_RC_QUERY_INTERVAL=100
> # CONFIG_DVB_SIANO_SMS1XXX is not set
>
> #
> # Supported FlexCopII (B2C2) Adapters
> #
> CONFIG_DVB_B2C2_FLEXCOP=m
> CONFIG_DVB_B2C2_FLEXCOP_PCI=m
> CONFIG_DVB_B2C2_FLEXCOP_USB=m
> # CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set
>
> #
> # Supported BT878 Adapters
> #
> CONFIG_DVB_BT8XX=m
>
> #
> # Supported Pluto2 Adapters
> #
> CONFIG_DVB_PLUTO2=m
>
> #
> # Supported DVB Frontends
> #
>
> #
> # Customise DVB Frontends
> #
> # CONFIG_DVB_FE_CUSTOMISE is not set
>
> #
> # DVB-S (satellite) frontends
> #
> CONFIG_DVB_CX24110=m
> CONFIG_DVB_CX24123=m
> CONFIG_DVB_MT312=m
> CONFIG_DVB_S5H1420=m
> CONFIG_DVB_STV0299=m
> CONFIG_DVB_TDA8083=m
> CONFIG_DVB_TDA10086=m
> CONFIG_DVB_VES1X93=m
> CONFIG_DVB_TUNER_ITD1000=m
> CONFIG_DVB_TDA826X=m
> CONFIG_DVB_TUA6100=m
>
> #
> # DVB-T (terrestrial) frontends
> #
> CONFIG_DVB_SP8870=m
> CONFIG_DVB_SP887X=m
> CONFIG_DVB_CX22700=m
> CONFIG_DVB_CX22702=m
> # CONFIG_DVB_DRX397XD is not set
> CONFIG_DVB_L64781=m
> CONFIG_DVB_TDA1004X=m
> CONFIG_DVB_NXT6000=m
> CONFIG_DVB_MT352=m
> CONFIG_DVB_ZL10353=m
> CONFIG_DVB_DIB3000MB=m
> CONFIG_DVB_DIB3000MC=m
> CONFIG_DVB_DIB7000M=m
> CONFIG_DVB_DIB7000P=m
> CONFIG_DVB_TDA10048=m
>
> #
> # DVB-C (cable) frontends
> #
> CONFIG_DVB_VES1820=m
> CONFIG_DVB_TDA10021=m
> CONFIG_DVB_TDA10023=m
> CONFIG_DVB_STV0297=m
>
> #
> # ATSC (North American/Korean Terrestrial/Cable DTV) frontends
> #
> CONFIG_DVB_NXT200X=m
> CONFIG_DVB_OR51211=m
> CONFIG_DVB_OR51132=m
> CONFIG_DVB_BCM3510=m
> CONFIG_DVB_LGDT330X=m
> CONFIG_DVB_S5H1409=m
> # CONFIG_DVB_AU8522 is not set
> CONFIG_DVB_S5H1411=m
>
> #
> # Digital terrestrial only tuners/PLL
> #
> CONFIG_DVB_PLL=m
> CONFIG_DVB_TUNER_DIB0070=m
>
> #
> # SEC control devices for DVB-S
> #
> CONFIG_DVB_LNBP21=m
> # CONFIG_DVB_ISL6405 is not set
> CONFIG_DVB_ISL6421=m
> CONFIG_DAB=y
> CONFIG_USB_DABUSB=m
>
> #
> # Graphics support
> #
> CONFIG_AGP=m
> CONFIG_AGP_ALI=m
> CONFIG_AGP_ATI=m
> CONFIG_AGP_AMD=m
> CONFIG_AGP_AMD64=m
> CONFIG_AGP_INTEL=m
> CONFIG_AGP_NVIDIA=m
> CONFIG_AGP_SIS=m
> CONFIG_AGP_SWORKS=m
> CONFIG_AGP_VIA=m
> CONFIG_AGP_EFFICEON=m
> CONFIG_DRM=m
> CONFIG_DRM_TDFX=m
> CONFIG_DRM_R128=m
> CONFIG_DRM_RADEON=m
> CONFIG_DRM_I810=m
> CONFIG_DRM_I830=m
> CONFIG_DRM_I915=m
> CONFIG_DRM_MGA=m
> CONFIG_DRM_SIS=m
> CONFIG_DRM_VIA=m
> CONFIG_DRM_SAVAGE=m
> CONFIG_VGASTATE=m
> CONFIG_VIDEO_OUTPUT_CONTROL=m
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_DDC=m
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=m
> CONFIG_FB_SYS_COPYAREA=m
> CONFIG_FB_SYS_IMAGEBLIT=m
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=m
> CONFIG_FB_SVGALIB=m
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
>
> #
> # Frame buffer hardware drivers
> #
> CONFIG_FB_CIRRUS=m
> CONFIG_FB_PM2=m
> CONFIG_FB_PM2_FIFO_DISCONNECT=y
> CONFIG_FB_CYBER2000=m
> CONFIG_FB_ARC=m
> CONFIG_FB_ASILIANT=y
> CONFIG_FB_IMSTT=y
> CONFIG_FB_VGA16=m
> CONFIG_FB_UVESA=m
> # CONFIG_FB_VESA is not set
> CONFIG_FB_EFI=y
> CONFIG_FB_IMAC=y
> # CONFIG_FB_N411 is not set
> CONFIG_FB_HGA=m
> # CONFIG_FB_HGA_ACCEL is not set
> CONFIG_FB_S1D13XXX=m
> CONFIG_FB_NVIDIA=m
> CONFIG_FB_NVIDIA_I2C=y
> # CONFIG_FB_NVIDIA_DEBUG is not set
> CONFIG_FB_NVIDIA_BACKLIGHT=y
> CONFIG_FB_RIVA=m
> CONFIG_FB_RIVA_I2C=y
> # CONFIG_FB_RIVA_DEBUG is not set
> CONFIG_FB_RIVA_BACKLIGHT=y
> CONFIG_FB_I810=m
> # CONFIG_FB_I810_GTF is not set
> CONFIG_FB_LE80578=m
> CONFIG_FB_CARILLO_RANCH=m
> CONFIG_FB_INTEL=m
> # CONFIG_FB_INTEL_DEBUG is not set
> CONFIG_FB_INTEL_I2C=y
> CONFIG_FB_MATROX=m
> CONFIG_FB_MATROX_MILLENIUM=y
> CONFIG_FB_MATROX_MYSTIQUE=y
> CONFIG_FB_MATROX_G=y
> CONFIG_FB_MATROX_I2C=m
> CONFIG_FB_MATROX_MAVEN=m
> CONFIG_FB_MATROX_MULTIHEAD=y
> CONFIG_FB_RADEON=m
> CONFIG_FB_RADEON_I2C=y
> CONFIG_FB_RADEON_BACKLIGHT=y
> # CONFIG_FB_RADEON_DEBUG is not set
> CONFIG_FB_ATY128=m
> CONFIG_FB_ATY128_BACKLIGHT=y
> CONFIG_FB_ATY=m
> CONFIG_FB_ATY_CT=y
> CONFIG_FB_ATY_GENERIC_LCD=y
> CONFIG_FB_ATY_GX=y
> CONFIG_FB_ATY_BACKLIGHT=y
> CONFIG_FB_S3=m
> CONFIG_FB_SAVAGE=m
> CONFIG_FB_SAVAGE_I2C=y
> CONFIG_FB_SAVAGE_ACCEL=y
> CONFIG_FB_SIS=m
> CONFIG_FB_SIS_300=y
> CONFIG_FB_SIS_315=y
> CONFIG_FB_NEOMAGIC=m
> CONFIG_FB_KYRO=m
> CONFIG_FB_3DFX=m
> # CONFIG_FB_3DFX_ACCEL is not set
> CONFIG_FB_VOODOO1=m
> CONFIG_FB_VT8623=m
> CONFIG_FB_CYBLA=m
> CONFIG_FB_TRIDENT=m
> # CONFIG_FB_TRIDENT_ACCEL is not set
> CONFIG_FB_ARK=m
> CONFIG_FB_PM3=m
> # CONFIG_FB_CARMINE is not set
> CONFIG_FB_GEODE=y
> CONFIG_FB_GEODE_LX=m
> CONFIG_FB_GEODE_GX=m
> CONFIG_FB_GEODE_GX1=m
> CONFIG_FB_SM501=m
> # CONFIG_FB_VIRTUAL is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=m
> CONFIG_LCD_LTV350QV=m
> # CONFIG_LCD_ILI9320 is not set
> # CONFIG_LCD_VGG2432A4 is not set
> # CONFIG_LCD_PLATFORM is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_CORGI=m
> CONFIG_BACKLIGHT_PROGEAR=m
> CONFIG_BACKLIGHT_CARILLO_RANCH=m
> # CONFIG_BACKLIGHT_MBP_NVIDIA is not set
>
> #
> # Display device support
> #
> CONFIG_DISPLAY_SUPPORT=m
>
> #
> # Display hardware drivers
> #
>
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> CONFIG_VIDEO_SELECT=y
> CONFIG_MDA_CONSOLE=m
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=m
> # CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
> # CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
> # CONFIG_FONTS is not set
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y
> # CONFIG_LOGO is not set
> CONFIG_SOUND=y
> # CONFIG_SND is not set
> # CONFIG_SOUND_PRIME is not set
> CONFIG_AC97_BUS=m
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=m
> # CONFIG_HID_DEBUG is not set
> CONFIG_HIDRAW=y
>
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=m
> CONFIG_USB_HIDINPUT_POWERBOOK=y
> # CONFIG_HID_FF is not set
> CONFIG_USB_HIDDEV=y
>
> #
> # USB HID Boot Protocol drivers
> #
> CONFIG_USB_KBD=m
> CONFIG_USB_MOUSE=m
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=m
> CONFIG_USB_DEBUG_MESSAGES=y
> # CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
>
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> # CONFIG_USB_DEVICE_CLASS is not set
> # CONFIG_USB_DYNAMIC_MINORS is not set
> CONFIG_USB_SUSPEND=y
> # CONFIG_USB_OTG is not set
> # CONFIG_USB_OTG_WHITELIST is not set
> # CONFIG_USB_OTG_BLACKLIST_HUB is not set
> CONFIG_USB_MON=y
>
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> CONFIG_USB_EHCI_HCD=m
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> # CONFIG_USB_EHCI_TT_NEWSCHED is not set
> CONFIG_USB_ISP116X_HCD=m
> # CONFIG_USB_ISP1760_HCD is not set
> CONFIG_USB_OHCI_HCD=m
> # CONFIG_USB_OHCI_HCD_SSB is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_UHCI_HCD=m
> CONFIG_USB_U132_HCD=m
> CONFIG_USB_SL811_HCD=m
> CONFIG_USB_SL811_CS=m
> CONFIG_USB_R8A66597_HCD=m
> # CONFIG_USB_GADGET_MUSB_HDRC is not set
>
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=m
> CONFIG_USB_PRINTER=m
> # CONFIG_USB_WDM is not set
>
> #
> # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
> #
>
> #
> # may also be needed; see USB_STORAGE Help for more information
> #
> CONFIG_USB_STORAGE=m
> # CONFIG_USB_STORAGE_DEBUG is not set
> CONFIG_USB_STORAGE_DATAFAB=y
> CONFIG_USB_STORAGE_FREECOM=y
> CONFIG_USB_STORAGE_ISD200=y
> CONFIG_USB_STORAGE_DPCM=y
> CONFIG_USB_STORAGE_USBAT=y
> CONFIG_USB_STORAGE_SDDR09=y
> CONFIG_USB_STORAGE_SDDR55=y
> CONFIG_USB_STORAGE_JUMPSHOT=y
> CONFIG_USB_STORAGE_ALAUDA=y
> # CONFIG_USB_STORAGE_ONETOUCH is not set
> CONFIG_USB_STORAGE_KARMA=y
> # CONFIG_USB_STORAGE_SIERRA is not set
> # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
> CONFIG_USB_LIBUSUAL=y
>
> #
> # USB Imaging devices
> #
> CONFIG_USB_MDC800=m
> CONFIG_USB_MICROTEK=m
>
> #
> # USB port drivers
> #
> CONFIG_USB_USS720=m
> CONFIG_USB_SERIAL=m
> CONFIG_USB_EZUSB=y
> CONFIG_USB_SERIAL_GENERIC=y
> CONFIG_USB_SERIAL_AIRCABLE=m
> CONFIG_USB_SERIAL_ARK3116=m
> CONFIG_USB_SERIAL_BELKIN=m
> CONFIG_USB_SERIAL_CH341=m
> CONFIG_USB_SERIAL_WHITEHEAT=m
> CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
> CONFIG_USB_SERIAL_CP2101=m
> CONFIG_USB_SERIAL_CYPRESS_M8=m
> CONFIG_USB_SERIAL_EMPEG=m
> CONFIG_USB_SERIAL_FTDI_SIO=m
> CONFIG_USB_SERIAL_FUNSOFT=m
> CONFIG_USB_SERIAL_VISOR=m
> CONFIG_USB_SERIAL_IPAQ=m
> # CONFIG_USB_SERIAL_IR is not set
> CONFIG_USB_SERIAL_EDGEPORT=m
> CONFIG_USB_SERIAL_EDGEPORT_TI=m
> CONFIG_USB_SERIAL_GARMIN=m
> CONFIG_USB_SERIAL_IPW=m
> # CONFIG_USB_SERIAL_IUU is not set
> CONFIG_USB_SERIAL_KEYSPAN_PDA=m
> CONFIG_USB_SERIAL_KEYSPAN=m
> # CONFIG_USB_SERIAL_KEYSPAN_MPR is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA28 is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA28X is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA28XA is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA19 is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA18X is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA19W is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA19QW is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA49W is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA49WLC is not set
> CONFIG_USB_SERIAL_KLSI=m
> CONFIG_USB_SERIAL_KOBIL_SCT=m
> CONFIG_USB_SERIAL_MCT_U232=m
> CONFIG_USB_SERIAL_MOS7720=m
> CONFIG_USB_SERIAL_MOS7840=m
> # CONFIG_USB_SERIAL_MOTOROLA is not set
> CONFIG_USB_SERIAL_NAVMAN=m
> CONFIG_USB_SERIAL_PL2303=m
> CONFIG_USB_SERIAL_OTI6858=m
> # CONFIG_USB_SERIAL_SPCP8X5 is not set
> CONFIG_USB_SERIAL_HP4X=m
> CONFIG_USB_SERIAL_SAFE=m
> # CONFIG_USB_SERIAL_SAFE_PADDED is not set
> CONFIG_USB_SERIAL_SIERRAWIRELESS=m
> CONFIG_USB_SERIAL_TI=m
> CONFIG_USB_SERIAL_CYBERJACK=m
> CONFIG_USB_SERIAL_XIRCOM=m
> CONFIG_USB_SERIAL_OPTION=m
> CONFIG_USB_SERIAL_OMNINET=m
> CONFIG_USB_SERIAL_DEBUG=m
>
> #
> # USB Miscellaneous drivers
> #
> CONFIG_USB_EMI62=m
> CONFIG_USB_EMI26=m
> CONFIG_USB_ADUTUX=m
> CONFIG_USB_RIO500=m
> CONFIG_USB_LEGOTOWER=m
> CONFIG_USB_LCD=m
> CONFIG_USB_BERRY_CHARGE=m
> CONFIG_USB_LED=m
> CONFIG_USB_CYPRESS_CY7C63=m
> CONFIG_USB_CYTHERM=m
> CONFIG_USB_PHIDGET=m
> CONFIG_USB_PHIDGETKIT=m
> CONFIG_USB_PHIDGETMOTORCONTROL=m
> CONFIG_USB_PHIDGETSERVO=m
> CONFIG_USB_IDMOUSE=m
> CONFIG_USB_FTDI_ELAN=m
> CONFIG_USB_APPLEDISPLAY=m
> CONFIG_USB_SISUSBVGA=m
> # CONFIG_USB_SISUSBVGA_CON is not set
> CONFIG_USB_LD=m
> CONFIG_USB_TRANCEVIBRATOR=m
> CONFIG_USB_IOWARRIOR=m
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_ISIGHTFW is not set
> # CONFIG_USB_GOTEMP is not set
> CONFIG_USB_ATM=m
> CONFIG_USB_SPEEDTOUCH=m
> CONFIG_USB_CXACRU=m
> CONFIG_USB_UEAGLEATM=m
> CONFIG_USB_XUSBATM=m
> CONFIG_USB_GADGET=m
> # CONFIG_USB_GADGET_DEBUG is not set
> # CONFIG_USB_GADGET_DEBUG_FILES is not set
> # CONFIG_USB_GADGET_DEBUG_FS is not set
> CONFIG_USB_GADGET_SELECTED=y
> # CONFIG_USB_GADGET_AMD5536UDC is not set
> # CONFIG_USB_GADGET_ATMEL_USBA is not set
> # CONFIG_USB_GADGET_FSL_USB2 is not set
> CONFIG_USB_GADGET_NET2280=y
> CONFIG_USB_NET2280=m
> # CONFIG_USB_GADGET_PXA25X is not set
> # CONFIG_USB_GADGET_M66592 is not set
> # CONFIG_USB_GADGET_PXA27X is not set
> # CONFIG_USB_GADGET_GOKU is not set
> # CONFIG_USB_GADGET_LH7A40X is not set
> # CONFIG_USB_GADGET_OMAP is not set
> # CONFIG_USB_GADGET_S3C2410 is not set
> # CONFIG_USB_GADGET_AT91 is not set
> # CONFIG_USB_GADGET_DUMMY_HCD is not set
> CONFIG_USB_GADGET_DUALSPEED=y
> CONFIG_USB_ZERO=m
> CONFIG_USB...
>
> [Message clipped]
