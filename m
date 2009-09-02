Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbZIBOYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbZIBOYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZIBOYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:24:00 -0400
Received: from eden-out.rutgers.edu ([128.6.68.11]:42042 "EHLO
	goshen4.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbZIBOX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 10:23:59 -0400
X-Greylist: delayed 2036 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Sep 2009 10:23:59 EDT
Date: Wed, 2 Sep 2009 09:49:54 -0400 (EDT)
From: Ciprian Docan <docan@eden.rutgers.edu>
X-X-Sender: docan@er3.rutgers.edu
To: linux-kernel@vger.kernel.org
cc: docan@eden.rutgers.edu
Subject: NULL pointer dereference
Message-ID: <Pine.SOC.4.64.0909020944510.21222@er3.rutgers.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I got the following in dmesg:

BUG: unable to handle kernel NULL pointer dereference at 00000000000000ae
IP: [<ffffffff8124701a>] ima_counts_put+0x34/0xb1
PGD a05e1067 PUD a05e2067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.3/class
CPU 1
Modules linked in: fuse sit tunnel4 nfs fscache nfsd lockd nfs_acl 
auth_rpcgss exportfs autofs4 sunrpc ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables ipv6 dm_multipath uinput snd_hda_codec_analog 
snd_hda_intel snd_hda_codec ppdev snd_hwdep snd_pcm parport_pc serio_raw 
dcdbas snd_timer iTCO_wdt iTCO_vendor_support parport wmi snd soundcore 
snd_page_alloc i2c_i801 usb_storage e1000e pata_acpi ata_generic i915 drm 
i2c_algo_bit i2c_core video output [last unloaded: speedstep_lib]
Pid: 3898, comm: devkit-disks-da Not tainted 
2.6.31-0.174.rc7.git2.fc12.x86_64 #1 OptiPlex 760
RIP: 0010:[<ffffffff8124701a>]  [<ffffffff8124701a>] 
ima_counts_put+0x34/0xb1
RSP: 0000:ffff8800a05f5d78  EFLAGS: 00010202
RAX: ffff8800b8f34148 RBX: 0000000000000004 RCX: 00000000b7698c0f
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000000
RBP: ffff8800a05f5da8 R08: ffff8800a05f5ce8 R09: ffff8800a05f5d18
R10: 00000000b7698c0f R11: 0000000000000000 R12: 0000000000000024
R13: 0000000000000000 R14: ffff8800a05f5e28 R15: fffffffffffffffa
FS:  00007ff4a8490790(0000) GS:ffff880007bde000(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000000ae CR3: 00000000a05e0000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process devkit-disks-da (pid: 3898, threadinfo ffff8800a05f4000, task 
ffff8800a05f8000)
Stack:
  ffff8800a05f5da8 00000000b7698c0f 0000000000000024 0000000000008001
<0> 0000000000000024 0000000000000000 ffff8800a05f5ef8 ffffffff8114e4b8
<0> ffff8800a05f5dc8 ffffffffffffff9c ffff8800a05f5dd8 00000000b7698c0f
Call Trace:
  [<ffffffff8114e4b8>] do_filp_open+0x534/0x9f3
  [<ffffffff810956f1>] ? lock_release_holdtime+0x3f/0x146
  [<ffffffff811146c4>] ? might_fault+0x71/0xd9
  [<ffffffff8115a407>] ? alloc_fd+0x125/0x14b
  [<ffffffff8113f3f1>] do_sys_open+0x71/0x131
  [<ffffffff8113f51e>] sys_open+0x33/0x49
  [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
Code: 48 83 ec 18 0f 1f 44 00 00 65 48 8b 04 25 28 00 00 00 48 89 45 d8 31 
c0 83 3d 36 22 28 01 00 48 8b 47 08 89 f3 48 8b 78 50 74 5e <0f> b7 87 ae 
00 00 00 25 00 f0 00 00 3d 00 80 00 00 75 4b e8 da
RIP  [<ffffffff8124701a>] ima_counts_put+0x34/0xb1
  RSP <ffff8800a05f5d78>
CR2: 00000000000000ae
---[ end trace 027f1f2d55021c25 ]---

Kernel version is: 2.6.31-0.174.rc7.git2.fc12.x86_64 #1 SMP Mon Aug 24 
23:25:34 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux, from F12 rawhide 
repository.

I am not sure what caused this, as it happened over night, and the machine 
was idle. The machine is still up and running, so if you need more 
information about it please let me know and I will try to provide them.

Thank you,
--
 	Ciprian Docan
