Return-Path: <linux-kernel-owner+w=401wt.eu-S1761530AbZAQI67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761530AbZAQI67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 03:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbZAQI6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 03:58:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:11502 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbZAQI6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 03:58:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=qUwdof6BeIYY8/zRwhZGZa9Ggq0xM/he+uwhZbmCBg/Xp3f96sSOrjyL5NXl0fnWRv
         +tZEKjf36SSFUGA7eYVrSS6AWwTJEW2O0T+jSPh93t5BzC5DI5+F8l0/FgcE9guekfDw
         gPm+cu29z51VzWYKFGQWM64cCUqvYca1Gkc8M=
Message-ID: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com>
Date: Sat, 17 Jan 2009 09:58:47 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in preemptible
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During suspend to ram:
[  131.287012] BUG: using smp_processor_id() in preemptible [00000000]
code: suspend_to_ram./2958
[  131.287012] caller is retrigger_next_event+0x13/0xb0
[  131.287012] Pid: 2958, comm: suspend_to_ram. Not tainted 2.6.29-rc2 #1
[  131.287012] Call Trace:
[  131.287012]  [<c025b41f>] debug_smp_processor_id+0xbf/0xd0
[  131.287012]  [<c01473b3>] retrigger_next_event+0x13/0xb0
[  131.287012]  [<c01489b7>] raw_notifier_call_chain+0x17/0x20
[  131.287012]  [<c014b938>] timekeeping_resume+0xe8/0x110
[  131.287012]  [<c02cc651>] __sysdev_resume+0x11/0x50
[  131.287012]  [<c02cc6d7>] sysdev_resume+0x47/0x80
[  131.287012]  [<c02d2478>] device_power_up+0x8/0x10
[  131.287012]  [<c0159c7b>] suspend_devices_and_enter+0xeb/0x160
[  131.287012]  [<c015a47f>] freeze_processes+0x4f/0xa0
[  131.287012]  [<c0159e3d>] enter_state+0xfd/0x150
[  131.287012]  [<c0159f1c>] state_store+0x8c/0xd0
[  131.287012]  [<c0159e90>] state_store+0x0/0xd0
[  131.287012]  [<c0250d54>] kobj_attr_store+0x24/0x30
[  131.287012]  [<c01e25d1>] sysfs_write_file+0xa1/0x110
[  131.287012]  [<c01e2530>] sysfs_write_file+0x0/0x110
[  131.287012]  [<c019bf48>] vfs_write+0xa8/0x140
[  131.287012]  [<c019c0b1>] sys_write+0x41/0x80
[  131.287012]  [<c010348d>] sysenter_do_call+0x12/0x21
[  131.287012]  [<c03b0000>] init_cyrix+0x72/0x444
[  131.287012] BUG: using smp_processor_id() in preemptible [00000000]
code: suspend_to_ram./2958
[  131.287012] caller is retrigger_next_event+0x65/0xb0
[  131.287012] Pid: 2958, comm: suspend_to_ram. Not tainted 2.6.29-rc2 #1
[  131.287012] Call Trace:
[  131.287012]  [<c025b41f>] debug_smp_processor_id+0xbf/0xd0
[  131.287012]  [<c0147405>] retrigger_next_event+0x65/0xb0
[  131.287012]  [<c014b938>] timekeeping_resume+0xe8/0x110
[  131.287012]  [<c02cc651>] __sysdev_resume+0x11/0x50
[  131.287012]  [<c02cc6d7>] sysdev_resume+0x47/0x80
[  131.287012]  [<c02d2478>] device_power_up+0x8/0x10
[  131.287012]  [<c0159c7b>] suspend_devices_and_enter+0xeb/0x160
[  131.287012]  [<c015a47f>] freeze_processes+0x4f/0xa0
[  131.287012]  [<c0159e3d>] enter_state+0xfd/0x150
[  131.287012]  [<c0159f1c>] state_store+0x8c/0xd0
[  131.287012]  [<c0159e90>] state_store+0x0/0xd0
[  131.287012]  [<c0250d54>] kobj_attr_store+0x24/0x30
[  131.287012]  [<c01e25d1>] sysfs_write_file+0xa1/0x110
[  131.287012]  [<c01e2530>] sysfs_write_file+0x0/0x110
[  131.287012]  [<c019bf48>] vfs_write+0xa8/0x140
[  131.287012]  [<c019c0b1>] sys_write+0x41/0x80
[  131.287012]  [<c010348d>] sysenter_do_call+0x12/0x21
[  131.287012]  [<c03b0000>] init_cyrix+0x72/0x444

After this system works OK.
config, dmesg:
http://www.unixy.pl/maciek/download/kernel/2.6.29-rc2/pc/
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
