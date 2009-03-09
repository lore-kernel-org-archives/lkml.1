Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbZCIRBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbZCIRBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 13:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbZCIRBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 13:01:24 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:52190 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZCIRBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 13:01:22 -0400
Date: Mon, 9 Mar 2009 17:01:19 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Fr3ddie <fr3ddie@fr3ddie.it>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: BUG at /build/buildd/linux-2.6.24/mm/rmap.c:631
Message-ID: <20090309170119.GE24213@silver.sucs.org>
References: <49B54125.6090300@fr3ddie.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B54125.6090300@fr3ddie.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 05:17:41PM +0100, Fr3ddie wrote:
> [4.] Kernel version (from /proc/version):
> Linux version 2.6.24-23-server (buildd@vernadsky) (gcc version 4.2.3
> (Ubuntu 4.2.3-2ubuntu7)) #1 SMP Mon Jan 26 00:55:21 UTC 2009

^^^ 2.6.24 is pretty old in LKML time (we're up to 2.6.29-rc7 in terms
of unstable releases and 2.6.28.7 is the latest stable at the time of
writing) so the issue might have been fixed. Generally if your kernel
isn't the latest stable/unstable and you don't have the facilities to
reproduce the error with a the newer kernels it is best to report the
issue to your kernel vendor (in this case Ubuntu) first as the issue
might have already been fixed. I would strongly urge you to file this
bug in the Ubuntu bug tracker. Details about how to do this can be read
on https://wiki.ubuntu.com/KernelTeamBugPolicies .

There's a mangled BUG message somewhere below (CC'ing Rik).
Unfortunately your email program has line wrapped the log file making it
very hard to read. 

