Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbYDGNZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbYDGNZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 09:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbYDGNZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 09:25:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:50899 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354AbYDGNZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 09:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TEb8DpwkCjysOXx4Ds4/EZlTO9HpDNXayER0QXPgziP+jIjV3nnwFnopcrvOtYMHsA+nuS1+VLNrCqbHBw6GYWlUWKOlPIBuDFa72BYA+liJyYgMSKbo5MzwyDmdzwFETOK7BWwAi1/ngvQj2t7IOb8Wprqmq7EjesDU6oMy1Ks=
Message-ID: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com>
Date: Mon, 7 Apr 2008 15:25:47 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

This has appeared in my kernel log:

Zdenek

----

 hwsleep-0322 [00] enter_sleep_state     : Entering sleep state [S3]
BUG: using smp_processor_id() in preemptible [00000000] code: pm-suspend/18791
caller is do_machine_check+0xa9/0x500
Pid: 18791, comm: pm-suspend Not tainted 2.6.25-rc8 #32

Call Trace:
 [debug_smp_processor_id+196/208] debug_smp_processor_id+0xc4/0xd0
 [do_machine_check+169/1280] do_machine_check+0xa9/0x500
 [init_8259A+27/256] ? init_8259A+0x1b/0x100
 [mce_init+86/240] mce_init+0x56/0xf0
 [mce_resume+11/16] mce_resume+0xb/0x10
 [__sysdev_resume+32/96] __sysdev_resume+0x20/0x60
 [sysdev_resume+88/144] sysdev_resume+0x58/0x90
 [device_power_up+9/16] device_power_up+0x9/0x10
 [suspend_devices_and_enter+327/416] suspend_devices_and_enter+0x147/0x1a0
 [enter_state+326/464] enter_state+0x146/0x1d0
 [state_store+186/256] state_store+0xba/0x100
 [kobj_attr_store+23/32] kobj_attr_store+0x17/0x20
 [sysfs_write_file+202/320] sysfs_write_file+0xca/0x140
 [vfs_write+203/368] vfs_write+0xcb/0x170
 [sys_write+80/144] sys_write+0x50/0x90
 [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80

Extended CMOS year: 2000
BUG: using smp_processor_id() in preemptible [00000000] code: pm-suspend/18791
caller is retrigger_next_event+0x1c/0xf0
Pid: 18791, comm: pm-suspend Not tainted 2.6.25-rc8 #32

Call Trace:
 [debug_smp_processor_id+196/208] debug_smp_processor_id+0xc4/0xd0
 [retrigger_next_event+28/240] retrigger_next_event+0x1c/0xf0
 [_spin_unlock+48/96] ? _spin_unlock+0x30/0x60
 [hres_timers_resume+30/80] hres_timers_resume+0x1e/0x50
 [timekeeping_resume+293/352] timekeeping_resume+0x125/0x160
 [__sysdev_resume+32/96] __sysdev_resume+0x20/0x60
 [sysdev_resume+88/144] sysdev_resume+0x58/0x90
 [device_power_up+9/16] device_power_up+0x9/0x10
 [suspend_devices_and_enter+327/416] suspend_devices_and_enter+0x147/0x1a0
 [enter_state+326/464] enter_state+0x146/0x1d0
 [state_store+186/256] state_store+0xba/0x100
 [kobj_attr_store+23/32] kobj_attr_store+0x17/0x20
 [sysfs_write_file+202/320] sysfs_write_file+0xca/0x140
 [vfs_write+203/368] vfs_write+0xcb/0x170
 [sys_write+80/144] sys_write+0x50/0x90
 [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80

BUG: using smp_processor_id() in preemptible [00000000] code: pm-suspend/18791
caller is retrigger_next_event+0x84/0xf0
Pid: 18791, comm: pm-suspend Not tainted 2.6.25-rc8 #32

Call Trace:
 [debug_smp_processor_id+196/208] debug_smp_processor_id+0xc4/0xd0
 [retrigger_next_event+132/240] retrigger_next_event+0x84/0xf0
 [hres_timers_resume+30/80] hres_timers_resume+0x1e/0x50
 [timekeeping_resume+293/352] timekeeping_resume+0x125/0x160
 [__sysdev_resume+32/96] __sysdev_resume+0x20/0x60
 [sysdev_resume+88/144] sysdev_resume+0x58/0x90
 [device_power_up+9/16] device_power_up+0x9/0x10
 [suspend_devices_and_enter+327/416] suspend_devices_and_enter+0x147/0x1a0
 [enter_state+326/464] enter_state+0x146/0x1d0
 [state_store+186/256] state_store+0xba/0x100
 [kobj_attr_store+23/32] kobj_attr_store+0x17/0x20
 [sysfs_write_file+202/320] sysfs_write_file+0xca/0x140
 [vfs_write+203/368] vfs_write+0xcb/0x170
 [sys_write+80/144] sys_write+0x50/0x90
 [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80

Enabling non-boot CPUs ...
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
