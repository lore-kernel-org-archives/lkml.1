Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbXKIUKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbXKIUKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 15:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbXKIUKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 15:10:35 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:54069 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbXKIUKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 15:10:34 -0500
Date: Fri, 9 Nov 2007 15:10:32 -0500
Message-Id: <200711092010.lA9KAWMh012863@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Subject: BUG: can't reboot -nf -mm 2007-11-06-02-32++
In-reply-to: Your message of "Fri, 09 Nov 2007 13:23:09 EST."
             <200711091823.lA9IN9Bp000989@agora.fsl.cs.sunysb.edu> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <200711091823.lA9IN9Bp000989@agora.fsl.cs.sunysb.edu>, Erez Zadok writes:
> Setup: FC6 system with MM snapshot broken-out-2007-11-06-02-32 and these two
> patches added:
> 
> r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
> r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch

Same setup above.  Here's a simple bug.  Just run

# /sbin/reboot -n -f
Segmentation fault

# dmesg
[...]
BUG: unable to handle kernel paging request at virtual address 42da9ff4
printing eip: c1c81e24 *pde = 030fb067 *pte = 3dfdc065 
Oops: 0003 [#1] 
last sysfs file: /sys/kernel/uevent_seqnum
Modules linked in: nfsd auth_rpcgss exportfs nfs lockd nfs_acl sunrpc

Pid: 1954, comm: reboot Not tainted (2.6.24-rc1-mm1-mm #11)
EIP: 0060:[<c1c81e24>] EFLAGS: 00010286 CPU: 0
EIP is at 0xc1c81e24
EAX: c1c152ac EBX: c0446d40 ECX: c1c81e24 EDX: c1c152ac
ESI: 01234567 EDI: 42da9ff4 EBP: c310be94 ESP: c310be8c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process reboot (pid: 1954, ti=c310a000 task=c309a000 task.ti=c310a000)
Stack: c02fad37 00000000 c310bea0 c0219d3f 28121969 c310bfb0 c0219e68 c17fe240 
       c310bee4 c0230cd7 c310bf14 c30ceb58 c20141fc c3043de8 c30fb4d4 c3043de8 
       c17fe240 00000000 c17fe240 c310bee4 c022f023 c17fe240 c310bf34 c0239003 
Call Trace:
 [<c020283e>] show_trace_log_lvl+0x12/0x25
 [<c02028db>] show_stack_log_lvl+0x8a/0x9c
 [<c0202978>] show_registers+0x8b/0x153
 [<c0202b24>] die+0xe4/0x1a2
 [<c0209fc2>] do_page_fault+0x3db/0x4b1
 [<c038a922>] error_code+0x6a/0x70
 [<c0219d3f>] kernel_restart+0x26/0x55
 [<c0219e68>] sys_reboot+0xee/0x101
 [<c0202212>] sysenter_past_esp+0x5f/0x91
 =======================
INFO: lockdep is turned off.
Code: 00 00 00 00 00 00 00 00 1c c8 c1 6f 76 20 20 39 20 31 34 3a 35 33 3a 31 39 20 6b 65 72 6e 65 6c 3a 20 54 43 50 20 65 73 74 61 62 <6c> 69 73 68 65 64 20 68 61 73 68 20 74 61 62 6c 65 20 65 6e 74 
EIP: [<c1c81e24>] 0xc1c81e24 SS:ESP 0068:c310be8c
WARNING: at lib/kref.c:33 kref_get()
 [<c020283e>] show_trace_log_lvl+0x12/0x25
 [<c0203038>] show_trace+0xd/0x10
 [<c0203134>] dump_stack+0x15/0x17
 [<c02c7f59>] kref_get+0x26/0x30
 [<c02c72ef>] kobject_get+0x12/0x17
 [<c02c7744>] kobject_add+0x97/0x162
 [<c02164e5>] uids_user_create+0x41/0x5d
 [<c0216850>] alloc_uid+0xc9/0x171
 [<c0219b58>] set_user+0x1f/0x93
 [<c021b36a>] sys_setreuid+0xa1/0x139
 [<c0202212>] sysenter_past_esp+0x5f/0x91
 =======================
BUG: atomic counter underflow at:
 [<c020283e>] show_trace_log_lvl+0x12/0x25
 [<c0203038>] show_trace+0xd/0x10
 [<c0203134>] dump_stack+0x15/0x17
 [<c02c7fb3>] kref_put+0x50/0x71
 [<c02c7254>] kobject_put+0x14/0x16
 [<c02c728d>] kobject_cleanup+0x37/0x3c
 [<c02c729d>] kobject_release+0xb/0xd
 [<c02c7fc3>] kref_put+0x60/0x71
 [<c02c7254>] kobject_put+0x14/0x16
 [<c0216751>] remove_user_sysfs_dir+0x77/0xad
 [<c021bb52>] run_workqueue+0xba/0x182
 [<c021c379>] worker_thread+0x79/0x84
 [<c021ea74>] kthread+0x39/0x61
 [<c0202537>] kernel_thread_helper+0x7/0x10
 =======================



Erez.