> Here's the log pages, sent me by logcheck, that I think could be relevant:
> 
> Mar  9 03:00:59 Aula2Server kernel: [117722.497458] Eeek!
> page_mapcount(page) went negative! (-1)
> Mar  9 03:00:59 Aula2Server kernel: [117722.497814]   page pfn = 44700
> Mar  9 03:00:59 Aula2Server kernel: [117722.498014]   page->flags = 80000060
> Mar  9 03:00:59 Aula2Server kernel: [117722.498250]   page->count = 1
> Mar  9 03:00:59 Aula2Server kernel: [117722.498442]   page->mapping =
> f4c0c681
> Mar  9 03:00:59 Aula2Server kernel: [117722.498706]   vma->vm_ops = 0x0
> Mar  9 03:00:59 Aula2Server kernel: [117722.498940] ------------[ cut
> here ]------------
> Mar  9 03:00:59 Aula2Server kernel: [117722.499243] kernel BUG at
> /build/buildd/linux-2.6.24/mm/rmap.c:631!
> Mar  9 03:00:59 Aula2Server kernel: [117722.499666] invalid opcode: 0000
> [#1] SMP
> Mar  9 03:00:59 Aula2Server kernel: [117722.499940] Modules linked in:
> xt_multiport video output sbs sbshc container dock battery w83627ehf
> hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
> ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
> snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
> sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
> snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
> button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
> intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
> usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
> floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
> async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
> processor fan fuse vesafb fbcon tileblit font bitblit softcursor
> Mar  9 03:00:59 Aula2Server kernel: [117722.505128]
> Mar  9 03:00:59 Aula2Server kernel: [117722.505224] Pid: 29294, comm:
> hadcm3trans_um_ Not tainted (2.6.24-23-server #1)
> Mar  9 03:00:59 Aula2Server kernel: [117722.505693] EIP:
> 0060:[page_remove_rmap+0xf9/0x110] EFLAGS: 00010246 CPU: 0
> Mar  9 03:00:59 Aula2Server kernel: [117722.506049] EIP is at
> page_remove_rmap+0xf9/0x110
> Mar  9 03:00:59 Aula2Server kernel: [117722.506351] EAX: 00000000 EBX:
> c188e000 ECX: 00000092 EDX: 00000000
> Mar  9 03:00:59 Aula2Server kernel: [117722.506752] ESI: f508dd68 EDI:
> c188e000 EBP: 00100100 ESP: f3807da0
> Mar  9 03:00:59 Aula2Server kernel: [117722.507155]  DS: 007b ES: 007b
> FS: 00d8 GS: 0000 SS: 0068
> Mar  9 03:00:59 Aula2Server kernel: [117722.507502] Process
> hadcm3trans_um_ (pid: 29294, ti=f3806000 task=f39565c0 task.ti=f3806000)
> Mar  9 03:00:59 Aula2Server kernel: [117722.508042] Stack: c03ccd53
> f4c0c681 fffb3140 44700067 c0181afc 44700067 00000000 c1fa3f8c
> Mar  9 03:00:59 Aula2Server kernel: [117722.508621]        c04992a0
> c200f2b0 00000000 f508dd68 f3807e4c 00000000 00000000 44700067
> Mar  9 03:00:59 Aula2Server kernel: [117722.509199]        00000000
> 00000001 00229000 00000000 bfc78000 f402c010 f4124f70 f44a21c0
> Mar  9 03:00:59 Aula2Server kernel: [117722.509778] Call Trace:
> Mar  9 03:00:59 Aula2Server kernel: [117722.509949]
> [unmap_vmas+0x46c/0x740] unmap_vmas+0x46c/0x740
> Mar  9 03:00:59 Aula2Server kernel: [117722.510320]
> [exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
> Mar  9 03:00:59 Aula2Server kernel: [117722.510623]  [mmput+0x1e/0x80]
> mmput+0x1e/0x80
> Mar  9 03:00:59 Aula2Server kernel: [117722.510889]
> [do_exit+0x165/0x860] do_exit+0x165/0x860
> Mar  9 03:00:59 Aula2Server kernel: [117722.511189]
> [recalc_sigpending+0xb/0x40] recalc_sigpending+0xb/0x40
> Mar  9 03:00:59 Aula2Server kernel: [117722.511515]
> [dequeue_signal+0x6b/0x150] dequeue_signal+0x6b/0x150
> Mar  9 03:00:59 Aula2Server kernel: [117722.511844]
> [do_group_exit+0x26/0x80] do_group_exit+0x26/0x80
> Mar  9 03:00:59 Aula2Server kernel: [117722.512157]
> [get_signal_to_deliver+0x2c7/0x4c0] get_signal_to_deliver+0x2c7/0x4c0
> Mar  9 03:00:59 Aula2Server kernel: [117722.512484]
> [finish_task_switch+0x70/0x90] finish_task_switch+0x70/0x90
> Mar  9 03:00:59 Aula2Server kernel: [117722.512793]
> [do_notify_resume+0x93/0x720] do_notify_resume+0x93/0x720
> Mar  9 03:00:59 Aula2Server kernel: [117722.513096]
> [__remove_hrtimer+0x4f/0x80] __remove_hrtimer+0x4f/0x80
> Mar  9 03:00:59 Aula2Server kernel: [117722.513387]
> [hrtimer_try_to_cancel+0x3c/0x80] hrtimer_try_to_cancel+0x3c/0x80
> Mar  9 03:00:59 Aula2Server kernel: [117722.513746]
> [hrtimer_cancel+0xe/0x20] hrtimer_cancel+0xe/0x20
> Mar  9 03:00:59 Aula2Server kernel: [117722.514054]
> [do_nanosleep+0x59/0x70] do_nanosleep+0x59/0x70
> Mar  9 03:00:59 Aula2Server kernel: [117722.514364]
> [hrtimer_nanosleep+0x5c/0xd0] hrtimer_nanosleep+0x5c/0xd0
> Mar  9 03:00:59 Aula2Server kernel: [117722.514707]
> [hrtimer_wakeup+0x0/0x20] hrtimer_wakeup+0x0/0x20
> Mar  9 03:00:59 Aula2Server kernel: [117722.515045]
> [sys_nanosleep+0x58/0x60] sys_nanosleep+0x58/0x60
> Mar  9 03:00:59 Aula2Server kernel: [117722.515363]
> [work_notifysig+0x13/0x19] work_notifysig+0x13/0x19
> Mar  9 03:00:59 Aula2Server kernel: [117722.515711]  =======================
> Mar  9 03:00:59 Aula2Server kernel: [117722.515939] Code: 8b 46 44 8b 50
> 08 b8 83 cd 3c c0 e8 82 e9 fc ff 8b 46 4c 85 c0 74 14 8b 40 10 85 c0 74
> 0d 8b 50 2c b8 74 bc 3c c0 e8 67 e9 fc ff <0f> 0b eb fe 8b 53 0c eb 85
> 8d b4 26 00 00 00 00 8d bc 27 00 00
> Mar  9 03:00:59 Aula2Server kernel: [117722.517495] EIP:
> [page_remove_rmap+0xf9/0x110] page_remove_rmap+0xf9/0x110 SS:ESP
> 0068:f3807da0
> Mar  9 03:00:59 Aula2Server kernel: [117722.576235] ---[ end trace
> 1b2cab846758a6ac ]---
> Mar  9 03:00:59 Aula2Server kernel: [117722.576540] Fixing recursive
> fault but reboot is needed!
> Mar  9 03:00:59 Aula2Server kernel: [117722.576890] BUG: scheduling
> while atomic: hadcm3trans_um_/29294/0x00000001
> Mar  9 03:00:59 Aula2Server kernel: [117722.597227] Pid: 29294, comm:
> hadcm3trans_um_ Tainted: G      D 2.6.24-23-server #1
> Mar  9 03:00:59 Aula2Server kernel: [117722.619395]
> [jbd:schedule+0x582/0x6b0] schedule+0x582/0x630
> Mar  9 03:00:59 Aula2Server kernel: [117722.639702]
> [do_exit+0x750/0x860] do_exit+0x750/0x860
> Mar  9 03:00:59 Aula2Server kernel: [117722.662075]
> [snd_hda_intel:printk+0x1b/0x100] printk+0x1b/0x20
> Mar  9 03:00:59 Aula2Server kernel: [117722.682283]  [die+0x277/0x280]
> die+0x277/0x280
> Mar  9 03:00:59 Aula2Server kernel: [117722.702388]
> [do_invalid_op+0x0/0x90] do_invalid_op+0x0/0x90
> Mar  9 03:00:59 Aula2Server kernel: [117722.724478]
> [do_invalid_op+0x81/0x90] do_invalid_op+0x81/0x90
> Mar  9 03:00:59 Aula2Server kernel: [117722.744549]
> [page_remove_rmap+0xf9/0x110] page_remove_rmap+0xf9/0x110
> Mar  9 03:00:59 Aula2Server kernel: [117722.766710]
> [snd_hwdep:__wake_up+0x3e/0x1f10] __wake_up+0x3e/0x60
> Mar  9 03:00:59 Aula2Server kernel: [117722.786542]
> [wake_up_klogd+0x3b/0x40] wake_up_klogd+0x3b/0x40
> Mar  9 03:00:59 Aula2Server kernel: [117722.807980]
> [error_code+0x72/0x78] error_code+0x72/0x78
> Mar  9 03:00:59 Aula2Server kernel: [117722.827340]
> [page_remove_rmap+0xf9/0x110] page_remove_rmap+0xf9/0x110
> Mar  9 03:00:59 Aula2Server kernel: [117722.848661]
> [unmap_vmas+0x46c/0x740] unmap_vmas+0x46c/0x740
> Mar  9 03:00:59 Aula2Server kernel: [117722.868105]
> [exit_mmap+0x79/0xf0] exit_mmap+0x79/0xf0
> Mar  9 03:00:59 Aula2Server kernel: [117722.887337]  [mmput+0x1e/0x80]
> mmput+0x1e/0x80
> Mar  9 03:00:59 Aula2Server kernel: [117722.908603]
> [do_exit+0x165/0x860] do_exit+0x165/0x860
> Mar  9 03:00:59 Aula2Server kernel: [117722.928016]
> [recalc_sigpending+0xb/0x40] recalc_sigpending+0xb/0x40
> Mar  9 03:00:59 Aula2Server kernel: [117722.949648]
> [dequeue_signal+0x6b/0x150] dequeue_signal+0x6b/0x150
> Mar  9 03:00:59 Aula2Server kernel: [117722.969151]
> [do_group_exit+0x26/0x80] do_group_exit+0x26/0x80
> Mar  9 03:00:59 Aula2Server kernel: [117722.988429]
> [get_signal_to_deliver+0x2c7/0x4c0] get_signal_to_deliver+0x2c7/0x4c0
> Mar  9 03:00:59 Aula2Server kernel: [117723.009712]
> [finish_task_switch+0x70/0x90] finish_task_switch+0x70/0x90
> Mar  9 03:00:59 Aula2Server kernel: [117723.030677]
> [do_notify_resume+0x93/0x720] do_notify_resume+0x93/0x720
> Mar  9 03:00:59 Aula2Server kernel: [117723.048891]
> [__remove_hrtimer+0x4f/0x80] __remove_hrtimer+0x4f/0x80
> Mar  9 03:00:59 Aula2Server kernel: [117723.066359]
> [hrtimer_try_to_cancel+0x3c/0x80] hrtimer_try_to_cancel+0x3c/0x80
> Mar  9 03:00:59 Aula2Server kernel: [117723.085353]
> [hrtimer_cancel+0xe/0x20] hrtimer_cancel+0xe/0x20
> Mar  9 03:00:59 Aula2Server kernel: [117723.101499]
> [do_nanosleep+0x59/0x70] do_nanosleep+0x59/0x70
> Mar  9 03:00:59 Aula2Server kernel: [117723.117188]
> [hrtimer_nanosleep+0x5c/0xd0] hrtimer_nanosleep+0x5c/0xd0
> Mar  9 03:00:59 Aula2Server kernel: [117723.134874]
> [hrtimer_wakeup+0x0/0x20] hrtimer_wakeup+0x0/0x20
> Mar  9 03:00:59 Aula2Server kernel: [117723.150343]
> [sys_nanosleep+0x58/0x60] sys_nanosleep+0x58/0x60
> Mar  9 03:00:59 Aula2Server kernel: [117723.165590]
> [work_notifysig+0x13/0x19] work_notifysig+0x13/0x19
> Mar  9 03:00:59 Aula2Server kernel: [117723.182636]  =======================
> Mar  9 03:01:02 Aula2Server kernel: [117724.867853] ------------[ cut
> here ]------------
> Mar  9 03:01:02 Aula2Server kernel: [117724.882838] kernel BUG at
> /build/buildd/linux-2.6.24/arch/x86/mm/highmem_32.c:42!
> Mar  9 03:01:02 Aula2Server kernel: [117724.898270] invalid opcode: 0000
> [#2] SMP
> Mar  9 03:01:02 Aula2Server kernel: [117724.913491] Modules linked in:
> xt_multiport video output sbs sbshc container dock battery w83627ehf
> hwmon_vid iptable_filter ip_tables x_tables ext3 jbd mbcache ac lp loop
> ipv6 sn9c102 compat_ioctl32 gspca videodev v4l2_common v4l1_compat
> snd_hda_intel snd_hwdep snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss
> sky2 snd_seq_dummy snd_seq_oss psmouse snd_seq_midi serio_raw
> snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device shpchp
> button evdev pci_hotplug snd pcspkr parport_pc parport soundcore
> intel_agp agpgart jfs sr_mod cdrom pata_acpi ata_piix usbhid hid
> usb_storage libusual sg sd_mod ahci ata_generic pata_it821x libata
> floppy scsi_mod ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor
> async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
> processor fan fuse vesafb fbcon tileblit font bitblit softcursor
> Mar  9 03:01:02 Aula2Server kernel: [117725.017819]
> Mar  9 03:01:02 Aula2Server kernel: [117725.035765] Pid: 6404, comm:
> cron Tainted: G      D (2.6.24-23-server #1)
> Mar  9 03:01:02 Aula2Server kernel: [117725.054331] EIP:
> 0060:[kmap_atomic_prot+0x90/0x130] EFLAGS: 00010206 CPU: 0
> Mar  9 03:01:02 Aula2Server kernel: [117725.072872] EIP is at
> kmap_atomic_prot+0x90/0x130
> Mar  9 03:01:02 Aula2Server kernel: [117725.091414] EAX: 7d1fc163 EBX:
> 00000007 ECX: c1fa1ec0 EDX: 00000000
> Mar  9 03:01:02 Aula2Server kernel: [117725.110362] ESI: 00000163 EDI:
> 80000000 EBP: f589c574 ESP: f559be64
> Mar  9 03:01:02 Aula2Server kernel: [117725.129109]  DS: 007b ES: 007b
> FS: 00d8 GS: 0033 SS: 0068
> Mar  9 03:01:02 Aula2Server kernel: [117725.147878] Process cron (pid:
> 6404, ti=f559a000 task=f5598000 task.ti=f559a000)
> Mar  9 03:01:02 Aula2Server kernel: [117725.148357] Stack: c0224be5
> 0000370c fffff000 00000038 00000007 80000000 7d0f6067 f589c540
> Mar  9 03:01:02 Aula2Server kernel: [117725.167780]        f589c574
> c01261ec 00000163 80000000 f589c540 c0183859 c200fb80 c20134b4
> Mar  9 03:01:02 Aula2Server kernel: [117725.187262]        c2011100
> 00000000 c04053a0 c010736e f55981f0 c049a400 f750fc40 f589c540
> Mar  9 03:01:02 Aula2Server kernel: [117725.206923] Call Trace:
> Mar  9 03:01:02 Aula2Server kernel: [117725.245863]
> [snd_seq:vsnprintf+0x2d5/0x610] vsnprintf+0x2d5/0x610
> Mar  9 03:01:02 Aula2Server kernel: [117725.265618]
> [loop:kmap_atomic+0x1c/0x30] kmap_atomic+0x1c/0x30
> Mar  9 03:01:02 Aula2Server kernel: [117725.285370]
> [handle_mm_fault+0x149/0xb80] handle_mm_fault+0x149/0xb80
> Mar  9 03:01:02 Aula2Server kernel: [117725.305389]
> [__switch_to+0x9e/0x150] __switch_to+0x9e/0x150
> Mar  9 03:01:02 Aula2Server kernel: [117725.325281]
> [hrtimer_cancel+0xe/0x20] hrtimer_cancel+0xe/0x20
> Mar  9 03:01:02 Aula2Server kernel: [117725.345056]
> [do_nanosleep+0x59/0x70] do_nanosleep+0x59/0x70
> Mar  9 03:01:02 Aula2Server kernel: [117725.364607]
> [hrtimer_nanosleep+0x5c/0xd0] hrtimer_nanosleep+0x5c/0xd0
> Mar  9 03:01:02 Aula2Server kernel: [117725.383540]
> [do_page_fault+0x143/0x900] do_page_fault+0x143/0x900
> Mar  9 03:01:02 Aula2Server kernel: [117725.402224]
> [do_nanosleep+0x46/0x70] do_nanosleep+0x46/0x70
> Mar  9 03:01:02 Aula2Server kernel: [117725.420897]
> [sys_nanosleep+0x58/0x60] sys_nanosleep+0x58/0x60
> Mar  9 03:01:02 Aula2Server kernel: [117725.439298]
> [do_page_fault+0x0/0x900] do_page_fault+0x0/0x900
> Mar  9 03:01:02 Aula2Server kernel: [117725.457566]
> [error_code+0x72/0x78] error_code+0x72/0x78
> Mar  9 03:01:02 Aula2Server kernel: [117725.475694]  =======================
> Mar  9 03:01:02 Aula2Server kernel: [117725.493441] Code: 14 40 8d 14 90
> a1 20 a3 40 c0 01 da 89 54 24 10 c1 e2 03 89 54 24 0c 89 44 24 08 a1 28
> 43 4b c0 29 d0 8b 50 04 8b 00 85 c0 74 04 <0f> 0b eb fe 85 d2 75 f8 2b
> 0d 00 1e 50 c0 31 db c1 f9 05 0f a4
> Mar  9 03:01:02 Aula2Server kernel: [117725.531982] EIP:
> [kmap_atomic_prot+0x90/0x130] kmap_atomic_prot+0x90/0x130 SS:ESP
> 0068:f559be64
> Mar  9 03:01:02 Aula2Server kernel: [117725.553358] ---[ end trace
> 1b2cab846758a6ac ]---

(There were more errors in the original mail but snipped for brevity)

Good luck!

-- 
Sitsofe | http://sucs.org/~sits/
