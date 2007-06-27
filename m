Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbXF0Kno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbXF0Kno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 06:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbXF0Kng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 06:43:36 -0400
Received: from smtp04.isdsl.net ([196.26.208.193]:53796 "EHLO smtp04.isdsl.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbXF0Kne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 06:43:34 -0400
X-Greylist: delayed 3932 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2007 06:43:34 EDT
Message-ID: <46823001.6060206@wcic.co.za>
Date: Wed, 27 Jun 2007 11:38:09 +0200
From: Willo van der Merwe <willo@wcic.co.za>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Kernel panic when RAID drive fails
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2007 09:35:13.0718 (UTC) FILETIME=[76952D60:01C7B89E]
X-TM-AS-Product-Ver: SMEX-7.5.0.1231-3.6.1039-15260.002
X-TM-AS-Result: No-1.865200-5.000000-2
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-Scan-Signature: 8bc6c98cb7d84625022b8db3725a79a8{87}}
X-Trace: smtp04.isdsl.net 1I3UIk-0003Gc-6l 4ebcd0ed1cbc1b40c6a83baf58867278
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Summary Info:
Kernel halts with a kernel panic when a member of a RAID1 failed.

Detail Info:
I hope it's due to one of the drives failing, but I'm not sure. I've had 
endless issues with this machine. Any help would be appreciated.

