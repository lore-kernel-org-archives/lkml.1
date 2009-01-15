Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZAOQnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZAOQnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 11:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758528AbZAOQnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 11:43:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:60907 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbZAOQm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 11:42:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=EwAe7dzXzAMpBrAc7UjJv5+fT3HROdMoJegOLRLhC5ifbanCi8C35tbTsz5ArZQbUh
         QZfom0FqqujNQuK3Cgklo96y9+uyF+TxmJlYm/jBLzdnSlaRdNmDjqIcJavuDuooYXK1
         aH7ne+N2QRlDxjb5oDJFjPAgi2xqoB73HS47c=
Message-ID: <8db1092f0901150842l62c77d3ci565f2c2eb09826f5@mail.gmail.com>
Date: Thu, 15 Jan 2009 17:42:57 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Latest git - BUG: using smp_processor_id() in preemptible [00000000]
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend to ram and disk works  OK now, on latest git, but during
suspend to ram I have this message:

[  257.907004] BUG: using smp_processor_id() in preemptible [00000000]
code: suspend_to_ram./3528
[  257.907004] caller is retrigger_next_event+0x13/0xb0
[  257.907004] Pid: 3528, comm: suspend_to_ram. Not tainted 2.6.29-rc1 #1
[  257.907004] Call Trace:
[  257.907004]  [<c025b44f>] debug_smp_processor_id+0xbf/0xd0
[  257.907004]  [<c01473e3>] retrigger_next_event+0x13/0xb0
[  257.907004]  [<c01489e7>] raw_notifier_call_chain+0x17/0x20
[  257.907004]  [<c014b968>] timekeeping_resume+0xe8/0x110
[  257.907004]  [<c02cc671>] __sysdev_resume+0x11/0x50
[  257.907004]  [<c02cc6f7>] sysdev_resume+0x47/0x80
[  257.907004]  [<c02d2498>] device_power_up+0x8/0x10
[  257.907004]  [<c0159cab>] suspend_devices_and_enter+0xeb/0x160
[  257.907004]  [<c015a3af>] freeze_processes+0x4f/0xa0
[  257.907004]  [<c0159e6d>] enter_state+0xfd/0x150
[  257.907004]  [<c0159f4c>] state_store+0x8c/0xd0
[  257.907004]  [<c0159ec0>] state_store+0x0/0xd0
[  257.907004]  [<c0250d84>] kobj_attr_store+0x24/0x30
[  257.907004]  [<c01e2601>] sysfs_write_file+0xa1/0x110
[  257.907004]  [<c01e2560>] sysfs_write_file+0x0/0x110
[  257.907004]  [<c019bf78>] vfs_write+0xa8/0x140
[  257.907004]  [<c019c0e1>] sys_write+0x41/0x80
[  257.907004]  [<c010348d>] sysenter_do_call+0x12/0x21
[  257.907004]  [<c03b0000>] init_cyrix+0x152/0x444
[  257.907004] BUG: using smp_processor_id() in preemptible [00000000]
code: suspend_to_ram./3528
[  257.907004] caller is retrigger_next_event+0x65/0xb0
[  257.907004] Pid: 3528, comm: suspend_to_ram. Not tainted 2.6.29-rc1 #1
[  257.907004] Call Trace:
[  257.907004]  [<c025b44f>] debug_smp_processor_id+0xbf/0xd0
[  257.907004]  [<c0147435>] retrigger_next_event+0x65/0xb0
[  257.907004]  [<c014b968>] timekeeping_resume+0xe8/0x110
[  257.907004]  [<c02cc671>] __sysdev_resume+0x11/0x50
[  257.907004]  [<c02cc6f7>] sysdev_resume+0x47/0x80
[  257.907004]  [<c02d2498>] device_power_up+0x8/0x10
[  257.907004]  [<c0159cab>] suspend_devices_and_enter+0xeb/0x160
[  257.907004]  [<c015a3af>] freeze_processes+0x4f/0xa0
[  257.907004]  [<c0159e6d>] enter_state+0xfd/0x150
[  257.907004]  [<c0159f4c>] state_store+0x8c/0xd0
[  257.907004]  [<c0159ec0>] state_store+0x0/0xd0
[  257.907004]  [<c0250d84>] kobj_attr_store+0x24/0x30
[  257.907004]  [<c01e2601>] sysfs_write_file+0xa1/0x110
[  257.907004]  [<c01e2560>] sysfs_write_file+0x0/0x110
[  257.907004]  [<c019bf78>] vfs_write+0xa8/0x140
[  257.907004]  [<c019c0e1>] sys_write+0x41/0x80
[  257.907004]  [<c010348d>] sysenter_do_call+0x12/0x21
[  257.907004]  [<c03b0000>] init_cyrix+0x152/0x444


Full dmesg, config:
http://www.unixy.pl/maciek/download/kernel/2.6.29-rc1-git5/pc/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
