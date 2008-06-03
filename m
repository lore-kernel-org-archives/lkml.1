Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbYFCImS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbYFCImS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 04:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYFCImK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 04:42:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:55043 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbYFCImH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 04:42:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=U/KLNJyJEi+YXMkbzISAwIqCo7du0q8dzaxpRftJmxlsi5BZ0M1QY94l6SLq30bclq2LgkqNUTZk1XaWOQmprybxSPsb2+ug0wokba5zh5gclVA06EFaWJBEY9fBEsFBMZoP1DcnloeAP5GzzxC+nhHnONPfu91NrfgNZXwd+1g=
Message-ID: <c4e36d110806030142j379f5a63xfba7c3bbb9df602a@mail.gmail.com>
Date: Tue, 3 Jun 2008 10:42:06 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: BUG: using smp_processor_id() in preemptible [00000000] code: pm-suspend/17334
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello


Another backtrace from suspend code path:
(T61, 2GB, C2D, no SD card)
kernel from git 20080603, commit 1beee8dc8cf58e3f605bd7b34d7a39939be7d8d2

----
agpgart-intel 0000:00:00.0: LATE suspend
platform bay.0: LATE suspend
platform dock.0: LATE suspend
Extended CMOS year: 2000
 hwsleep-0324 [00] enter_sleep_state     : Entering sleep state [S3]
Back to C!
BUG: using smp_processor_id() in preemptible [00000000] code: pm-suspend/17334
caller is do_machine_check+0xa9/0x500
Pid: 17334, comm: pm-suspend Not tainted 2.6.26-rc4 #31

Call Trace:
 [<ffffffff8118347c>] debug_smp_processor_id+0xcc/0xd0
 [<ffffffff810184d9>] do_machine_check+0xa9/0x500
 [<ffffffff81010e7b>] ? init_8259A+0x1b/0x120
 [<ffffffff810189d6>] mce_init+0x56/0xf0
 [<ffffffff81018a7b>] mce_resume+0xb/0x10
 [<ffffffff81204fd0>] __sysdev_resume+0x20/0x60
 [<ffffffff81205068>] sysdev_resume+0x58/0x90
 [<ffffffff8120aac9>] device_power_up+0x9/0x10
 [<ffffffff8106f4f7>] suspend_devices_and_enter+0x147/0x1a0
 [<ffffffff8106f6c6>] enter_state+0x146/0x1d0
 [<ffffffff8106f80a>] state_store+0xba/0x100
 [<ffffffff81177ae7>] kobj_attr_store+0x17/0x20
 [<ffffffff81110fea>] sysfs_write_file+0xca/0x140
 [<ffffffff810ba00b>] vfs_write+0xcb/0x190
 [<ffffffff810ba1c0>] sys_write+0x50/0x90
 [<ffffffff8100c4fb>] system_call_after_swapgs+0x7b/0x80

Extended CMOS year: 2000
BUG: using smp_processor_id() in preemptible [00000000] code: pm-suspend/17334
caller is retrigger_next_event+0x1c/0x100
Pid: 17334, comm: pm-suspend Not tainted 2.6.26-rc4 #31

Call Trace:
 [<ffffffff8118347c>] debug_smp_processor_id+0xcc/0xd0
 [<ffffffff81055d3c>] retrigger_next_event+0x1c/0x100
 [<ffffffff812f5710>] ? _spin_unlock+0x30/0x60
 [<ffffffff810565ae>] hres_timers_resume+0x1e/0x50
 [<ffffffff81059657>] timekeeping_resume+0x137/0x170
 [<ffffffff81204fd0>] __sysdev_resume+0x20/0x60
 [<ffffffff81205068>] sysdev_resume+0x58/0x90
 [<ffffffff8120aac9>] device_power_up+0x9/0x10
 [<ffffffff8106f4f7>] suspend_devices_and_enter+0x147/0x1a0
 [<ffffffff8106f6c6>] enter_state+0x146/0x1d0
 [<ffffffff8106f80a>] state_store+0xba/0x100
 [<ffffffff81177ae7>] kobj_attr_store+0x17/0x20
 [<ffffffff81110fea>] sysfs_write_file+0xca/0x140
 [<ffffffff810ba00b>] vfs_write+0xcb/0x190
 [<ffffffff810ba1c0>] sys_write+0x50/0x90
 [<ffffffff8100c4fb>] system_call_after_swapgs+0x7b/0x80

BUG: using smp_processor_id() in preemptible [00000000] code: pm-suspend/17334
caller is retrigger_next_event+0x8b/0x100
Pid: 17334, comm: pm-suspend Not tainted 2.6.26-rc4 #31

Call Trace:
 [<ffffffff8118347c>] debug_smp_processor_id+0xcc/0xd0
 [<ffffffff81055dab>] retrigger_next_event+0x8b/0x100
 [<ffffffff810565ae>] hres_timers_resume+0x1e/0x50
 [<ffffffff81059657>] timekeeping_resume+0x137/0x170
 [<ffffffff81204fd0>] __sysdev_resume+0x20/0x60
 [<ffffffff81205068>] sysdev_resume+0x58/0x90
 [<ffffffff8120aac9>] device_power_up+0x9/0x10
 [<ffffffff8106f4f7>] suspend_devices_and_enter+0x147/0x1a0
 [<ffffffff8106f6c6>] enter_state+0x146/0x1d0
 [<ffffffff8106f80a>] state_store+0xba/0x100
 [<ffffffff81177ae7>] kobj_attr_store+0x17/0x20
 [<ffffffff81110fea>] sysfs_write_file+0xca/0x140
 [<ffffffff810ba00b>] vfs_write+0xcb/0x190
 [<ffffffff810ba1c0>] sys_write+0x50/0x90
 [<ffffffff8100c4fb>] system_call_after_swapgs+0x7b/0x80

platform dock.0: EARLY resume
platform bay.0: EARLY resume
agpgart-intel 0000:00:00.0: EARLY resume
pci 0000:00:02.0: EARLY resume
pci 0000:00:02.1: EARLY resume
e1000e 0000:00:19.0: EARLY resume
----

Zdenek
