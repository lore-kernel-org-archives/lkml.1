Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZAFX7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZAFX7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZAFX7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:59:22 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:35244 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZAFX7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:59:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=o6JRFXgYdgnMU2mnPf7XfomYTkxYdQ1C71oG8eklk/u2OTWGFYfIKBCuxyC+WVy7Cd
         vpIyuNBVHREXpUWPfLl3KELS0MZtkJ903IzzpDogdAcEFacq0Mq9gNBgN6x3Bh0d1tGk
         i3ytrIekDLJ3AqyLImJFscvZ4s371O7TPqzdc=
Message-ID: <4963EE3C.3070106@googlemail.com>
Date: Wed, 07 Jan 2009 00:50:20 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081122)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] HID updates for 2.6.29
References: <alpine.LNX.1.10.0901040115060.5377@jikos.suse.cz> <alpine.LNX.1.10.0901051055120.5377@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0901051055120.5377@jikos.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:

Hi Jiri ,

> [ Hmm, sorry, forgot to push yesterday ... synced out to kernel.org now ]
> 
> On Sun, 4 Jan 2009, Jiri Kosina wrote:
> 
>> Linus,
>>
>> could you please pull from 'for-linus' branch of
>>
>>         git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus
>>
>> to receive the following updates of HID code that have been planned for 
>> 2.6.29.
>>
>> This batch contains mostly added support for new quirky devices and various
>> rather easy fixes all over the code.
>>
>> Thanks!
>>
>>  drivers/hid/Kconfig             |   70 ++++++++-------
>>  drivers/hid/Makefile            |    5 +-
>>  drivers/hid/hid-bright.c        |   71 ---------------
>>  drivers/hid/hid-core.c          |  120 +++++++++++++++++++++++---
>>  drivers/hid/hid-dell.c          |   76 ----------------
>>  drivers/hid/hid-dummy.c         |    6 ++
>>  drivers/hid/hid-gaff.c          |  185 +++++++++++++++++++++++++++++++++++++++
>>  drivers/hid/hid-ids.h           |   21 +++--
>>  drivers/hid/hid-lg.c            |    7 --
>>  drivers/hid/hid-ntrig.c         |   82 +++++++++++++++++
>>  drivers/hid/hid-sony.c          |    2 +-
>>  drivers/hid/hid-topseed.c       |   77 ++++++++++++++++
>>  drivers/hid/hidraw.c            |   32 ++++++-
>>  drivers/hid/usbhid/Kconfig      |    2 +-
>>  drivers/hid/usbhid/hid-core.c   |   34 +++++---
>>  drivers/hid/usbhid/hid-quirks.c |    1 +
>>  drivers/hid/usbhid/hiddev.c     |  135 +++++++++++++++++++++--------
>>  drivers/hid/usbhid/usbhid.h     |   10 ++
>>  include/linux/hid.h             |   16 ++--
>>  include/linux/hidraw.h          |    2 +
>>  20 files changed, 685 insertions(+), 269 deletions(-)
>>
>> Alan Stern (1):
>>       HID: automatically call usbhid_set_leds in usbhid driver
>>
>> Alexey Klimov (1):
>>       HID: don't allow DealExtreme usb-radio be handled by usb hid driver
>>
>> David Brownell (1):
>>       HID: switch specialized drivers from "default y" to !EMBEDDED
>>
>> Hannes Eder (1):
>>       HID: avoid sparse warning in HID_COMPAT_LOAD_DRIVER
>>
>> Jiri Kosina (6):
>>       HID: ignore mouse interface for unibody macbooks
>>       HID: non-input reports can also be numbered
>>       HID: add phys and name ioctls to hidraw
>>       HID: set proper dev.parent in hidraw
>>       HID: fix default Kconfig setting for TopSpeed driver
>>       HID: fix error condition propagation in hid-sony driver
>>
>> Jiri Slaby (4):
>>       HID: move usbhid flags to usbhid.h
>>       HID: usbhid, use usb_endpoint_xfer_int
>>       HID: use GFP_KERNEL in hid_alloc_buffers
>>       HID: add dynids facility
>>
>> Kay Sievers (1):
>>       HID: struct device - replace bus_id with dev_name(), dev_set_name()
>>
>> Lev Babiev (1):
>>       HID: driver for TopSeed Cyberlink quirky remote
>>
>> Lukasz Lubojanski (1):
>>       HID: force feedback driver for GreenAsia 0x12 PID
>>
>> Matt Helsley (1):
>>       HID: add proper support for pensketch 12x9 tablet
>>
>> Oliver Neukum (2):
>>       HID: hiddev cleanup -- handle all error conditions properly
>>       HID: fix reference count leak hidraw
>>
>> Parag Warudkar (1):
>>       HID: make boot protocol drivers depend on EMBEDDED
>>
>> Rafi Rubin (1):
>>       HID: add n-trig digitizer support
>>
>>
> 