Jun 27 05:22:27 sabertooth kernel: ata1: handling error/timeout
Jun 27 05:22:27 sabertooth kernel: ata1: port reset, p_is 0 is 0 pis 0 
cmd 4c017 tf 7f ss 0 se 0
Jun 27 05:22:27 sabertooth kernel: ata1: status=0x50 { DriveReady 
SeekComplete }
Jun 27 05:22:27 sabertooth kernel: Info fld=0x8c36, Current sda: sense 
key No Sense
Jun 27 05:22:27 sabertooth kernel: Assertion failure in dx_probe() at 
fs/ext3/namei.c:381: "dx_get_limit(entries) == dx_root_limit(dir, 
root->info.info_length)"
Jun 27 05:22:27 sabertooth kernel: ------------[ cut here ]------------
Jun 27 05:22:27 sabertooth kernel: kernel BUG at fs/ext3/namei.c:381!
Jun 27 05:22:27 sabertooth kernel: invalid operand: 0000 [#1]
Jun 27 05:22:27 sabertooth kernel: SMP
Jun 27 05:22:27 sabertooth kernel: Modules linked in: rfcomm l2cap 
bluetooth loop md5 ipv6 autofs4 dm_mirror dm_mod button battery ac 
uhci_hcd ehci_hcd e1000
 ext3 jbd raid1 ahci libata sd_mod scsi_mod
Jun 27 05:22:27 sabertooth kernel: CPU:    1
Jun 27 05:22:27 sabertooth kernel: EIP:    0060:[<f88a28c6>]    Not 
tainted VLI
Jun 27 05:22:27 sabertooth kernel: EFLAGS: 00010216   (2.6.9-42.ELsmp)
Jun 27 05:22:27 sabertooth kernel: EIP is at dx_probe+0x186/0x2b5 [ext3]
Jun 27 05:22:27 sabertooth kernel: eax: 00000081   ebx: e4c9a998   ecx: 
e2472cf4   edx: f88ad744
Jun 27 05:22:27 sabertooth kernel: esi: dceac018   edi: e2472d58   ebp: 
00000000   esp: e2472cf0
Jun 27 05:22:27 sabertooth kernel: ds: 007b   es: 007b   ss: 0068
Jun 27 05:22:27 sabertooth kernel: Process mysqld (pid: 16821, 
threadinfo=e2472000 task=f11386b0)
Jun 27 05:22:27 sabertooth kernel: Stack: f88ad744 f88ac880 f88ad734 
0000017d f88ad6f0 e2472d2c c011cd26 620fa5e2
Jun 27 05:22:27 sabertooth kernel:        e3f5c694 e4c9a998 d5636474 
d5636474 e4c9a998 f77dcafc f88a32d6 e2472d58
Jun 27 05:22:27 sabertooth kernel:        e2472dd4 c1a88f84 e4c9a998 
d56364e8 00000015 c01a9ea3 00000000 f7f59a00
Jun 27 05:22:27 sabertooth kernel: Call Trace:
Jun 27 05:22:27 sabertooth kernel:  [<c011cd26>] 
recalc_task_prio+0x128/0x133
Jun 27 05:22:27 sabertooth kernel:  [<f88a32d6>] 
ext3_dx_find_entry+0x6a/0x1d4 [ext3]
Jun 27 05:22:27 sabertooth kernel:  [<c01a9ea3>] 
avc_has_perm_noaudit+0x8d/0xda
Jun 27 05:22:27 sabertooth kernel:  [<f88a2f98>] 
ext3_find_entry+0x8f/0x363 [ext3]
Jun 27 05:22:27 sabertooth kernel:  [<c01204d1>] finish_wait+0x2c/0x50
Jun 27 05:22:27 sabertooth kernel:  [<c01aaff1>] inode_has_perm+0x4c/0x54
Jun 27 05:22:27 sabertooth kernel:  [<c02d2cb2>] __cond_resched+0x14/0x39
Jun 27 05:22:27 sabertooth kernel:  [<f88a345f>] ext3_lookup+0x1f/0x87 
[ext3]
Jun 27 05:22:27 sabertooth kernel:  [<c0166591>] real_lookup+0x6e/0xd2
Jun 27 05:22:27 sabertooth kernel:  [<c01667ae>] do_lookup+0x56/0x8f
Jun 27 05:22:27 sabertooth kernel:  [<c0166fef>] 
__link_path_walk+0x808/0xbb5
Jun 27 05:22:27 sabertooth kernel:  [<c01673df>] link_path_walk+0x43/0xbe
Jun 27 05:22:27 sabertooth kernel:  [<c011e794>] 
default_wake_function+0x0/0xc
Jun 27 05:22:27 sabertooth kernel:  [<c02d2cb2>] __cond_resched+0x14/0x39
Jun 27 05:22:27 sabertooth kernel:  [<c01c31ca>] 
direct_strncpy_from_user+0x3e/0x5d
Jun 27 05:22:27 sabertooth kernel:  [<c0167774>] path_lookup+0x14b/0x17f
Jun 27 05:22:27 sabertooth kernel:  [<c0167e4b>] open_namei+0x99/0x579
Jun 27 05:22:27 sabertooth kernel:  [<c015a3de>] filp_open+0x45/0x70
Jun 27 05:22:27 sabertooth kernel:  [<c011e794>] 
default_wake_function+0x0/0xc
Jun 27 05:22:27 sabertooth kernel:  [<c02d2cb2>] __cond_resched+0x14/0x39
Jun 27 05:22:27 sabertooth kernel:  [<c01c31ca>] 
direct_strncpy_from_user+0x3e/0x5d
Jun 27 05:22:27 sabertooth kernel:  [<c015a73a>] sys_open+0x31/0x7d
Jun 27 05:22:27 sabertooth kernel:  [<c02d4703>] syscall_call+0x7/0xb
Jun 27 05:22:27 sabertooth kernel:  [<c02d007b>] packet_rcv+0x242/0x307
Jun 27 05:22:27 sabertooth kernel: Code: 0c 29 d0 83 e8 18 c1 e8 03 39 
c1 74 29 68 f0 d6 8a f8 68 7d 01 00 00 68 34 d7 8a f8 68 80 c8 8a f8 68 
44 d7 8a f8 e8
 d8 ff 87 c7 <0f> 0b 7d 01 34 d7 8a f8 83 c4 14 0f b7 5e 02 85 db 74 07 
0f b7
Jun 27 05:22:27 sabertooth kernel:  <0>Fatal exception: panic in 5 seconds
Jun 27 05:22:29 sabertooth kernel: EXT3-fs error (device md0) in 
start_transaction: Journal has aborted

