Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbZASWjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbZASWjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZASWjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:39:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40034 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbZASWjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:39:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Subject: Re: Latest git - BUG: using smp_processor_id() in preemptible [00000000]
Date: Mon, 19 Jan 2009 23:38:22 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <8db1092f0901150842l62c77d3ci565f2c2eb09826f5@mail.gmail.com>
In-Reply-To: <8db1092f0901150842l62c77d3ci565f2c2eb09826f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901192338.23197.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009, Maciej Rutecki wrote:
> Suspend to ram and disk works  OK now, on latest git, but during
> suspend to ram I have this message:
> 
> [  257.907004] BUG: using smp_processor_id() in preemptible [00000000]
> code: suspend_to_ram./3528
> [  257.907004] caller is retrigger_next_event+0x13/0xb0
> [  257.907004] Pid: 3528, comm: suspend_to_ram. Not tainted 2.6.29-rc1 #1
> [  257.907004] Call Trace:
> [  257.907004]  [<c025b44f>] debug_smp_processor_id+0xbf/0xd0
> [  257.907004]  [<c01473e3>] retrigger_next_event+0x13/0xb0
> [  257.907004]  [<c01489e7>] raw_notifier_call_chain+0x17/0x20
> [  257.907004]  [<c014b968>] timekeeping_resume+0xe8/0x110
> [  257.907004]  [<c02cc671>] __sysdev_resume+0x11/0x50
> [  257.907004]  [<c02cc6f7>] sysdev_resume+0x47/0x80
> [  257.907004]  [<c02d2498>] device_power_up+0x8/0x10
> [  257.907004]  [<c0159cab>] suspend_devices_and_enter+0xeb/0x160
> [  257.907004]  [<c015a3af>] freeze_processes+0x4f/0xa0
> [  257.907004]  [<c0159e6d>] enter_state+0xfd/0x150
> [  257.907004]  [<c0159f4c>] state_store+0x8c/0xd0
> [  257.907004]  [<c0159ec0>] state_store+0x0/0xd0
> [  257.907004]  [<c0250d84>] kobj_attr_store+0x24/0x30
> [  257.907004]  [<c01e2601>] sysfs_write_file+0xa1/0x110
> [  257.907004]  [<c01e2560>] sysfs_write_file+0x0/0x110
> [  257.907004]  [<c019bf78>] vfs_write+0xa8/0x140
> [  257.907004]  [<c019c0e1>] sys_write+0x41/0x80
> [  257.907004]  [<c010348d>] sysenter_do_call+0x12/0x21
> [  257.907004]  [<c03b0000>] init_cyrix+0x152/0x444
> [  257.907004] BUG: using smp_processor_id() in preemptible [00000000]
> code: suspend_to_ram./3528
> [  257.907004] caller is retrigger_next_event+0x65/0xb0
> [  257.907004] Pid: 3528, comm: suspend_to_ram. Not tainted 2.6.29-rc1 #1
> [  257.907004] Call Trace:
> [  257.907004]  [<c025b44f>] debug_smp_processor_id+0xbf/0xd0
> [  257.907004]  [<c0147435>] retrigger_next_event+0x65/0xb0
> [  257.907004]  [<c014b968>] timekeeping_resume+0xe8/0x110
> [  257.907004]  [<c02cc671>] __sysdev_resume+0x11/0x50
> [  257.907004]  [<c02cc6f7>] sysdev_resume+0x47/0x80
> [  257.907004]  [<c02d2498>] device_power_up+0x8/0x10
> [  257.907004]  [<c0159cab>] suspend_devices_and_enter+0xeb/0x160
> [  257.907004]  [<c015a3af>] freeze_processes+0x4f/0xa0
> [  257.907004]  [<c0159e6d>] enter_state+0xfd/0x150
> [  257.907004]  [<c0159f4c>] state_store+0x8c/0xd0
> [  257.907004]  [<c0159ec0>] state_store+0x0/0xd0
> [  257.907004]  [<c0250d84>] kobj_attr_store+0x24/0x30
> [  257.907004]  [<c01e2601>] sysfs_write_file+0xa1/0x110
> [  257.907004]  [<c01e2560>] sysfs_write_file+0x0/0x110
> [  257.907004]  [<c019bf78>] vfs_write+0xa8/0x140
> [  257.907004]  [<c019c0e1>] sys_write+0x41/0x80
> [  257.907004]  [<c010348d>] sysenter_do_call+0x12/0x21
> [  257.907004]  [<c03b0000>] init_cyrix+0x152/0x444
> 
> 
> Full dmesg, config:
> http://www.unixy.pl/maciek/download/kernel/2.6.29-rc1-git5/pc/

This seems to be http://bugzilla.kernel.org/show_bug.cgi?id=12422 .

Thanks,
Rafael