After this merge I get the following panic , by just touching my  Wireless USB Mouse :

...

[  223.999461] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
[  224.000446] IP: [<ffffffff80224e65>] __ticket_spin_lock+0x9/0x1a
[  224.000446] PGD 7b4a5067 PUD 7a24b067 PMD 0
[  224.000446] Oops: 0002 [#1] PREEMPT SMP
[  224.000446] last sysfs file: /sys/devices/pci0000:00/0000:00:19.0/irq
[  224.000446] CPU 0
[  224.000446] Modules linked in: i915 binfmt_misc acpi_cpufreq freq_table w83627ehf hwmon_vid fuse loop lp ppdev parport_pc parport joydev pcspkr i2c_i801 intel_agp button sg evdev processor
[  224.000446] Pid: 0, comm: swapper Not tainted 2.6.28-06127-g238c6d5 #31
[  224.000446] RIP: 0010:[<ffffffff80224e65>]  [<ffffffff80224e65>] __ticket_spin_lock+0x9/0x1a
[  224.000446] RSP: 0018:ffffffff807e3bd0  EFLAGS: 00010002
[  224.000446] RAX: 0000000000000100 RBX: 0000000000000082 RCX: 0000000000000000
[  224.000446] RDX: 0000000000000000 RSI: 0000000000000082 RDI: 0000000000000050
[  224.000446] RBP: ffffffff807e3bd0 R08: ffff88007d254000 R09: ffffffff806db440
[  224.000446] R10: ffffffff8023d95c R11: ffff88007e0a3d80 R12: 0000000000000050
[  224.000446] R13: ffffffff807e3c70 R14: 0000000000000006 R15: 0000000000000050
[  224.000446] FS:  0000000000000000(0000) GS:ffffffff807ec000(0000) knlGS:0000000000000000
[  224.000446] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  224.000446] CR2: 0000000000000050 CR3: 000000007e1c0000 CR4: 00000000000006e0
[  224.000446] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  224.000446] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  224.000446] Process swapper (pid: 0, threadinfo ffffffff80772000, task ffffffff806d8340)
[  224.000446] Stack:
[  224.000446]  ffffffff807e3be0 ffffffff80224f2f ffffffff807e3c00 ffffffff805673a7
[  224.000446]  ffff88007d22c180 0000000000000000 ffffffff807e3c50 ffffffff80496bc0
[  224.000446]  ffff880001014740 ffff88000101af00 ffff88000101af00 ffff88007d22c180
[  224.000446] Call Trace:
[  224.000446]  <IRQ> <0> [<ffffffff80224f2f>] default_spin_lock_flags+0x9/0xe
[  224.000446]  [<ffffffff805673a7>] _spin_lock_irqsave+0x37/0x40
[  224.000446]  [<ffffffff80496bc0>] hiddev_send_event+0x2e/0xe9
[  224.000446]  [<ffffffff80496ccd>] hiddev_report_event+0x52/0x54
[  224.000446]  [<ffffffff8023211c>] ? resched_task+0x45/0x81
[  224.000446]  [<ffffffff8048cd93>] hid_report_raw_event+0xb3/0x3b3
[  224.000446]  [<ffffffff80235e86>] ? tg_shares_up+0x183/0x1a3
[  224.000446]  [<ffffffff80235b6b>] ? enqueue_entity+0x1f8/0x200
[  224.000446]  [<ffffffff8048d15c>] hid_input_report+0xc9/0xdc
[  224.000446]  [<ffffffff80494939>] hid_irq_in+0x90/0x194
[  224.000446]  [<ffffffff804535ef>] usb_hcd_giveback_urb+0x58/0x87
[  224.000446]  [<ffffffff80469f0f>] uhci_giveback_urb+0x108/0x19d
[  224.000446]  [<ffffffff8046a666>] uhci_scan_schedule+0x5a8/0x86b
[  224.000446]  [<ffffffff8023327e>] ? __wake_up+0x43/0x50
[  224.000446]  [<ffffffff8046c5bc>] uhci_irq+0x13f/0x158
[  224.000446]  [<ffffffff80453168>] usb_hcd_irq+0x42/0x90
[  224.000446]  [<ffffffff8056789b>] ? _spin_unlock+0x33/0x3e
[  224.000446]  [<ffffffff80278485>] handle_IRQ_event+0x2e/0x65
[  224.000446]  [<ffffffff80279994>] handle_fasteoi_irq+0x8b/0xcb
[  224.000446]  [<ffffffff8020f08c>] do_IRQ+0x70/0xe4
[  224.000446]  [<ffffffff8020ce93>] ret_from_intr+0x0/0x29
[  224.000446]  <EOI> <0>Code: 4c 22 80 44 89 c6 4c 89 cf e8 5e fc ff ff eb 0e 0f b7 f2 0f b6 f8 4c 89 ca e8 75 fc ff ff c9 c3 90 90 55 b8 00 01 00 00 48 89 e5 <f0> 66 0f c1 07 38 e0 74 06 f3 90 8a 07 eb f6 c9 c3 55 48 89 e5
[  224.000446] RIP  [<ffffffff80224e65>] __ticket_spin_lock+0x9/0x1a
[  224.000446]  RSP <ffffffff807e3bd0>
[  224.000446] CR2: 0000000000000050
[  224.000446] ---[ end trace 7f15bb0ad8b16dd9 ]---
[  224.000446] Kernel panic - not syncing: Fatal exception in interrupt
[  224.000446] ------------[ cut here ]------------
[  224.000446] WARNING: at kernel/smp.c:299 smp_call_function_many+0x40/0x1ec()
[  224.000446] Hardware name: P5E-VM DO
[  224.000446] Modules linked in: i915 binfmt_misc acpi_cpufreq freq_table w83627ehf hwmon_vid fuse loop lp ppdev parport_pc parport joydev pcspkr i2c_i801 intel_agp button sg evdev processor
[  224.000446] Pid: 0, comm: swapper Tainted: G      D    2.6.28-06127-g238c6d5 #31
[  224.000446] Call Trace:
[  224.000446]  <IRQ>  [<ffffffff8024152d>] warn_slowpath+0xd3/0x10f
[  224.000446]  [<ffffffff80224f2f>] ? default_spin_lock_flags+0x9/0xe
[  224.000446]  [<ffffffff805677ea>] ? _spin_unlock_irqrestore+0x4f/0x53
[  224.000446]  [<ffffffff805677ea>] ? _spin_unlock_irqrestore+0x4f/0x53
[  224.000446]  [<ffffffff80241c5f>] ? release_console_sem+0x198/0x1cd
[  224.000446]  [<ffffffff802421af>] ? vprintk+0x2f0/0x31c
[  224.000446]  [<ffffffff802135cd>] ? stop_this_cpu+0x0/0x2c
[  224.000446]  [<ffffffff805677ea>] ? _spin_unlock_irqrestore+0x4f/0x53
[  224.000446]  [<ffffffff8026bbb6>] ? crash_kexec+0xe5/0xef
[  224.000446]  [<ffffffff80261af2>] smp_call_function_many+0x40/0x1ec
[  224.000446]  [<ffffffff802135cd>] ? stop_this_cpu+0x0/0x2c
[  224.000446]  [<ffffffff80261ccd>] smp_call_function+0x2f/0x65
[  224.000446]  [<ffffffff8021d312>] native_smp_send_stop+0x22/0x49
[  224.000446]  [<ffffffff80564f46>] panic+0xbe/0x163
[  224.000446]  [<ffffffff8020f460>] ? show_registers+0x20d/0x21c
[  224.000446]  [<ffffffff803dbec1>] ? do_unblank_screen+0xf/0x10d
[  224.000446]  [<ffffffff802101e6>] oops_end+0xb9/0xc9
[  224.000446]  [<ffffffff8022a011>] do_page_fault+0x9d5/0xab4
[  224.000446]  [<ffffffff80413dc3>] ? pci_map_single+0x57/0x60
[  224.000446]  [<ffffffff805677e1>] ? _spin_unlock_irqrestore+0x46/0x53
[  224.000446]  [<ffffffff804e3fe7>] ? dev_hard_start_xmit+0x1fc/0x280
[  224.000446]  [<ffffffff805674c5>] ? _spin_lock+0x18/0x1b
[  224.000446]  [<ffffffff804f4fad>] ? __qdisc_run+0x149/0x244
[  224.000446]  [<ffffffff804e45da>] ? dev_queue_xmit+0x45e/0x48f
[  224.000446]  [<ffffffff805095e8>] ? ip_finish_output2+0x1fe/0x244
[  224.000446]  [<ffffffff80554980>] ? csum_partial_copy_nocheck+0xf/0x11
[  224.000446]  [<ffffffff80509696>] ? ip_finish_output+0x68/0x6a
[  224.000446]  [<ffffffff80506e6a>] ? ip_cork_release+0x36/0x45
[  224.000446]  [<ffffffff80508cc5>] ? ip_push_pending_frames+0x36d/0x385
[  224.000446]  [<ffffffff8056789b>] ? _spin_unlock+0x33/0x3e
[  224.000446]  [<ffffffff80508f00>] ? ip_send_reply+0x223/0x243
[  224.000446]  [<ffffffff802316d6>] ? enqueue_task+0x50/0x5b
[  224.000446]  [<ffffffff80567c85>] page_fault+0x25/0x30
[  224.000446]  [<ffffffff8023d95c>] ? try_to_wake_up+0x2b0/0x2c2
[  224.000446]  [<ffffffff80224e65>] ? __ticket_spin_lock+0x9/0x1a
[  224.000446]  [<ffffffff80224f2f>] default_spin_lock_flags+0x9/0xe
[  224.000446]  [<ffffffff805673a7>] _spin_lock_irqsave+0x37/0x40
[  224.000446]  [<ffffffff80496bc0>] hiddev_send_event+0x2e/0xe9
[  224.000446]  [<ffffffff80496ccd>] hiddev_report_event+0x52/0x54
[  224.000446]  [<ffffffff8023211c>] ? resched_task+0x45/0x81
[  224.000446]  [<ffffffff8048cd93>] hid_report_raw_event+0xb3/0x3b3
[  224.000446]  [<ffffffff80235e86>] ? tg_shares_up+0x183/0x1a3
[  224.000446]  [<ffffffff80235b6b>] ? enqueue_entity+0x1f8/0x200
[  224.000446]  [<ffffffff8048d15c>] hid_input_report+0xc9/0xdc
[  224.000446]  [<ffffffff80494939>] hid_irq_in+0x90/0x194
[  224.000446]  [<ffffffff804535ef>] usb_hcd_giveback_urb+0x58/0x87
[  224.000446]  [<ffffffff80469f0f>] uhci_giveback_urb+0x108/0x19d
[  224.000446]  [<ffffffff8046a666>] uhci_scan_schedule+0x5a8/0x86b
[  224.000446]  [<ffffffff8023327e>] ? __wake_up+0x43/0x50
[  224.000446]  [<ffffffff8046c5bc>] uhci_irq+0x13f/0x158
[  224.000446]  [<ffffffff80453168>] usb_hcd_irq+0x42/0x90
[  224.000446]  [<ffffffff8056789b>] ? _spin_unlock+0x33/0x3e
[  224.000446]  [<ffffffff80278485>] handle_IRQ_event+0x2e/0x65
[  224.000446]  [<ffffffff80279994>] handle_fasteoi_irq+0x8b/0xcb
[  224.000446]  [<ffffffff8020f08c>] do_IRQ+0x70/0xe4
[  224.000446]  [<ffffffff8020ce93>] ret_from_intr+0x0/0x29
[  224.000446]  <EOI> <4>---[ end trace 7f15bb0ad8b16dd9 ]---

...

I've reverted this whole merge from Linus tree ( sorry I don't have any time right now to bisect ) and the problem gone.

Full dmesg and config can be found at http://frugalware.org/~crazy/kernel/

Please let me know if you need more infos.

Regards,

Gabriel C
