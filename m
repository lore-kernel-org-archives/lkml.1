Return-Path: <linux-kernel-owner+w=401wt.eu-S1760962AbYHUTXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760962AbYHUTXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 15:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYHUTW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 15:22:59 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:53785 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbYHUTW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 15:22:58 -0400
Message-ID: <48ADC08C.6030406@linux.vnet.ibm.com>
Date: Fri, 22 Aug 2008 00:52:52 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080724)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: [BUG] linux-next: Tree for August 21 - WARNING: at fs/sysfs/dir.c:465
 sysfs_add_one()
References: <20080821191253.ba180d5e.sfr@canb.auug.org.au>
In-Reply-To: <20080821191253.ba180d5e.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while booting up the next-20080821 kernel on x86 machine, warning shows up for sysfs_add_one
of acpi getting called twice


[    3.070999] kobject: 'acpi' (f78b2130): kobject_add_internal: parent: 'module', set: 'module'
[    3.095999] kobject: 'acpi' (f78b2130): kobject_uevent_env
[    3.112571] kobject: 'acpi' (f78b2130): fill_kobj_path: path = '/module/acpi'
[    3.134999] kobject: 'processor' (f7907ad0): kobject_add_internal: parent: 'module', set: 'module'
[    3.161999] kobject: 'processor' (f7907ad0): kobject_uevent_env
[    3.179847] kobject: 'processor' (f7907ad0): fill_kobj_path: path = '/module/processor'
[    3.203999] kobject: 'thermal' (f7907b28): kobject_add_internal: parent: 'module', set: 'module'
[    3.230731] kobject: 'thermal' (f7907b28): kobject_uevent_env
[    3.247999] kobject: 'thermal' (f7907b28): fill_kobj_path: path = '/module/thermal'
[    3.270999] kobject: 'acpi' (f7907b80): kobject_add_internal: parent: 'module', set: 'module'
[    3.296886] ------------[ cut here ]------------
[    3.310838] WARNING: at fs/sysfs/dir.c:465 sysfs_add_one+0x2a/0x36()
[    3.329985] sysfs: duplicate filename 'acpi' can not be created
[    3.347828] Modules linked in:
[    3.356999] Pid: 1, comm: swapper Not tainted 2.6.27-rc3-next-20080821-autotest #1
[    3.379835]  [<c0425899>] warn_slowpath+0x4e/0x76
[    3.394150]  [<c04ff278>] ? trace_hardirqs_on_thunk+0xc/0x10
[    3.411425]  [<c0403a50>] ? restore_nocheck_notrace+0x0/0xe
[    3.428751]  [<c0425d52>] ? release_console_sem+0x194/0x1a7
[    3.445750]  [<c0488c7e>] ? ifind+0x83/0x8d
[    3.458593]  [<c0645a28>] ? _spin_unlock+0x1d/0x20
[    3.473408]  [<c0488c7e>] ? ifind+0x83/0x8d
[    3.485999]  [<c04b6ce8>] ? sysfs_find_dirent+0x16/0x27
[    3.501950]  [<c04b6d83>] sysfs_add_one+0x2a/0x36
[    3.516236]  [<c04b7227>] create_dir+0x43/0x72
[    3.529747]  [<c04b7283>] sysfs_create_dir+0x2d/0x41
[    3.544838]  [<c04fac51>] kobject_add_internal+0xe5/0x189
[    3.561205]  [<c04fada0>] kobject_add_varg+0x35/0x41
[    3.576304]  [<c04faf69>] kobject_init_and_add+0x26/0x28
[    3.592435]  [<c07cf7f1>] kernel_param_sysfs_setup+0x4c/0x99
[    3.609605]  [<c07cf935>] param_sysfs_init+0xf7/0x153
[    3.625006]  [<c0401125>] _stext+0x3d/0x11d
[    3.637760]  [<c07cf83e>] ? param_sysfs_init+0x0/0x153
[    3.653450]  [<c041ec8b>] ? wake_up_process+0xf/0x11
[    3.668925]  [<c0432777>] ? start_workqueue_thread+0x1d/0x20
[    3.685999]  [<c0432a2f>] ? __create_workqueue_key+0xa4/0x13c
[    3.703507]  [<c07bc58c>] kernel_init+0x177/0x1de
[    3.717798]  [<c07bc415>] ? kernel_init+0x0/0x1de
[    3.732215]  [<c0404643>] kernel_thread_helper+0x7/0x10
[    3.748060]  =======================
[    3.758882] ---[ end trace 4eaa2a86a8e2da22 ]---
[    3.772837] kobject_add_internal failed for acpi with -EEXIST, don't try to register things with the same name in the same directory.
[    3.809008] Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc3-next-20080821-autotest #1
[    3.834005]  [<c04facbd>] kobject_add_internal+0x151/0x189
[    3.850635]  [<c04fada0>] kobject_add_varg+0x35/0x41
[    3.865700]  [<c04faf69>] kobject_init_and_add+0x26/0x28
[    3.881807]  [<c07cf7f1>] kernel_param_sysfs_setup+0x4c/0x99
[    3.899005]  [<c07cf935>] param_sysfs_init+0xf7/0x153
[    3.914359]  [<c0401125>] _stext+0x3d/0x11d
[    3.927111]  [<c07cf83e>] ? param_sysfs_init+0x0/0x153
[    3.942802]  [<c041ec8b>] ? wake_up_process+0xf/0x11
[    3.958005]  [<c0432777>] ? start_workqueue_thread+0x1d/0x20
[    3.975282]  [<c0432a2f>] ? __create_workqueue_key+0xa4/0x13c
[    3.992999]  [<c07bc58c>] kernel_init+0x177/0x1de
[    4.007322]  [<c07bc415>] ? kernel_init+0x0/0x1de
[    4.021732]  [<c0404643>] kernel_thread_helper+0x7/0x10
[    4.037578]  =======================

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
