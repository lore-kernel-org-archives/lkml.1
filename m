Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbZG1XFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbZG1XFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932104AbZG1XFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:05:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086AbZG1XFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:05:33 -0400
Date: Tue, 28 Jul 2009 16:05:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: scgtrp@gmail.com
Cc: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Amerigo Wang <xiyou.wangcong@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 13850] New: reading /proc/kcore causes oops
Message-Id: <20090728160527.1da52682.akpm@linux-foundation.org>
In-Reply-To: <bug-13850-10286@http.bugzilla.kernel.org/>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Mon, 27 Jul 2009 03:19:11 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13850
> 
>            Summary: reading /proc/kcore causes oops
>            Product: Other
>            Version: 2.5
>     Kernel Version: 2.6.30
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: other_other@kernel-bugs.osdl.org
>         ReportedBy: scgtrp@gmail.com
>         Regression: No
> 
> 
> When trying to use an old trick for finding lost data by grep'ing /proc/kcore,
> I managed to oops my server's kernel. I tried again on my desktop with cat
> /proc/kcore >/dev/null. cat was killed, and a similar oops appeared in my dmesg
> which I managed to capture:
> 
> Jul 26 23:04:13 mike kernel: BUG: unable to handle kernel paging request at
> e07cf000
> Jul 26 23:04:13 mike kernel: IP: [<c0224dd1>] read_kcore+0x2c1/0x4b0
> Jul 26 23:04:13 mike kernel: *pde = 1b5f4067 *pte = 00000000 
> Jul 26 23:04:13 mike kernel: Oops: 0000 [#2] PREEMPT SMP 
> Jul 26 23:04:13 mike kernel: last sysfs file: /sys/power/state
> Jul 26 23:04:13 mike kernel: Modules linked in: ipv6 sg sd_mod fuse usb_storage
> usbhid hid snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
> snd_pcm_oss snd_mixer_oss ppdev snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm
> snd_timer ohci_hcd parport_pc lp parport snd soundcore snd_page_alloc nvidia(P)
> agpgart k8temp ehci_hcd forcedeth i2c_nforce2 i2c_core usbcore evdev thermal
> processor fan button battery ac rtc_cmos rtc_core rtc_lib ext3 jbd mbcache
> ide_gd_mod ide_cd_mod cdrom sata_nv libata amd74xx ide_pci_generic ide_core
> scsi_mod
> Jul 26 23:04:13 mike kernel: 
> Jul 26 23:04:13 mike kernel: Pid: 4835, comm: cat Tainted: P      D   
> (2.6.30-ARCH #1) W3107
> Jul 26 23:04:13 mike kernel: EIP: 0060:[<c0224dd1>] EFLAGS: 00210286 CPU: 0
> Jul 26 23:04:13 mike kernel: EIP is at read_kcore+0x2c1/0x4b0
> Jul 26 23:04:13 mike kernel: EAX: ddb71ac0 EBX: 00001000 ECX: 00000400 EDX:
> e07d0000
> Jul 26 23:04:13 mike kernel: ESI: e07cf000 EDI: da20e000 EBP: d73fbf30 ESP:
> d73fbefc
> Jul 26 23:04:13 mike kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Jul 26 23:04:13 mike kernel: Process cat (pid: 4835, ti=d73fa000 task=d4b5cc00
> task.ti=d73fa000)
> Jul 26 23:04:13 mike kernel: Stack:
> Jul 26 23:04:13 mike kernel: da20e000 e07cf000 d73fbf90 00000000 09459000
> 00000000 00008000 00001000
> Jul 26 23:04:13 mike kernel: 00000000 6798ed89 ddaf0000 ce920c80 c0224b10
> fffffffb c0219e89 d73fbf90
> Jul 26 23:04:13 mike kernel: 09459000 00008000 d73fbf90 6798ed89 ce920c80
> 00008000 09459000 d73fbf80
> Jul 26 23:04:13 mike kernel: Call Trace:
> Jul 26 23:04:13 mike kernel: [<c0224b10>] ? read_kcore+0x0/0x4b0
> Jul 26 23:04:13 mike kernel: [<c0219e89>] ? proc_reg_read+0x79/0xc0
> Jul 26 23:04:13 mike kernel: [<c01d1b43>] ? vfs_read+0xc3/0x1a0
> Jul 26 23:04:13 mike kernel: [<c0219e10>] ? proc_reg_read+0x0/0xc0
> Jul 26 23:04:13 mike kernel: [<c01d1d28>] ? sys_read+0x58/0xb0
> Jul 26 23:04:13 mike kernel: [<c0103c73>] ? sysenter_do_call+0x12/0x28
> Jul 26 23:04:13 mike kernel: Code: 89 fb 0f 43 f2 89 ca 29 f2 29 f3 39 f9 0f 46
> da 29 5c 24 14 f6 40 0c 01 8d 14 33 75 19 89 d9 89 f7 c1 e9 02 2b 7c 24 04 03
> 3c 24 <f3> a5 89 d9 83 e1 03 74 02 f3 a4 8b 4c 24 14 8b 00 85 c9 74 0a 
> Jul 26 23:04:13 mike kernel: EIP: [<c0224dd1>] read_kcore+0x2c1/0x4b0 SS:ESP
> 0068:d73fbefc
> Jul 26 23:04:13 mike kernel: CR2: 00000000e07cf000
> Jul 26 23:04:13 mike kernel: ---[ end trace 3bb140bf57c1987e ]---
> Jul 26 23:04:13 mike kernel: note: cat[4835] exited with preempt_count 1
> 
> I understand it's quite a ridiculous thing to do, but userspace shouldn't be
> able to cause kernel errors, no matter what kind of insane things I try.
> 

gee, read_kcore() is huge.  This makes it pretty hard to work out where
exactly the kernel died.

Is it reproducible, or do you still have the vmlinux from the above
oops on-disk?

If so, can you please help work out where it crashed?  You could run
something like

	addr2line -e vmlinux 0xc0224dd1

or

	gdb vmlinux
	(gdb) l *0xc0224dd1

both of these will need CONFIG_DEBUG_INFO=y.


It is possible to work out where the kernel crashed using the above
Code: line, but it's a bit of a pain.

Thanks.

